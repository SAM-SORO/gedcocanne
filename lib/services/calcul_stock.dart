import 'package:cocages/models/decharger_table.dart';
import 'package:cocages/models/table_canne.dart';
import 'package:isar/isar.dart';
import 'package:cocages/models/decharger_cours.dart';
import 'package:cocages/services/database.dart';

//cette fonction permet de determiner la quantite total de canne entree dans la cours
Future<double?> tonnageEntreeCours(int annee) async {
  final isar = await Database.getInstance();

  // Filtrer les camions déchargés en fonction de l'année donnée, sans inclure le 1er janvier de l'année suivante
  final camions = await isar.dechargerCours
      .filter()
      .dateHeureDechargBetween(
        DateTime(annee, 1, 1), DateTime(annee + 1, 1, 1).subtract(Duration(seconds: 1)))
      .findAll();

  double sommePoidsNet = 0.0;

  for (var camion in camions) {
    sommePoidsNet += camion.poidsNet;
  }

  return sommePoidsNet;
}

Future<double> calculerTonnageActuelleCours(int annee) async {
  final isar = await Database.getInstance();

  final camions = await isar.dechargerCours.filter()
      .etatBroyageEqualTo(false)
      .dateHeureDechargBetween(
        DateTime(annee, 1, 1),
        DateTime(annee, 12, 31, 23, 59, 59),
      )
      .findAll();

  double sommePoidsNet = 0.0;
  for (var camion in camions) {
    sommePoidsNet += camion.poidsNet;
  }

  return sommePoidsNet;
}

////////////les fonctions pour le calcul du stock actuelle dans la table a canne//////////////////

//cette fonction donnera le tonnage des camions qui ont ete organiser par tas avant d'etre broyer cette somme sera Accumulere lorsque le poids P2 des camions sera disponible
Future<double?> calculerTonnageCanneBroyerParTas(int annee) async {
  final isar = await Database.getInstance();

  final camions = await isar.dechargerCours.filter()
      .etatBroyageEqualTo(true)
      .dateHeureDechargBetween(
        DateTime(annee, 1, 1),
        DateTime(annee, 12, 31, 23, 59, 59),
      )
      .findAll();

  double sommePoidsNet = 0.0;
  for (var camion in camions) {
    sommePoidsNet += camion.poidsNet;
  }

  return sommePoidsNet;
}

//fonction qui retourne le tonnage des tas broyer
Future<double?> tonnageCanneBroyerParTasAccumuler(int annee) async {
  final isar = await Database.getInstance();

  // Effectuer la requête pour filtrer par année et obtenir le tonnage
  final tonnage = await isar.tableCannes
      .filter()
      .anneeTableCanneEqualTo(annee)
      .findFirst(); // Utilisez findFirst() si vous attendez un seul enregistrement

  // Retourner le tonnage, ou null si aucun enregistrement n'est trouvé
  return tonnage?.tonnageTasDeverse;
}

Future<double> tonnageCanneDechargerDirect(int annee) async {
  final isar = await Database.getInstance();

  final camions = await isar.dechargerTables.filter()
      .dateHeureDechargBetween(
        DateTime(annee, 1, 1),
        DateTime(annee, 12, 31, 23, 59, 59),
      )
      .findAll();

  double sommePoidsNet = 0.0;

  for (var camion in camions) {
    sommePoidsNet += camion.poidsNet;
  }

  return sommePoidsNet;
}




// Fonction pour obtenir le stock dans la cour
Future<double> stockActuelleCours(int annee) async {
  final tonnageEntree = await tonnageEntreeCours(annee);
  final tonnageBroyerParTasAccumuler = await tonnageCanneBroyerParTasAccumuler(annee);
  final tonnageBroyerParTasCalculer = await calculerTonnageCanneBroyerParTas(annee);
  final tonnageActuelCours = await calculerTonnageActuelleCours(annee);

  final differenceTonnageAproximTempsReel = tonnageEntree! - tonnageBroyerParTasAccumuler!;
  final differenceTonnageExact = tonnageEntree - tonnageBroyerParTasCalculer!;

  return [
    tonnageActuelCours,
    differenceTonnageAproximTempsReel,
    differenceTonnageExact
  ].reduce((a, b) => a > b ? a : b); // Retourne le tonnage le plus élevé
}

// Fonction pour obtenir le stock de canne broyer
Future<double?> stockBroyerTable(int annee) async {
  final tonnageBroyerParTasCalculer = await calculerTonnageCanneBroyerParTas(annee);
  //final tonnageDechargerDirect = await tonnageCanneDechargerDirect(annee);
  // final tonnageBroyerParTasAccumuler = await tonnageCanneBroyerParTasAccumuler(annee);

  final tonnageBroyerCalculer = tonnageBroyerParTasCalculer;
  // final sommeTempsReel = tonnageBroyerParTasAccumuler! + tonnageDechargerDirect;

  return tonnageBroyerCalculer;

  // return [
  //   sommeAccumuler,
  //   sommeTempsReel
  // ].reduce((a, b) => a > b ? a : b); // Retourne le tonnage le plus élevé
}


/*
Future<double> stockCanne(int annee) async {
  final tonnageBroyerAccumuler = await calculerTonnageCanneBroyerParTas(annee);
  final tonnageDechargerDirect = await tonnageCanneDechargerDirect(annee);
  final tonnageBroyerTempsReel = await tonnageCanneBroyerParTasAccumuler(annee);

  // Calculer les deux combinaisons de tonnages
  final combinaison1 = tonnageBroyerAccumuler + tonnageDechargerDirect;
  final combinaison2 = tonnageBroyerTempsReel + tonnageDechargerDirect;

  // Retourner la combinaison avec le tonnage le plus élevé
  return max(combinaison1, combinaison2);
}


Future<double> stockCours(int annee) async {
  final tonnageEntreeCours = await tonnageEntreeCours(annee);
  final tonnageActuelCours = await calculerTonnageActuelleCours(annee);
  final tonnageBroyerTempsReel = await tonnageCanneBroyerParTasAccumuler(annee);
  final tonnageBroyerAccumuler = await calculerTonnageCanneBroyerParTas(annee);

  final differenceTonnageAproximTempsReel = tonnageBroyerTempsReel - tonnageEntreeCours;
  final differenceTonnageExact = tonnageBroyerAccumuler - tonnageEntreeCours;

  // Retourner le tonnage le plus élevé
  return max(tonnageActuelCours, max(differenceTonnageAproximTempsReel, differenceTonnageExact));
}



*/



// Future<double> calculerSommePoidsTas() async {
//   final isar = await Database.getInstance();

//   final tableCannes = await isar.tableCannes.where().findAll();

//   double sommePoidsTas = 0.0;
  

//   return sommePoidsTas;
// }


// Future<double> calculerStockCours() async {
//   double sommePoidsNet = await calculerSommePoidsCours();
//   double sommePoidsTas = await calculerSommePoidsTas();

//   // Calculer le stock dans la cour
//   double stockCours = sommePoidsNet - sommePoidsTas;

//   return stockCours;
// }


///// stock dans la table a canne 




// Future<double> calculerStockTable() async {
//   double sommePoidsTas = await calculerSommePoidsTas();
//   double sommePoidsTable = await calculerSommePoidsTable();

//   // Calculer le stock total
//   double stockTable = sommePoidsTable + sommePoidsTas;

//   return stockTable;
// }

/*

DateTime(annee + 1, 1, 1) :

Cette expression crée une date qui correspond au 1er janvier de l'année suivante (annee + 1).
Par exemple, si annee = 2024, alors DateTime(2025, 1, 1) correspond à "1er janvier 2025, 00:00:00".
.subtract(Duration(seconds: 1)) :

La méthode subtract soustrait une durée spécifique (dans ce cas, une seconde) de la date fournie.
En soustrayant une seconde à "1er janvier 2025, 00:00:00", vous obtenez "31 décembre 2024, 23:59:59".


on peut simplement utiliser
final camions = await isar.dechargerCours
    .filter()
    .dateHeureDechargBetween(
        DateTime(annee, 1, 1),
        DateTime(annee, 12, 31, 23, 59, 59),
    )
    .findAll();

*/




/*

//calcul du stock sans la cour et sur la table

Future<double> calculerStockDechargerCours() async {
  final isar = await Database.getInstance();
  
  final camions = await isar.dechargerCours.where().findAll();

  double stockTotal = 0.0;

  for (var camion in camions) {
    double poidsNet = camion.poidsP2 != null ? (camion.poidsP1 - camion.poidsP2!) : (camion.poidsP1 - camion.poidsTare);
    stockTotal += poidsNet;
  }

  return stockTotal;
}


Future<double> calculerStockDechargerTable() async {
  final isar = await Database.getInstance();
  
  final camions = await isar.dechargerTables.where().findAll();

  double stockTotal = 0.0;

  for (var camion in camions) {
    double poidsNet = camion.poidsP2 != null ? (camion.poidsP1 - camion.poidsP2!) : (camion.poidsP1 - camion.poidsTare);
    stockTotal += poidsNet;
  }

  return stockTotal;
}

*/


/*

// Fonction pour lister tous les camions déchargés dans la cour et dans la table dont l'etatAffectation = 0, triés par ordre décroissant de dateHeureDecharg
Future<List<dynamic>> listerTousLesCamionsDecharges() async {
  final camionsDechargerCours = await listerCamionDechargerCours();
  final camionsDechargerTable = await listerCamionDechargerTable();
  
  // Combinez les deux listes
  final tousLesCamionsDecharges = <dynamic>[]
    ..addAll(camionsDechargerCours)
    ..addAll(camionsDechargerTable);
  
  // Trier la liste combinée par dateHeureDecharg
  tousLesCamionsDecharges.sort((a, b) {
    DateTime dateA = a.dateHeureDecharg;
    DateTime dateB = b.dateHeureDecharg;
    return dateB.compareTo(dateA); // Tri décroissant
  });

  return tousLesCamionsDecharges;
}
  

*/















/*
Future<double> calculerStockDechargerCours() async {
  final isar = await Database.getInstance();

  final camions = await isar.dechargerCours.where().findAll();

  double poidsNetSum = 0;

  for (var camion in camions) {
    double poidsP2 = camion.poidsP2 ?? camion.poidsTare;
    poidsNetSum += camion.poidsP1 - poidsP2;
  }

  return poidsNetSum;
}

Future<double> calculerStockDechargerTable() async {
  final isar = await Database.getInstance();

  final camions = await isar.dechargerTables.where().findAll();

  double poidsNetSum = 0;

  for (var camion in camions) {
    double poidsP2 = camion.poidsP2 ?? camion.poidsTare;
    poidsNetSum += camion.poidsP1 - poidsP2;
  }

  return poidsNetSum;
}
 

 */