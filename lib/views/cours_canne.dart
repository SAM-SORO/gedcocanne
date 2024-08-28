import 'dart:async';
import 'package:cocages/models/decharger_cours.dart';
import 'package:cocages/models/decharger_table.dart';
import 'package:cocages/models/ligne.dart';
import 'package:cocages/services/api_service.dart';
import 'package:cocages/services/decharge_services.dart';
import 'package:cocages/services/ligne_services.dart';
import 'package:cocages/services/table_canne_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

class CoursCanne extends StatefulWidget {
  //doit permettre de faire la recuperation des P2 et la synchro ainsi que le reset du timer dans le cas du pull to refresh
  //final void Function() updateP2AndSyncAndResetTimer;
  final Function updateP2AndSyncAndResetTimer;
  final bool isSwitched;
  const CoursCanne({super.key, required this.updateP2AndSyncAndResetTimer, required this.isSwitched});

  @override
  State<CoursCanne> createState() => _CoursCanneState();
}

class _CoursCanneState extends State<CoursCanne> {
  List<Ligne> lignes = [];
  int? selectedIndexLigne;
  List<Map<String, String>> camionsAttente = [];
  List<DechargerCours> camionsLigne = [];
  List<int> lignesVerrouillees = [];
  Timer? _debounce;
  // Booléen pour suivre si le chargement des camions en attente est en cours ou pas
  bool _isLoading = true;

  //pour chaque ligne on aura un champ textFiel il faut donc un controlleur pour chacun afin d'avoir un control sur la valeur saisi
  late List<TextEditingController> _controllers= [];

  //FocusNode _focusNode = FocusNode();

  //c'est pour eviter qu'il puisse faire des affectation a une ligne verouiller
  bool ICanAffected = true;  // on va donc utiliser cette variable pour suivre


  @override
  void initState() {
    super.initState();
    _loadLignes();

    //en fonction de l'etat du switch afficher les camions en attente
    if (widget.isSwitched) {
      _loadCamionsAttente(); // Charger tous les camions en attente sans exclusion ( sans tenir compte de la technique de coupe)

    } else {
      _loadCamionsAttenteFiltrerPourLaCour(); // charger les camions en atttente a decharger dans la cour (on tient compte de la technique de coupe)
    }

    //celui ci permet d'annuler le timer de le changement du nombre de tas au niveau de l'interface
    _debounce?.cancel();

    // Vérifiez que le focus n'est pas donné automatiquement
    //_focusNode = FocusNode();
  }

  

  @override
  void dispose() {
    // Nettoyer les contrôleurs lorsqu'ils ne sont plus nécessaires
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int nombreDeCamionEnAttente  = camionsAttente.length ;
    int nombreCamionAffecter = camionsLigne.length;

    //bool _isHovered = false; //permet de savoir si on fait un hover ou pas sur l'elelement de la listVew
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Center(child: Text("Lignes", style: TextStyle(fontWeight: FontWeight.bold)))),
                      Expanded(child: Center(child: Text("Tas", style: TextStyle(fontWeight: FontWeight.bold)))),
                      Expanded(child: Center(child: Text("Nombre de tas", style: TextStyle(fontWeight: FontWeight.bold)))),
                      Expanded(child: Center(child: Text("Tonnage", style: TextStyle(fontWeight: FontWeight.bold)))),
                    ],
                  ),
                ),
                Expanded(

                  //celui la permet de fermer le clavier lorsqu'il est ouvert et qu'on tap ailleur
                  child: GestureDetector(
                    onTap: () {
                      // Fermer le clavier lorsque vous cliquez en dehors du TextField
                      FocusScope.of(context).unfocus();
                    },

                    //le pull to refresh des lignes
                    child: RefreshIndicator(
                      onRefresh: _refreshLigne, // Méthode pour rafraîchir les données
                      child: ListView.builder(
                        itemCount: lignes.length,
                        itemBuilder: (context, index) {
                          final ligne = lignes[index];
                          final estVerrouillee = lignesVerrouillees.contains(ligne.id);

                          //celui la me permet de detecter les click sur le card
                          return GestureDetector(
                            onTap: () {

                              setState(() {
                                if (selectedIndexLigne == index) {
                                  selectedIndexLigne = null; // Désélectionner la ligne si elle est déjà sélectionnée
                                } else {
                                  selectedIndexLigne = index; // Sélectionner la nouvelle ligne
                                 _loadCamionsAffecterLigne(); // chargerger les camions de la ligne
                                }
                              });
                            },
                            child: Dismissible(
                              key: Key(ligne.id.toString()), // Utilisez l'identifiant de la ligne comme clé
                              direction: DismissDirection.endToStart, // Permet de glisser de droite à gauche pour supprimer
                              background: Container(
                                color: Colors.red,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                alignment: Alignment.centerRight,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                // Afficher un dialogue de confirmation avant de supprimer
                                return await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Confirmer la suppression"
                                    'Aucun camion en attente', style: GoogleFonts.poppins(fontSize: 16)),
                                      content: Text("Voulez-vous vraiment supprimer cette ligne?", style: GoogleFonts.poppins(fontSize: 16)),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(false),
                                          child: Text("Annuler", style: GoogleFonts.poppins(fontSize: 16)),
                                        ),
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(true),
                                          child: Text("Supprimer", style: GoogleFonts.poppins(fontSize: 16)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              onDismissed: (direction) async {
                                // Appeler la fonction pour supprimer la ligne
                                bool deleteSuccess = await deleteLigne(ligne.id);
                                
                                if (deleteSuccess) {
                                  // Supprimer la ligne de la liste locale
                                  setState(() {
                                    lignes.removeAt(index);
                                  });
                            
                                } else {
                                  // Afficher un message d'erreur si la suppression échoue
                                  _showMessage('Erreur lors de la suppression de la ligne');
                                }
                              },
                              child: Card(
                                // color: estVerrouillee ? const Color.fromARGB(57, 142, 105, 105) : selectedIndexLigne == index ? const Color(0xFFF8E7E7) : Colors.white,
                                color: estVerrouillee ? const Color(0xFF265175) : selectedIndexLigne == index ? const Color(0xFFF8E7E7) : Colors.white,
                                elevation: 14,
                                margin: const EdgeInsets.all(10),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      //zone d'affichage du nom de la ligne
                                      Expanded(
                                        child: Center(
                                          child: Text(ligne.libele , style: GoogleFonts.poppins(fontSize: 16, color: estVerrouillee ? Colors.white : Colors.black,))
                                        )
                                      ),
                                    
                                      Expanded(
                                        child: Center(
                                          child: SizedBox(
                                            width: 300, // Largeur fixe pour la colonne de `Tas`
                                            height: 100, // Hauteur fixe ou ajustée en fonction du nombre de cases
                                            child: GridView.builder(
                                              shrinkWrap: true,
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3, // Nombre de colonnes
                                                crossAxisSpacing: 2.0, // Espacement horizontal entre les cases
                                                mainAxisSpacing: 2.0, // Espacement vertical entre les cases
                                              ),
                                              itemCount: ligne.tas.length,
                                              itemBuilder: (context, i) {
                                                final tas = ligne.tas[i];
                                                final bool estCoche = tas.etat == 1;

                                                return GestureDetector(
                                                  onTap: () async {
                                                    if (estVerrouillee) return; // Ne pas permettre les changements si la ligne est verrouillée

                                                    //Mettre à jour l'état du tas
                                                    setState(() {
                                                      tas.etat = estCoche ? 0 : 1;
                                                    });
                                                    

                                                    if (tas.etat == 1) {  
                                                      // Essayer de mettre à jour l'état du tas  
                                                      bool miseAJourReussie = await mettreAJourEtatTas(  
                                                        ligneId: ligne.id,  
                                                        tasId: tas.id,  
                                                        nouvelEtat: 1, // nouvelle valeur de l'état souhaitée  
                                                      );  

                                                      //faire aparaitre le toast
                                                      showSimpleNotification(
                                                        Center(
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                '${ligne.libele}: Tas ${i + 1} broyé!',
                                                                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                                                              ),
                                                              Text(
                                                                '${tas.poids} tonne',
                                                                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        duration: const Duration(milliseconds: 2000),
                                                        background: const Color(0xFF019998),
                                                        // background: const Color.fromARGB(218, 76, 175, 79),
                                                      );

                                                      //mettreAJourLibeleLigne(ligneId: ligne.id, nouveauLibele: 'sam');

                                                      //Si la mise à jour a réussi, appeler la méthode d'ajout  
                                                      if (miseAJourReussie) {  
                                                        await ajouterTasDansTableCanne(  
                                                          ligneId: ligne.id,  
                                                          tasId: tas.id,  
                                                        );  
                                                      }else{
                                                        // Afficher un message d'erreur si le retrait échoue
                                                        _showMessageWithTime('Erreur lors de l\'ajout du tas.', 3000);
                                                      }

                                                    } else {  
                                                      // Si la case est décochée, retirer le poids du tas de la tableCanne
                                                      bool retraitReussi = await retirerTasDeTableCanne(
                                                        ligneId: ligne.id,
                                                        tasId: tas.id,
                                                      );

                                                      if (!retraitReussi) {
                                                        // Afficher un message d'erreur si le retrait échoue
                                                        _showMessageWithTime('Erreur lors du retrait du tas de TableCanne.', 3000);
                                                      }
                                                    }

                                                    // Vérifier si c'est le dernier tas
                                                    bool estDernierTas = await verifierTousTasCoches(ligne.id);

                                                    if (estDernierTas) {
                                                      await _verrouillerLigne(ligne.id);
                                                    }
                                                  },
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Theme(
                                                        data: ThemeData(
                                                          checkboxTheme: CheckboxThemeData(
                                                            side: WidgetStateBorderSide.resolveWith(
                                                              (states) => const BorderSide(
                                                                color: Colors.black, // Couleur de la bordure
                                                                width: 0.5, // Largeur de la bordure
                                                              ),
                                                            ),
                                                            fillColor: WidgetStateProperty.resolveWith<Color>(
                                                              (states) {
                                                                if (states.contains(WidgetState.selected)) {
                                                                  return const Color(0xFF9B5229); // Couleur de remplissage lorsque sélectionné
                                                                }
                                                                return Colors.white; // Couleur de remplissage lorsque non sélectionné
                                                              },
                                                            ),
                                                            //fillColor: WidgetStateProperty.all(Colors.white), // Couleur de la bordure
                                                            checkColor:  WidgetStateProperty.all(estVerrouillee ? const Color(0xFFFBA336): const Color.fromARGB(255, 79, 215, 84),), // Couleur de la coche
                                                            //overlayColor: WidgetStateProperty.all(Colors.purple), // Couleur de survol
                                                            
                                                          ),
                                                        ),
                                                        child: Transform.scale(
                                                          scale: 1.5, // Agrandir le Checkbox
                                                          child: Checkbox(
                                                            value: estCoche,
                                                            onChanged: null, // Désactiver le changement de valeur via Checkbox
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        child: Text(
                                                          '${i + 1}', // Affiche le numéro du tas (index + 1)
                                                          style: TextStyle(
                                                            fontSize: 14, // Taille du texte
                                                            fontWeight: FontWeight.bold,
                                                            color: estCoche ? Colors.white : Colors.black, // Couleur du texte

                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              
                                              },
                                            ),
                                          ),
                                        ),
                                      ),

                                    //champ pour renseigner le nombre de ligne
                                      Expanded(
                                        child: Center(
                                          child: SizedBox(
                                            width: 70,
                                            child: TextField(
                                              style: TextStyle(color: estVerrouillee ? Colors.white : Colors.black,),
                                              //focusNode: _focusNode,
                                              autofocus: false,
                                              readOnly: estVerrouillee, // Désactiver le TextField si la ligne est verrouillée,
                                              controller: _controllers[index], //controlleur pour suivre les changements dans le code
                                              keyboardType: TextInputType.number,
                                              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                              onChanged: (value) {
                                                _onTextChanged(value, index);
                                                
                                              }
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      //afficher le tonnage de la ligne
                                      Expanded(
                                        child: Center(
                                          child: Container(
                                            width: 300,
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                            child: TextField(
                                              style: TextStyle(color: estVerrouillee ? Colors.white : Colors.black,),
                                              readOnly: true, // Rendre ce champ en lecture seule
                                              decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                                              controller: TextEditingController(text: ligne.poidsTotal.toString()),
                                            ),
                                          ),
                                        ),
                                      ),
                                      
                                      //si tous les tas sont cocher verouiller la ligne
                                      if (estVerrouillee)
                                        IconButton(
                                          icon: const Icon(Icons.lock_open, color: Color(0xFFFBA336), size: 30 ,),
                                          onPressed: () async { 
                                            await _debloquerLigne(ligne.id) ; 
                                            await _loadLignes();
                                            FocusScope.of(context).unfocus();
                                          }    
                                        ),
                                    ],
                                  ),
                                ),
                                
                              ),
                            ),
                    
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        
          // Column for Camions
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("Camions en attente d'affectation ($nombreDeCamionEnAttente)", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold))),
                ),
                Expanded(
                  child: _isLoading
                        ? const Center(child: CircularProgressIndicator()) // Afficher le CircularProgressIndicator si en chargement
                        : camionsAttente.isEmpty
                            ? RefreshIndicator(
                              onRefresh: _refreshCamionsAttente,
                              child: Center(
                                  child: ListView(
                                    children: [
                                      const SizedBox(height: 50,),
                                      Text(
                                      'Aucun',
                                      style: GoogleFonts.poppins(fontSize: 16),
                                      textAlign: TextAlign.center, // Centrer le texte horizontalement
                                    ),
                                    ],
                                  ),
                                ),
                            )
                            : RefreshIndicator(
                              onRefresh: _refreshCamionsAttente,
                              child: ListView.builder(
                                itemCount: 
                                camionsAttente.length, 
                                itemBuilder: (context, index) {
                                  final camion = camionsAttente[index]; // 
                                  // Conversion des chaînes en types appropriés
                                  var poidsP1 = double.tryParse(camion['PS_POIDSP1']!) ?? 0.0;
                                  var dateDecharge = DateTime.parse(camion['DATEHEUREP1']!); // Convertir en DateTime
                                  var dateDechargeFormater = DateFormat('dd/MM/yyyy HH:mm:ss').format(dateDecharge);

                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                                    child: ListTile(
                                      contentPadding:  const EdgeInsets.symmetric(vertical: 8),
                                      minTileHeight: 50,
                                      title: RichText(
                                        text: TextSpan(
                                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black), // Style par défaut
                                          children: [
                                            TextSpan(
                                              text: '${camion['VE_CODE']} ', // Premier texte en gras
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '(${camion['PS_CODE']})', // Deuxième texte normal
                                            ),
                                          ],
                                        ),
                                      ),
                                      subtitle: Text(
                                        'Poids P1 : $poidsP1 tonnes, $dateDechargeFormater',
                                        style: GoogleFonts.poppins(fontSize: 14),
                                      ),
                                      trailing: selectedIndexLigne != null
                                          ? Checkbox(
                                              value: false,
                                              onChanged: (bool? value) {
                                                //c'est pour eviter qu'il puisse faire des affectation a une ligne verouiller
                                                final ligne = lignes[selectedIndexLigne!];
                                                bool isVerrouillee = false;
                                                //verifier si la ligne a ete verouiller
                                                isVerrouillee = lignesVerrouillees.contains(ligne.id);

                                                if (!isVerrouillee){
                                                  setState(() {
                                                    // Si vous devez gérer la sélection ou la désélection, vous pouvez utiliser une logique conditionnelle
                                                  _affecterCamion(index);
                                                  });
                                                }
                                              },
                                            )
                                          : null,
                                      onTap: () {
                                        //c'est pour eviter qu'il puisse faire des affectation a une ligne verouiller
                                        final ligne = lignes[selectedIndexLigne!];
                                        bool isVerrouillee = false;
                                        //verifier si la ligne a ete verouiller
                                        isVerrouillee = lignesVerrouillees.contains(ligne.id);

                                        //s'il à selectionner une ligne et que cette ligne n'est pas verouiller accepter l'affectation
                                        if (selectedIndexLigne != null && !isVerrouillee) {
                                          _affecterCamion(index);
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                ),

                if (selectedIndexLigne != null ) ...[
                  //construire la deuxieme section de la deuxieme grande colonne en fonction de l'affectation
                  Expanded(
                    child: FutureBuilder<bool>(
                      //si des camions ont ete affecter a une ligne et qu'elle est selectionner il faut les affichés
                      future: _verifierAffectation(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Optionnel : Afficher un indicateur de chargement pendant la vérification
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          // Optionnel : Gérer les erreurs
                          return Center(child: Text('Erreur: ${snapshot.error}'));
                        } else if (snapshot.data == true) {
                          // Afficher les camions affectés uniquement si la vérification réussit
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                child: Center(
                                  child: Text(
                                    "Camions affectés à la ${lignes[selectedIndexLigne!].libele} ($nombreCamionAffecter)",
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: RefreshIndicator(
                                  onRefresh: _refreshCamionsAffecterLigne,
                                  child: ListView.builder(
                                    itemCount: camionsLigne.length,
                                    itemBuilder: (context, index) {
                                      final camion = camionsLigne[index];
                                      final etatSynchro = camion.etatSynchronisation;
                                      // var dateDechargeFormater = DateFormat('dd/MM/yy HH:mm:ss').format(camion.dateHeureDecharg);
                                      return ListTile(
                                        title: Text('${camion.veCode}(${camion.parcelle})' , style: GoogleFonts.poppins(fontSize: 14)),
                                        subtitle: Text('Poids P1 : ${camion.poidsP1} tonnes, ${camion.poidsP2 != null ? 'Poids P2 : ${camion.poidsP2} tonnes, ' : 'PoidsTare ${camion.poidsTare} tonnes, '} Poids Net : ${camion.poidsNet} tonnes'),
                                  
                                        trailing: !etatSynchro? IconButton(
                                                                  icon: const Icon(Icons.remove_circle),
                                                                  onPressed: () => _retirerCamion(index),
                                                                )
                                                              : null
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        } else {
                          // Si aucune donnée n'est disponible ou la vérification échoue, ne rien afficher
                          return const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Aucun camion affecté à cette ligne.')
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ],
                
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: _addLigne,
        child: const Icon(Icons.add),   
      ),
    
    );

  }

  //sera utiliser dans le pull to refresh
  Future<void> _refreshLigne () async {
    _loadLignes();
    widget.updateP2AndSyncAndResetTimer();


  }

  //permet de charger les ligne deja creer (les recuperer dans la base de donnee afin d'en faire l'affichage)
  Future<void> _loadLignes() async {
    final List<Ligne> allLignes = await getAllLignes();
    setState(() {
      lignes = allLignes;

      // Dispose des anciens contrôleurs
      for (var controller in _controllers) {
        controller.dispose();
      }

      _controllers = List.generate(
        lignes.length,
        (index) => TextEditingController(text: lignes[index].nbreTas.toString()),
      );
    });
  }

  //permet de verouiller la ligne dans le cas ou l'on a broyé la derniere tas
  Future<void> _verrouillerLigne(int ligneId) async {
    setState(() {
      lignesVerrouillees.add(ligneId);
    });
  }

  //permet de deverouiller la ligne dans le cas ou l'on a fini de brollé tout les tas et qu'il est verouiller
  Future<void> _debloquerLigne(int ligneId) async {
    await updateEtatBrollage(ligneId); // mettra l'etat de brollage de tout les camions de la ligne a 1
    await deverouillerLigne(ligneId); 
    setState(() {
      lignesVerrouillees.remove(ligneId);
    });
  }

  //me permet de mettr a jour le poids de la deuxieme pesee (sera utiliser lors des pull to refresh)
  Future<void> _updatePoidsP2() async {
    String updated = await getPoidsP2FromFPESEE(); 
    if (updated == "error"){    
      _showMessageWithTime("La Mise a jour du poids P2 camions déchargés à echoué . Veuillez vérifier également votre connexion internet.",6000);
    } 
    // else if (updated == "") {
    //   _showMessageWithTime("La Recuperation du poids de la deuxieme pesee des camons déchargés effectuée avec succès",4000);

    // }
    // else{
    //   _showMessageWithTime("Les Poids de la deuxieme pesee des camions dechargés ont été recuperé",4000);
    // }
  }


  //permet de verifier si au moins un camions a ete affecter au camion sera utile lorsqu'il aura selectionnner une ligne
  Future<bool> _verifierAffectation() async {
    // Vérifiez si une ligne est sélectionnée
    if (selectedIndexLigne != null) {
      // Utilisez l'ID de la ligne sélectionnée pour vérifier l'affectation
      bool hasCamions = await verifierAffectationLigne(ligneId: lignes[selectedIndexLigne!].id);
      return hasCamions;
    }
    
    // Si aucune ligne n'est sélectionnée, renvoyez false ou un autre comportement souhaité
    return false;
  }



  // Fonction pour récupérer les camions en attente depuis l'API
  Future<void> _loadCamionsAttenteFiltrerPourLaCour() async {
    try {
      // Charger les camions en attente depuis l'API
      camionsAttente = await getCamionAttenteFromAPI();

      // Charger les camions déchargés depuis les collections DechargerCours et DechargerTable
      final camionsCours = await listerCamionDechargerCours(); // Récupère les camions déchargés de DechargerCours
      final camionsTable = await listerCamionDechargerTable(); // Récupère les camions déchargés de DechargerTable

      // Combiner les camions déchargés des deux collections
      final allCamionsDecharger = [...camionsTable, ...camionsCours];

      // Exclure les camions dont la technique de coupe est 'RV' ou 'RB' de la liste initiale
      final camionsAttenteFiltres = camionsAttente.where((camionAttente) {
        return !(camionAttente['TECH_COUPE'] == 'RV' || camionAttente['TECH_COUPE'] == 'RB');
      }).toList();

      // Filtrer les camions en attente pour exclure ceux déjà déchargés
      final filteredCamionsAttente = camionsAttenteFiltres.where((camionAttente) {
        // Convertir la chaîne de caractères 'DATEHEUREP1' du camion en attente en objet DateTime
        DateTime dateHeureP1Attente = DateTime.parse(camionAttente['DATEHEUREP1']!);

        // Vérifier si la date/heure du camion en attente correspond à celle d'un camion déchargé
        return !allCamionsDecharger.any((camionDecharge) {
          DateTime? dateHeureP1Decharge;

          // Si le camion déchargé est de type DechargerCours, récupérer sa date/heure P1
          if (camionDecharge is DechargerCours) {
            dateHeureP1Decharge = camionDecharge.dateHeureP1;
          }
          // Si le camion déchargé est de type DechargerTable, récupérer sa date/heure P1
          else if (camionDecharge is DechargerTable) {
            dateHeureP1Decharge = camionDecharge.dateHeureP1;
          }

          // Comparer les dates/heure pour vérifier si elles correspondent
          return dateHeureP1Decharge != null && dateHeureP1Attente.isAtSameMomentAs(dateHeureP1Decharge);
        });
      }).toList();

      // Mettre à jour la liste des camions en attente et indiquer la fin du chargement
      setState(() {
        camionsAttente = filteredCamionsAttente;
        _isLoading = false; // Fin du chargement
      });
    } catch (e) {
      if (mounted) {
        // Afficher un message d'erreur en cas de problème lors du chargement des camions en attente
        _showMessageWithTime("Le chargement des camions en attente a échoué. Vérifiez votre connexion internet.", 6000);
      }
      
    }
  }



  // Fonction pour récupérer les camions en attente depuis l'API
  Future<void> _loadCamionsAttente() async {
    try {
      // Charger les camions en attente depuis l'API
      camionsAttente = await getCamionAttenteFromAPI();

      // Charger les camions déchargés depuis les collections DechargerCours et DechargerTable
      final camionsCours = await listerCamionDechargerCours(); // Récupère les camions déchargés de DechargerCours
      final camionsTable = await listerCamionDechargerTable(); // Récupère les camions déchargés de DechargerTable

      // Combiner les camions déchargés des deux collections
      final allCamionsDecharger = [...camionsTable, ...camionsCours];

  

      // Filtrer les camions en attente pour exclure ceux déjà déchargés
      final filteredCamionsAttente = camionsAttente.where((camionAttente) {
        // Convertir la chaîne de caractères 'DATEHEUREP1' du camion en attente en objet DateTime
        DateTime dateHeureP1Attente = DateTime.parse(camionAttente['DATEHEUREP1']!);

        // Vérifier si la date/heure du camion en attente correspond à celle d'un camion déchargé
        return !allCamionsDecharger.any((camionDecharge) {
          DateTime? dateHeureP1Decharge;

          // Si le camion déchargé est de type DechargerCours, récupérer sa date/heure P1
          if (camionDecharge is DechargerCours) {
            dateHeureP1Decharge = camionDecharge.dateHeureP1;
          }
          // Si le camion déchargé est de type DechargerTable, récupérer sa date/heure P1
          else if (camionDecharge is DechargerTable) {
            dateHeureP1Decharge = camionDecharge.dateHeureP1;
          }

          // Comparer les dates/heure pour vérifier si elles correspondent
          return dateHeureP1Decharge != null && dateHeureP1Attente.isAtSameMomentAs(dateHeureP1Decharge);
        });
      }).toList();

      // Mettre à jour la liste des camions en attente et indiquer la fin du chargement
      setState(() {
        camionsAttente = filteredCamionsAttente;
        _isLoading = false; // Fin du chargement
      });
    } catch (e) {
      if (mounted) {
        // Afficher un message d'erreur en cas de problème lors du chargement des camions en attente
        _showMessageWithTime("Le chargement des camions en attente a échoué. Vérifiez votre connexion internet.", 6000);
      }
      
    }
  }


  Future<void> _refreshCamionsAttente() async {
    //en fonction de l'etat du switch afficher les camions en attente
    if (widget.isSwitched) {
      _loadCamionsAttente(); // Charger tous les camions en attente sans exclusion selon la technique de coupe

    } else {
      _loadCamionsAttenteFiltrerPourLaCour(); // charger les camions en atttente a decharger dans la cour (on tient compte de la technique de coupe)
    }
    _updatePoidsP2();
    widget.updateP2AndSyncAndResetTimer();

  }


  Future<void> _refreshCamionsAffecterLigne() async { 
    _loadCamionsAffecterLigne();
    widget.updateP2AndSyncAndResetTimer();
    
  }


  //fonction pour charger les camions affecter a la ligne selectionner
  Future<void> _loadCamionsAffecterLigne() async {
    if (selectedIndexLigne != null) {
      final camions = await recupererCamionsLigne(lignes[selectedIndexLigne!].id);
      setState(() {
        camionsLigne = camions;
      });
      _updatePoidsP2();
      _loadLignes();
    }
  }

  Future<void> _addLigne() async {
    bool success = await createLigne();
    if (success){
      _loadLignes();  
    }else{
      _showMessage('Erreur lors de la creation de la ligne');
    }

  }
  
  //cette methode a ete creer pour faciliter la modification du nombre de tas et sa mis a jour // le probleme qui se posait c'est lorsqu'il change le nombre de tas on a pas assez de temps pour faire la mise a jour
  void _onTextChanged(String value, int index) {
    // Annule le Timer précédent si il existe encore pour éviter des appels redondants.
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    // Crée un nouveau Timer qui attend 500 millisecondes avant d'exécuter le code à l'intérieur.
    // Cela permet d'attendre que l'utilisateur ait fini de taper avant d'exécuter la mise à jour.
    _debounce = Timer(const Duration(milliseconds: 2000), () async {
      // Essaie de convertir la valeur saisie en entier. Si la conversion échoue, utilise la valeur actuelle de nbreTas.
      int newCount = int.tryParse(value) ?? lignes[index].nbreTas;
      
      //mettre à jour le nombre de tas dans la base de données.
      await _updateNombreTas(lignes[index].id, newCount);

    });
  }

  
   Future<bool> _enregistrerCamionCours(dynamic camion, int index) async {
    try {
      final veCode = camion['VE_CODE']!;
      final poidsP1 = double.parse(camion['PS_POIDSP1']!);
      final dateHeureP1 = DateTime.parse(camion['DATEHEUREP1']!);
      final techCoupe = camion['TECH_COUPE']!;
      final parcelle = camion['PS_CODE']!;
      final ligneId = lignes[selectedIndexLigne!].id;

      // Enregistrer dans DechargerTable
      bool success = await enregistrerDechargementCours(
        veCode: veCode,
        poidsP1: poidsP1,
        techCoupe: techCoupe,
        parcelle:  parcelle,
        dateHeureP1: dateHeureP1,
        ligneId: ligneId
      );

      if (success) {
        setState(() {
          camionsAttente.removeAt(index); // Retirer le camion de la liste des camions en attente
        });

        //_showMessageWithTime('Déchargement sur la table à canne enregistré avec succès.', 1000);
      } 
      // else {
      //   _showMessageWithTime('Échec de l\'enregistrement du camion déchargé sur la table à canne.', 5000);
      // }
      return success; // Retourner le résultat de l'enregistrement
    } catch (err) {
     // _showMessageWithTime('Erreur lors de l\'enregistrement du camion: $err', 5000);
      return false; // Retourner false en cas d'exception
    }
  }

  //affecter un camion a une ligne implique de l'enregistrer dans la cours 
  Future<void> _affecterCamion(int camionIndex) async {
    if (selectedIndexLigne != null) {
      var camion = camionsAttente[camionIndex];

      try {
        // Enregistrer le camion dans la table de déchargement
        bool success = await _enregistrerCamionCours(camion, camionIndex);

        if (success) {
          // L'enregistrement a réussi, procéder à l'affectation du camion
          //int camionId = int.parse(camion['id']!); // Convertir 'id' de 'String?' à 'int'
          final veCode = camion['VE_CODE']!;
          final dateHeureP1 = DateTime.parse(camion['DATEHEUREP1']!);

          // Appeler la fonction d'affectation avec le 'camionId' converti en 'int'
          await affecterCamionALigne(ligneId: lignes[selectedIndexLigne!].id, veCode: veCode, dateHeureP1:  dateHeureP1);

          //Recharger les données après l'affectation
          await _loadCamionsAffecterLigne();
          await _loadLignes();

          //_showMessageWithTime('Camion déchargé et affecté avec succès.', 3000);
        } else {
          // L'enregistrement a échoué, informer l'utilisateur et ne pas effectuer l'affectation
          _showMessageWithTime('L\'enregistrement du camion dans la cour a échoué. Aucune affectation n\'a été effectuée.', 5000);
          //print('L\'enregistrement du camion dans la cour a échoué. Aucune affectation n\'a été effectuée.');

        }
      } catch (e) {
        // Gérer les erreurs potentielles lors de l'affectation ou de l'enregistrement
        //_showMessageWithTime('Erreur lors de l\'affectation ou de l\'enregistrement du camion', 5000);
        print('Erreur lors de l\'affectation ou de l\'enregistrement du camion: $e');
      }
    } else {
      _showMessageWithTime('Aucune ligne sélectionnée.', 3000);
    }
  }

  //retirer un camion affecter a une ligne
  Future<void> _retirerCamion(int camionIndex) async {
    if (selectedIndexLigne != null) {
      var camion = camionsLigne[camionIndex];

      final veCode = camion.veCode;
      final dateHeureP1 = camion.dateHeureP1; // Suppression de la conversion

      // Supprimer le camion de la ligne
      await retirerCamionDeLigne(
        ligneId: lignes[selectedIndexLigne!].id, 
        veCode: veCode, 
        dateHeureP1: dateHeureP1 // DateTime utilisé directement
      );

      // Supprimer le camion de la collection DechargerCours
      bool success = await supprimerDechargementCours(camion.id);

      if (success) {
        await _loadLignes();
        await _loadCamionsAffecterLigne();
        _refreshCamionsAttente();
      } else {
        _showMessageWithTime('Échec du retrait du camion.', 5000);
      }
    }
  }



  //changer le nombre de tas d'une ligne
  Future<void> _updateNombreTas(int ligneId, int newCount) async {
    await updateNombreTas(ligneId: ligneId, nouveauNombreTas: newCount);
    // Recharger les lignes pour mettre à jour l'interface utilisateur
    _loadLignes();
    
  }

  // Fonction pour afficher les messages d'erreur
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message),
      duration: const Duration(seconds: 10)), // Durée de 10 secondes
    );
    
  }

  // Fonction pour afficher les messages en precisant le temps que cela doit faire
  void _showMessageWithTime(String message, int milliseconds) {
    if (!mounted) return; // Si le widget est démonté, on arrête la méthode
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(milliseconds: milliseconds),
      ),
    );
  }



}

















// Future<void> _updatePoidsTotalLigne(int ligneId) async {
//   final updatedLigne = await getLigneById(ligneId);
//   setState(() {
//     final index = lignes.indexWhere((ligne) => ligne.id == ligneId);
//     if (index != -1) {
//       lignes[index] = updatedLigne;
//     }
//   });
// }


/*

 // Fonction pour récupérer les camions en attente depuis l'API
  Future<void> _loadCamionsAttenteFiltrerPourLaCour() async {
    try {
      // Charger les camions en attente depuis l'API
      camionsAttente = await getCamionAttenteFromAPI();

      // Charger les camions déchargés depuis les collections DechargerCours et DechargerTable
      final camionsCours = await listerCamionDechargerCours(); // Récupère les camions déchargés de DechargerCours
      final camionsTable = await listerCamionDechargerTable(); // Récupère les camions déchargés de DechargerTable

      // Combiner les camions déchargés des deux collections
      final allCamionsDecharger = [...camionsTable, ...camionsCours];

      // Filtrer les camions en attente pour exclure ceux déjà déchargés
      final filteredCamionsAttente = camionsAttente.where((camionAttente) {
        // Convertir la chaîne de caractères 'DATEHEUREP1' du camion en attente en objet DateTime
        DateTime dateHeureP1Attente = DateTime.parse(camionAttente['DATEHEUREP1']!);

        // Vérifier si la date/heure du camion en attente correspond à celle d'un camion déchargé
        return !allCamionsDecharger.any((camionDecharge) {
          DateTime? dateHeureP1Decharge;

          // Si le camion déchargé est de type DechargerCours, récupérer sa date/heure P1
          if (camionDecharge is DechargerCours) {
            dateHeureP1Decharge = camionDecharge.dateHeureP1;
          }
          // Si le camion déchargé est de type DechargerTable, récupérer sa date/heure P1
          else if (camionDecharge is DechargerTable) {
            dateHeureP1Decharge = camionDecharge.dateHeureP1;
          }

          // Comparer les dates/heure pour vérifier si elles correspondent
          return dateHeureP1Decharge != null && dateHeureP1Attente.isAtSameMomentAs(dateHeureP1Decharge);
        });
      }).toList();

      // Mettre à jour la liste des camions en attente et indiquer la fin du chargement
      setState(() {
        camionsAttente = filteredCamionsAttente;
        _isLoading = false; // Fin du chargement
      });
    } catch (e) {
      // Afficher un message d'erreur en cas de problème lors du chargement des camions en attente
      _showMessageWithTime("Le chargement des camions en attente a échoué. Vérifiez votre connexion internet.", 6000);
    }
  }
*/
