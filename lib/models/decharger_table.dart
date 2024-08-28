import 'package:isar/isar.dart';

part 'decharger_table.g.dart';

@Collection()
class DechargerTable {

  Id id = Isar.autoIncrement; // Clé primaire
  @Index()
  late String veCode;

  @Index()
  late double poidsP1;

  @Index()
  late double poidsTare;

  
  @Index()
  double? poidsP2; // Attribut pour enregistrer le Poids P2 peut etre null


  @Index()
  late DateTime dateHeureP1;

  @Index()
  late DateTime dateHeureDecharg; // Date et Heure actuelles à la création

  @Index()
  DateTime? dateHeureP2; // Date et Heure pour le poids P2, peut être nul

  late String techCoupe;

  late String parcelle; 

  @Index()
  late String matriculeAgent; // Matricule de l'agent au lieu de l'identifiant
  
  @Index()
  bool etatSynchronisation = false; // Par défaut à 0 (false)

  @Index()
  bool etatModification = false; // Par défaut à 0 (false)

  // Méthode calculée pour obtenir le poids net
  double get poidsNet => poidsP2 != null ? (poidsP1 - poidsP2!) : (poidsP1 - poidsTare);
}
