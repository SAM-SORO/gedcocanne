import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

//autres bilan qu'on pourait avoir

Future<void> main() async {

final maxBroyageHoraire = await getTopAgentFromAPI(heureDebut: 19, heureFin: 20);
final minBroyageHoraire = await getMinAgentFromAPI(heureDebut: 19, heureFin: 20);
final maxBroyageAnnee = await getTopAgentAnneeFromAPI();
final minBroyageAnnee = await getMinAgentAnneeFromAPI();


if (maxBroyageHoraire == null) {
  logger.e('Une erreur est survenue lors de la requête.');
} else if (maxBroyageHoraire.isEmpty) {
  logger.i('Aucun agent n\'a été trouvé pour la plage horaire spécifiée.');
} else {
  logger.d('Matricule: ${maxBroyageHoraire['matricule']}');
  logger.d('max Broyage Horaire: ${maxBroyageHoraire['totalPoids']}');
}


if (minBroyageHoraire == null) {
  logger.e('Une erreur est survenue lors de la requête.');
} else if (minBroyageHoraire.isEmpty) {
  logger.i('Aucun agent n\'a été trouvé pour la plage horaire spécifiée.');
} else {
  logger.d('Matricule: ${minBroyageHoraire['matricule']}');
  logger.d('min Broyage Horaire: ${minBroyageHoraire['totalPoids']}');
}


if (maxBroyageAnnee == null) {
  logger.e('Une erreur est survenue lors de la requête.');
} else if (maxBroyageAnnee.isEmpty) {
  logger.i('Aucun agent n\'a été trouvé pour cette annee.');
} else {
  logger.d('Matricule: ${maxBroyageAnnee['matricule']}');
  logger.d('max Broyage Annee: ${maxBroyageAnnee['totalPoids']}');
}


if (minBroyageAnnee == null) {
  logger.e('Une erreur est survenue lors de la requête.');
} else if (minBroyageAnnee.isEmpty) {
  logger.i('Aucun agent n\'a été trouvé pour cette annee.');
} else {
  logger.d('Matricule: ${minBroyageAnnee['matricule']}');
  logger.d('min Broyage Annee: ${minBroyageAnnee['totalPoids']}');
}

// Exemple d'appel avec deux dates
final dateDebut = DateTime(2024, 1, 1); // Exemple: 1er Janvier 2024
final dateFin = DateTime(2024, 12, 31); // Exemple: 31 Décembre 2024

afficherTonnageCanneEntreeEntreDates(dateDebut, dateFin);

afficherAgentTopBroyage(dateDebut, dateFin);

}


void afficherTonnageCanneEntreeEntreDates(DateTime dateDebut, DateTime dateFin) async {
  try {
    final tonnageTotal = await getTonnageCanneEntreeEntreDates(
      dateDebut: dateDebut,
      dateFin: dateFin,
    );
    logger.d('Le tonnage total de canne entrée entre ${dateDebut.toIso8601String()} et ${dateFin.toIso8601String()} est de : $tonnageTotal tonnes.');
  } catch (e) {
    logger.e('Erreur lors de la récupération du tonnage : $e');
  }
}


void afficherAgentTopBroyage(DateTime dateDebut, DateTime dateFin) async {
  try {
    final agentTopBroyage = await getAgentTopBroyageEntreDates(
      dateDebut: dateDebut,
      dateFin: dateFin,
    );
    logger.d('L\'agent avec le plus de broyage entre ${dateDebut.toIso8601String()} et ${dateFin.toIso8601String()} est : ${agentTopBroyage['matricule']} avec ${agentTopBroyage['totalPoids']} tonnes.');
  } catch (e) {
    logger.e('Erreur lors de la récupération de l\'agent top broyage : $e');
  }
}


//Fonction pour obtenir les tonnages broyés directement et par tas entre les dates fournies.
void afficherTonnageBroyerEntreDates(DateTime dateDebut, DateTime dateFin) async {
  try {
    final tonnageBroyerDirect = await getTonnageBroyerDirectEntreDates(
      dateDebut: dateDebut,
      dateFin: dateFin,
    );

    final tonnageBroyerParTas = await getTonnageBroyerParTasEntreDates(
      dateDebut: dateDebut,
      dateFin: dateFin,
    );

    logger.d('Tonnage broyé entre les dates : Direct = $tonnageBroyerDirect tonnes, Par Tas = $tonnageBroyerParTas tonnes');
  } catch (e) {
    logger.e('Erreur lors de la récupération du tonnage broyé : $e');
  }
}


// Fonction pour récupérer l'agent qui a broyé le plus entre deux dates
Future<Map<String, dynamic>> getAgentTopBroyageEntreDates({
  required DateTime dateDebut,
  required DateTime dateFin,
}) async {
  final uri = Uri.parse('http://192.168.1.190:80/api/agentTopBroyageEntreDates');
  
  final response = await http.post(
    uri,
    headers: {"Content-Type": "application/json"},
    body: json.encode({
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
    }),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Erreur lors de la récupération de l\'agent top broyage');
  }
}


// Fonction pour récupérer le tonnage total de canne entrée entre deux dates
Future<double> getTonnageCanneEntreeEntreDates({
  required DateTime dateDebut,
  required DateTime dateFin,
}) async {
  final uri = Uri.parse(
      'http://192.168.1.190:80/api/getTonnageCanneEntreeEntreDates?dateDebut=${dateDebut.toIso8601String()}&dateFin=${dateFin.toIso8601String()}');

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['tonnageTotal'].toDouble();
    } else {
      throw Exception('Erreur lors de la récupération du tonnage de canne');
    }
  } catch (e) {
    logger.e('Erreur lors de la récupération du tonnage de canne: $e');
    throw Exception('Erreur lors de la récupération du tonnage de canne $e');
  }
}

//Fonction pour récupérer le tonnage broyé directement entre deux dates
Future<double> getTonnageBroyerDirectEntreDates({
  required DateTime dateDebut,
  required DateTime dateFin,
}) async {
  final uri = Uri.parse(
    'http://10.0.2.2:3000/tonnageBroyerDirectDates',
  );

  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'dateDebut': dateDebut.toIso8601String(),
        'dateFin': dateFin.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['stockBroyerDirect'].toDouble();
    } else {
      throw Exception('Erreur lors de la récupération du tonnage broyé directement');
    }
  } catch (e) {
    logger.e('Erreur lors de la récupération du tonnage broyé directement: $e');

    throw Exception('Erreur lors de la récupération du tonnage broyé directement $e');
  }
}


//Fonction pour récupérer le tonnage broyé par tas entre deux dates
Future<double> getTonnageBroyerParTasEntreDates({
  required DateTime dateDebut,
  required DateTime dateFin,
}) async {
  final uri = Uri.parse(
    'http://10.0.2.2:3000/tonnageBroyerParTasDates',
  );

  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'dateDebut': dateDebut.toIso8601String(),
        'dateFin': dateFin.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['tonnageBroyerParTas'].toDouble();
    } else {
      throw Exception('Erreur lors de la récupération du tonnage broyé par tas');
    }
  } catch (e) {
    logger.e('Erreur lors de la récupération du tonnage broyé par tas: $e');
    throw Exception('Erreur lors de la récupération du tonnage broyé par tas $e');

  }
}


// Fonction pour récupérer le tonnage total de canne entrée pour l'année en cours
Future<double?> getTonnageCanneEntree() async {
  final uri = Uri.parse('http://192.168.1.190:80/api/getTonnageCanneEntree');

  try {
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['tonnageTotal'].toDouble();
    } else {
      //throw Exception('Erreur lors de la récupération du tonnage de canne');
      return null;
    }
  } catch (e) {
    logger.e('Erreur lors de la récupération du tonnage de canne: $e');
    return null;
  }
}


//Fonction d'appel pour l'agent avec le plus de tonnage broyé dans une plage horaire
Future<Map<String, dynamic>?> getTopAgentFromAPI({
  required int heureDebut, // Heure de début à envoyer
  required int heureFin,   // Heure de fin à envoyer
}) async {
  final uri = Uri.parse('http://192.168.1.190:80/api/agentTopBroyage'); // URL de l'API

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'heureDebut': heureDebut, // Envoi des heures de début
        'heureFin': heureFin,     // Envoi des heures de fin
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'matricule': data['matricule'],
        'totalPoids': data['totalPoids'].toDouble(),
      };
    } else if (response.statusCode == 404) {
      // Gérer le cas où aucun agent n'a été trouvé
      //logger.d('Aucun agent n\'a broyé de tas ou déchargé de camions dans la plage horaire spécifiée');
      return {};
    } else {
      // Gérer d'autres erreurs HTTP
      //logger.e('Erreur HTTP: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // Gérer les erreurs de requête
    //logger.e('Erreur lors de la requête: $e');
    return null;
  }
}


// recuperer l'agent qui broyer le moins de canne dans une plage horaire donnee 
Future<Map<String, dynamic>?> getMinAgentFromAPI({
  required int heureDebut, // Heure de début à envoyer
  required int heureFin,   // Heure de fin à envoyer
}) async {
  final uri = Uri.parse('http://192.168.1.190:80/api/agentMinBroyage'); // URL de l'API

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'heureDebut': heureDebut, // Envoi des heures de début
        'heureFin': heureFin,     // Envoi des heures de fin
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'matricule': data['matricule'],
        'totalPoids': data['totalPoids'].toDouble(),
      };
    } else if (response.statusCode == 404) {
      // Gérer le cas où aucun agent n'a broyé de tas
      //logger.d('Aucun agent n\'a broyé de tas ou déchargé de camions dans la plage horaire spécifiée');
      return {};
    } else {
      // Gérer d'autres erreurs HTTP
      //logger.e('Erreur HTTP: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // Gérer les erreurs de requête
    //logger.e('Erreur lors de la requête: $e');
    return null;
  }
}


//Fonction d'appel pour l'agent avec le plus de tonnage broyé sur l'année  (une autre façon de faire ne donne pas le resultat exact c'est pour juste voir la maniere de faire)
Future<Map<String, dynamic>?> getTopAgentAnneeFromAPI() async {
  final uri = Uri.parse('http://192.168.1.190:80/api/agentTopBroyageAnnee'); // URL de l'API

  try {
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'matricule': data['matricule'],
        'totalPoids': data['totalPoids'].toDouble(),
      };
    } else if (response.statusCode == 404) {
      // Gérer le cas où aucun agent n'a été trouvé
      //logger.d('Aucun agent n\'a broyé de tas ou déchargé de camions cette année.');
      return {};
    } else {
      // Gérer d'autres erreurs HTTP
      //logger.e('Erreur HTTP: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // Gérer les erreurs de requête
    //logger.e('Erreur lors de la requête: $e');
    return null;
  }
}


//Fonction d'appel pour l'agent avec le moins de tonnage broyé sur l'année   (une autre façon de faire ne donne pas le resultat exact c'est pour juste voir la maniere de faire)
Future<Map<String, dynamic>?> getMinAgentAnneeFromAPI() async {
  final uri = Uri.parse('http://192.168.1.190:80/api/agentMinBroyageAnnee'); // URL de l'API

  try {
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'matricule': data['matricule'],
        'totalPoids': data['totalPoids'].toDouble(),
      };
    } else if (response.statusCode == 404) {
      // Gérer le cas où aucun agent n'a été trouvé
      //logger.d('Aucun agent n\'a broyé de tas ou déchargé de camions cette année.');
      return {};
    } else {
      // Gérer d'autres erreurs HTTP
      //logger.e('Erreur HTTP: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    // Gérer les erreurs de requête
    //logger.e('Erreur lors de la requête: $e');
    return null;
  }
}

