import 'dart:convert';
import 'package:Gedcocanne/auth/services/login_services.dart';
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
  final url = Uri.parse('http://10.0.2.2:1445/api/authenticate');

  final hashedPassword = hashPassword(password);

  //print(hashedPassword);

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'matricule': matricule, 'password': hashedPassword}),
    ).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      //logger.e('lq');
      final data = json.decode(response.body);
      if (data['success']) {
        await storeUserLocally(data['data']);
        return "true";
      } else {
        return "false";
      }
    } else {
      //logger.e('Erreur HTTP: ${response.statusCode}');
      //logger.e('la');
      return "false";
    }
  } catch (e) {
    //logger.e('Erreur lors de la connexion API : $e');
    return "error";
  }
}


//si tu utilises la fonction `hashPassword("admin")`, voici le résultat du hachage SHA-256 pour le mot de passe `"admin"` :

// ```
// 8c6976e5b5410415bde908bd4dee15dfb16e0d42d70b2fd95a42d5a9a7c3ee07
// ```