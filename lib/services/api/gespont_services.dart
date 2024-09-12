import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();


// récuperer les camions en attente
Future<List<Map<String, String>>> getCamionAttenteFromAPI() async {
  try {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:1445/api/camionsEnAttente'))
        .timeout(const Duration(minutes: 5)); // Timeout après 5 minutes

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((camion) => {
        'VE_CODE': camion['VE_CODE']?.toString() ?? '',
        'PR_CODE': camion['PR_CODE']?.toString() ?? '',
        'TN_CODE': camion['TN_CODE']?.toString() ?? '',
        'PS_CODE': camion['PS_CODE']?.toString() ?? '',
        'PS_TECH_COUPE': camion['PS_TECH_COUPE']?.toString() ?? '',
        'PS_POIDSP1': camion['PS_POIDSP1']?.toString() ?? '',
        'PS_DATEHEUREP1': camion['PS_DATEHEUREP1']?.toString() ?? '',
      }).toList();
    } else {
      throw Exception('Failed to load camions en attente');
    }
  } catch (e) {
    //logger.e('Error: $e');
    throw Exception('Failed to load camions en attente: $e');
  }
}


// Fonction pour récupérer le poids de la dernière tare depuis l'API
Future<double?> recupererPoidsTare({
  required String veCode,
}) async {
  try {
    final uri = Uri.parse('http://10.0.2.2:1445/api/getPoidsTare?veCode=$veCode');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['PS_POIDSP2'] as num?)?.toDouble(); 
    } else {
      throw Exception('Échec de la récupération du poidsTare');
    }
  } catch (error) {
    logger.e('Erreur lors de la récupération du poids de la tare: $error');
    return null; // Renvoie null en cas d'erreur
  }
}


Future<double?> getTonnageCanneCamionAttenteFromAPI(List<Map<String, String>> camionsEnAttente) async {
  try {
    // Récupérer les camions en attente
    //final camions = await getCamionAttenteFromAPI();
    double tonnageTotal = 0;

    if (camionsEnAttente.isNotEmpty){
      // Parcourir chaque camion et calculer son poids net
    for (var camion in camionsEnAttente) {
      final veCode = camion['VE_CODE']!;
        final poidsP1 = double.parse(camion['PS_POIDSP1']!);

      // Récupérer le poids de la dernière tare du camion
      final poidsTare = await recupererPoidsTare(veCode: veCode);

      if (poidsTare != null) {
        // Calculer le poids net du camion (poidsP1 - poidsTare)
        final poidsNet = poidsP1 - poidsTare;
        // Ajouter le poids net au tonnage total
        tonnageTotal += poidsNet;
      } else {
        // Gérer le cas où le poidsTare est introuvable
        logger.e('Poids tare introuvable pour le camion $veCode');
      }
    }
    }
    
    return tonnageTotal;
  } catch (e) {
    // Gérer les erreurs
    logger.e('Erreur lors de la récupération du tonnage total des camions en attente: $e');
    return null;
    //throw e;
  }
}
