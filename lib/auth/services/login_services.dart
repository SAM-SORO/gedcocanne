import 'package:gedcocanne/models/agent.dart';
import 'package:gedcocanne/models/current_user.dart';
import 'package:gedcocanne/services/database.dart';
import 'package:isar/isar.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:logger/logger.dart';

final logger = Logger();


  
String hashPassword(String password) {
  // Utiliser SHA-256 pour le hachage
  return sha256.convert(utf8.encode(password)).toString();
}

Future<String> authenticateUser(String matricule, String password) async {
  
  final isar = await Database.getInstance();

  final hashedPassword = hashPassword(password);

  try {
    final agent = await isar.agents
        .filter()
        .matriculeEqualTo(matricule)
        .passwordEqualTo(hashedPassword)
        .findFirst();

    if (agent != null) {
      await isar.writeTxn(() async {
        await isar.currentUsers.clear();
        CurrentUser currentUser = CurrentUser()
          ..userId = agent.id;
        await isar.currentUsers.put(currentUser);
      });
      return 'true';
    } else {
      return 'false';
    }
  } catch (e) {
    //print("Erreur lors de l'authentification : $e");
    return 'error';
  }
}


// Fonction pour stocker les informations de l'utilisateur localement
Future<void> storeUserLocally(Map<String, dynamic> userData) async {
  final isar = await Database.getInstance();
  await isar.writeTxn(() async {
    // Stocker les informations de l'agent dans la table `Agent`
    //await isar.agents.clear(); // Supprimer les anciens agents
    Agent agent = Agent()
      ..matricule = userData['matricule']
      ..password = userData['password']
      ..role = userData['role'] // Ajouter le rôle
      ..etatSynchronisation = true;
    int agentId = await isar.agents.put(agent); // Enregistrer l'agent et récupérer l'ID

    // Stocker les informations de l'utilisateur actuel dans `CurrentUser`
    await isar.currentUsers.clear(); // Supprimer les anciens utilisateurs
    CurrentUser currentUser = CurrentUser()
      ..userId = agentId; // Utiliser l'ID récupéré ici

    await isar.currentUsers.put(currentUser);
  });
}


// Fonction pour vérifier si un utilisateur est connecté
Future <bool> userIsInSession() async {
  final isar = await Database.getInstance();
  final currentUser = await isar.currentUsers.where().findFirst();
  return currentUser != null;
}



// Fonction pour déconnecter l'utilisateur
Future<void> logout() async {
  final isar = await Database.getInstance();
  final currentUser = await isar.currentUsers.where().findFirst();
  if (currentUser != null) {
    await isar.writeTxn(() async {
      await isar.currentUsers.delete(currentUser.id);
    });
  }
}

//Fonction pour obtenir l'identifiant de l'utilisateur connecté
Future<int?> getCurrentUserId() async {
  final isar = await Database.getInstance();
  final currentUser = await isar.currentUsers.where().findFirst();
  return currentUser?.userId;
}

Future<String?> getCurrentUserMatricule() async {
  final isar = await Database.getInstance();
  final currentUser = await isar.currentUsers.where().findFirst();
  final agent = await isar.agents.get(currentUser!.userId);
  return agent?.matricule;
}


// Fonction pour vérifier si l'utilisateur connecté est un admin
Future<bool> isAdmin() async {
  final isar = await Database.getInstance();
  final userId = await getCurrentUserId();

  if (userId != null) {
    final currentUser = await isar.agents.where().idEqualTo(userId).findFirst();
    if (currentUser != null && currentUser.role == 'admin') {
      return true;
    }
  }
  return false;
}



/*  
  Utilisation d'un Algorithme de Hachage Sécurisé : SHA-256 est acceptable pour des usages généraux, mais pour des mots de passe, des algorithmes comme bcrypt sont souvent recommandés pour une sécurité accrue.
 */