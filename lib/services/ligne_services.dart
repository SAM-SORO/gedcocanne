import 'package:cocages/auth/services/login_services.dart';
import 'package:cocages/models/agent.dart';
import 'package:cocages/models/decharger_cours.dart';
import 'package:cocages/models/ligne.dart';
import 'package:cocages/services/database.dart';
import 'package:isar/isar.dart';

//recuperer le nombre de ligne
Future<int> getLigneCount() async {
  final isar = await Database.getInstance();
  final lignes = await isar.lignes.where().findAll();
  return lignes.length;
}

//recuperer toute les lignes
Future<List<Ligne>> getAllLignes() async {
  final isar = await Database.getInstance();
  return await isar.lignes.where().findAll();
}

//creer une ligne
Future<bool> createLigne() async {
  final isar = await Database.getInstance();
  final count = await getLigneCount();

  // Créer une nouvelle ligne
  final newLigne = Ligne(
    libele: 'Ligne ${count + 1}',
  );

  // Attendre le résultat de getCurrentUserId
  final currentUserId = await getCurrentUserId();

  if (currentUserId == null) {
    // Gestion de l'erreur si currentUserId est nul
    //print('ID de l\'utilisateur actuel est nul');
    return false; // Retourner false si l'ID est nul
  }

  try {
    // Récupérer l'agent correspondant à l'ID fourni
    final agent = await isar.agents.get(currentUserId);

    if (agent != null) {
      await isar.writeTxn(() async {
        // Lier l'agent à la nouvelle ligne
        newLigne.agent.value = agent;
        // Enregistrer la nouvelle ligne dans la base de données
        await isar.lignes.put(newLigne);
      });
      return true; // Retourner true si la ligne est créée avec succès
    } else {
      // Gestion de l'erreur si l'agent est nul
      //print('Agent non trouvé pour l\'ID $currentUserId');
      return false; // Retourner false si l'agent n'est pas trouvé
    }
  } catch (e) {
    // Gestion des exceptions
    //print('Erreur lors de la création de la ligne : $e');
    return false; // Retourner false en cas d'exception
  }
}



Future<bool> deleteLigne(int ligneId) async {
  final isar = await Database.getInstance();

  try {
    // Rechercher la ligne par son identifiant
    final ligne = await isar.lignes.get(ligneId);

    if (ligne != null) {
      // Supprimer la ligne dans une transaction
      await isar.writeTxn(() async {
        // Supprimer les liens associés si nécessaire
        ligne.agent.value = null;
        ligne.camions.clear(); // Délier tous les camions associés

        // Supprimer la ligne
        await isar.lignes.delete(ligneId);
      });

      return true; // Retourner true si la ligne est supprimée avec succès
    } else {
      // Gestion de l'erreur si la ligne n'est pas trouvée
      //print('Ligne non trouvée pour l\'ID $ligneId');
      return false; // Retourner false si la ligne n'est pas trouvée
    }
  } catch (e) {
    // Gestion des exceptions
    //print('Erreur lors de la suppression de la ligne : $e');
    return false; // Retourner false en cas d'exception
  }
}


// Fonction pour mettre à jour l'état d'affectation d'un camion
Future<void> updateCamionAffectation({
  required int camionId,
  required bool affecte,
}) async {
  final isar = await Database.getInstance();
  
  await isar.writeTxn(() async {
    final camion = await isar.dechargerCours.get(camionId);
    if (camion != null) {
      camion.etatAffectation = affecte;
      await isar.dechargerCours.put(camion);
    }
  });
}

Future<void> affecterCamionALigne({
  required int ligneId,
  required String veCode,
  required DateTime dateHeureP1,
}) async {
  final isar = await Database.getInstance();

  // Rechercher le camion correspondant dans la collection DechargerCours
  final camion = await isar.dechargerCours
      .filter()
      .veCodeEqualTo(veCode)
      .and()
      .dateHeureP1EqualTo(dateHeureP1)
      .findFirst();

  // Récupérer la ligne par son ID
  final ligne = await isar.lignes.get(ligneId);

  if (ligne != null && camion != null) {
    await isar.writeTxn(() async {
      // Ajouter le camion à la ligne
      ligne.camions.add(camion);
      await ligne.camions.save();

      ligne.ajouterPoids(camion.poidsNet);

      // Recalculer et répartir le poids total parmi les tas
      ligne.recalculerPoidsParTas();

      // Sauvegarder la ligne mise à jour dans la base de données
      await isar.lignes.put(ligne);
    });

    // Mettre à jour l'etat d'affectation du camion
    await updateCamionAffectation(camionId: camion.id, affecte: true);
  } else {
    if (ligne == null) {
      logger.e("Ligne introuvable pour l'ID $ligneId");
    }
    if (camion == null) {
      logger.e("Camion introuvable pour veCode $veCode et dateHeureP1 $dateHeureP1");
    }
  }
}


// vérifier s'il y a au moins un camion affecté à la ligne en utilisant la méthode limit(1) pour optimiser les performances
Future<bool> verifierAffectationLigne({
  required int ligneId,
}) async {
  final isar = await Database.getInstance();
  
  final ligne = await isar.lignes.get(ligneId);

  if (ligne != null) {
    final camions = await ligne.camions.filter()
      .etatBroyageEqualTo(false)
      .etatAffectationEqualTo(true)
      .limit(1) // Limit to one result
      .findAll();

    return camions.isNotEmpty;
  }
  
  return false;
}


Future<void> retirerCamionDeLigne({
  required int ligneId,
  required String veCode,
  required DateTime dateHeureP1,
}) async {
  final isar = await Database.getInstance();

  // Rechercher le camion correspondant dans la collection DechargerCours
  final camion = await isar.dechargerCours
      .filter()
      .veCodeEqualTo(veCode)
      .dateHeureP1EqualTo(dateHeureP1)
      .findFirst();

  // Récupérer la ligne par son ID
  final ligne = await isar.lignes.get(ligneId);

  if (ligne != null && camion != null) {
    await isar.writeTxn(() async {
      // Supprimer le camion de la ligne
      ligne.camions.remove(camion);
      await ligne.camions.save();

      ligne.retirerPoids(camion.poidsNet);

      // Recalculer et répartir le poids total parmi les tas restants
      ligne.recalculerPoidsParTas();

      // Sauvegarder la ligne mise à jour dans la base de données
      await isar.lignes.put(ligne);
    });

    // Mettre à jour l'état d'affectation du camion
    await updateCamionAffectation(camionId: camion.id, affecte: false);
  } else {
    if (ligne == null) {
      logger.e("Ligne introuvable pour l'ID $ligneId");
    }
    if (camion == null) {
      logger.e("Camion introuvable pour veCode $veCode et dateHeureP1 $dateHeureP1");
    }
  }
}


// Fonction qui récupère la liste des camions d'une ligne à partir de son identifiant 

// Fonction qui récupère la liste des camions d'une ligne à partir de son identifiant 
Future<List<DechargerCours>> recupererCamionsLigne(int ligneId) async {
  final isar = await Database.getInstance();
  
  final ligne = await isar.lignes.get(ligneId);
  
  if (ligne != null) {
    await ligne.camions.load();
    
    // Filtrer les camions qui ne sont pas encore broyés et les trier par ordre décroissant de dateHeureDecharg
    final camionsNonBroyes = ligne.camions
        .where((camion) => !camion.etatBroyage)
        .toList();

    // Trier par ordre décroissant de dateHeureDecharg
    camionsNonBroyes.sort((a, b) => b.dateHeureDecharg.compareTo(a.dateHeureDecharg));


    //  autre maniere d'ecrire
    /*
      final camionsNonBroye = ligne.camions.where((camion) {
        return camion.etatBroyage == false;
      }).toList(); 

      Normalement, si vous utilisiez a.dateHeureDecharg.compareTo(b.dateHeureDecharg), vous obtiendriez un tri croissant (du plus ancien au plus récent).
      final camionsNonBroyes = ligne.camions.where((camion) => camion.etatBroyage == false).toList();

    */

    return camionsNonBroyes;
  } else {
    return [];
  }
}




//le verouillage d'une ligne permet d'indiquer que les tas des camions qui lui etait affecter sona 1
//updateEtatBrollage
Future<void> updateEtatBrollage(int ligneId) async {
  final isar = await Database.getInstance();
  
  // Récupérer les camions non broyés de la ligne
  final camionsNonBroyes = await recupererCamionsLigne(ligneId);

  
  // Mettre à jour l'état de broyage des camions
  await isar.writeTxn(() async {
    for (var camion in camionsNonBroyes) {
      camion.etatBroyage = true;
      camion.etatModification = true; // pour permettre la synchronisation
      await isar.dechargerCours.put(camion);
    }
  });
}


Future<void> deverouillerLigne(int ligneId) async {
  final isar = await Database.getInstance();
  
  // Récupérer la ligne
  final ligne = await isar.lignes.get(ligneId);
  
  if (ligne != null) {
    // Réinitialiser la ligne
    ligne.reinitialiserLigne();

    // Sauvegarder les modifications de la ligne
    await isar.writeTxn(() async {
      await isar.lignes.put(ligne);
    });
  }
}



//il y'a deux cas lors de la lis a jour du nombre de tas soit des camions ont ete affecter a la ligne soit non 
Future<void> updateNombreTas({
  required int ligneId,
  required int nouveauNombreTas,
}) async {
  final isar = await Database.getInstance();

  // Récupérer l'instance de la ligne par son identifiant
  final ligne = await isar.lignes.get(ligneId);

  if (ligne != null) {
    // Préparer les modifications nécessaires en dehors de la transaction
    final poidsParTas = ligne.poidsTotal / nouveauNombreTas;
    List<Tas> nouveauxTas;

    if (ligne.camions.isEmpty) {
      // Aucun camion n'a été affecté, générer la nouvelle liste de tas
      nouveauxTas = List.generate(nouveauNombreTas, (index) => Tas(id: index + 1));
    } else {
      // Camions déjà affectés, répartir le poids total entre les nouveaux tas
      if (ligne.tas.length > nouveauNombreTas) {
        // Si le nouveau nombre de tas est inférieur, réduire la liste des tas
        nouveauxTas = ligne.tas.sublist(0, nouveauNombreTas);
      } else if (ligne.tas.length < nouveauNombreTas) {
        // Si le nouveau nombre de tas est supérieur, ajouter des tas
        nouveauxTas = List.from(ligne.tas)
          ..addAll(List.generate(nouveauNombreTas - ligne.tas.length, 
            (index) => Tas(id: ligne.tas.length + index + 1, poids: poidsParTas)));
      } else {
        nouveauxTas = ligne.tas;
      }
      
      // Mettre à jour le poids de chaque tas
      for (var tas in nouveauxTas) {
        tas.poids = poidsParTas;
      }
    }

    // Effectuer les modifications dans une transaction
    await isar.writeTxn(() async {
      ligne.nbreTas = nouveauNombreTas;
      ligne.tas = nouveauxTas;
      await isar.lignes.put(ligne);
    });
  }
}



 