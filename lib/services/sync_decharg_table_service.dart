// récupère les enregistrements de la table DechargerTable qui n'ont pas encore été synchronisés.
import 'package:cocages/models/decharger_table.dart';
import 'package:cocages/services/api_service.dart';
import 'package:cocages/services/database.dart';
import 'package:isar/isar.dart';

Future<List<Map<String, dynamic>>> getDonneeTableNonSynchronises() async {
  final isar = await Database.getInstance();

  final camionsTable = await isar.dechargerTables
      .filter()
      .etatSynchronisationEqualTo(false)
      .findAll();

  return camionsTable.map((camion) {
    //print(camion.poidsNet);
    return {
      'id' : camion.id,
      'veCode': camion.veCode,
      'poidsP1': camion.poidsP1,
      'poidsTare': camion.poidsTare,
      'dateHeureP1': camion.dateHeureP1.toIso8601String(),
      'dateHeureDecharg': camion.dateHeureDecharg.toIso8601String(),
      'techCoupe': camion.techCoupe,
      'parcelle' : camion.parcelle,
      'poidsP2': camion.poidsP2,
      'poidsNet' : camion.poidsNet,
      'dateHeureP2': camion.dateHeureP2?.toIso8601String(),
      'etatSynchronisation': camion.etatSynchronisation,
      'matriculeAgent': camion.matriculeAgent,
    };
  }).toList();
}



//récupère les enregistrements de la table DechargerTable qui ont été modifiés après synchronisation.
Future<List<Map<String, dynamic>>> getDonneeTableAMettreAJour() async {
  final isar = await Database.getInstance();

  final camionsTable = await isar.dechargerTables
      .filter()
      .etatSynchronisationEqualTo(true)
      .etatModificationEqualTo(true)
      .findAll();

  return camionsTable.map((camion) {
    return {
      'id' : camion.id,
      'veCode': camion.veCode,
      'poidsP2': camion.poidsP2,
      'poidsNet' : camion.poidsNet,
      'dateHeureP2': camion.dateHeureP2?.toIso8601String(),
      'etatSynchronisation': camion.etatSynchronisation,
      'dateHeureDecharg': camion.dateHeureDecharg.toIso8601String(),
    };
  }).toList();
}


//met à jour l'état de synchronisation des enregistrements pour indiquer qu'ils ont été synchronisés.
Future<void> updateEtatDonneeDechargerTableNonSynchronises(List<int> dechargerIds) async {
  final isar = await Database.getInstance();
  //print('object');
  await isar.writeTxn(() async {
    for (var id in dechargerIds) {
      final camion = await isar.dechargerTables.get(id);
      if (camion != null) {
        camion.etatSynchronisation = true;
        camion.etatModification = false;
        await isar.dechargerTables.put(camion);
      }
    }
  });
}

// réinitialise l'état de modification des enregistrements pour indiquer qu'ils ont été synchronisés.
Future<void> resetEtatModificationDonneeTable(List<int> dechargerIds) async {
  final isar = await Database.getInstance();

  await isar.writeTxn(() async {
    for (var id in dechargerIds) {
      final camion = await isar.dechargerTables.get(id);
      if (camion != null) {
        camion.etatModification = false;
        await isar.dechargerTables.put(camion);
      }
    }
  });
}

//vérifie s'il existe des enregistrements dans la table DechargerTable qui nécessitent une synchronisation.
Future<bool> thereAreSynchronisationForDechargerTable() async {
  final isar = await Database.getInstance();

  final nonSynchronises = await isar.dechargerTables
      .filter()
      .etatSynchronisationEqualTo(false)
      .findFirst();

  if (nonSynchronises != null) {
    return true;
  }

  final aMettreAJour = await isar.dechargerTables
      .filter()
      .etatSynchronisationEqualTo(true)
      .etatModificationEqualTo(true)
      .findFirst();

  if (aMettreAJour != null) {
    return true;
  }

  return false;
}

//fonction pour synchroniser les donnees decharger dans la table directement
Future<bool> synchroniserDonneeDechargerTableDirect() async {
  final nonSynchronises = await getDonneeTableNonSynchronises();
  final aMettreAJour = await getDonneeTableAMettreAJour();
  //print("las");

  final camionsTable = [...nonSynchronises, ...aMettreAJour];

  if (camionsTable.isEmpty) {
    return true;
  }

  final success = await sendToApiSyncDechargTable(camionsTable);

  if (success) {
    final dechargerIds = camionsTable.map((camion) => camion['id'] as int).toList();

    await updateEtatDonneeDechargerTableNonSynchronises(dechargerIds);

    if (aMettreAJour.isNotEmpty) {
      //print('object');
      final updateDechargerIds = aMettreAJour.map((camion) => camion['id'] as int).toList();
      await resetEtatModificationDonneeTable(updateDechargerIds);
    }

    return true;
  } else {
    return false;
  }
}






/*

1. Récupération des Données Non Synchronisées et à Mettre à Jour
Vous avez correctement implémenté deux fonctions pour récupérer les enregistrements qui nécessitent une synchronisation :

getDonneeTableNonSynchronises() : Récupère les enregistrements qui n'ont pas encore été synchronisés.
getDonneeTableAMettreAJour() : Récupère les enregistrements qui ont été modifiés après synchronisation.
2. Mise à Jour des États de Synchronisation
Les fonctions suivantes mettent à jour les états des enregistrements dans la base de données :

updateEtatDonneeDechargerTableNonSynchronises() : Marque les enregistrements comme synchronisés après une synchronisation réussie.
resetEtatModificationDonneeTable() : Réinitialise l'état de modification après une mise à jour réussie des données.
3. Vérification de la Nécessité de Synchronisation
La fonction thereAreSynchronisationForDechargerTable() est bien conçue pour vérifier si des enregistrements nécessitent une synchronisation ou une mise à jour.

4. Synchronisation des Données
La fonction synchroniserDonneeDechargerTableDirect() combine tout cela pour orchestrer le processus complet de synchronisation :

Elle récupère les enregistrements à synchroniser.
Elle appelle l'API pour synchroniser les données.
Elle met à jour les états de synchronisation et de modification en fonction du succès de l'opération.
5. Envoi des Données à l'API
Votre fonction sendToApiSyncDechargTable() gère bien l'envoi des données à l'API avec un bloc try-catch pour capturer les erreurs. Elle vérifie également le code de statut HTTP pour déterminer si la synchronisation a réussi.



*/