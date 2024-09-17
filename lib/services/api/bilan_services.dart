import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

Future<double?> getTonnageCanneDechargerCoursFromAPI({
  required String heureDebut, // Envoi en tant que String
  required String heureFin,   // Envoi en tant que String
}) async {
  final uri = Uri.parse('http://192.168.1.190:80/api/tonnageDechargerCours');

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'heureDebut': heureDebut, // Envoi des heures comme String
        'heureFin': heureFin,     // Envoi des heures comme String
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['stockEntree']?.toDouble();
    } else {
      //logger.e('HTTP error: ${response.statusCode}');
      throw Exception('Failed to load stockEntree');
    }
  } catch (e) {
    //logger.e('Error: $e');
    return null;
  }
}


Future<double?> getTonnageCanneBroyerDirectFromAPI({
  required String heureDebut,
  required String heureFin,
}) async {
  // URL de l'API pour le tonnage broyé direct
  final uri = Uri.parse('http://192.168.1.190:80/api/tonnageBroyerDirect');

  try {
    // Envoi d'une requête POST à l'API
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json', // Spécification du type de contenu
      },
      body: json.encode({
        'heureDebut': heureDebut, // Heure de début envoyée dans le corps de la requête
        'heureFin': heureFin,     // Heure de fin envoyée dans le corps de la requête
      }),
    );

    // Vérification de la réponse de l'API
    if (response.statusCode == 200) {
      // Décodage des données JSON renvoyées par l'API
      final data = json.decode(response.body);
      // Retourne le tonnage broyé direct en tant que double, ou null si non disponible
      return data['stockBroyerDirect']?.toDouble();
    } else {
      //logger.e(response.statusCode);
      // Si la requête échoue, lancer une exception
      throw Exception('Failed to load stockBroyerDirect');
    }
  } catch (e) {
    // Impression de l'erreur en cas d'échec
    //logger.e('Error: $e');
    return null;
  }
}


//le tonnage broyer par tas
Future<double?> getTonnageCanneBroyerParTasFromAPI({
  required String heureDebut,
  required String heureFin,
}) async {
  // URL de l'API pour le tonnage broyé par tas
  final uri = Uri.parse('http://192.168.1.190:80/api/tonnageBroyerParTas');

  try {
    // Envoi d'une requête POST à l'API
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',  // Spécification du type de contenu
      },
      body: json.encode({
        'heureDebut': heureDebut,  // Heure de début envoyée dans le corps de la requête
        'heureFin': heureFin,      // Heure de fin envoyée dans le corps de la requête
      }),
    );

    // Vérification de la réponse de l'API
    if (response.statusCode == 200) {
      // Impression de la réponse brute
      ////logger.d('Response body: ${response.body}');
      // Décodage des données JSON renvoyées par l'API
      final data = json.decode(response.body);
      // Retourne le tonnage broyé par tas en tant que double, ou null si non disponible
      return data['tonnageBroyerParTas']?.toDouble();
    } else {
      // Si la requête échoue, lancer une exception avec le code de statut
      throw Exception('Failed to load tonnageBroyerParTas');
    }
  } catch (e) {
    // Impression de l'erreur en cas d'échec
    //logger.e('Error: $e');
    return null;
  }
}



//la quantite de canne restant dans la cour
Future<double?> getTonnageCanneRestantCoursFromAPI() async {
  // URL de l'API pour le tonnage restant dans la cour
  final uri = Uri.parse('http://192.168.1.190:80/api/tonnageRestantCourt');

  try {
    // Envoi d'une requête POST à l'API sans corps (pas de paramètres requis)
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json', // Spécification du type de contenu
      },
    );

    // Vérification de la réponse de l'API
    if (response.statusCode == 200) {
      // Décodage des données JSON renvoyées par l'API
      final data = json.decode(response.body);
      // Retourne le tonnage restant en tant que double, ou null si non disponible
      return data['tonnageRestant']?.toDouble();
    } else {
      // Si la requête échoue, lancer une exception avec le code de statut
      //throw Exception('Failed to load tonnageRestant');
      return null;
    }
  } catch (e) {
    // Impression de l'erreur en cas d'échec
    logger.e('Error: $e');
    return null;
  }
}


// Fonction pour récupérer le tonnage total de canne entrée par un agent lors de son quart
Future<double?> getTonnageCanneEntree({
  required String heureDebut,
  required String heureFin,
}) async {
  final uri = Uri.parse('http://192.168.1.190:80/api/getTonnageCanneEntree');

  try {
    // Envoi d'une requête POST à l'API avec les heures de début et de fin
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json', // Spécification du type de contenu
      },
      body: json.encode({
        'heureDebut': heureDebut, // Heure de début envoyée dans le corps de la requête
        'heureFin': heureFin,     // Heure de fin envoyée dans le corps de la requête
      }),
    );

    // Vérification de la réponse de l'API
    if (response.statusCode == 200) {
      // Décodage des données JSON renvoyées par l'API
      final data = json.decode(response.body);
      // Retourne le tonnage total en tant que double, ou null si non disponible
      return data['tonnageTotal']?.toDouble();
    } else {
      // Log de l'erreur avec le code de statut
      logger.e('Failed to load tonnageTotal, status code: ${response.statusCode}');
      return null;
      //throw Exception('Failed to load tonnageTotal');
    }
  } catch (e) {
    // Impression de l'erreur en cas d'échec
    logger.e('Erreur lors de la récupération du tonnage de canne: $e');
    return null;
  }
}









