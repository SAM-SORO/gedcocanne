import 'package:cocages/models/decharger_cours.dart';
import 'package:cocages/services/api_service.dart';
import 'package:cocages/services/database.dart';
import 'package:isar/isar.dart';


// Récupérer les données non synchronisées
Future<List<Map<String, dynamic>>> getDonneeCoursNonSynchronises() async {
  final isar = await Database.getInstance();
  final camionsCours = await isar.dechargerCours
      .filter()
      .etatSynchronisationEqualTo(false)
      .findAll();

  return camionsCours.map((camion) {
    return {
      'id': camion.id,
      'veCode': camion.veCode,
      'poidsP1': camion.poidsP1,
      'dateHeureP1': camion.dateHeureP1.toIso8601String(),
      'dateHeureDecharg': camion.dateHeureDecharg.toIso8601String(),
      'parcelle' : camion.parcelle,
      'techCoupe': camion.techCoupe,
      'poidsP2': camion.poidsP2,
      'poidsTare': camion.poidsTare,
      'poidsNet' : camion.poidsNet,
      'dateHeureP2': camion.dateHeureP2?.toIso8601String(),
      'etatSynchronisation': camion.etatSynchronisation,
      'etatBroyage': camion.etatBroyage,
      'matriculeAgent': camion.matriculeAgent,
    };
  }).toList();
}

// Récupérer les données à mettre à jour
Future<List<Map<String, dynamic>>> getDonneeCoursAMettreAJour() async {
  final isar = await Database.getInstance();
  final camionsCours = await isar.dechargerCours
      .filter()
      .etatSynchronisationEqualTo(true)
      .etatModificationEqualTo(true)
      .findAll();

  return camionsCours.map((camion) {
    return {
      'id': camion.id,
      'veCode': camion.veCode,
      'poidsP2': camion.poidsP2,
      'poidsNet' : camion.poidsNet,
      'dateHeureP2': camion.dateHeureP2?.toIso8601String(),
      'etatBroyage': camion.etatBroyage,
      'etatSynchronisation': camion.etatSynchronisation,
      'dateHeureDecharg': camion.dateHeureDecharg.toIso8601String(),
    };
  }).toList();
}

// Mettre à jour l'état de synchronisation des données
Future<void> updateEtatDonneeDechargerCoursNonSynchronises(List<int> dechargerIds) async {
  final isar = await Database.getInstance();
  await isar.writeTxn(() async {
    for (var id in dechargerIds) {
      final camion = await isar.dechargerCours.get(id);
      if (camion != null) {
        camion.etatSynchronisation = true;
        camion.etatModification = false;
        await isar.dechargerCours.put(camion);
      }
    }
  });
}

// Réinitialiser l'état de modification des données
Future<void> resetEtatModifDonneeCoursNonSynchronise(List<int> dechargerIds) async {
  final isar = await Database.getInstance();
  await isar.writeTxn(() async {
    for (var id in dechargerIds) {
      final camion = await isar.dechargerCours.get(id);
      if (camion != null) {
        camion.etatModification = false;
        await isar.dechargerCours.put(camion);
      }
    }
  });
}

// Vérifier s'il y a des enregistrements nécessitant une synchronisation
Future<bool> thereAreSynchronisationForDechargerCours() async {
  final isar = await Database.getInstance();

  final nonSynchronises = await isar.dechargerCours
      .filter()
      .etatSynchronisationEqualTo(false)
      .findFirst();

  if (nonSynchronises != null) {
    return true;
  }

  final aMettreAJour = await isar.dechargerCours
      .filter()
      .etatSynchronisationEqualTo(true)
      .etatModificationEqualTo(true)
      .findFirst();

  return aMettreAJour != null;
}

// Fonction principale de synchronisation
Future<bool> synchroniserDonneeDechargerCours() async {
  try {
    final nonSynchronises = await getDonneeCoursNonSynchronises();
    final aMettreAJour = await getDonneeCoursAMettreAJour();
    final camionsCours = [...nonSynchronises, ...aMettreAJour];

    if (camionsCours.isEmpty) {
      return true;
    }

    //envoyer sur le serveur via l'api
    final success = await sendToApiSyncDechargCours(camionsCours);

    if (success) {
      final dechargerIds = camionsCours.map((camion) => camion['id'] as int).toList();
      await updateEtatDonneeDechargerCoursNonSynchronises(dechargerIds);

      if (aMettreAJour.isNotEmpty) {
        final updateDechargerIds = aMettreAJour.map((camion) => camion['id'] as int).toList();
        await resetEtatModifDonneeCoursNonSynchronise(updateDechargerIds);
      }

      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}