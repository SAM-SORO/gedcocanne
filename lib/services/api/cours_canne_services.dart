import 'dart:convert';
import 'package:Gedcocanne/auth/services/login_services.dart';
import 'package:Gedcocanne/services/api/gespont_services.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

//recuperer tous les camions decharger dans la cours (afin de faire mon filtre pour les camions en attente)
Future<List<Map<String, dynamic>>> getCamionDechargerCoursFromAPI() async {
  try {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:1445/api/camionsDechargerCours'))
        .timeout(const Duration(minutes: 10)); // Timeout après 10 secondes

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((camion) => camion as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load camions déchargés (Cours): ${response.statusCode} ${response.reasonPhrase}');
    }
  } catch (e) {
    //logger.e('Error: $e');
    throw Exception('Failed to load data: $e');
  }
}


//recuperer les camions decharger dans la cour à canne dans les dernière heure
Future<List<Map<String, dynamic>>> getCamionDechargerCoursDerniereHeureFromAPI() async {
  const String url = 'http://10.0.2.2:1445/api/camionsDechargerCoursDerniereHeure';
  
  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }).timeout(const Duration(minutes: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    throw Exception('Failed to load data: $e');
  }
}


//enregistrement un dechargement dans la cour
Future<bool> saveDechargementCoursFromAPI({
  required String veCode,
  required double poidsP1,
  required String techCoupe,
  required String parcelle,
  required DateTime dateHeureP1,
  required String ligneLibele,
  required int ligneId,
}) async {
  try {
    // Récupérer le poidsTare via l'API
    final poidsTare = await recupererPoidsTare(veCode: veCode);

    if (poidsTare == null) {
      logger.e('Poids tare introuvable');
      return false;
    }

    final agentMatricule = await getCurrentUserMatricule();

    if (agentMatricule == null) {
      logger.e('Matricule agent introuvable');
      return false;
    }

    final Map<String, dynamic> data = {
      'veCode': veCode,
      'poidsP1': poidsP1,
      'poidsTare': poidsTare,
      'techCoupe': techCoupe,
      'parcelle': parcelle,
      'dateHeureP1': dateHeureP1.toIso8601String(),
      'ligneLibele': ligneLibele,
      'ligneId': ligneId,
      'matriculeAgent': agentMatricule,
      'etatBroyage': 0,
    };

    // Log des données envoyées
    //logger.d('Données envoyées: $data');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/api/enregistrerDechargementCours'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    //Log de la réponse de l'API
    //logger.d('Réponse API: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 201) {
      return true;
    } else {
      //logger.e('Erreur API: ${response.statusCode} - ${response.body}');
      return false;
    }
  } catch (e) {
    logger.e('Erreur: $e');
    return false;
  }
}


//Supprimer un camion affecter à une ligne
Future<bool> deleteCamionDechargerCoursFromAPI({
  required String veCode, 
  required String dateHeureP1,
}) async {
  try {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:1445/api/deleteCamionDechargerCours'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'veCode': veCode,
        'dateHeureP1': dateHeureP1,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Suppression réussie
    } else {
      //logger.e('Erreur: ${response.body}');
      return false; // Suppression échouée
    }
  } catch (e) {
    //logger.e('Erreur lors de la suppression du camion: $e');
    return false; // Erreur pendant la communication avec le serveur
  }
}


//recuperer les camions affecter a une ligne
// Future<List<Map<String, dynamic>>> recupererCamionsLigneFromAPI(String ligneLibele) async {
//   try {
//     final response = await http.post(
//       Uri.parse('http://10.0.2.2:1445/api/getCamionsOfLigne'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({'ligneLibele': ligneLibele}),
//     );

//     if (response.statusCode == 200) {
//       // Décoder la réponse JSON en une liste de camions
//       final List<dynamic> data = json.decode(response.body);
//       return data.map((item) => item as Map<String, dynamic>).toList();
//     } else {
//       //logger.e('Erreur: ${response.body}');
//       return [];
//     }
//   } catch (e) {
//     //logger.e('Erreur lors de la récupération des camions: $e');
//     return [];
//   }
// }

//recuperer les camions affecter a une ligne
// Fonction pour récupérer les camions affectés à une ligne depuis l'API
Future<List<Map<String, dynamic>>> recupererCamionsLigneFromAPI(int ligneId) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:1445/api/getCamionsOfLigne'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: json.encode({
      'ligneId': ligneId,
    }),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data);
  } else if (response.statusCode == 404) {
    return [];
  } else {
    throw Exception('Failed to load camions');
  }
}




//verifier s'il y'a un camion affecter à la ligne

Future<bool> verifierAffectationLigneFromAPI({required int ligneId}) async {  // Utilisation de int ligneId
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/api/verifierAffectationLigne'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'ligneId': ligneId}),  // Envoi de ligneId comme int
    );

    if (response.statusCode == 200) {
      // La réponse attendue est un booléen : true si au moins un camion est affecté, false sinon
      return json.decode(response.body) as bool;
    } else {
      //logger.e('Erreur: ${response.body}');
      return false;
    }
  } catch (e) {
    //logger.e('Erreur lors de la vérification de l\'affectation: $e');
    return false;
  }
}






