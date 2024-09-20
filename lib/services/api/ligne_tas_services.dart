import 'dart:convert';
import 'package:Gedcocanne/auth/services/login_services.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();



///////////////
//LIGNE & TAS
////////////////


Future<int> getLigneCountFromAPI() async {
  try {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:1445/api/getLigneCount'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['count'];
    } else {
      // Gérer les erreurs HTTP non 200
      throw Exception('Erreur du serveur : ${response.statusCode}');
    }
  } catch (e) {
    // Capturer les exceptions liées aux erreurs de connexion
    throw Exception('Erreur de connexion à l\'API');
  }
}


// Récupérer toutes les lignes depuis l'API
Future<List<Map<String, dynamic>>> getAllLigneFromAPI() async {

  const String url = 'http://10.0.2.2:1445/api/getLignes';
  
  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      // Convertir la liste dynamique en List<Map<String, dynamic>>
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load data');
    }
  } catch (e) {
    logger.e('$e');
    throw Exception('Failed to load data: $e');
  }
}


// Fonction pour vérifier si la suppression de la ligne est acceptable
Future<bool> canDeleteLigneFromAPI(String ligneLibele) async {
  final String url = 'http://10.0.2.2:1445/api/canDeleteLigne/$ligneLibele';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return true;  // La suppression est autorisée
    } else {
      return false;  // La suppression n'est pas autorisée
    }
  } catch (e) {
    logger.e('Erreur lors de la vérification de la suppression de la ligne: $e');
    return false;
  }
}



//supprimer une ligne
Future<bool> deleteLigneFromAPI(int ligneId) async {
  final String url = 'http://10.0.2.2:1445/api/deleteLigne/$ligneId';

  try {
    final response = await http.delete(Uri.parse(url));

    if (response.statusCode == 200) {
      return true;  // Suppression réussie
    } else {
      return false;  // Échec de la suppression
    }
  } catch (e) {
    logger.e('Erreur lors de la suppression de la ligne: $e');
    return false;
  }
}


//creer une ligne
Future<bool> createLigneFromAPI(String ligneLibele) async {
  try {

    final agentMatricule = await getCurrentUserMatricule();

    if (agentMatricule == null) {
      logger.e('Matricule agent introuvable');
      return false;
    }
    
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/api/creerLigne'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'libele': ligneLibele,
        'agentMatricule' : agentMatricule,
      }),
    );

    if (response.statusCode == 201) {
      // La ligne a été créée avec succès
      //print('fait');
      return true;
    } else {
      logger.e('Erreur lors de la création de la ligne : ${response.statusCode}');
      return false;
    }
  } catch (e) {
    logger.e('Exception lors de la création de la ligne : $e');
    return false;
  }
}


//marquer la ligne comme etant verouiller
Future<bool> updateStatutVerouillageFromAPI({
  required int ligneId,
}) async {
  const String url = 'http://10.0.2.2:1445/api/updateStatutVerouillage'; // Remplacez par l'URL correcte

  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'ligneId': ligneId,
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['success'] ?? false;
    } else {
      throw Exception('Failed to update tas state');
    }
  } catch (e) {
    throw Exception('Failed to update tas state: $e');
  }
}




//deverouiller une ligne revient à la marquer comme etant liberer et de creer une nouvelle ligne avec le meme libele
Future<bool> deverouillerLigneFromAPI(int ligneId, String ligneLibele) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/api/deverouillerLigne'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'ligneId': ligneId, 'ligneLibele' : ligneLibele}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      logger.e('Erreur: ${response.body}');
      return false;
    }
  } catch (e) {
    logger.e('Erreur lors du déverrouillage de la ligne: $e');
    return false;
  }
}


//Mettre à Jour le Tonnage de la Ligne depuis l'API
Future<bool> updateLigneTonnageFromAPI({
  required int ligneId,
  required String ligneLibele,
}) async {
  try {
    final Map<String, dynamic> data = {
      'ligneId': ligneId,
      'ligneLibele': ligneLibele,
    };

    // Log des données envoyées
    //logger.d('Données envoyées pour mise à jour du tonnage de la ligne: $data');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/api/updateLigneTonnage'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    // Log de la réponse de l'API
    //logger.d('Réponse API pour mise à jour du tonnage: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      logger.e('Erreur API pour mise à jour du tonnage: ${response.statusCode} - ${response.body}');
      return false;
    }
  } catch (e) {
    logger.e('Erreur lors de la mise à jour du tonnage: $e');
    return false;
  }
}



///Répartir le Tonnage entre les Tas depuis l'API
Future<bool> repartirTonnageTasFromAPI({
  required int ligneId,
}) async {
  try {
    final Map<String, dynamic> data = {
      'ligneId': ligneId,
    };

    // Log des données envoyées
    //logger.d('Données envoyées pour répartition du tonnage entre les tas: $data');

    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/api/repartirTonnageTas'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    // Log de la réponse de l'API
    //logger.d('Réponse API pour répartition du tonnage: ${response.statusCode} - ${response.body}');

    if (response.statusCode == 200) {
      return true;
    } else {
      logger.e('Erreur API pour répartition du tonnage: ${response.statusCode} - ${response.body}');
      return false;
    }
  } catch (e) {
    logger.e('Erreur lors de la répartition du tonnage: $e');
    return false;
  }
}
