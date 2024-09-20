import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();


/*************************
 SYNCHRONISATION
*************************/

/*************************
 SYNCHRONISATION
*************************/

/// Envoie les données des agents à l'API et retourne `true` si l'enregistrement a réussi, sinon `false`.
Future<bool> sendToApiSyncAgent(List<Map<String, dynamic>> agents) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/api/syncAgents'), // Remplacez par l'URL de votre API
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'agents': agents}),
    ).timeout(const Duration(seconds: 10)); // Timeout de 5 secondes
    return response.statusCode == 200; // Retourne `true` si la réponse HTTP est 200 (OK)
  } catch (e) {
    logger.e('object $e');
    return false;
  }
}



