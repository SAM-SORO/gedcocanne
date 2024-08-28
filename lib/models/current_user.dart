import 'package:isar/isar.dart';

part 'current_user.g.dart';

@Collection()
class CurrentUser {
  Id id = Isar.autoIncrement; // Clé primaire

  // Le champ "userId" stocke l'identifiant de l'utilisateur connecté
  late int userId;
}
