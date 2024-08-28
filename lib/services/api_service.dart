import 'dart:convert';
import 'package:cocages/auth/services/login_services.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();


  
String hashPassword(String password) {
  // Utiliser SHA-256 pour le hachage
  return sha256.convert(utf8.encode(password)).toString();
}

// Fonction pour appeler l'API d'authentification
Future<String> authenticateUserFromAPI(String matricule, String password) async {
  final url = Uri.parse('http://10.0.2.2:1445/authenticate');
  final hashedPassword = hashPassword(password);

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'matricule': matricule, 'password': hashedPassword}),
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      //print('lq');
      final data = json.decode(response.body);
      if (data['success']) {
        await storeUserLocally(data['data']);
        return "true";
      } else {
        return "false";
      }
    } else {
      //print('Erreur HTTP: ${response.statusCode}');
      //print('la');
      return "false";
    }
  } catch (e) {
    //print('Erreur lors de la connexion API : $e');
    return "error";
  }
}



Future<List<Map<String, String>>> getCamionAttenteFromAPI() async {
  try {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:1445/camionsEnAttente'))
        .timeout(const Duration(seconds: 10)); // Timeout après 10 secondes

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((camion) => {
        'VE_CODE': camion['VE_CODE'].toString(),
        'PS_CODE': camion['PS_CODE'].toString(),
        'PS_POIDSP1': camion['PS_POIDSP1'].toString(),
        'PS_POIDSTare': camion['PS_POIDSTare'].toString(),
        'DATEHEUREP1': camion['DATEHEUREP1'].toString(),
        'TECH_COUPE': camion['TECH_COUPE'].toString(),
      }).toList();
    } else {
      throw Exception('Failed to load camions en attente');
    }
  } catch (e) {
    //logger.e('Error: $e');
    throw e;
  }
}

// Fonction pour récupérer les poids P2 depuis l'API
Future<List<Map<String, dynamic>>> getPoidsP2FromAPI(List<Map<String, dynamic>> camions) async {
  try {
    // Convertir les objets DateTime en chaînes ISO8601
    final camionsFormatted = camions.map((camion) {
      return {
        'veCode': camion['veCode'],
        'dateHeureP1': (camion['dateHeureP1'] as DateTime).toIso8601String(),
        'poidsP1': camion['poidsP1'],
      };
    }).toList();

    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/poidsP2'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'camions': camionsFormatted}),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      // Gérer les erreurs HTTP non 200
      throw Exception('Erreur du serveur : ${response.statusCode}');
    }
  } catch (e) {
    // Capturer les exceptions liées aux erreurs de connexion
    //logger.e('Erreur de connexion à l\'API : $e');
    throw Exception('Erreur de connexion à l\'API');
  }
}

// Fonction pour récupérer le poidsTare d'un camion depuis l'API
Future<double?> recupererPoidsTare({
  required String veCode,
  required DateTime dateHeureP1,
}) async {
  final uri = Uri.parse('http://10.0.2.2:1445/poidsTare?veCode=$veCode&dateHeureP1=${dateHeureP1.toIso8601String()}');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['PS_POIDSTare']?.toDouble();
  } else {
    throw Exception('Failed to load poidsTare');
  }
}


/// Envoie les données des agents à l'API et retourne `true` si l'enregistrement a réussi, sinon `false`.
Future<bool> sendToApiSyncAgent(List<Map<String, dynamic>> agents) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/syncAgents'), // Remplacez par l'URL de votre API
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'agents': agents}),
    ).timeout(const Duration(seconds: 10)); // Timeout de 5 secondes
    //print(agents);
    return response.statusCode == 200; // Retourne `true` si la réponse HTTP est 200 (OK)
  } catch (e) {
    //print('object $e');
    return false;
  }
}

/// Envoie les données de déchargement dans la cour à l'API et retourne `true` si l'enregistrement a réussi, sinon `false`.
Future<bool> sendToApiSyncDechargCours(List<Map<String, dynamic>> camions) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/sync-decharg-cours'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'camions': camions}),
    ).timeout(const Duration(seconds: 5)); // Timeout de 5 secondes

    return response.statusCode == 200; // Retourne `true` si la réponse HTTP est 200 (OK)
  } catch (e) {
    return false;
  }
}

// Envoie les données de synchronisation de la table dechargerTable à mettre à jour l'état
Future<bool> sendToApiSyncDechargTable(List<Map<String, dynamic>> camions) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/sync-decharg-table'), // Remplacez par l'URL de votre API
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'camions': camions}),
    ).timeout(const Duration(seconds: 5)); // Timeout de 5 secondes

    // Vérifie si la réponse a un code de statut 200
    if (response.statusCode == 200) {
      return true;
    } else {
      // Gérer d'autres codes de statut ici si nécessaire
      //print('Échec de la synchronisation : ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // Gérer les exceptions, y compris les timeouts
    //print('Erreur lors de l\'envoi des données : $e');
    return false;
  }
}

// Envoyer les données de synchronisation de TableCanne à l'API
Future<bool> sendToApiSyncTableCanne(List<Map<String, dynamic>> cannes) async {
  try {
    // Convertir les objets DateTime en chaînes de caractères
    final formattedCannes = cannes.map((canne) {
      return {
        'tonnageTasDeverse': canne['tonnageTasDeverse'],
        'anneeTableCanne': canne['anneeTableCanne'],
        'dateDecharg': (canne['dateDecharg']).toIso8601String().split('T')[0], // Convertir en yyyy-MM-dd
        'heureDecharg': canne['heureDecharg'],
        'etatSynchronisation': canne['etatSynchronisation'],
      };
    }).toList();

    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/sync-table-canne'), // Remplacez par l'URL de votre API
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'cannes': formattedCannes}),
    ).timeout(const Duration(seconds: 5)); // Timeout de 5 secondes

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Erreur lors de la synchronisation. Statut HTTP: ${response.statusCode}, Message: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Exception lors de l\'envoi à l\'API: $e');
    return false;
  }
}




Future<double?> getTonnageDechargerCoursFromAPI({
  required String startHour,
  required String endHour,
}) async {
  final uri = Uri.parse('http://10.0.2.2:1445/tonnageEntreeCours');

  try {
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'heureDebut': startHour,
        'heureFin': endHour,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['stockEntree']?.toDouble();
    } else {
      throw Exception('Failed to load stockEntree');
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}


Future<double?> getTonnageBroyerDirectFromAPI({
  required String startHour,
  required String endHour,
}) async {
  // URL de l'API pour le tonnage broyé direct
  final uri = Uri.parse('http://10.0.2.2:1445/tonnageBroyerDirect');

  try {
    // Envoi d'une requête POST à l'API
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json', // Spécification du type de contenu
      },
      body: json.encode({
        'heureDebut': startHour, // Heure de début envoyée dans le corps de la requête
        'heureFin': endHour,     // Heure de fin envoyée dans le corps de la requête
      }),
    );

    // Vérification de la réponse de l'API
    if (response.statusCode == 200) {
      // Décodage des données JSON renvoyées par l'API
      final data = json.decode(response.body);
      // Retourne le tonnage broyé direct en tant que double, ou null si non disponible
      return data['stockBroyerDirect']?.toDouble();
    } else {
      print(response.statusCode);
      // Si la requête échoue, lancer une exception
      throw Exception('Failed to load stockBroyerDirect');
    }
  } catch (e) {
    // Impression de l'erreur en cas d'échec
    print('Error: $e');
    return null;
  }
}


Future<double?> getTonnageBroyerParTasFromAPI({
  required String startHour,
  required String endHour,
}) async {
  // URL de l'API pour le tonnage broyé par tas
  final uri = Uri.parse('http://10.0.2.2:1445/tonnageBroyerParTas');

  try {
    // Envoi d'une requête POST à l'API
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',  // Spécification du type de contenu
      },
      body: json.encode({
        'heureDebut': startHour,  // Heure de début envoyée dans le corps de la requête
        'heureFin': endHour,      // Heure de fin envoyée dans le corps de la requête
      }),
    );

    // Vérification de la réponse de l'API
    if (response.statusCode == 200) {
      // Décodage des données JSON renvoyées par l'API
      final data = json.decode(response.body);
      // Retourne le tonnage broyé par tas en tant que double, ou null si non disponible
      return data['totalTonnage']?.toDouble();
    } else {
      // Si la requête échoue, lancer une exception avec le code de statut
      throw Exception('Failed to load totalTonnage');
    }
  } catch (e) {
    // Impression de l'erreur en cas d'échec
    print('Error: $e');
    return null;
  }
}


/*
////10.0.2.2:1445
///192.168.1.190:80
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> sendToApiSyncDechargTable(List<Map<String, dynamic>> camions) async {
  final apiUrl = 'https://votre-api-url.com/sync-decharg-table'; // Remplacez par votre URL API

  try {
    // Préparer les données en JSON
    final body = jsonEncode(camions);

    // Envoyer une requête POST à l'API
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      // La synchronisation a réussi
      return true;
    } else {
      // La synchronisation a échoué, gérer l'erreur en fonction du code de statut
      print('Échec de la synchronisation : ${response.statusCode} - ${response.body}');
      return false;
    }
  } catch (e) {
    // Gérer les erreurs de réseau ou autres exceptions
    print('Erreur lors de la synchronisation : $e');
    return false;
  }
}

getDonneeCoursNonSynchronises :

Récupère les enregistrements dans la base de données locale DechargerCours qui n'ont pas encore été synchronisés avec l'API.
getDonneeCoursAMettreAJour :

Récupère les enregistrements déjà synchronisés mais qui ont été modifiés localement, nécessitant une mise à jour côté serveur.
updateEtatDonneeCoursNonSynchronises :

Met à jour l'état des enregistrements dans la base de données locale pour indiquer qu'ils ont été synchronisés avec succès.
resetEtatModificationDonneeCoursNon :

Réinitialise l'état de modification des enregistrements une fois qu'ils ont été synchronisés.
thereAreSynchronisationForDechargerCours :

Vérifie s'il existe des enregistrements dans la base de données locale qui nécessitent une synchronisation (nouveaux ou modifiés).
sendToApiSyncDechargCours :

Envoie les enregistrements récupérés à l'API pour les synchroniser avec le serveur distant.
synchroniserDonneeDechargerCours :

Effectue l'ensemble du processus de synchronisation : récupération des données, envoi à l'API, et mise à jour des états dans la base de données locale.

*/