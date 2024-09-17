import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();


//recuperer les camions decharger sur la table à canne 
Future<List<Map<String, dynamic>>> getCamionDechargerTableFromAPI() async {
  try {
    final response = await http
        .get(Uri.parse('http://192.168.1.190:80/api/camionsDechargerTable'))
        .timeout(const Duration(minutes: 10)); // Timeout après 10 secondes

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      //logger.e('la');

      return data.map((camion) => camion as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load camions déchargés (Table)');
    }
  } catch (e) {
    //logger.e('Error: $e');
    throw Exception('Failed to load data: $e');
  }
}


//recuperer les camions decharger sur la table à canne dans les dernière heure
Future<List<Map<String, dynamic>>> getCamionDechargerTableDerniereHeureFromAPI() async {
  const String url = 'http://192.168.1.190:80/api/camionsDechargerTableDerniereHeure';
  
  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }).timeout(const Duration(minutes: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      //logger.e('Réponse JSON: $data');
      return List<Map<String, dynamic>>.from(data);
    } else {
      logger.e('Erreur: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to load data');
    }
  } catch (e) {
    logger.e('Exception: $e');
    throw Exception('Failed to load data: $e');
  }
}



//enregistrer un dechargement dans la cour
Future<bool> saveDechargementTableFromAPI({
  required String veCode,
  required double poidsP1,
  required String techCoupe,
  required String parcelle,
  required DateTime dateHeureP1,
  required double poidsTare,
  required String matricule,
}) async {
  try {
    // Préparation des données à envoyer
    final Map<String, dynamic> data = {
      'veCode': veCode,
      'poidsP1': poidsP1,
      'techCoupe': techCoupe,
      'parcelle': parcelle,
      'dateHeureP1': dateHeureP1.toIso8601String(),
      'poidsTare': poidsTare,
      'matriculeAgent': matricule, // Correspond à agentMatricule dans la base de données
    };

    // Appel API
    final response = await http.post(
      Uri.parse('http://192.168.1.190:80/api/enregistrerDechargementTable'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to save camion: ${response.statusCode}');
    }
  } catch (e) {
    logger.e('Erreur lors de l\'enregistrement du camion: $e');
    return false;
  }
}


Future<bool> deleteCamionDechargerTableFromAPI(String veCode, String dateHeureDecharg) async {
  try {
    final response = await http.delete(
      Uri.parse('http://192.168.1.190:80/api/deleteCamionDechargerTable'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'veCode': veCode,
        'dateHeureDecharg': dateHeureDecharg,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to delete camion from table: ${response.statusCode}');
    }
  } catch (e) {
    logger.e('Erreur: $e');
    return false;
  }
}

