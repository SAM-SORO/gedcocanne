import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();


// récuperer les camions en attente
Future<List<Map<String, String>>> getCamionAttenteFromAPI() async {
  try {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:1445/api/camionsEnAttente'))
        .timeout(const Duration(minutes: 5)); // Timeout après 10 secondes

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
    throw Exception('Failed to load camions en attente $e');
  }
}



// Fonction pour récupérer le poids de la derniere tare poidsTare d'un camion depuis l'API
Future<double?> recupererPoidsTare({
  required String veCode,
  required DateTime dateHeureP1,
}) async {
  final uri = Uri.parse('http://10.0.2.2:1445/api/getPoidsTare?veCode=$veCode&dateHeureP1=${dateHeureP1.toIso8601String()}');

  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['PS_POIDSTare']?.toDouble();
  } else {
    throw Exception('Failed to load poidsTare');
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
      final dateHeureP1 = DateTime.parse(camion['DATEHEUREP1']!);
      final poidsP1 = double.parse(camion['PS_POIDSP1']!);

      // Récupérer le poids de la dernière tare du camion
      final poidsTare = await recupererPoidsTare(veCode: veCode, dateHeureP1: dateHeureP1);

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
