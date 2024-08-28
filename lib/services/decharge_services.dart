import 'dart:async';
import 'package:cocages/auth/services/login_services.dart';
import 'package:cocages/models/decharger_cours.dart';
import 'package:cocages/models/decharger_table.dart';
import 'package:cocages/models/ligne.dart';
import 'package:cocages/services/api_service.dart';
import 'package:cocages/services/database.dart';
import 'package:isar/isar.dart'; 
import 'package:logger/logger.dart';
final logger = Logger();

// Fonction pour enregistrer un camion déchargé dans la table Cours
Future<bool> enregistrerDechargementCours({
  required String veCode,
  required double poidsP1,
  required String techCoupe,
  required String parcelle,
  required DateTime dateHeureP1,
  required int ligneId, // Ajout du paramètre ligneId
}) async {
  try {
    // Récupérer le poidsTare via l'API
    final poidsTare = await recupererPoidsTare(veCode: veCode, dateHeureP1: dateHeureP1);

    if (poidsTare == null) {
      //logger.e('Le poidsTare est introuvable pour le camion avec veCode $veCode');
      return false; // Retourner false si le poidsTare est introuvable
    }

    final isar = await Database.getInstance();
    final agentMatricule = await getCurrentUserMatricule(); // Obtient l'identifiant de l'agent connecté

    if (agentMatricule == null) {
      //logger.e('Le matricule de l\'agent connecté est introuvable');
      return false; // Retourner false si le matricule de l'agent est introuvable
    }

    // Vérifier si un enregistrement avec la même dateHeureP1 existe déjà
    final existeDeja = await isar.dechargerCours
        .filter()
        .dateHeureP1EqualTo(dateHeureP1)
        .findFirst();

    if (existeDeja != null) {
      logger.w('Un camion avec la même dateHeureP1 existe déjà.');
      return true; // Retourner true pour indiquer que la situation est acceptable
    }

    final decharger = DechargerCours()
      ..veCode = veCode
      ..poidsP1 = poidsP1
      ..poidsTare = poidsTare // Utiliser le poidsTare récupéré
      ..dateHeureP1 = dateHeureP1
      ..techCoupe = techCoupe
      ..dateHeureDecharg = DateTime.now() // Date et Heure actuelles à la création
      ..matriculeAgent = agentMatricule
      ..parcelle = parcelle
      ..ligneId = ligneId; // Assigner l'ID de la ligne

    await isar.writeTxn(() async {
      await isar.dechargerCours.put(decharger);
    });

    return true; // Retourner true si tout s'est bien passé
  } catch (e) {
    //logger.e('Erreur lors de l\'enregistrement du déchargement dans Cours : $e');
    return false; // Retourner false en cas d'exception
  }
}


Future<bool> supprimerDechargementCours(int camionId) async {
  try {
    final isar = await Database.getInstance();

    // Vérifier si le camion existe avant de tenter de le supprimer
    final camion = await isar.dechargerCours.get(camionId);

    if (camion == null) {
      //logger.e('Le camion avec l\'ID $camionId est introuvable.');
      return false; // Retourner false si le camion est introuvable
    }

    // Supprimer le camion de la base de données
    await isar.writeTxn(() async {
      await isar.dechargerCours.delete(camionId);
    });

    //logger.i('Le camion avec l\'ID $camionId a été supprimé avec succès.');
    return true; // Retourner true si la suppression s'est bien déroulée
  } catch (e) {
    //logger.e('Erreur lors de la suppression du camion avec l\'ID $camionId : $e');
    return false; // Retourner false en cas d'exception
  }
}




// Fonction pour enregistrer un camion déchargé dans la table
Future<bool> enregistrerDechargementTable({
  required String veCode,
  required double poidsP1,
  required String techCoupe,
  required String parcelle,
  required DateTime dateHeureP1,
}) async {
  try {
    // Récupérer le poidsTare via l'API
    final poidsTare = await recupererPoidsTare(veCode: veCode, dateHeureP1: dateHeureP1);

    if (poidsTare == null) {
      logger.e('Le poidsTare est introuvable pour le camion avec veCode $veCode');
      return false; // Retourner false si le poidsTare est introuvable
    }

    final isar = await Database.getInstance();
    final agentMatricule = await getCurrentUserMatricule(); // Obtient l'identifiant de l'agent connecté

    if (agentMatricule == null) {
      logger.e('Le matricule de l\'agent connecté est introuvable');
      return false; // Retourner false si le matricule de l'agent est introuvable
    }

    // Vérifier si un enregistrement avec la même dateHeureP1 existe déjà
    final existeDeja = await isar.dechargerTables
        .filter()
        .dateHeureP1EqualTo(dateHeureP1)
        .findFirst();

    if (existeDeja != null) {
      logger.w('Un camion avec la même dateHeureP1 existe déjà.');
      return true; // Retourner true pour indiquer que la situation est acceptable
    }

    final decharger = DechargerTable()
      ..veCode = veCode
      ..poidsP1 = poidsP1
      ..poidsTare = poidsTare // Utiliser le poidsTare récupéré
      ..dateHeureP1 = dateHeureP1
      ..techCoupe = techCoupe
      ..dateHeureDecharg = DateTime.now() // Date et Heure actuelles à la création
      ..matriculeAgent = agentMatricule
      ..parcelle = parcelle;

    await isar.writeTxn(() async {
      await isar.dechargerTables.put(decharger);
    });

    return true; // Retourner true si tout s'est bien passé

  } catch (e) {
    logger.e('Erreur lors de l\'enregistrement du déchargement : $e');
    return false; // Retourner false en cas d'exception
  }
}

Future<bool> supprimerDechargementTable(int camionId) async {
  try {
    final isar = await Database.getInstance();

    // Vérifier si le camion existe avant de tenter de le supprimer
    final camion = await isar.dechargerTables.get(camionId);

    if (camion == null) {
      //logger.e('Le camion avec l\'ID $camionId est introuvable.');
      return false; // Retourner false si le camion est introuvable
    }

    // Supprimer le camion de la base de données
    await isar.writeTxn(() async {
      await isar.dechargerTables.delete(camionId);
    });

    //logger.i('Le camion avec l\'ID $camionId a été supprimé avec succès.');
    return true; // Retourner true si la suppression s'est bien déroulée
  } catch (e) {
    //logger.e('Erreur lors de la suppression du camion avec l\'ID $camionId : $e');
    return false; // Retourner false en cas d'exception
  }
}


// lister tous les camions déchargés dans la cour à canne au cours de la semaine  servira pour faire le filtre des camions en attente pour ne pas qu'un camions decharger  qui n'a pas encore disparu dans F_PREMPESEE soit decharger a nouveau

Future<List<DechargerCours>> listerCamionDechargerCours() async {
  final isar = await Database.getInstance();
  
  // // Obtenir la date actuelle
  // DateTime maintenant = DateTime.now();
  
  // // Calculer le début de la semaine (le lundi)
  // DateTime debutSemaine = maintenant.subtract(Duration(days: maintenant.weekday - 1));

  // Filtrer les camions en attente d'affectation déchargés cette semaine
  return await isar.dechargerCours
    .where()
    .sortByDateHeureDechargDesc()
    .findAll();

    // .dateHeureDechargBetween(debutSemaine, maintenant)
  
}



// lister tous les camions déchargés sur la table canne au cours de la semaine  servira pour faire le filtre des camions en attente pour ne pas qu'un camions decharger  qui n'a pas encore disparu dans F_PREMPESEE soit decharger a nouveau
Future<List<DechargerTable>> listerCamionDechargerTable() async {
  final isar = await Database.getInstance();
  
  // Obtenir la date actuelle
  // DateTime maintenant = DateTime.now();
  
  // Calculer le début de la semaine (le lundi)
  // DateTime debutSemaine = maintenant.subtract(Duration(days: maintenant.weekday - 1));

  // Filtrer les camions déchargés cette semaine
  return await isar.dechargerTables
    .where()
    .sortByDateHeureDechargDesc()
    .findAll();
    // .dateHeureDechargBetween(debutSemaine, maintenant)
    
}

//permet de recuperer les camions decharger dans les heure sera utiliser pour afficher les camions decharger sur la table a canne dans les derniere heures
Future<List<DechargerTable>> listerCamionDechargerTableDerniereHeure() async {
  final isar = await Database.getInstance();
  
  // Définir la date/heure actuelle
  final DateTime now = DateTime.now();

  // Calculer la date/heure il y a une heure
  final DateTime oneHourAgo = now.subtract(const Duration(hours: 1));

  // Rechercher les camions déchargés dans la dernière heure
  return await isar.dechargerTables
    .where()
    .filter()
    .dateHeureDechargBetween(oneHourAgo, now)
    .sortByDateHeureDechargDesc()
    .findAll();
}

//permet de recuperer les camions decharger dans les heure sera utiliser pour afficher les camions decharger dans la cour a canne dans les derniere heures

Future<List<DechargerCours>> listerCamionDechargerCoursDerniereHeure() async {
  final isar = await Database.getInstance();
  
  // Définir la date/heure actuelle
  final DateTime now = DateTime.now();

  // Calculer la date/heure il y a une heure
  final DateTime oneHourAgo = now.subtract(const Duration(hours: 1));

  // Rechercher les camions en attente d'affectation dans la dernière heure
  return await isar.dechargerCours
    .filter()
    .etatBroyageEqualTo(false) // Filtrer par état de broyage égal à faux
    .dateHeureDechargBetween(oneHourAgo, now) // Filtrer par date de déchargement dans la dernière heure
    .sortByDateHeureDechargDesc() // Trier par ordre décroissant de la date de déchargement
    .findAll();
}


//les camions en attente d'affectation 
// Fonction pour lister tous les camions déchargés dans la cour dont l'etatAffectation = 0 et etatBroyage = false, triés par ordre décroissant de dateHeureDecharg
Future<List<DechargerCours>> listerCamionAttenteAffectation() async {
  final isar = await Database.getInstance();
  return await isar.dechargerCours.filter()
    .etatBroyageEqualTo(false)
    .etatAffectationEqualTo(false)
    .sortByDateHeureDechargDesc()
    .findAll();
}



//""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""//
/*  Mise a jour du poids P2   */

// Fonction pour obtenir la liste des camions de DechargerTable et DechargerCours dont le poidsP2 est nul dans la base de donnee local
Future<List<Map<String, dynamic>>> getCamionsWithP2NullTable() async {
  final isar = await Database.getInstance();

  // Récupérer les camions de DechargerTable dont le poidsP2 est nul
  final camionsDechargerTable = await isar.dechargerTables
      .filter()
      .poidsP2IsNull()
      .findAll();

  // Liste pour stocker les camions à mettre à jour
  List<Map<String, dynamic>> camionsToUpdateTable = [];

  if(camionsDechargerTable.isNotEmpty){
    // Ajouter les camions de DechargerTable à la liste
    for (var camion in camionsDechargerTable) {
      camionsToUpdateTable.add({
        'veCode': camion.veCode,
        'dateHeureP1': camion.dateHeureP1,
        'poidsP1': camion.poidsP1,
      });
    }
  }

  return camionsToUpdateTable;
}

Future<List<Map<String, dynamic>>> getCamionsWithP2NullCours() async {
  final isar = await Database.getInstance();

  // Récupérer les camions de DechargerCours dont le poidsP2 est nul
  final camionsDechargerCours = await isar.dechargerCours
      .filter()
      .poidsP2IsNull()
      .findAll();

  // Liste pour stocker les camions à mettre à jour
  List<Map<String, dynamic>> camionsToUpdateCours = [];

  if (camionsDechargerCours.isNotEmpty){
    // Ajouter les camions de DechargerCours à la liste
    for (var camion in camionsDechargerCours) {
      camionsToUpdateCours.add({
        'veCode': camion.veCode,
        'dateHeureP1': camion.dateHeureP1,
        'poidsP1': camion.poidsP1,
      });
    }
  }

  return camionsToUpdateCours;
}


Future<bool> updatePoidsP2Table(List<Map<String, dynamic>> camions) async {
  if (camions.isEmpty) {
    // Pas de camions à mettre à jour
    return false; // Rien à mettre à jour si la liste est vide
  }

  final isar = await Database.getInstance();

  try {
    await isar.writeTxn(() async {
      for (var camion in camions) {
        DateTime dateHeureP1 = DateTime.parse(camion['dateHeureP1']);

        // Rechercher dans DechargerTable
        final dechargerTableCamion = await isar.dechargerTables
          .filter()
          .veCodeEqualTo(camion['veCode'])
          .poidsP2IsNull()
          .dateHeureP1EqualTo(dateHeureP1)
          .findFirst();

        if (dechargerTableCamion != null) {
          final poidsP2 = camion['poidsP2'];

          // Vérifier que poidsP2 n'est pas nul avant de procéder à la mise à jour
          if (poidsP2 != null) {
            // Convertir le poidsP2 en double si nécessaire
            dechargerTableCamion.poidsP2 = (poidsP2 is int) ? poidsP2.toDouble() : poidsP2 as double?;
            dechargerTableCamion.etatModification = true;
            await isar.dechargerTables.put(dechargerTableCamion);
          } 
          // else {
          //   print('poidsP2 est nul pour le camion avec veCode: ${camion['veCode']}');
          // }
        }
      }
    });

    return true; // Retourner true si la transaction se passe bien
  } catch (e) {
    // Gestion des erreurs
    //print('Erreur lors de la mise à jour du poids P2 dans DechargerTable : $e');
    return false; // Retourner false en cas d'erreur
  }
}

Future<bool> updatePoidsP2Cours(List<Map<String, dynamic>> camions) async {
  if (camions.isEmpty) {
    return false;
  }

  final isar = await Database.getInstance();
  final lignesToUpdate = <int>{}; // Utiliser un Set pour stocker les IDs des lignes uniques à mettre à jour

  try {
    // Première transaction : mettre à jour les poidsP2
    await isar.writeTxn(() async {
      for (var camion in camions) {
        DateTime dateHeureP1 = DateTime.parse(camion['dateHeureP1']);

        // Rechercher l'entrée correspondante dans la base de données
        final dechargerCoursCamion = await isar.dechargerCours
          .filter()
          .veCodeEqualTo(camion['veCode'])
          .and()
          .poidsP2IsNull()
          .dateHeureP1EqualTo(dateHeureP1)
          .findFirst();

        if (dechargerCoursCamion != null) {
          final poidsP2 = camion['poidsP2'];

          // Vérifier que poidsP2 n'est pas nul avant de procéder à la mise à jour
          if (poidsP2 != null) {
            // Convertir le poidsP2 en double si nécessaire
            dechargerCoursCamion.poidsP2 = (poidsP2 is int) ? poidsP2.toDouble() : poidsP2 as double?;
            dechargerCoursCamion.etatModification = true;
            await isar.dechargerCours.put(dechargerCoursCamion);

            // Ajouter l'ID de la ligne à mettre à jour
            lignesToUpdate.add(dechargerCoursCamion.ligneId);

          }
          //logger.e('PoidsP2 est nul pour le camion avec veCode: ${camion['veCode']}');
        
        }
      }
    });

    // Recalculer le poids total des lignes affectées
    await _updatePoidsTotalLignes(lignesToUpdate);

    return true; // Retourner true si la transaction se passe bien
    
  } catch (e) {
    // Gestion des erreurs
    logger.e('Erreur lors de la mise à jour du poids P2 : $e');
    return false; // Retourner false en cas d'erreur
  }
}

Future<void> _updatePoidsTotalLignes(Set<int> lignesIds) async {
  final isar = await Database.getInstance();

  await isar.writeTxn(() async {
    for (var ligneId in lignesIds) {
      final ligne = await isar.lignes.get(ligneId);

      if (ligne != null) {
        // Récupérer tous les camions affectés à cette ligne
        final camions = await isar.dechargerCours
            .filter()
            .ligneIdEqualTo(ligneId)
            .findAll();

        // Calculer la somme des poids nets pour tous les camions de la ligne
        double poidsTotal = camions.fold(0, (total, camion) => total + (camion.poidsNet));

        // Mettre à jour le poids total de la ligne
        ligne.poidsTotal = poidsTotal;

        // Répartir le poids total parmi les tas
        ligne.recalculerPoidsParTas();

        // Enregistrer la ligne mise à jour
        await isar.lignes.put(ligne);
      }
    }
  });
}


Future <bool> thereAreSynchronisationOfP2() async{
  // Étape 1 : Récupérer les camions pour lesquelles la deuxieme pessee n'a pas encore ete effectuer
  final camionsCoursToUpdate = await getCamionsWithP2NullCours();
  final camionsTableToUpdate = await getCamionsWithP2NullTable();

  if (camionsCoursToUpdate.isNotEmpty || camionsTableToUpdate.isNotEmpty){
    return true;
  }
  return false;
}


//mettre a jour le poids P2 en local
Future<String> getPoidsP2FromFPESEE() async {
  bool updatedP2Cours = false;
  bool updatedP2Table = false;

  try {
    // Étape 1 : Récupérer les camions pour lesquelles la deuxieme pessee n'a pas encore ete effectuer
    final camionsCoursToUpdate = await getCamionsWithP2NullCours();
    final camionsTableToUpdate = await getCamionsWithP2NullTable();

    // Étape 2 : Récupérer les poids P2 depuis l'API REST
    if (camionsCoursToUpdate.isNotEmpty) {
      try {
        final camionsCoursAvecPoidsP2Null = await getPoidsP2FromAPI(camionsCoursToUpdate)
            .timeout(Duration(seconds: 10)); // Définir un délai d'attente de 10 secondes

        updatedP2Cours = await updatePoidsP2Cours(camionsCoursAvecPoidsP2Null);
      } catch (e) {
        //logger.e('Erreur lors de la récupération des poids P2 (Cours) : $e');
        return 'error';
      }
    }

    if (camionsTableToUpdate.isNotEmpty) {
      try {
        final camionsTableAvecPoidsP2Null = await getPoidsP2FromAPI(camionsTableToUpdate)
            .timeout(const Duration(seconds: 10)); // Définir un délai d'attente de 10 secondes

        updatedP2Table = await updatePoidsP2Table(camionsTableAvecPoidsP2Null);
      } catch (e) {
        //logger.e('Erreur lors de la récupération des poids P2 (Table) : $e');
        return 'error';
      }
    }

    // Étape 3 : Vérifier si des poids ont été mis à jour
    if (updatedP2Cours || updatedP2Table) {
      return 'true';
    } else {
      return 'false';
    }

  } catch (e) {
    logger.e('Erreur lors de la synchronisation des poids P2 : $e');
    return 'error';
  }
}


/* 

////////////////////////////////////////////////////////////////////
/// Exemple d'intégration

Future<String> synchroniserPoidsP2() async {
  bool updatedP2Cours = false;
  bool updatedP2Table = false;

  try {
    // Étape 1 : Récupérer les camions à mettre à jour
    final camionsCoursToUpdate = await getCamionsWithP2NullCours();
    final camionsTableToUpdate = await getCamionsWithP2NullTable();

    // Étape 2 : Récupérer les poids P2 depuis l'API REST
    if (camionsCoursToUpdate.isNotEmpty) {
      try {
        final camionsCoursAvecPoidsP2Null = await getPoidsP2FromAPI(camionsCoursToUpdate)
            .timeout(Duration(seconds: 10)); // Définir un délai d'attente de 10 secondes

        updatedP2Cours = await updatePoidsP2Cours(camionsCoursAvecPoidsP2Null);
      } on TimeoutException catch (e) {
        logger.e('Erreur : La requête pour récupérer les poids P2 (Cours) a expiré : $e');
        return 'timeout';
      } on SocketException catch (e) {
        logger.e('Erreur de connexion lors de la récupération des poids P2 (Cours) : $e');
        return 'connection_error';
      } catch (e) {
        logger.e('Erreur lors de la récupération des poids P2 (Cours) : $e');
        return 'error';
      }
    }

    if (camionsTableToUpdate.isNotEmpty) {
      try {
        final camionsTableAvecPoidsP2Null = await getPoidsP2FromAPI(camionsTableToUpdate)
            .timeout(Duration(seconds: 10)); // Définir un délai d'attente de 10 secondes

        updatedP2Table = await updatePoidsP2Table(camionsTableAvecPoidsP2Null);
      } on TimeoutException catch (e) {
        logger.e('Erreur : La requête pour récupérer les poids P2 (Table) a expiré : $e');
        return 'timeout';
      } on SocketException catch (e) {
        logger.e('Erreur de connexion lors de la récupération des poids P2 (Table) : $e');
        return 'connection_error';
      } catch (e) {
        logger.e('Erreur lors de la récupération des poids P2 (Table) : $e');
        return 'error';
      }
    }

    // Étape 3 : Vérifier si des poids ont été mis à jour
    if (updatedP2Cours || updatedP2Table) {
      return 'true';
    } else {
      return 'false';
    }

  } catch (e) {
    logger.e('Erreur lors de la synchronisation des poids P2 : $e');
    return 'error';
  }
}


/////////////////////////////////////////////////////////////////
// Fonction pour récupérer les poids P2 (Cours) de l'API
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';

Future<String> synchroniserPoidsP2() async {
  bool updatedP2Cours = false;
  bool updatedP2Table = false;

  try {
    // Étape 1 : Récupérer les camions à mettre à jour
    final camionsCoursToUpdate = await getCamionsWithP2NullCours();
    final camionsTableToUpdate = await getCamionsWithP2NullTable();

    // Étape 2 : Récupérer les poids P2 depuis l'API REST
    if (camionsCoursToUpdate.isNotEmpty) {
      try {
        final camionsCoursAvecPoidsP2Null = await getPoidsP2FromAPI(camionsCoursToUpdate)
            .timeout(Duration(seconds: 10)); // Définir un délai d'attente de 10 secondes

        updatedP2Cours = await updatePoidsP2Cours(camionsCoursAvecPoidsP2Null);
      } catch (e) {
        logger.e('Erreur lors de la récupération des poids P2 (Cours) : $e');
        if (e is TimeoutException) {
          return 'timeout';
        } else if (e is SocketException) {
          return 'connection_error';
        } else {
          return 'error';
        }
      }
    }

    if (camionsTableToUpdate.isNotEmpty) {
      try {
        final camionsTableAvecPoidsP2Null = await getPoidsP2FromAPI(camionsTableToUpdate)
            .timeout(Duration(seconds: 10)); // Définir un délai d'attente de 10 secondes

        updatedP2Table = await updatePoidsP2Table(camionsTableAvecPoidsP2Null);
      } catch (e) {
        logger.e('Erreur lors de la récupération des poids P2 (Table) : $e');
        if (e is TimeoutException) {
          return 'timeout';
        } else if (e is SocketException) {
          return 'connection_error';
        } else {
          return 'error';
        }
      }
    }

    // Étape 3 : Vérifier si des poids ont été mis à jour
    if (updatedP2Cours || updatedP2Table) {
      return 'true';
    } else {
      return 'false';
    }

  } catch (e) {
    logger.e('Erreur lors de la synchronisation des poids P2 : $e');
    return 'error';
  }
}


*/








