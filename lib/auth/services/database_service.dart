//definir un singleton pour eviter les erreurs lie a l'ouverture multiple

import 'package:cocages/models/decharger_cours.dart';
import 'package:cocages/models/decharger_table.dart';
import 'package:cocages/models/table_canne.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cocages/models/agent.dart';
import 'package:cocages/models/current_user.dart';
import 'package:cocages/models/ligne.dart';

class DatabaseService {
  static Isar? _isarInstance;

  // Assure-toi que cette fonction est appelée de manière asynchrone
  static Future<Isar> get instance async {
    if (_isarInstance == null) {
      final directory = await getApplicationDocumentsDirectory();
      _isarInstance = await Isar.open(
        [AgentSchema, CurrentUserSchema, LigneSchema, DechargerCoursSchema,DechargerTableSchema,TableCanneSchema], // Assure-toi d'utiliser les bons schémas pour tes collections
        directory: directory.path,
        inspector: true,
      );
    }
    return _isarInstance!;
  }

  static Future<void> close() async {
    if (_isarInstance != null) {
      await _isarInstance!.close();
      _isarInstance = null;
    }
  }
}
