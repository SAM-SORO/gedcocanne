import 'package:cocages/models/ligne.dart';
import 'package:isar/isar.dart';

part 'agent.g.dart';

@Collection()
class Agent {
  Id id = Isar.autoIncrement; // Clé primaire

  @Index()
  late String matricule; // Matricule de l'agent

  @Index()
  late String password; // Mot de passe de l'agent

  // Nouveau champ pour le rôle, avec une valeur par défaut
  @Index()
  String role = "user"; // Rôle de l'agent, par défaut à "user"

  // 
  @Index()
  bool etatSynchronisation = false; // Etat de synchronisation, par défaut à false

  // 
  @Index()
  bool etatModification = false; // Etat de Modification, par défaut à false

  // Lignes associées à cet agent
  final lignes = IsarLinks<Ligne>();
}
