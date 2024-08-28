import 'package:cocages/models/table_canne.dart';
import 'package:cocages/services/api_service.dart';
import 'package:cocages/services/database.dart';
import 'package:isar/isar.dart';


// Récupérer les enregistrements de TableCanne qui n'ont pas encore été synchronisés
Future<List<Map<String, dynamic>>> getTableCanneNonSynchronises() async {
  final isar = await Database.getInstance();

  final cannes = await isar.tableCannes
      .filter()
      .etatSynchronisationEqualTo(false)
      .findAll();

  return cannes.map((canne) {
    //j'aurai besoin de l'identifiant pour faire la mise a jour du statut de synchronisation
    return {
      'id': canne.id,
      'tonnageTasDeverse': canne.tonnageTasDeverse,
      'anneeTableCanne': canne.anneeTableCanne,
      'dateDecharg': canne.dateDecharg,
      'heureDecharg': canne.heureDecharg,
      'etatSynchronisation': canne.etatSynchronisation,
    };
  }).toList();
}

//Récupérer les enregistrements de TableCanne qui ont été modifiés après synchronisation
Future<List<Map<String, dynamic>>> getTableCanneAMettreAJour() async {
  final isar = await Database.getInstance();

  final cannes = await isar.tableCannes
      .filter()
      .etatSynchronisationEqualTo(true)
      .etatModificationEqualTo(true)
      .findAll();

  return cannes.map((canne) {
    return {
      'id': canne.id,
      'anneeTableCanne': canne.anneeTableCanne,
      'tonnageTasDeverse': canne.tonnageTasDeverse,
      'heureDecharg': canne.heureDecharg,
      'dateDecharg': canne.dateDecharg,
      'etatSynchronisation': canne.etatSynchronisation,
    };
  }).toList();
}

//Mettre à jour l'état de synchronisation des enregistrements pour indiquer qu'ils ont été synchronisés
Future<void> updateEtatTableCanneNonSynchronises(List<int> canneIds) async {
  final isar = await Database.getInstance();
  await isar.writeTxn(() async {
    for (var id in canneIds) {
      final canne = await isar.tableCannes.get(id);
      if (canne != null) {
        canne.etatSynchronisation = true;
        canne.etatModification = false;
        await isar.tableCannes.put(canne);
      }
    }
  });
}


//Réinitialiser l'état de modification des enregistrements modifier pour indiquer qu'ils ont été synchronisés
//sera appeler apres synchronisation
Future<void> resetEtatModificationTableCanne(List<int> canneIds) async {
  final isar = await Database.getInstance();

  await isar.writeTxn(() async {
    for (var id in canneIds) {
      final canne = await isar.tableCannes.get(id);
      if (canne != null) {
        canne.etatModification = false;
        await isar.tableCannes.put(canne);
      }
    }
  });
}


//Vérifier s'il existe des enregistrements dans TableCanne qui nécessitent une synchronisation
Future<bool> thereAreSynchronisationForTableCanne() async {
  final isar = await Database.getInstance();

  final nonSynchronises = await isar.tableCannes
    .filter()
    .etatSynchronisationEqualTo(false)
    .findFirst();

  if (nonSynchronises != null) {
    return true;
  }

  final aMettreAJour = await isar.tableCannes
    .filter()
    .etatSynchronisationEqualTo(true)
    .etatModificationEqualTo(true)
    .findFirst();

  if (aMettreAJour != null) {
    return true;
  }

  return false;
}


//synchroniser les données de TableCanne
Future<bool> synchroniserDonneeTableCanne() async {
  final nonSynchronises = await getTableCanneNonSynchronises();
  final aMettreAJour = await getTableCanneAMettreAJour();
  //print("la");

  final cannesTable = [...nonSynchronises, ...aMettreAJour];

  if (cannesTable.isEmpty) {
    return true;
  }

  final success = await sendToApiSyncTableCanne(cannesTable);

  if (success) {
    //extraire l'identifiant des camions dont on a vient de faire la mise a jour
    final canneIds = cannesTable.map((canne) => canne['id'] as int).toList();

    await updateEtatTableCanneNonSynchronises(canneIds);

    if (aMettreAJour.isNotEmpty) {
      final updateCanneIds = aMettreAJour.map((canne) => canne['id'] as int).toList();
      await resetEtatModificationTableCanne(updateCanneIds);
    }

    return true;
  } else {
    return false;
  }
}
