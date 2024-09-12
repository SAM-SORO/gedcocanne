import 'package:Gedcocanne/assets/images_references.dart';
import 'package:Gedcocanne/services/api/bilan_services.dart';
import 'package:Gedcocanne/services/api/gespont_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class BilanCourScreen extends StatefulWidget {
  final List<Map<String, String>> camionsAttente;

  const BilanCourScreen({super.key, required this.camionsAttente});

  @override
  State<BilanCourScreen> createState() => _BilancoursState();
}

class _BilancoursState extends State<BilanCourScreen> {
  late TextEditingController heureDebutController;
  late TextEditingController heureFinController;

  double? qteCanneBroye;
  double? qteCanneEntree;
  double? qteCanneRestantDansCours;
  double? qteCanneEnAttenteDeBroyage;

  bool _chargementEnCours = false; // Indicateur de chargement

  @override
  void initState() {
    super.initState();
    _initialiserHeures();

    // Listener pour recalculer les tonnages lorsque les heures changent
    heureDebutController.addListener(_calculerTonnage);
    heureFinController.addListener(_calculerTonnage);
  }

  void _initialiserHeures() {
    DateTime maintenant = DateTime.now();
    heureDebutController = TextEditingController(text: _obtenirHeurePrecedente(maintenant));
    heureFinController = TextEditingController(text: _obtenirHeureActuelle(maintenant));
    _calculerTonnage();
  }

  String _obtenirHeurePrecedente(DateTime maintenant) {
    int heureActuelle = maintenant.hour;
    int heurePrecedente = heureActuelle - 1;

    // Si l'heure est 00, alors il faut passer à 23
    if (heurePrecedente < 0) {
      heurePrecedente = 23;
    }

    return heurePrecedente.toString().padLeft(2, '0');
  }


  String _obtenirHeureActuelle(DateTime maintenant) {
    String heureActuelle = maintenant.hour.toString().padLeft(2, '0');
    return heureActuelle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Image.asset(
          Imagesreferences.bilan,
          height: 100, 
          width: 250,  
          fit: BoxFit.contain,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _rafraichirHeures(); // Utilise les heures actuelles au rafraîchissement
          await _calculerTonnage();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(40.0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Rapport du stock Cours à canne",
                      style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: heureDebutController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Heure de début',
                          suffixIcon: Icon(Icons.access_time),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: heureFinController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(2),
                        ],
                        decoration: const InputDecoration(
                          labelText: 'Heure de fin',
                          suffixIcon: Icon(Icons.access_time),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Indicateur de chargement
                _chargementEnCours 
                  ? const Center(child: CircularProgressIndicator()) 
                  : Column(
                      children: [
                        construireInfoTonnage('Tonnage de canne en attente', '${qteCanneEnAttenteDeBroyage?.toStringAsFixed(2) ?? 'N/A'} tonnes'),
                        const SizedBox(height: 16),
                        construireInfoTonnage('Tonnage de canne dechargé', '${qteCanneEntree?.toStringAsFixed(2) ?? 'N/A'} tonnes'),
                        const SizedBox(height: 16),
                        construireInfoTonnage('Tonnage de canne actuelle dans la cour', '${qteCanneRestantDansCours?.toStringAsFixed(2) ?? 'N/A'} tonnes'),
                        const SizedBox(height: 16),
                        construireInfoTonnage('Tonnage de canne broyé', '${qteCanneBroye?.toStringAsFixed(2) ?? 'N/A'} tonnes'),
                      ],
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget construireInfoTonnage(String titre, String quantite) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF9B5229),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text(
                  titre,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
          Text(
            //le tonnage
            quantite,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _rafraichirHeures() {
    DateTime maintenant = DateTime.now();
    setState(() {
      heureDebutController.text = _obtenirHeurePrecedente(maintenant);
      heureFinController.text = _obtenirHeureActuelle(maintenant);
    });
  }

  Future<void> _calculerTonnage() async {
    final heureDebut = heureDebutController.text;
    final heureFin = heureFinController.text;

       // Validation des heures
    if (!_heureEstValide(heureDebut) || !_heureEstValide(heureFin)) {
      _showErrorMessage("Veuillez entrer des heures valides (entre 00 et 23).");
      return;
    }

    setState(() {
      _chargementEnCours = true; // Début du chargement
    });

    try {
      
      //les tas de canne broyé
      final tonnageBroyerParTas = await getTonnageCanneBroyerParTasFromAPI(heureDebut: heureDebut, heureFin: heureFin);
      //pour la quantite restant dans la cour
      final tonnageRestantCours = await getTonnageCanneRestantCoursFromAPI();
      //pour la quantite dechager directement sur la table a canne
      final tonnageBroyerTableDirect = await getTonnageCanneBroyerDirectFromAPI(heureDebut: heureDebut, heureFin: heureFin);
      // pour la quantite decharger daans la cours
      final tonnageDechargeCours = await getTonnageCanneDechargerCoursFromAPI(heureDebut: heureDebut, heureFin: heureFin);
      //pour la quantite de canne en attente de dechargement
      final tonnageCamionAttente = await getTonnageCanneCamionAttenteFromAPI(widget.camionsAttente);
      //pour la quantite total de canne entree dans la cour ca canne
      final tonnageEntreeCours = await getTonnageCanneEntree(heureDebut: heureDebut, heureFin: heureFin);

      // Vérifie que toutes les valeurs sont valides
      if (tonnageBroyerParTas == null ||
          tonnageRestantCours == null ||
          tonnageBroyerTableDirect == null ||
          tonnageDechargeCours == null ||
          tonnageCamionAttente == null ||
          tonnageEntreeCours == null) {
        _showErrorMessage('La récupération des informations sur le tonnage à échoué.');
        return;
      }


      setState(() {
        qteCanneEntree = tonnageEntreeCours;
        qteCanneBroye = tonnageBroyerTableDirect + tonnageBroyerParTas;
        qteCanneEnAttenteDeBroyage = tonnageCamionAttente;
        qteCanneRestantDansCours = tonnageRestantCours;
      });

    } catch (e) {
      _showErrorMessage('La récupération des informations sur le tonnage à échoué.');
    } finally {
      setState(() {
        _chargementEnCours = false; // Fin du chargement
      });
    }
  }

  bool _heureEstValide(String heure) {
    final int? valeur = int.tryParse(heure);
    return valeur != null && valeur >= 0 && valeur <= 23;
  }

  void _showErrorMessage(String message){
    toastification.show(
      context: context,
      alignment: Alignment.topCenter,
      style: ToastificationStyle.flatColored,
      type: ToastificationType.error,
      title: Text(message, style: GoogleFonts.poppins(fontSize: 18)),
      autoCloseDuration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(30),
    );
  }




}
