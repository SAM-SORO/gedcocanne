import 'package:gedcocanne/assets/imagesReferences.dart';
import 'package:gedcocanne/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class BilanCourScreen extends StatefulWidget {
  const BilanCourScreen({super.key});

  @override
  State<BilanCourScreen> createState() => _BilancoursState();
}

class _BilancoursState extends State<BilanCourScreen> {
  late TextEditingController startHourController ;
  late TextEditingController endHourController ;
  // TextEditingController endHourController = TextEditingController(text: '05');
  // TextEditingController endHourController = TextEditingController(text: '05');
  
  
  double? stockEntree;
  double? stockActuel;
  double? stockBroyer;

  @override
  void initState() {
    super.initState();
     // Obtenir l a date et l'heure actuelle
    DateTime now = DateTime.now();
    
    // Convertir l'heure actuelle en chaîne de caractères (format 24 heures)
    String currentHour = now.hour.toString().padLeft(2, '0');
    //padLeft(2, '0') : Assure que l'heure est toujours au format "hh" (par exemple, "06" au lieu de "6").

    // Définir l'heure suivante
    String nextHour = ((now.hour + 1) % 24).toString().padLeft(2, '0');
    //(now.hour + 1) % 24 : Calcule l'heure suivante en tenant compte du fait que l'heure est sur un cycle de 24 heures (par exemple, si l'heure actuelle est 23, l'heure suivante sera 00).

    // Initialiser les contrôleurs avec les valeurs par défaut
    startHourController = TextEditingController(text: currentHour);
    endHourController = TextEditingController(text: nextHour);

    _calculateTonnage();

    // Ajouter des listeners pour recalculer le tonnage à chaque modification des heures
    startHourController.addListener(_calculateTonnage);
    endHourController.addListener(_calculateTonnage);
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
          height: 100, // Ajustez la hauteur souhaitée
          width: 250,  // Ajustez la largeur souhaitée
          fit: BoxFit.contain, // Ajuste l'image pour s'adapter
        ),
        // centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Remettre les heures par défaut et recalculer le tonnage
          setState(() {
            startHourController.text = '05';
            endHourController.text = '22';
          });
          await _calculateTonnage();
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
                      "Bilan du stock",
                      style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: startHourController,
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
                        controller: endHourController,
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
                buildTonnageInfo('Tonnage de la canne Entree', '${stockEntree?.toStringAsFixed(2) ?? 'N/A'} tonnes'),
                const SizedBox(height: 16),
                buildTonnageInfo('Tonnage de la canne actuelle dans la cour', '${stockActuel?.toStringAsFixed(2) ?? 'N/A'} tonnes'),
                const SizedBox(height: 16),
                buildTonnageInfo('Tonnage broyé', '${stockBroyer?.toStringAsFixed(2) ?? 'N/A'} tonnes'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTonnageInfo(String title, String quantity) {
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
                  title,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
          Text(
            quantity,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  
  Future<void> _calculateTonnage() async {
    final startHour = startHourController.text;
    final endHour = endHourController.text;

    final tonnageDechargerCours = await getTonnageDechargerCoursFromAPI(startHour: startHour, endHour: endHour);
    final tonnageBroyerTableDirect = await getTonnageBroyerDirectFromAPI(startHour: startHour, endHour: endHour);
    final tonnageBroyerParTas = await getTonnageBroyerParTasFromAPI(startHour: startHour, endHour: endHour);

    final tonnageEntree = (tonnageDechargerCours! + (tonnageBroyerTableDirect!));
    final tonnageBroyer = (tonnageBroyerParTas! + tonnageBroyerTableDirect);
    setState(() {
      stockEntree = tonnageEntree;
      stockBroyer = tonnageBroyer;
      stockActuel = (tonnageEntree - tonnageBroyer);
    });
  }




  @override
  void dispose() {
    // Libérer les ressources
    startHourController.removeListener(_calculateTonnage);
    endHourController.removeListener(_calculateTonnage);
    startHourController.dispose();
    endHourController.dispose();
    super.dispose();
  }
}
