import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

final logger = Logger();

///////////////
//UPDATE POIDS P2
////////////////



Future<bool> thereAreSynchronisationOfP2FromAPI() async {
  try {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:1445/api/checkPoidsP2Null'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['needsUpdate'];
    } else {
      // Gérer les erreurs HTTP non 200
      throw Exception('Erreur du serveur : ${response.statusCode}');
    }
  } catch (e) {
    // Capturer les exceptions liées aux erreurs de connexion
    throw Exception('Erreur de connexion à l\'API');
  }
}



Future<List<Map<String, dynamic>>> getCamionsWithP2NullCoursFromAPI() async {
  try {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:1445/api/camionsP2NullCours'),
      headers: {'Content-Type': 'application/json'},
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


Future<List<Map<String, dynamic>>> getCamionsWithP2NullTableFromAPI() async {
  try {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:1445/api/camionsP2NullTable'),
      headers: {'Content-Type': 'application/json'},
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


// Fonction pour récupérer les poids P2 depuis l'API
Future<List<Map<String, dynamic>>> getPoidsP2ForTableFromAPI(List<Map<String, dynamic>> camions) async {
  try {
    // Convertir les objets DateTime en chaînes ISO8601
    final camionsFormatted = camions.map((camion) {
      return {
        'veCode': camion['veCode'],
        'dateHeureP1': (camion['dateHeureP1']),
        'poidsP1': camion['poidsP1'],
      };
    }).toList();

    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/api/getPoidsP2'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'camions': camionsFormatted}),
    );

    if (response.statusCode == 200) {
    
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      
    } else {
      // Gérer les erreurs HTTP non 200
      throw Exception('Erreur serveur lors de la recuperation du poids P2 : ${response.statusCode}');

    }
  } catch (e) {
    // Capturer les exceptions liées aux erreurs de connexion
    //logger.e('Erreur de connexion à l\'API : $e');
    throw Exception('Erreur de connexion à l\'API lors de la tentative de recuperation des poids P2 $e');

  }
}



// Fonction pour récupérer les poids P2 depuis l'API
Future<List<Map<String, dynamic>>> getPoidsP2ForCoursFromAPI(List<Map<String, dynamic>> camions) async {
  try {
    // Convertir les objets DateTime en chaînes ISO8601
    final camionsFormatted = camions.map((camion) {
      return {
        'veCode': camion['veCode'],
        'dateHeureP1': (camion['dateHeureP1']),
        'poidsP1': camion['poidsP1'],
        'ligneId': camion['ligneId'],
      };
    }).toList();

    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/api/getPoidsP2'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'camions': camionsFormatted}),
    );

    if (response.statusCode == 200) {
    
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      
    } else {
      // Gérer les erreurs HTTP non 200
      throw Exception('Erreur serveur lors de la recuperation du poids P2 : ${response.statusCode}');

    }
  } catch (e) {
    // Capturer les exceptions liées aux erreurs de connexion
    //logger.e('Erreur de connexion à l\'API : $e');
    throw Exception('Erreur de connexion à l\'API lors de la tentative de recuperation des poids P2 $e');

  }
}


//permet de mettre le poids P2 pour les camions de la table dechargerTable
Future<bool> updatePoidsP2CoursFromAPI(List<Map<String, dynamic>> camions) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/api/updatePoidsP2Cours'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'camions': camions}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['updated'] == true;
    } else {
      // Gérer les erreurs HTTP non 200
      logger.e('Erreur serveur lors de la mise à jour du poids P2 : ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // Capturer les exceptions liées aux erreurs de connexion
    logger.e('Erreur de connexion à l\'API lors de la tentative de mise à jour du poids P2');
    return false;
  }
}


//permet de mettre le poids P2 pour les camions de la table dechargerTable
Future<bool> updatePoidsP2TableFromAPI(List<Map<String, dynamic>> camions) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/api/updatePoidsP2Table'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'camions': camions}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['updated'] == true;
    } else {
      // Gérer les erreurs HTTP non 200
      throw Exception('Erreur du serveur : ${response.statusCode}');
    }
  } catch (e) {
    // Capturer les exceptions liées aux erreurs de connexion
    throw Exception('Erreur de connexion à l\'API');
  }
}



// appelera les deux methode qui precede pour mettre a jour les poids P2
Future<String> updatePoidsP2ForCamionsWithP2Null() async {
  bool updatedP2Cours = false;
  bool updatedP2Table = false;

  try {
    // Étape 1 : Récupérer les camions pour lesquelles la deuxieme pessee n'a pas encore ete effectuer
    final camionsCoursToUpdate = await getCamionsWithP2NullCoursFromAPI();
    final camionsTableToUpdate = await getCamionsWithP2NullTableFromAPI();

    //print(camionsCoursToUpdate);

    // Étape 2 : Récupérer les poids P2 depuis l'API REST
    if (camionsCoursToUpdate.isNotEmpty) {
      try {
        final camionsCoursAvecPoidsP2Null = await getPoidsP2ForCoursFromAPI(camionsCoursToUpdate)
            .timeout(const Duration(seconds: 10)); // Définir un délai d'attente de 10 secondes

        updatedP2Cours = await updatePoidsP2CoursFromAPI(camionsCoursAvecPoidsP2Null);
      } catch (e) {
        logger.e('Erreur lors de la récupération des poids P2 (Cours) : $e');
        return 'error';
      }
    }

    if (camionsTableToUpdate.isNotEmpty) {
      try {
        final camionsTableAvecPoidsP2Null = await getPoidsP2ForTableFromAPI(camionsTableToUpdate)
            .timeout(const Duration(seconds: 10)); // Définir un délai d'attente de 10 secondes

        updatedP2Table = await updatePoidsP2TableFromAPI(camionsTableAvecPoidsP2Null);
      } catch (e) {
        logger.e('Erreur lors de la récupération des poids P2 (Table) : $e');
        return 'error';
      }
    }

    //Étape 3 : Vérifier si des poids ont été mis à jour
    if (updatedP2Cours || updatedP2Table) {
      return 'true';
    } else {
      //Une mise a jour à échoué
      return 'false';
    }

  } catch (e) {
    logger.e('Erreur lors de la synchronisation des poids P2 : $e');
    return 'error';
  }
}




