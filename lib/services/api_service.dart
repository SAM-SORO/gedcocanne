import 'dart:convert';
import 'package:gedcocanne/auth/services/login_services.dart';
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



///////////////////////////CAMIONS EN ATTENTE ET CAMIONS DECHARGER

// récuperer les camions en attente
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


//recuperer les camions decharger sur la table à canne 
Future<List<Map<String, dynamic>>> getCamionDechargerTableFromAPI() async {
  try {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:1445/camionsDechargerTable'))
        .timeout(const Duration(seconds: 10)); // Timeout après 10 secondes

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

//recuperer les camions decharger dans la cours (on prendra ceux decharger dans les 15 dernier jours) 
Future<List<Map<String, dynamic>>> getCamionDechargerCoursFromAPI() async {
  try {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:1445/camionsDechargerCours'))
        .timeout(const Duration(seconds: 10)); // Timeout après 10 secondes

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      //logger.e('ici');
      return data.map((camion) => camion as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to load camions déchargés (Cours)');
    }
  } catch (e) {
    //logger.e('Error: $e');
    throw Exception('Failed to load data: $e');
  }
}


//recuperer les camions decharger sur la table à canne dans les dernière heure
Future<List<Map<String, dynamic>>> getCamionDechargerTableDerniereHeureFromAPI() async {
  const String url = 'http://10.0.2.2:1445/camionsDechargerTableDerniereHeure';
  
  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      //logger.e('Réponse JSON: $data');
      return List<Map<String, dynamic>>.from(data);
    } else {
      //logger.e('Erreur: ${response.statusCode} ${response.reasonPhrase}');
      throw Exception('Failed to load data');
    }
  } catch (e) {
    //logger.e('Exception: $e');
    throw Exception('Failed to load data: $e');
  }
}



//recuperer les camions decharger dans la cour à canne dans les dernière heure
Future<List<Map<String, dynamic>>> getCamionDechargerCoursDerniereHeureFromAPI() async {
  const String url = 'https://10.0.2.2:1445/dechargerCoursDerniereHeure';
  
  try {
    final response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    }).timeout(const Duration(seconds: 10));

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
      Uri.parse('http://10.0.2.2:1445/enregistrerDechargementTable'),
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
      Uri.parse('http://10.0.2.2:1445/deleteCamionDechargerTable'),
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




///////////////
//LIGNE & TAS
////////////////




// Récupérer toutes les lignes depuis l'API
Future<List<Map<String, dynamic>>> getAllLigneFromAPI() async {
  const String url = 'https://10.0.2.2:1445/allLigne';
  
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
    throw Exception('Failed to load data: $e');
  }
}


//supprimer une ligne
Future<bool> deleteLigneFromAPI(int ligneId) async {
  final String url = 'https://10.0.2.2:1445/deleteLigne/$ligneId';

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
Future<bool> createLigneFromAPI(String libelle, int agentId) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/creerLigne'), 
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'libelle': libelle,
        'agentId': agentId,
      }),
    );

    if (response.statusCode == 201) {
      // La ligne a été créée avec succès
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


//deverouiller une ligne revient à la restaurer avec ces valeurs par defaut
Future<bool> deverouillerLigneFromAPI(int ligneId) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/deverouillerLigne'),
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
    logger.e('Erreur lors du déverrouillage de la ligne: $e');
    return false;
  }
}



//mettre à jour l’état des tas via l’API.
Future<bool> updateEtatTasFromAPI({
  required int ligneId,
  required int tasId,
  required int nouvelEtat,
}) async {
  const String url = 'https://10.0.2.2:1445/updateEtatTas'; // Remplacez par l'URL correcte

  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'ligneId': ligneId,
        'tasId': tasId,
        'nouvelEtat': nouvelEtat,
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


//broyer un tas revient a ajouter son poids au tonnanage boyer par tas

Future<bool> addTasDansTableCanneFromAPI({
  required int ligneId,
  required double tasPoids,
}) async {
  const String url = 'https://10.0.2.2:1445/addTasInTableCanne'; // Remplacez par l'URL correcte

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'ligneId': ligneId,
        'tasPoids': tasPoids,
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['success'] ?? false;
    } else {
      throw Exception('Failed to add tas to TableCanne');
    }
  } catch (e) {
    throw Exception('Failed to add tas to TableCanne: $e');
  }
}


//annuler la coche d'un tas revient a dire qu'on s'etait tromper donc on retire le poids du tonnage
Future<bool> retirerTasDeTableCanneFromAPI({
  required int ligneId,
  required double tasPoids,
}) async {
  const String url = 'https://10.0.2.2:1445/retraitTasDeTableCanne'; // Remplacez par l'URL correcte

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'ligneId': ligneId,
        'tasPoids': tasPoids,
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['success'] ?? false;
    } else {
      throw Exception('Failed to remove tas from TableCanne. Status code: ${response.statusCode}');
    }
  } catch (e) {
    logger.e('Error: $e'); // Optionnel : afficher l'erreur pour débogage
    throw Exception('Failed to remove tas from TableCanne: $e');
  }
}


//verifier si tous les tas d'une ligne donnée sont broyé c'est à dire on un etat=1
Future<bool> verifierTousTasCochesFromAPI(int ligneId) async {
  String url = 'https://10.0.2.2:1445/verifierTousTasCoches/$ligneId'; // Remplacez par l'URL correcte

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
  const String url = 'https://10.0.2.2:1445/updateNombreTas'; // Remplacez par l'URL correcte

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
      return false;
    }
  } catch (e) {
    // En cas d'erreur, renvoyer false
    return false;
  }
}



Future<int> getLigneCountFromAPI() async {
  try {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:1445/getLigneCount'),
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




///////////////
//AFFECTATION
////////////////




//enregistrement un dechargement dans la cour
Future<bool> saveDechargementCoursFromAPI({
  required String veCode,
  required double poidsP1,
  required String techCoupe,
  required String parcelle,
  required DateTime dateHeureP1,
  required String ligneLibele, // Correction: Utilisation d'un String pour ligneLibele
}) async {
  try {
    // Récupérer le poidsTare via l'API
    final poidsTare = await recupererPoidsTare(veCode: veCode, dateHeureP1: dateHeureP1);

    if (poidsTare == null) {
      // Gestion de l'erreur si le poidsTare est introuvable
      return false; // Retourner false si le poidsTare est introuvable
    }

    final agentMatricule = await getCurrentUserMatricule(); // Obtient l'identifiant de l'agent connecté

    if (agentMatricule == null) {
      // Gestion de l'erreur si le matricule de l'agent est introuvable
      return false; // Retourner false si le matricule de l'agent est introuvable
    }

    // Préparer les données à envoyer
    final Map<String, dynamic> data = {
      'veCode': veCode,
      'poidsP1': poidsP1,
      'poidsTare': poidsTare,
      'techCoupe': techCoupe,
      'parcelle': parcelle,
      'dateHeureP1': dateHeureP1.toIso8601String(),
      'ligneLibele': ligneLibele, // LigneLibele est maintenant un String
      'matriculeAgent': agentMatricule,
      'etatBroyage': 0, // Initialisation de l'état de broyage à 0
    };

    // Appel API
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/enregistrerDechargementCours'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return true; // Retourner true si l'enregistrement est réussi
    } else {
      throw Exception('Failed to save camion in Cours: ${response.statusCode}');
    }
  } catch (e) {
    return false; // Retourner false en cas d'exception
  }
}


//Supprimer un camion affecter à une ligne
Future<bool> deleteCamionDechargerCoursFromAPI({
  required String veCode, 
  required DateTime dateHeureP1,
}) async {
  try {
    final response = await http.delete(
      Uri.parse('http://10.0.2.2:1445/deleteCamionDechargerCours'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'veCode': veCode,
        'dateHeureP1': dateHeureP1.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      return true; // Suppression réussie
    } else {
      logger.e('Erreur: ${response.body}');
      return false; // Suppression échouée
    }
  } catch (e) {
    logger.e('Erreur lors de la suppression du camion: $e');
    return false; // Erreur pendant la communication avec le serveur
  }
}


//recuperer les camions affecter a une ligne
Future<List<Map<String, dynamic>>> recupererCamionsLigneFromAPI(String ligneLibele) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/getCamionsOfLigne'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'ligneLibele': ligneLibele}),
    );

    if (response.statusCode == 200) {
      // Décoder la réponse JSON en une liste de camions
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      logger.e('Erreur: ${response.body}');
      return [];
    }
  } catch (e) {
    logger.e('Erreur lors de la récupération des camions: $e');
    return [];
  }
}


//verifier s'il y'a un camion affecter à la ligne
Future<bool> verifierAffectationLigneFromAPI({required String ligneLibele}) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/verifierAffectationLigne'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'ligneLibele': ligneLibele}),
    );

    if (response.statusCode == 200) {
      // La réponse attendue est un booléen : true si au moins un camion est affecté, false sinon
      return json.decode(response.body) as bool;
    } else {
      logger.e('Erreur: ${response.body}');
      return false;
    }
  } catch (e) {
    logger.e('Erreur lors de la vérification de l\'affectation: $e');
    return false;
  }
}


//permet de marquer tout les camions d'une ligne comme etant broyer
Future<bool> updateEtatBroyageFromAPI(String ligneLibele) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/updateEtatBroyage'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'ligneLibele': ligneLibele}),
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



///////////////
//UPDATE POIDS P2
////////////////


Future<List<Map<String, dynamic>>> getCamionsWithP2NullCoursFromAPI() async {
  try {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:1445/camionsP2NullCours'),
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
      Uri.parse('http://10.0.2.2:1445/camionsP2NullTable'),
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


Future<bool> updatePoidsP2CoursFromAPI(List<Map<String, dynamic>> camions) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/updatePoidsP2Cours'),
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


Future<bool> updatePoidsP2TableFromAPI(List<Map<String, dynamic>> camions) async {
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:1445/updatePoidsP2Table'),
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



//mettre a jour les poids P2
Future<String> updatePoidsP2ForCamionsWithP2Null() async {
  bool updatedP2Cours = false;
  bool updatedP2Table = false;

  try {
    // Étape 1 : Récupérer les camions pour lesquelles la deuxieme pessee n'a pas encore ete effectuer
    final camionsCoursToUpdate = await getCamionsWithP2NullCoursFromAPI();
    final camionsTableToUpdate = await getCamionsWithP2NullTableFromAPI();

    // Étape 2 : Récupérer les poids P2 depuis l'API REST
    if (camionsCoursToUpdate.isNotEmpty) {
      try {
        final camionsCoursAvecPoidsP2Null = await getPoidsP2FromAPI(camionsCoursToUpdate)
            .timeout(Duration(seconds: 10)); // Définir un délai d'attente de 10 secondes

        updatedP2Cours = await updatePoidsP2CoursFromAPI(camionsCoursAvecPoidsP2Null);
      } catch (e) {
        //logger.e('Erreur lors de la récupération des poids P2 (Cours) : $e');
        return 'error';
      }
    }

    if (camionsTableToUpdate.isNotEmpty) {
      try {
        final camionsTableAvecPoidsP2Null = await getPoidsP2FromAPI(camionsTableToUpdate)
            .timeout(const Duration(seconds: 10)); // Définir un délai d'attente de 10 secondes

        updatedP2Table = await updatePoidsP2TableFromAPI(camionsTableAvecPoidsP2Null);
      } catch (e) {
        //logger.e('Erreur lors de la récupération des poids P2 (Table) : $e');
        return 'error';
      }
    }

    // Étape 3 : Vérifier si des poids ont été mis à jour
    if (updatedP2Cours || updatedP2Table) {
      return 'true';
    } else {
      return 'false';
    }

  } catch (e) {
    logger.e('Erreur lors de la synchronisation des poids P2 : $e');
    return 'error';
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



Future<bool> thereAreSynchronisationOfP2FromAPI() async {
  try {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:1445/checkPoidsP2Null'),
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







/*************************
 SYNCHRONISATION
*************************/

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
    //logger.e(agents);
    return response.statusCode == 200; // Retourne `true` si la réponse HTTP est 200 (OK)
  } catch (e) {
    //logger.e('object $e');
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
      //logger.e('Échec de la synchronisation : ${response.statusCode}');
      return false;
    }
  } catch (e) {
    // Gérer les exceptions, y compris les timeouts
    //logger.e('Erreur lors de l\'envoi des données : $e');
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
      logger.e('Erreur lors de la synchronisation. Statut HTTP: ${response.statusCode}, Message: ${response.body}');
      return false;
    }
  } catch (e) {
    logger.e('Exception lors de l\'envoi à l\'API: $e');
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
    logger.e('Error: $e');
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
      logger.e(response.statusCode);
      // Si la requête échoue, lancer une exception
      throw Exception('Failed to load stockBroyerDirect');
    }
  } catch (e) {
    // Impression de l'erreur en cas d'échec
    logger.e('Error: $e');
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
    logger.e('Error: $e');
    return null;
  }
}







/*
////10.0.2.2:1445
///10.0.2.2:1445
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
      logger.e('Échec de la synchronisation : ${response.statusCode} - ${response.body}');
      return false;
    }
  } catch (e) {
    // Gérer les erreurs de réseau ou autres exceptions
    logger.e('Erreur lors de la synchronisation : $e');
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