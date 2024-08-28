import 'package:isar/isar.dart';

part 'table_canne.g.dart';

@Collection()
class TableCanne {
  Id id = Isar.autoIncrement; // Clé primaire

  @Index()
  late double tonnageTasDeverse;

  @Index()
  late int anneeTableCanne; // Non nullable avec le late

  @Index()
  late DateTime dateDecharg; // Propriété pour la date de déchargement

  @Index()
  late int heureDecharg; // Propriété pour l'heure de déchargement

  bool etatSynchronisation = false; // Par défaut à 0 (false)

  bool etatModification = false; // Par défaut à 0 (false)
}
