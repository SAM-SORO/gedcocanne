import 'package:isar/isar.dart';
import 'agent.dart';
import 'decharger_cours.dart';

part 'ligne.g.dart';

@Collection()
class Ligne {
  Id id = Isar.autoIncrement;
  @Index()
  late String libele;
  @Index()
  late int nbreTas; // Nombre de tas, par défaut 5
  late List<Tas> tas;
  final camions = IsarLinks<DechargerCours>();
  final agent = IsarLink<Agent>(); // Agent associé à cette ligne

  late double poidsTotal; // Utilisation de late pour l'initialisation tardive

  Ligne({
    required this.libele,
  })  : this.nbreTas = 5, // Nombre de tas par défaut
        this.tas = List.generate(5, (index) => Tas(id: index + 1)) {
        poidsTotal = 0.0; // Initialisation à 0
  }


  // Recalculer le poids total et répartir parmi les tas
  void recalculerPoidsParTas() {
    final totalPoids = poidsTotal; // Calculer le poids total
    if (nbreTas > 0) {
      final poidsParTas = totalPoids / nbreTas; // Répartir le poids total
      for (var t in tas) {
        t.poids = poidsParTas; // Mettre à jour le poids de chaque tas
      }
    } else {
      // Gérer le cas où nbreTas est 0 pour éviter la division par zéro
      for (var t in tas) {
        t.poids = 0;
      }
    }
  }

  // Méthode pour mettre à jour le poids total
  void mettreAJourPoidsTotal() {
    poidsTotal = camions.map((c) => c.poidsNet).fold(0.0, (prev, poids) => prev + poids);
  }

  void retirerPoids(double poids) {
    poidsTotal -= poids;
    if (poidsTotal<0) poidsTotal = 0;
  }

  void ajouterPoids(double poids) {
    poidsTotal += poids;
  }

  //Méthode pour réinitialiser les tas
  void reinitialiserLigne() {
    for (var t in tas) {
      t.etat = 0;  // Réinitialiser l'état du tas
      t.poids = 0; // Réinitialiser le poids du tas
    }
    poidsTotal = 0;
  }

  /*
  // Retirer un poids du poids total de la ligne
  void retirerPoids(double poids) {
    // Ici, le poidsTotal est calculé dynamiquement, mais si nécessaire, 
    // vous pouvez appliquer une autre logique pour ce retrait.
    // Cette méthode est conservée pour les cas spécifiques, si besoin.
    //poidsTotal -= poids;
    if (poidsTotal<0) poidsTotal = 0;
  }
  */

}

@Embedded()
class Tas {
  late int id;
  late int etat; // 0 = non coché, 1 = coché
  late double poids;

  Tas({
    int id = 0, // Valeur par défaut
    int etat = 0, // Valeur par défaut
    double poids = 0.0, // Valeur par défaut
  })  : this.id = id,
        this.etat = etat,
        this.poids = poids;
}
