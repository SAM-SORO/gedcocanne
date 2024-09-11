import 'dart:convert';
import 'package:Gedcocanne/auth/services/login_services.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

//***********************************
// BROYAGE
//***************************


// Ajouter un tas dans TableCanne et envoyer les données à l'API
Future<bool> addTasDansTableCanneFromAPI({
  required int tasId,  // L'ID de la ligne est un entier
}) async {
  const String url = 'http://10.0.2.2:1445/api/addTasInTableCanne'; // Remplacez par l'URL correcte

  final agentMatricule = await getCurrentUserMatricule();

  if (agentMatricule == null) {
    logger.e('Matricule agent introuvable');
    return false;
  }

  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'tasId': tasId,           // Transmettez ligneId comme entier
        'agentMatricule': agentMatricule,  // Transmettez le matricule de l'agent
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['success'] ?? false;
    } else {
      logger.e('Échec lors de l\'ajout du tas à TableCanne');
      return false;
    }
  } catch (e) {
    logger.e('Échec lors de l\'ajout du tas à TableCanne: $e');
    return false;
  }
}


// Annuler la coche d'un tas en retirant le poids du tonnage de la ligne
Future<String> retirerTasDeTableCanneFromAPI({
  required int tasId,  // L'ID de la ligne
}) async {
  const String url = 'http://10.0.2.2:1445/api/retraitTasDeTableCanne'; // Remplacez par l'URL correcte

  final agentMatricule = await getCurrentUserMatricule(); // Récupération du matricule de l'agent

  if (agentMatricule == null) {
    logger.e('Matricule agent introuvable');
    return 'false';
  }

  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'tasId': tasId,           // Transmettez l'ID de la ligne
        'agentMatricule': agentMatricule,  // Transmettez le matricule de l'agent
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['success']) {
        return 'true';
      } else if (data['non_autorise']) {
        return 'non_autorise';  // Si l'agent n'est pas autorisé à retirer le tas
      } else {
        logger.e('Erreur: ${response.statusCode}');
        return 'false';
      }
    } else if ( response.statusCode == 403) {
      //logger.e('Échec lors de la suppression du tas de TableCanne. Code: ${response.statusCode}');
       return 'non_autorise';
    }else{
      logger.e('Échec lors de la suppression du tas de TableCanne. Code: ${response.statusCode}');
      return 'erreur';
    }
  } catch (e) {
    logger.e('Échec lors de la suppression du tas de TableCanne: $e');
    return 'erreur';
  }
}



//verifier si tous les tas d'une ligne donnée sont broyé c'est à dire on un etat=1
Future<bool> verifierTousTasCochesFromAPI(int ligneId) async {
  String url = 'http://10.0.2.2:1445/api/verifierTousTasCoches/$ligneId'; // Remplacez par l'URL correcte

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
      },
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['estTousCoches'] ?? false;
    } else {
      throw Exception('Failed to check if all tas are checked. Status code: ${response.statusCode}');
    }
  } catch (e) {
    logger.e('Error: $e'); // Optionnel : afficher l'erreur pour débogage
    throw Exception('Failed to check if all tas are checked: $e');
  }
}


// Fonction pour mettre à jour le nombre de tas via l'API
Future<bool> updateNombreTasFromAPI({
  required int ligneId,
  required int nouveauNombreTas,
}) async {
  const String url = 'http://10.0.2.2:1445/api/updateNombreTas'; // Remplacez par l'URL correcte

  try {
    // Envoie d'une requête POST à l'API
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'ligneId': ligneId,
        'nouveauNombreTas': nouveauNombreTas,
      }),
    ).timeout(const Duration(seconds: 10));

    // Vérification de la réponse
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['success'] ?? false;
    } else {
      logger.e("à echoué");
      return false;
    }
  } catch (e) {
    // En cas d'erreur, renvoyer false
    logger.e("erreur $e");
    return false;
  }
}


//permet de marquer tout les camions affecer à ligne comme etant broyer (sera utile dans le cas du deverouillage d'une ligne)
Future<bool> updateEtatBroyageOfCamionFromAPI(int ligneId) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/api/updateEtatBroyageOfCamionAffecte'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'ligneId': ligneId}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      logger.e('Erreur: ${response.body}');
      return false;
    }
  } catch (e) {
    logger.e('Erreur lors de la mise à jour de l\'état de broyage: $e');
    return false;
  }
}


