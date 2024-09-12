import 'dart:async';
import 'package:Gedcocanne/auth/services/login_services.dart';
import 'package:Gedcocanne/services/api/broyage_services.dart';
import 'package:Gedcocanne/services/api/cours_canne_services.dart';
import 'package:Gedcocanne/services/api/ligne_tas_services.dart';
import 'package:Gedcocanne/services/viewsFunction/cours_canne_functions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:overlay_support/overlay_support.dart';

class CoursCanne extends StatefulWidget {
  //doit permettre de faire la recuperation des P2 et la synchro ainsi que le reset du timer dans le cas du pull to refresh
  //final void Function() updateP2AndSyncAndResetTimer;
  final Function updateP2AndSyncAndResetTimer;
  final bool isSwitched;
  //réçoit la liste des camions en attente de son parent
  final List<Map<String, String>> camionsAttente;
  //callback pour informer le parent lorsqu'un element est retirer de la liste
  final Function(Map<String, String>) onCamionsAttenteUpdated;
  //celui va permet de recharger la liste des caamions en attente dans le cas d'une supression par exemple
  final Future<void> Function() chargerCamionsAttente;

  const CoursCanne({
    super.key, 
    required this.updateP2AndSyncAndResetTimer, 
    required this.isSwitched, 
    required this.camionsAttente, 
    required this.onCamionsAttenteUpdated, 
    required this.chargerCamionsAttente,});

  @override
  State<CoursCanne> createState() => _CoursCanneState();
}

class _CoursCanneState extends State<CoursCanne> {
  List<Map<String, dynamic>> lignes = [];
  // variable pour suivre la selection d'une ligne dans la premiere grande colonne
  int? selectedIndexLigne;
  //// variable pour suivre la selection d'un camion dans la deuxieme grande colonne
  int? selectedIndexCamion;

  bool _hasAffectation = false; //permettra de savoir si des camions sont affecter a la ligne selectionner
  bool _isLoadingCamionAffecter = false; //permettra de savoir si le chargement des camions affecter a une ligne est en cours ou pas

  late List<Map<String, String>> camionsAttenteFiltres; // Variable d'état locale

  //stocker la liste des camions d'une ligne donnee
  List<Map<String, dynamic>> camionsLigne = [];

  //celle variable vas contenir une liste des lignes verouiller
  List<int> lignesVerrouillees = [];

  Timer? _debounce;

  // Booléen pour suivre si le chargement des camions en attente est en cours ou pas
  final bool _isLoadingCamionAttente = false;

  // Booléen pour suivre si le chargement des lignes est en cours ou pas

  bool _isLoadingLigne = true;

  //pour chaque ligne on aura un champ textFiel il faut donc un controlleur pour chacun afin d'avoir un control sur la valeur saisi
  late List<TextEditingController> _controllers= [];

  //FocusNode _focusNode = FocusNode();

  //c'est pour eviter qu'il puisse faire des affectation a une ligne verouiller
  //bool ICanAffected = true;  // on va donc utiliser cette variable pour suivre


  @override
  void initState() {
    super.initState();
    
    _loadLignes();

    //en fonction de l'etat du switch afficher les camions en attente
    if (widget.isSwitched) {
      camionsAttenteFiltres = widget.camionsAttente; // Charger tous les camions en attente sans exclusion ( sans tenir compte de la technique de coupe)
  
    } else {
      _filterCamionsAttentePourLaCour(); // charger les camions en atttente a decharger dans la cour (on tient compte de la technique de coupe)
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
    int nombreDeCamionEnAttente  = camionsAttenteFiltres.length ;
    int nombreCamionAffecter = camionsLigne.length;

    //bool _isHovered = false; //permet de savoir si on fait un hover ou pas sur l'elelement de la listVew
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Center(child: Text("Lignes", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)))),
                      Expanded(child: Center(child: Text("Tas" , style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)))),
                      Expanded(child: Center(child: Text("Nombre de tas", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)))),
                      Expanded(child: Center(child: Text("Tonnage", style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)))),
                    ],
                  ),
                ),
                Expanded(

                  //celui la permet de fermer le clavier lorsqu'il est ouvert et qu'on tap ailleur
                  child: _isLoadingLigne
                        ? const Center(child: CircularProgressIndicator())
                        : lignes.isEmpty ? Center(
                                child: ListView(
                                  children: [
                                    const SizedBox(height: 50,),
                                    Text(
                                    'Aucune ligne n\'est definit',
                                    style: GoogleFonts.poppins(fontSize: 16 , color: Colors.grey),
                                    textAlign: TextAlign.center, // Centrer le texte horizontalement
                                  ),
                                  ],
                                ),
                              )  
                        : GestureDetector(
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
                                  //si c'est egal ça veut dire que tous les tas ont ete cocher donc il faut verouiller
                                  final estVerrouillee = ligne['nbreTas']==ligne['nbreTasBroyes'];
                                  //celui la me permet de detecter les click sur le card
                                  return InkWell(
                                    onTap: () async {
                                      //bool thereAffectation = await _verifierAffectation();
                                    
                                      setState(() {
                                        if (selectedIndexLigne == index) {
                                          selectedIndexLigne = null; // Désélectionner la ligne si elle est déjà sélectionnée
                                        } else {
                                          selectedIndexLigne = index; // Sélectionner la nouvelle ligne
                                        }
                                      });

                                      // chargera les camions affecter a la ligne s'il y'en a bien sur
                         
                                      _loadCamionsAffecterLigne(ligne['ligneId']);
                                    },
                                    child: Dismissible(
                                      key: Key(ligne['ligneId'].toString()), // Utilisez l'identifiant de la ligne comme clé
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
                                        // Vérifier si la suppression est acceptable
                                        bool canDelete = await canDeleteLigneFromAPI(ligne['libele']);
                                        
                                        if (!canDelete) {
                                          // Afficher un message si la suppression n'est pas autorisée
                                          // Afficher un message si la suppression n'est pas autorisée
                                          _showErrorMessage('Impossible de supprimer cette ligne. Supprimez les lignes avec un numéro plus élevé d\'abord.', const Color(0xFF323232));
                                          return false;
                                        } 
                                        // Afficher un dialogue de confirmation avant de supprimer
                                        // Afficher un dialogue de confirmation avant de supprimer
                                        return await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Confirmer la suppression", style: GoogleFonts.poppins(fontSize: 16)),
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
                                          },).then((value) {
                                              // Utilisez mounted pour vérifier que le widget est encore monté avant d'effectuer toute action.
                                              if (!mounted) return false;
                                              return value ?? false;
                                            });
                                          //on peut enleverla partie de then
                                        },

                                      onDismissed: (direction) async {
                                        // Vérifier si la suppression est acceptable
                                        bool canDelete = await canDeleteLigneFromAPI(ligne['libele']);

                                        if (canDelete) {
                                          // Appeler la fonction pour supprimer la ligne
                                          bool deleteSuccess = await deleteLigneFromAPI(ligne['ligneId']);
                                          
                                          if (deleteSuccess) {
                                            // Supprimer la ligne de la liste locale
                                            setState(() {
                                              lignes.removeAt(index);
                                            });
                                          
                                          } else {
                                            // Afficher un message d'erreur si la suppression échoue
                                            _showErrorMessage("La suppression de la ligne à echoué, connectez vous au reseau", const Color(0xFF323232));

                                          }
                                        } else {
                              
                                          // Afficher un message si la suppression n'est pas autorisée
                                          _showErrorMessage('Impossible de supprimer cette ligne. Supprimez les lignes avec un numéro plus élevé d\'abord.', const Color(0xFF323232));
                                        }
                                      },
                                      child: Card(
                                        color: estVerrouillee ? const Color(0xFF265175) : selectedIndexLigne == index ? const Color(0xFFF8E7E7) : Colors.white,
                                        elevation: 14,
                                        margin: const EdgeInsets.all(10),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            //crossAxisAlignment: CrossAxisAlignment.start, // Aligner les éléments au sommet
                                            children: [
                                              // Zone d'affichage du nom de la ligne
                                              
                                              // Zone d'affichage du nom de la ligne
                                              Flexible(
                                                flex: 1, // Peut être ajusté pour contrôler la flexibilité
                                                child: SizedBox(
                                                  width: 100, // Largeur fixe
                                                  child: Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 12.0),
                                                      child: Text(
                                                        ligne['libele'],
                                                        style: GoogleFonts.poppins(fontSize: 16 , color: estVerrouillee ? Colors.white : Colors.black),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // Zone des tas (utilise GridView pour la grille des cases)
                                              Expanded(
                                                child: SizedBox(
                                                  width: 300, // Largeur fixe pour la colonne de Tas
                                                  height: 150, // Hauteur fixe ou ajustée en fonction du nombre de cases
                                                  child: GridView.builder(
                                                    shrinkWrap: true,
                                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3, // Nombre de colonnes
                                                      crossAxisSpacing: 2.0, // Espacement horizontal entre les cases
                                                      mainAxisSpacing: 2.0, // Espacement vertical entre les cases
                                                    ),
                                                    itemCount: ligne['tas'].length,
                                                    itemBuilder: (context, i) {
                                                      final tas = ligne['tas'][i];
                                                      final bool estCoche = tas['tasEtat'] == 1;
                                                      //_loadVerouillageLigne(ligne['ligneId']);
                                                      //les case a
                                                      return GestureDetector(
                                                        onTap: () async {
                                                          if (estVerrouillee) return; // Ne pas permettre les changements si la ligne est verrouillée
                                                
                                                          // Mettre à jour l'état du tas
                                                          setState(() {
                                                            tas['tasEtat'] = estCoche ? 0 : 1;
                                                          });
                                                
                                                          if (tas['tasEtat'] == 1) {
                                                              
                                                            double tasPoids = tas['poids'].toDouble();
                                                            //print(tasPoids);
                                                            //debugTasPoids(tasPoids);
                                                            //si une case est coche enregistrer son broyage
                                                            bool success = await addTasDansTableCanneFromAPI(
                                                              tasId: tas['tasId'],
                                                            );
                                                            if(success){                                                       
                                                              //le broyage à reussi afficher un messag
                                                              _showMessageBroyage(ligne['libele'], i + 1, tasPoids);
                                                
                                                              bool estDernierTas =  await verifierTousTasCochesFromAPI(ligne['ligneId']);
                                                
                                                              if (estDernierTas) {
                                                                bool successVerouillage = await updateStatutVerouillageFromAPI(ligneId: ligne['ligneId']);
                                                
                                                                if(!successVerouillage) _showErrorMessage("Le verouillage de la ligne à echoué, Connectez vous au reseau", const Color(0xFF323232));
                                                              }
                                                              
                                                            } else {
                                                              //le broyage du tas a echoue annuler la coche
                                                              _showErrorMessage("Le marquage du broyage a échoué, Connectez-vous au réseau", const Color(0xFF323232));
                                                
                                                            }
                                                           
                                                          } else {
                                                            String resultatRetrait = await retirerTasDeTableCanneFromAPI(
                                                            tasId: tas['tasId'],);
                                                
                                                            switch (resultatRetrait) {
                                                              case 'true':
                                                      
                                                                _showSuccessMessage('Broyage annulé pour le tas ${i + 1}');
                                                                break;
                                                              case 'non_autorise':
                                                                _showErrorMessage('Opération non autorisée. Vous n\'avez pas les droits nécessaires.', const Color(0xFF323232));
                                                                break;
                                                              case 'false':                                           
                                                                _showErrorMessage("L'operation à echoué, Connectez vous au réseau ", const Color.fromARGB(207, 0, 0, 0));
                                                                break;
                                                              case 'erreur':
                                                              default:
                                                                _showErrorMessage('Erreur lors du retrait du tas de TableCanne, connectez-vous au réseau', const Color(0xFF323232));
                                                                break;
                                                            }
                                                
                                                          }

                                                          _loadLignes();

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
                                                                  checkColor: WidgetStateProperty.all(
                                                                    estVerrouillee ? const Color(0xFFFBA336) : const Color.fromARGB(255, 79, 215, 84),
                                                                  ), // Couleur de la coche
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

                                              // la partie des
                                              SizedBox(
                                                width: 270,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(right: 20),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          // Zone pour renseigner le nombre de lignes
                                                          SizedBox(
                                                            width: 60,
                                                            child: Center(
                                                              child: TextField(
                                                                style: TextStyle(color: estVerrouillee ? Colors.white : Colors.black),
                                                                autofocus: false,
                                                                readOnly: estVerrouillee, // Désactiver le TextField si la ligne est verrouillée
                                                                controller: _controllers[index], // Contrôleur pour suivre les changements dans le code
                                                                keyboardType: TextInputType.number,
                                                                decoration: InputDecoration(
                                                                  // border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

                                                                  enabledBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      borderSide: BorderSide(
                                                                        color: Theme.of(context).brightness == Brightness.dark 
                                                                            ? Colors.black // Bordure  en mode sombre
                                                                            : Colors.black, // Couleur de la bordure lorsqu'elle n'est pas sélectionnée
                                                                        width: 1, // Largeur de la bordure
                                                                      ),
                                                                    ),

                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      borderSide: BorderSide(
                                                                        color: Theme.of(context).brightness == Brightness.dark 
                                                                            ? Colors.blue // Bordure  en mode sombre
                                                                            : Colors.blue, // Couleur de la bordure lorsqu'elle n'est pas sélectionnée
                                                                        width: 1, // Largeur de la bordure
                                                                      ),
                                                                    ),
                                                                    
                                                                ),
                                                                onChanged: (value) {
                                                                  _onTextChanged(value, index);
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          
                                                          const SizedBox(width: 10,),

                                                          // Afficher le tonnage de la ligne
                                                          Expanded(
                                                            child: Center(
                                                              child: Container(
                                                                width: 800,
                                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                                child: TextField(
                                                                  style: TextStyle(color: estVerrouillee ? Colors.white : Colors.black),
                                                                  readOnly: true, // Rendre ce champ en lecture seule
                                                                  decoration: InputDecoration(
                                                                    // border: OutlineInputBorder(
                                                                    //   borderRadius: BorderRadius.circular(10), 
                                                                    // ),

                                                                    enabledBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      borderSide: BorderSide(
                                                                        color: Theme.of(context).brightness == Brightness.dark 
                                                                            ? Colors.black // Bordure  en mode sombre
                                                                            : Colors.black, // Couleur de la bordure lorsqu'elle n'est pas sélectionnée
                                                                        width: 1, // Largeur de la bordure
                                                                      ),
                                                                    ),

                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      borderSide: BorderSide(
                                                                        color: Theme.of(context).brightness == Brightness.dark 
                                                                            ? Colors.blue // Bordure  en mode sombre
                                                                            : Colors.blue, // Couleur de la bordure lorsqu'elle n'est pas sélectionnée
                                                                        width: 1, // Largeur de la bordure
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  controller: TextEditingController(text: ligne['tonnageLigne'].toString()),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                  
                                                  
                                                      // Afficher le tonnage de la ligne
                                                      Row(
                                                        children: [
                                                          Center(child: Text('Broyé (${ligne['nbreTasBroyes'].toString()}/${ligne['nbreTas'].toString()})', style: TextStyle(color: estVerrouillee  ? Colors.white : Colors.black),)),

                                                          const SizedBox(width: 10,),

                                                          Expanded(
                                                            child: Center(
                                                              child: Container(
                                                                width: 900,
                                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                                                                child: TextField(
                                                                  style: TextStyle(color: estVerrouillee ? Colors.white : Colors.black),
                                                                  readOnly: true, // Rendre ce champ en lecture seule
                                                                  decoration: InputDecoration(
                                                                    border: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      borderSide: BorderSide(color: estVerrouillee ?Colors.black : const Color(0xFF000000)), // Couleur de la bordure
                                                                    ),
                                                                    enabledBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      borderSide: BorderSide(
                                                                        color: Theme.of(context).brightness == Brightness.dark 
                                                                            ? Colors.black // Bordure  en mode sombre
                                                                            : Colors.black, // Couleur de la bordure lorsqu'elle n'est pas sélectionnée
                                                                        width: 1, // Largeur de la bordure
                                                                      ),
                                                                    ),

                                                                    focusedBorder: OutlineInputBorder(
                                                                      borderRadius: BorderRadius.circular(10),
                                                                      borderSide: BorderSide(
                                                                        color: Theme.of(context).brightness == Brightness.dark 
                                                                            ? Colors.blue // Bordure  en mode sombre
                                                                            : Colors.blue, // Couleur de la bordure lorsqu'elle n'est pas sélectionnée
                                                                        width: 1, // Largeur de la bordure
                                                                      ),
                                                                    ),
                                                                                                                                    
                                                                  ),
                                                                  controller: TextEditingController(text: ligne['tonnageTasBroyes'].toString()),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              //si tous les tas sont cocher verouiller la ligne
                                              if (estVerrouillee)
                                                IconButton(
                                                  icon: const Icon(Icons.lock_open, color: Color(0xFFFBA336), size: 30 ,),
                                                  onPressed: () async { 
                                                    await _debloquerLigne(ligne['ligneId'], ligne['libele'] ); 
                                                    await _loadLignes();
                                                    
                                                  }    
                                                ),
                                            ],
                                          ),
                                        ),
                                      )

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
        
          // Deuxieme grande colonne

          Expanded(
            flex: 2,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: Text("Camions en attente d'affectation ($nombreDeCamionEnAttente)", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold))),
                ),

                //premiere section de la deuxieme grande colonne
                Expanded(
                  child: _isLoadingCamionAttente
                        ? const Center(child: CircularProgressIndicator()) // Afficher le CircularProgressIndicator si en chargement
                        : camionsAttenteFiltres.isEmpty
                            ? RefreshIndicator(
                              onRefresh: _reloadCamionsAttente,
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
                              onRefresh: _reloadCamionsAttente,
                              child: ListView.builder(
                                itemCount: 
                                camionsAttenteFiltres.length, 
                                itemBuilder: (context, index) {
                                  final camion = camionsAttenteFiltres[index]; // 
                                  // Conversion des chaînes en types appropriés
                                  var poidsP1 = double.tryParse(camion['PS_POIDSP1']!) ?? 0.0;
                                  var dateDecharge = DateTime.parse(camion['PS_DATEHEUREP1']!); // Convertir en DateTime
                                  var dateDechargeFormater = DateFormat('dd/MM/yyyy HH:mm:ss').format(dateDecharge);

                                  return Container(
                                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 40),
                                    margin: const EdgeInsets.only(left: 20),
                                    decoration: const BoxDecoration(color: Colors.white),
                                    child: ListTile(
                                      dense: true,  // Rendre le ListTile plus compact
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),  // Réduire le padding interne
                                      minVerticalPadding: 4,  // Réduire le padding vertical au minimum
                                      hoverColor: Colors.lightBlueAccent,    // Couleur de survol (Desktop/Web)
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
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextSpan(
                                              text: '- ${camion['PS_TECH_COUPE'] }', // Deuxième texte normal
                                              style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      leading: const Icon(Icons.fire_truck_rounded),
                                      subtitle: Text(
                                        'Poids P1 : $poidsP1 tonnes, $dateDechargeFormater',
                                        style: GoogleFonts.poppins(fontSize: 14),
                                      ),
                                      trailing: selectedIndexLigne != null
                                          ? Checkbox(
                                              value: false,
                                              onChanged: (bool? value) {
                                                final ligne = lignes[selectedIndexLigne!];
                                                bool isVerrouillee = lignesVerrouillees.contains(ligne['ligneId']);
                                    
                                                if (!isVerrouillee) {
                                                  setState(() {
                                                    _affecterCamion(camionsAttenteFiltres, index , lignes , lignes[selectedIndexLigne!] ,ligne['ligneId']);
                                                  });
                                                } else {
                                                  _showErrorMessage('Cette ligne est verrouillée et ne peut pas être affectée.', const Color(0xFF323232));
                                                }
                                              },
                                            )
                                          : null,
                                      onTap: () {
                                        //pour dire oui c'est lui qui a ete selectionner
                                        //selectedIndexCamion = index;
                                                                        
                                        //c'est pour eviter qu'il puisse faire des affectation a une ligne verouiller ou non selectionner
                                                                        
                                        if (selectedIndexLigne != null){
                                        final ligne = lignes[selectedIndexLigne!];
                                        //verifier si la ligne a ete verouiller
                                        //bool isVerrouillee = false;
                                        // Vérifier si la ligne est verrouillée en utilisant 'ligneId'
                                        final isVerrouillee = ligne['nbreTas']==ligne['nbreTasBroyes'];
                                    
                                        //s'il à selectionner une ligne et que cette ligne n'est pas verouiller accepter l'affectation
                                        if (selectedIndexLigne != null && !isVerrouillee) {
                                          _affecterCamion(camionsAttenteFiltres, index , lignes , lignes[selectedIndexLigne!] ,ligne['ligneId']);
                                        }
                                        }
                                        
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                ),

                if (selectedIndexLigne != null ) ...[
                  Expanded(
                    child: _isLoadingCamionAffecter
                      ? const Center(child: CircularProgressIndicator())
                      : _hasAffectation == true
                          ? Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  child: Center(
                                    child: Text(
                                      "Camions affectés à la ${lignes[selectedIndexLigne!]['libele']} ($nombreCamionAffecter)",
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
                                        // Extraire les valeurs des champs à partir du Map
                                        final veCode = camion['veCode'] ?? '';
                                        final parcelle = camion['parcelle'] ?? '';
                                        final techCoupe = camion['techCoupe'] ?? '';
                                        final poidsP1 = camion['poidsP1']?.toString();
                                        final poidsP2 = camion['poidsP2']?.toString();
                                        final poidsTare = camion['poidsTare']?.toString();
                                        final poidsNet = camion['poidsNet']?.toString();
                                        bool isVerrouillee = lignesVerrouillees.contains(lignes[selectedIndexLigne!]['ligneId']);
                                        return InkWell(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 40),
                                            margin: const EdgeInsets.only(left: 20),
                                            decoration: const BoxDecoration(color: Colors.white),
                                            child: ListTile(
                                              dense: true, // Rendre le ListTile plus compact
                                              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8), // Réduire le padding interne
                                              minVerticalPadding: 4, // Réduire le padding vertical au minimum
                                              hoverColor: Colors.lightBlueAccent, // Couleur de survol (Desktop/Web)
                                              leading: const Icon(Icons.fire_truck_rounded),
                                              title: Text(
                                                '$veCode ($parcelle) - $techCoupe',
                                                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                                              ),
                                              subtitle: Text(
                                                'Poids P1 : $poidsP1 tonnes, '
                                                '${poidsP2 != null ? 'Poids P2 : $poidsP2 tonnes, ' : 'Poids Tare : $poidsTare tonnes, '}'
                                                'Poids Net : $poidsNet tonnes',
                                              ),
                                              trailing: !isVerrouillee ? IconButton(
                                                icon: const Icon(Icons.remove_circle),
            
                                                onPressed: () {_retirerCamion(index) ; _reloadCamionsAttente();},
                                              ) : null,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : const Center(
                              child: Text('Aucun camion affecté à cette ligne.'),
                            ),
                  ),                         
                
                ],
                
              ],
            ),
          ),
          
        ],
      ),

      floatingActionButton: DraggableFAB(
        onPressed: _addLigne,
        //child: const Icon(Icons.add),   
      ),
    );

  }

  //sera utiliser dans le pull to refresh
  Future<void> _refreshLigne () async {
    _loadLignes();
    widget.updateP2AndSyncAndResetTimer();
  }

  //permet de charger les ligne deja creer (les recuperer dans la base de donnee afin d'en faire l'affichage)
   //permet de charger les ligne deja creer (les recuperer dans la base de donnee afin d'en faire l'affichage)
  //on lui passe l'ancienne liste et il va recharger si jamais il y'a des nouvelle lignes ont pourra les prendres 
  Future<void> _loadLignes() async {
    try {
      final List<Map<String, dynamic>> allLignes = await getAllLigneFromAPI();
      
      setState(() {
        // Vérifier si la liste des lignes est vide
        if (allLignes.isEmpty) {
          _isLoadingLigne= false;
          //logger('Aucune ligne disponible.');
        } else {
          lignes = allLignes;

          _isLoadingLigne= false;

          // Disposer des anciens contrôleurs
          for (var controller in _controllers) {
            controller.dispose();
          }

          // Générer de nouveaux contrôleurs en fonction du nombre de lignes
          _controllers = List.generate(
            lignes.length,
            (index) => TextEditingController(text: lignes[index]['nbreTas'].toString()),
          );
        }
      });
    } catch (e) {
      // En cas d'erreur, on peut également réinitialiser la liste des lignes
      // setState(() {
      //   //lignes = [];
      //   //_isLoadingLigne= false;
      //   //_controllers.clear();
      // });
      //logger.e('Erreur lors du chargement des lignes : $e');
        _showErrorMessage("Le chargement des Lignes à échoué. Connectez vous au réseau.", const Color(0xFF323232));
    }
  }


  //permet de verouiller la ligne dans le cas ou l'on a broyé la derniere tas
  // Future<void> _verrouillerLigne(int ligneId) async {
  //   setState(() {
  //     lignesVerrouillees.add(ligneId);
  //   });
  // }

  //permet de deverouiller la ligne dans le cas ou l'on a fini de brollé tout les tas et qu'il est verouiller
  Future<void> _debloquerLigne(int ligneId, String ligneLibele) async {

    bool etatBroyageMisAJour = await updateEtatBroyageOfCamionFromAPI(ligneId);
    if (!etatBroyageMisAJour) {
      // Afficher une alerte si la mise à jour de l'état de broyage échoue
      _showErrorMessage('Échec de la mise à jour de l\'état de broyage des camions affecter à la ligne. Connectez vous au réseau et réessayer.', const Color(0xFF323232));       
      return;
    }

    bool ligneDeverrouillee = await deverouillerLigneFromAPI(ligneId, ligneLibele);
    if (!ligneDeverrouillee) {
      // Afficher une alerte si le déverrouillage de la ligne échoue

      _showErrorMessage('Échec du déverrouillage de la ligne. Connectez vous au réseau et réessayer.', const Color(0xFF323232));
      return;
    }

    // Succès, informer l'utilisateur que la ligne a été déverrouillée
    _showSuccessMessage('La $ligneLibele a été libéré avec succès.');
  }


  //permet de verifier si au moins un camions a ete affecter au camion sera utile lorsqu'il aura selectionnner une ligne
  
  //fonction pour charger les camions affecter a la ligne selectionner
  Future<void> _loadCamionsAffecterLigne(int ligneId) async {
    setState(() {
      _isLoadingCamionAffecter = true; // Commencer le chargement
    });

    if (selectedIndexLigne != null) {
      // Utilisez l'ID de la ligne sélectionnée pour vérifier l'affectation
      bool hasCamions = await verifierAffectationLigneFromAPI(ligneId: lignes[selectedIndexLigne!]['ligneId']);
      
      if (hasCamions) {
        // Charger les camions affectés uniquement si des camions sont affectés
        final camions = await recupererCamionsLigneFromAPI(ligneId);
        setState(() {
          camionsLigne = camions;
        });
      }

      setState(() {
        _hasAffectation = hasCamions; // Mettre à jour le résultat
        _isLoadingCamionAffecter = false; // Arrêter le chargement
      });

    } else {
      setState(() {
        _isLoadingCamionAffecter = false; // Arrêter le chargement
      });
    }
  } 


  // Fonction pour récupérer les camions en attente depuis l'API
  // Méthode pour filtrer les camions en attente localement
  void _filterCamionsAttentePourLaCour() {
    try {
      //widget.chargerCamionsAttente();
      // Exclure les camions dont la technique de coupe est 'RV' ou 'RB'
      final camionsFiltres = widget.camionsAttente.where((camionAttente) {
        return !(camionAttente['PS_TECH_COUPE'] == 'RV' || camionAttente['PS_TECH_COUPE'] == 'RB');
      }).toList();

      // Mettre à jour l'état local sans notifier le parent
      setState(() {
        camionsAttenteFiltres = camionsFiltres;
      });

    } catch (e) {
      // Gérer l'erreur localement
      _showErrorMessage("Erreur lors du filtrage des camions en attente.", Colors.black);
    }
  }

  //pour recharger la liste des camions en attent
  Future<void> _reloadCamionsAttente() async {
    
    widget.chargerCamionsAttente();

    //en fonction de l'etat du switch afficher les camions en attente
    if (widget.isSwitched) {
      camionsAttenteFiltres = widget.camionsAttente;  // Charger tous les camions en attente sans exclusion selon la technique de coupe

    } else {
      _filterCamionsAttentePourLaCour(); // charger les camions en atttente a decharger dans la cour (on tient compte de la technique de coupe)
    }
    //_updatePoidsP2();
    //widget.updateP2AndSyncAndResetTimer();

  }

  //pour recharger la liste des camions affecter a une ligne
  Future<void> _refreshCamionsAffecterLigne() async { 
    _loadCamionsAffecterLigne(lignes[selectedIndexLigne!]['ligneId']);
    widget.updateP2AndSyncAndResetTimer();  
    _loadLignes();
  }


 
  
  //permet de marquer les ligne veouiller lors de la construction du card des lignes
  // Future<void> _loadVerouillageLigne(int ligneId) async {
  //   Future<bool> estDernierTas =  verifierTousTasCochesFromAPI(ligneId);
  //   if (await estDernierTas) {
  //     await _verrouillerLigne(ligneId);
  //   }
  // }

  //pour creer une ligne
  Future<void> _addLigne() async {
    final count = await getLigneCountFromAPI();
    final libeleLigne = 'Ligne ${count + 1}';
    final currentUserId = await getCurrentUserId();

    if (currentUserId == null) {
      _showMessage('Erreur : ID de l\'utilisateur actuel est nul');
      return;
    }

    bool success = await createLigneFromAPI(libeleLigne);
    if (success) {
      _loadLignes();
    } else {
      _showMessage('La création de la ligne à echoué, Connectez vous au réseau');
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
      int newCount = int.tryParse(value) ?? lignes[index]['nbreTas'];
      
      //mettre à jour le nombre de tas dans la base de données.
      await _updateNombreTas(lignes[index]['ligneId'], newCount);

    });
  }


  //changer le nombre de tas d'une ligne
  Future<void> _updateNombreTas(int ligneId, int newCount) async {
   
    bool success = await updateNombreTasFromAPI(ligneId: ligneId, nouveauNombreTas: newCount);

    if (!success) {
      _showMessage("La mise à jour du nombre de tas pour cette ligne a échoué");
    } else {
      // Recharger les lignes pour mettre à jour l'interface utilisateur
      _loadLignes();
    }
  }


  
  //decharger un camion dans la cour
  // Décharger un camion dans la cour
  Future<bool> _enregistrerCamionCours(dynamic camion,  Map<String, dynamic> ligneSelectionner) async {
    try {
      final veCode = camion['VE_CODE']!;
      final poidsP1 = double.parse(camion['PS_POIDSP1']!);
      final dateHeureP1 = DateTime.parse(camion['PS_DATEHEUREP1']!);
      final techCoupe = camion['PS_TECH_COUPE']!;
      final parcelle = camion['PS_CODE']!;
      final ligneLibele = ligneSelectionner['libele'];
      final ligneId = ligneSelectionner['ligneId'];

      // Enregistrer dans DechargerCours via l'API
      bool success = await saveDechargementCoursFromAPI(
        veCode: veCode,
        poidsP1: poidsP1,
        techCoupe: techCoupe,
        parcelle: parcelle,
        dateHeureP1: dateHeureP1,
        ligneLibele: ligneLibele,
        ligneId : ligneId,
      );

      // Si l'enregistrement se fait sans souci
      if (success) {
        // Tentative de mise à jour du tonnage de la ligne
        bool successUpdateLigne = await updateLigneTonnageFromAPI(ligneId: ligneId, ligneLibele: ligneLibele);
        
        if (successUpdateLigne) {
          // Tentative de répartition du tonnage
          bool successRepartition = await repartirTonnageTasFromAPI(ligneId: ligneId);

          if (successRepartition) {
            // Tout a réussi, retirer le camion de la liste des camions en attente
            return true;
          } else {
            // Message d'erreur spécifique à la répartition
            _showErrorMessage("La répartition du tonnage entre les tas a échoué.", const Color(0xFF323232));

            // Suppression du camion car la répartition a échoué
            bool successDelete = await deleteCamionDechargerCoursFromAPI(
              veCode: veCode, 
              dateHeureP1: dateHeureP1.toIso8601String(),
            );

            if (!successDelete) {
              _showErrorMessage("La répartition a échoué et la suppression du camion a également échoué.", const Color(0xFF323232));
            } 
          }
        } else {
          // Message d'erreur spécifique à la mise à jour du tonnage
          _showErrorMessage("La mise à jour du tonnage de la ligne a échoué.", const Color(0xFF323232));

          // Suppression du camion car la mise à jour a échoué
          bool successDelete = await deleteCamionDechargerCoursFromAPI(
            veCode: veCode, 
            dateHeureP1: dateHeureP1.toIso8601String(),
          );

          if (!successDelete) {
            _showErrorMessage("La mise à jour du tonnage a échoué et la suppression du camion a également échoué.", const Color(0xFF323232));

          } else {
            // Tentative de mise à jour et répartition après suppression
            await updateLigneTonnageFromAPI(ligneId: ligneId, ligneLibele: ligneLibele);
            await repartirTonnageTasFromAPI(ligneId: ligneId);
          }
        }
      } else {
        // Message d'erreur global si l'enregistrement échoue
        return false;
      }

      return success; // Retourner le résultat de l'enregistrement
    } catch (err) {
      // Message d'erreur en cas d'exception
      //_showMessage('Erreur lors de l\'enregistrement du camion: $err');
      return false; // Retourner false en cas d'exception
    }
  }



  // Affecter un camion à une ligne et l'enregistrer dans la cour
  Future<void> _affecterCamion(List<Map<String, String>>camionsEnAttente, int camionIndex, List<Map<String, dynamic>> allLignes , Map<String, dynamic> ligneSelectionner ,int ligneId) async {
    try {
      final camion = camionsEnAttente[camionIndex];
      // Enregistrer le camion dans la la table des camions decharger dans la cour
      bool success = await _enregistrerCamionCours(camion, ligneSelectionner);

      if (success) {
        
        //le camion a pu etre enregistrer il faut donc le supprimer de la liste des camions en attente
        setState(() {
          camionsAttenteFiltres.removeAt(camionIndex);
        });

        // Appeler le callback pour informer le parent que la liste a changé
        widget.onCamionsAttenteUpdated(camion);

        // Recharger les données après l'affectation
        await _loadCamionsAffecterLigne(ligneId);
        await _loadLignes();

        //_showErrorMessage('Camion déchargé et affecté avec succès.', const Color(0xFF323232));
      } else {
        // Affichage d'un message si l'enregistrement échoue
        _showErrorMessage('L\'enregistrement du camion dans la cour a échoué. Aucune affectation n\'a été effectuée. Connectez-vous au réseau.', const Color(0xFF323232));

      }
    } catch (e) {
      // Message d'erreur en cas d'exception générale
      _showErrorMessage('L\'affectation a échoué, connectez-vous au réseau.', const Color(0xFF323232));
    }
    
  }

  // Retirer un camion affecté à une ligne
  Future<void> _retirerCamion(int camionIndex) async {
    if (selectedIndexLigne != null) {
      // Récupération du camion à partir de la liste des camions affectés
      var camion = camionsLigne[camionIndex];

      // Extraction des valeurs à partir du Map
      final veCode = camion['veCode'];
      final dateHeureP1 = camion['dateHeureP1']; // Assurez-vous que c'est bien un DateTime

      // Supprimer le camion via l'API
      bool success = await deleteCamionDechargerCoursFromAPI(
        veCode: veCode, 
        dateHeureP1: dateHeureP1
      );

      if (success) {
        // Mise à jour du tonnage de la ligne
        final ligneId = lignes[selectedIndexLigne!]['ligneId'];
        final ligneLibele = lignes[selectedIndexLigne!]['libele'];

        bool successUpdateLigne = await updateLigneTonnageFromAPI(ligneId: ligneId, ligneLibele: ligneLibele);

        if (successUpdateLigne) {
          // Répartir le tonnage sur les tas après la mise à jour de la ligne
          bool successRepartition = await repartirTonnageTasFromAPI(ligneId: ligneId);

          if (successRepartition) {
            // Recharger les données après le retrait du camion et la mise à jour
            await _loadLignes();
            await _loadCamionsAffecterLigne(lignes[selectedIndexLigne!]['ligneId']);
            await _reloadCamionsAttente();

            //_showErrorMessage('Camion retiré et tonnage mis à jour avec succès.', const Color(0xFF323232));
          } else {
            // Remettre le camion si la répartition échoue
            bool successReAdd = await saveDechargementCoursFromAPI(
              veCode: veCode,
              poidsP1: camion['poidsP1'],
              techCoupe: camion['techCoupe'],
              parcelle: camion['parcelle'],
              dateHeureP1: DateTime.parse(camion['dateHeureP1']),
              ligneLibele: lignes[selectedIndexLigne!]['libele'],
              ligneId: lignes[selectedIndexLigne!]['ligneId'],

            );

            if (successReAdd) {
              _showErrorMessage('La répartition des tas a échoué. Le camion a été remis. Connectez-vous au réseau.', const Color(0xFF323232));
            } else {
              _showErrorMessage('La répartition des tas a échoué et la remise du camion a également échoué. Connectez-vous au réseau.', const Color(0xFF323232));
            }
          }
        } else {
          // Remettre le camion si la mise à jour du tonnage échoue
          bool successReAdd = await saveDechargementCoursFromAPI(
            veCode: veCode,
            poidsP1: camion['poidsP1'],
            techCoupe: camion['techCoupe'],
            parcelle: camion['parcelle'],
            dateHeureP1: DateTime.parse(camion['dateHeureP1']),
            ligneLibele: lignes[selectedIndexLigne!]['libele'],
            ligneId: lignes[selectedIndexLigne!]['ligneId'],
          );

          if (successReAdd) {
            _showErrorMessage('La mise à jour du tonnage a échoué. Le camion a été remis. Connectez-vous au réseau.', const Color(0xFF323232));
          } else {
            _showErrorMessage('La mise à jour du tonnage a échoué et la remise du camion a également échoué. Connectez-vous au réseau.', const Color(0xFF323232));
          }
        }
      } else {
        _showErrorMessage('Échec du retrait du camion. Connectez-vous au réseau.', const Color(0xFF323232));
      }
    } else {
      _showErrorMessage('Veuillez sélectionner une ligne avant de retirer un camion.', const Color(0xFF323232));
    }
  }


  void _showMessageBroyage(String ligneLibel, int tasNumber, double tasPoids) {
    // On déclare une variable pour stocker l'entrée de la notification.
    OverlaySupportEntry? entry;

    entry = showSimpleNotification(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligne les éléments de chaque côté
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Centre le texte horizontalement
              children: [
                Text(
                  '$ligneLibel: Tas $tasNumber broyé!',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$tasPoids tonne',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              // On ferme la notification en appuyant sur la croix.
              entry?.dismiss(); // Fermer la notification via l'entrée
            },
          ),
        ],
      ),
      slideDismissDirection: DismissDirection.horizontal, // Permet de glisser pour fermer
      duration: const Duration(seconds: 2),
      background: const Color(0xFF019998), // Couleur de fond personnalisée
      position: NotificationPosition.bottom,
    );
  }


  // Fonction pour afficher les messages d'erreur
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message),
      duration: const Duration(seconds: 10)), // Durée de 10 secondes
    );
    
  }


  void _showErrorMessage(String message, Color color) {
    //On déclare une variable pour stocker l'entrée de la notification.
    OverlaySupportEntry? entry;

    //On assigne l'entrée de la notification à cette variable.
    entry = showSimpleNotification(
      Row(
        children: [
          //const Icon(Icons.error, color: Colors.white), // Icône d'erreur
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              //On ferme la notification en appuyant sur la croix.
              entry?.dismiss(); // Fermer la notification via l'entrée
            },
          ),
        ],
      ),
      background: Colors.black, // Couleur de fond pour indiquer une erreur
      position: NotificationPosition.bottom,
      duration: const Duration(seconds: 4),
      slideDismissDirection: DismissDirection.horizontal, // Permet de glisser pour fermer
    );
  }


  void _showSuccessMessage(String message) {
    OverlaySupportEntry? entry;

    entry = showSimpleNotification(
      Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white), // Icône de succès
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.white),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              entry?.dismiss(); // Fermer la notification via l'entrée
            },
          ),
        ],
      ),
      background: const Color.fromARGB(255, 67, 159, 70), // Couleur de fond pour indiquer le succès
      position: NotificationPosition.bottom, // Toujours afficher en haut
      duration: const Duration(seconds: 2),
      slideDismissDirection: DismissDirection.horizontal, // Permet de glisser pour fermer
    );
  }


  // void debugTasPoids(dynamic tasPoids) {
  //   print('Valeur de tasPoids: $tasPoids');
  //   print('Type de tasPoids: ${tasPoids.runtimeType}');
  // }






}

