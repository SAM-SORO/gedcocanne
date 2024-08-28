import 'package:isar/isar.dart';

part 'decharger_cours.g.dart';

@Collection()
class DechargerCours {
  Id id = Isar.autoIncrement; // Clé primaire

  @Index()
  late String veCode;

  @Index()
  late double poidsP1;

  @Index()
  late double poidsTare;

  @Index()
  double? poidsP2; // Attribut facultatif pour les mises à jour futures

  @Index()
  late DateTime dateHeureP1;

  @Index()
  late DateTime dateHeureDecharg; // Date et Heure actuelles à la création

  @Index()
  DateTime? dateHeureP2; // Date et Heure pour le poids P2, peut être nul

  late String parcelle;  // le nom de la parcelle 

  @Index()
  late String techCoupe;

  @Index()
  late String matriculeAgent; // Matricule de l'agent au lieu de l'identifiant

  bool etatAffectation = false; // Par défaut à 0 (false)

  bool etatBroyage = false; // Par défaut à 0 (false)

  @Index()
  bool etatSynchronisation = false; // Par défaut à 0 (false)

  @Index()
  bool etatModification = false; // Par défaut à 0 (false)

  // Nouveau champ pour l'ID de la ligne associée
  @Index()
  late int ligneId; 

  // Méthode calculée pour obtenir le poids net
  double get poidsNet => poidsP2 != null ? (poidsP1 - poidsP2!) : (poidsP1 - poidsTare);
}
