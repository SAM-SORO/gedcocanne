import 'package:Gedcocanne/models/agent.dart';
import 'package:Gedcocanne/services/api/synchro_services.dart';
import 'package:Gedcocanne/services/isar/database.dart';
import 'package:isar/isar.dart';

// Fonction pour récupérer les agents non synchronisés
Future<List<Map<String, dynamic>>> getAgentsNonSynchronises() async {
  final isar = await Database.getInstance();

  final agents = await isar.agents
      .filter()
      .etatSynchronisationEqualTo(false) // Non synchronisés avec le serveur distant
      .findAll();

  return agents.map((agent) {
    return {
      'id' : agent.id,
      'matricule': agent.matricule,
      'password': agent.password,
      'role': agent.role,
      'etatSynchronisation': agent.etatSynchronisation,
      'etatModification': agent.etatModification,
    };
  }).toList();
}

// Fonction pour récupérer les agents à mettre à jour
Future<List<Map<String, dynamic>>> getAgentsAMettreAJour() async {
  final isar = await Database.getInstance();

  final agents = await isar.agents
      .filter()
      .etatSynchronisationEqualTo(true) // Déjà synchronisés
      .etatModificationEqualTo(true) // Nécessitent une mise à jour
      .findAll();

  return agents.map((agent) {
    return {
      'id' : agent.id,
      'matricule': agent.matricule,
      'password': agent.password,
      'role': agent.role,
      'etatSynchronisation': agent.etatSynchronisation,
    };
  }).toList();
}


// Fonction pour mettre à jour l'état de synchronisation dans la base de données locale

Future<void> updateEtatAgentNonSyncroniser(List<int> agentIds) async {
  final isar = await Database.getInstance();
  // Récupérer les agents depuis Isar et mettre à jour l'état de synchronisation
  await isar.writeTxn(() async {
    for (var id in agentIds) {
      final agent = await isar.agents.get(id);
      if (agent != null) {
        agent.etatSynchronisation = true;
        agent.etatModification = false;
        await isar.agents.put(agent); // Mettre à jour l'agent dans Isar
      }
    }
  });
}


// Fonction pour réinitialiser l'état de modification dans la base de données locale
Future<void> resetEtatModification(List<int> agentIds) async {
  final isar = await Database.getInstance();

  await isar.writeTxn(() async {
    for (var id in agentIds) {
      final agent = await isar.agents.get(id);
      if (agent != null) {
        agent.etatModification = false;
        await isar.agents.put(agent); // Mettre à jour l'agent dans Isar
      }
    }
  });
}

Future<bool> thereAreSynchronisationForAgent() async {
  final isar = await Database.getInstance();

  // Vérifier s'il y a des agents non synchronisés
  final agentsNonSynchronises = await isar.agents
      .filter()
      .etatSynchronisationEqualTo(false) // Non synchronisés
      .findFirst();

  if (agentsNonSynchronises != null) {
    // Il y a des agents non synchronisés
    return true;
  }

  // Vérifier s'il y a des agents synchronisés mais modifiés
  final agentsAMettreAJour = await isar.agents
      .filter()
      .etatSynchronisationEqualTo(true) // Déjà synchronisés
      .etatModificationEqualTo(true) // modifiés
      .findFirst();

  if (agentsAMettreAJour != null) {
    // Il y a des agents synchronisés mais modifiés
    return true;
  }

  // Aucun agent ne nécessite une synchronisation
  return false;
}


// Fonction principale pour synchroniser les agents
Future<bool> synchroniserAgent() async {
  try {
    // Récupérer les agents non synchronisés et les agents à mettre à jour
    final agentsNonSynchronises = await getAgentsNonSynchronises();
    final agentsAUpdate = await getAgentsAMettreAJour();

    // Combiner les deux listes d'agents pour envoi
    final agents = [...agentsNonSynchronises, ...agentsAUpdate];

    if (agents.isEmpty) {
      // Aucune donnée à synchroniser
      return true;
    }

    //print(agents);

    // Envoyer les données à l'API

    final success = await sendToApiSyncAgent(agents);

    //print(success);
    if (success) {
      // Mettre à jour l'état des agents dans la base de données locale
      final agentIds = agents.map((agent) => agent['id'] as int).toList();

      // Mettre à jour l'état de synchronisation
      await updateEtatAgentNonSyncroniser(agentIds);

      // Réinitialiser l'état de modification seulement pour les agents qui avaient besoin d'une mise à jour
      if (agentsAUpdate.isNotEmpty) {
        final updateAgentIds = agentsAUpdate.map((agent) => agent['id'] as int).toList();
        await resetEtatModification(updateAgentIds);
      }
      return true;
    } else {
      // Échec de la synchronisation
      //logger.e("la ssynchronisation a echoue cela vient de l'api");
      return false;
    }
  }catch (e) {
    logger.e("erreur rencontrer $e");
    return false;
  }
}


/*
//une autre maniere de faire la mise a jour serait 

Future<void> updateEtatAgentNonSyncroniser(Isar isar, List<Map<String, dynamic>> agentsEnvoyes) async {
  // Transformer la liste des agents en une liste d'IDs
  final agentIds = agentsEnvoyes.map((agent) => agent['id'] as int).toList();

  // Récupérer les agents un par un depuis Isar
  final agentsToUpdate = <Agent>[];

  for (var id in agentIds) {
    final agent = await isar.agents.get(id);
    if (agent != null) {
      agent.etatSynchronisation = true;
      agentsToUpdate.add(agent);
    }
  }

  // Enregistrer les agents mis à jour dans Isar
  if (agentsToUpdate.isNotEmpty) {
    await isar.writeTxn(() async {
      for (var agent in agentsToUpdate) {
        await isar.agents.put(agent);
      }
    });
  }
}
// ou encore comme ça
Future<void> updateEtatAgentNonSyncroniser(Isar isar, List<Map<String, dynamic>> agentsEnvoyes) async {
  // Transformer la liste des agents en une liste d'IDs
  final agentIds = agentsEnvoyes.map((agent) => agent['id'] as int).toSet(); // Utiliser un Set pour éviter les doublons

  // Récupérer les agents depuis Isar et mettre à jour l'état de synchronisation
  await isar.writeTxn(() async {
    for (var id in agentIds) {
      final agent = await isar.agents.get(id);
      if (agent != null) {
        agent.etatSynchronisation = true;
        await isar.agents.put(agent); // Mettre à jour l'agent dans Isar
      }
    }
  });
}

*/
