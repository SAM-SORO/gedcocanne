//import 'package:cocages/models/decharger_cours.dart';
import 'package:cocages/models/ligne.dart';
import 'package:cocages/models/table_canne.dart'; // Ce fichier doit inclure la déclaration de TableCanne
import 'package:cocages/services/database.dart';
import 'package:isar/isar.dart';


//Fonction pour vérifier si tous les tas de la ligne sont cochés :

Future<bool> verifierTousTasCoches(int ligneId) async {
  final isar = await Database.getInstance();

  // Vérifier l'état de tous les tas
  final ligne = await isar.lignes.get(ligneId);
  if (ligne != null && ligne.tas.every((t) => t.etat == 1)) {
    // Si tous les tas sont cochés, mettre à jour l'état de broyage des camions
    
    // for (var camion in ligne.camions) {
    //   await isar.writeTxn(() async {
    //     if (!camion.etatBroyage) {
    //       camion.etatBroyage = true;
    //       await isar.dechargerCours.put(camion);
    //     }
    //   });
    // }
    return true;
  }
  return false;
}



Future<bool> mettreAJourEtatTas({
  required int ligneId,
  required int tasId,
  required int nouvelEtat,
}) async {
  final isar = await Database.getInstance();

  try {
    // Récupération de la ligne en dehors de la transaction
    final ligne = await isar.lignes.get(ligneId);

    //permet d'eviter le probleme de transaction imbriquer ne pas supprimer
    // ignore: unused_local_variable
    final poidsTotal = ligne?.poidsTotal;

    if (ligne != null) {
      // Trouver le tas
      final tas = ligne.tas.firstWhere((t) => t.id == tasId);

      // Mettre à jour l'état du tas
      tas.etat = nouvelEtat;

      // Ouvrir une transaction pour sauvegarder la ligne mise à jour
      await isar.writeTxn(() async {
        await isar.lignes.put(ligne);
      });

      return true;
    } else {
      //print('Ligne non trouvée');
      return false;
    }
  } catch (e) {
    // Gestion des erreurs
    //print('Erreur lors de la mise à jour de l\'état du tas : $e');
    return false;
  }
}




Future<bool> ajouterTasDansTableCanne({
  required int ligneId,
  required int tasId,
}) async {
  final isar = await Database.getInstance();
  final maintenant = DateTime.now();
  final anneeEnCours = maintenant.year;
  final dateActuelle = DateTime(maintenant.year, maintenant.month, maintenant.day);
  final heureActuelle = maintenant.hour;

  // Obtenez la ligne et le tas
  final ligne = await isar.lignes.get(ligneId);
  final tas = ligne?.tas.firstWhere((t) => t.id == tasId);
  final poidsTas = tas?.poids;

  if (poidsTas == null) {
    return false;
  }

  try {
    // Utilisez une seule transaction pour les deux opérations
    await isar.writeTxn(() async {
      // Mettez à jour ou ajoutez dans TableCanne
      final tableCanne = await isar.tableCannes.filter()
        .anneeTableCanneEqualTo(anneeEnCours)
        .dateDechargEqualTo(dateActuelle)
        .heureDechargEqualTo(heureActuelle)
        .findFirst();

      if (tableCanne == null) {
        await isar.tableCannes.put(TableCanne()
          ..tonnageTasDeverse = poidsTas
          ..anneeTableCanne = anneeEnCours
          ..dateDecharg = dateActuelle
          ..heureDecharg = heureActuelle
          ..etatModification = true
        );
      } else {
        tableCanne.tonnageTasDeverse += poidsTas;
        tableCanne.etatModification = true;
        await isar.tableCannes.put(tableCanne);
      }

      // Mettez à jour l'état du tas
      tas!.etat = 1;
      await isar.lignes.put(ligne!);
    });

    return true;
  } catch (e) {
    // Gestion des erreurs
    //print('Erreur lors de l\'ajout dans TableCanne: $e');
    return false;
  }
}

Future<bool> retirerTasDeTableCanne({
  required int ligneId,
  required int tasId,
}) async {
  final isar = await Database.getInstance();
  final anneeEnCours = DateTime.now().year;

  try {
    await isar.writeTxn(() async {
      // Obtenir le poids du tas
      final ligne = await isar.lignes.get(ligneId);
      final tas = ligne?.tas.firstWhere((t) => t.id == tasId);
      final poidsTas = tas?.poids;

      if (poidsTas == null) {
        // Si poidsTas est null, retournez false
        return false;
      }

      // Trouver le plus récent enregistrement correspondant dans TableCanne
      final tableCanne = await isar.tableCannes.filter()
          .anneeTableCanneEqualTo(anneeEnCours)
          .findFirst();

      if (tableCanne != null) {
        // Soustraire le poids du tonnage
        tableCanne.tonnageTasDeverse -= poidsTas;

        // Assurez-vous que tonnageTasDeverse ne devient pas négatif
        if (tableCanne.tonnageTasDeverse < 0) {
          tableCanne.tonnageTasDeverse = 0;
        }

        tableCanne.etatModification = true;

        // Mettre à jour la tableCanne dans la base de données
        await isar.tableCannes.put(tableCanne);
      }
    });

    // Mettre à jour l'état du tas dans la ligne
    await mettreAJourEtatTas(
      ligneId: ligneId,
      tasId: tasId,
      nouvelEtat: 0,
    );

    // Retourner true si tout s'est bien passé
    return true;
  } catch (e) {
    // En cas d'erreur, retourner false
    return false;
  }
}
