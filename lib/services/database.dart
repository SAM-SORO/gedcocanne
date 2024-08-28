import 'package:cocages/models/agent.dart';
import 'package:cocages/models/current_user.dart';
import 'package:cocages/models/ligne.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cocages/models/decharger_cours.dart';
import 'package:cocages/models/decharger_table.dart';
import 'package:cocages/models/table_canne.dart';


//on appel çaune ouverture singleton de la base de donner je ne sais plus
class Database {
  static Isar? _isar;

  static Future<Isar> getInstance() async {
    if (_isar == null) {
      final directory = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [TableCanneSchema, DechargerCoursSchema, DechargerTableSchema, LigneSchema, AgentSchema, CurrentUserSchema],
        directory: directory.path,
        inspector: true,  // Activer l'inspecteur Isar
      );
    }
    return _isar!;
  }
}


//disons que pour la connexion je ne veux pas passer par une classe
//lors de l'ouverture il faut perciser les shema des tables qui seront utiliser ainsi que les schemas des tables auxquels elle sont lier
// Future<Isar> openIsar() async {
//   final directory = await getApplicationDocumentsDirectory();
//   final isar = await Isar.open(
//     [AgentSchema, CurrentUserSchema,LigneSchema,DechargerCoursSchema], // Assure-toi d'utiliser les bons schémas pour tes collections
//     directory: directory.path,
//     inspector: true,
//   );
//   return isar;
// }
