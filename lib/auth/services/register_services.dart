import 'dart:convert';
import 'package:Gedcocanne/models/agent.dart';
import 'package:Gedcocanne/models/current_user.dart';
import 'package:Gedcocanne/services/isar/database.dart';
import 'package:crypto/crypto.dart';
import 'package:isar/isar.dart';

// Fonction pour hacher le mot de passe avec SHA-256
String hashPassword(String password) {
  return sha256.convert(utf8.encode(password)).toString();
}

Future<bool> registerAgent(String matricule, String password, String role) async {
  // Créer une instance d'Isar
  final isar = await Database.getInstance();

  // Vérifier si l'agent existe déjà dans la base de données
  var agent = await isar.agents.filter().matriculeEqualTo(matricule).findFirst();

  // Si l'agent existe déjà, mettre à jour ses informations
  if (agent != null) {
    await isar.writeTxn(() async {
      // Hacher le mot de passe avant de le stocker
      final hashedPassword = hashPassword(password);
      agent.role = role;
      agent.etatModification = true;
      agent.password = hashedPassword; // Mettre à jour le mot de passe haché
      await isar.agents.put(agent); // Sauvegarder les modifications
    });
  } else {
    // Si l'agent n'existe pas, en créer un nouveau avec le mot de passe haché
    final hashedPassword = hashPassword(password);
    final nouvelAgent = Agent()
      ..matricule = matricule
      ..password = hashedPassword
      ..role = role;

    try {
      // Insérer le nouvel agent dans la base de données Isar
      await isar.writeTxn(() async {
        await isar.agents.put(nouvelAgent);
      });
      return true; // Retourner true si l'enregistrement est réussi
    } catch (e) {
      // Gestion des erreurs
      return false; // Retourner false en cas d'erreur
    }
  }
  return true;
}


Future<bool> updatePassword(String matricule, String newPassword) async {
  final isar = await Database.getInstance();
  var agent = await isar.agents.filter().matriculeEqualTo(matricule).findFirst();
  
  if (agent != null) {
    final hashedPassword = hashPassword(newPassword);
    await isar.writeTxn(() async {
      // Hacher le nouveau mot de passe avant de le stocker
      agent.password = hashedPassword;
      agent.etatModification = true;
      await isar.agents.put(agent);
    });
    return true;
  }
  return false;
}


Future<String?> getCurrentUserPassword() async {
  final isar = await Database.getInstance();
  final currentUser = await isar.currentUsers.where().findFirst();
  final agent = await isar.agents.get(currentUser!.userId);
  return agent?.password; // Retourne le mot de passe haché
}
