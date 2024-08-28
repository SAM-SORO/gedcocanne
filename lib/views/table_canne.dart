import 'dart:async';
import 'package:cocages/services/api_service.dart';
import 'package:cocages/services/decharge_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class TableCanne extends StatefulWidget {
  //doit permettre de faire la recuperation des P2 et la synchro ainsi que le reset du timer dans le cas du pull to refresh
  final void Function() updateP2AndSyncAndResetTimer;

  // Retirez le mot-clé 'const' du constructeur
  const TableCanne({super.key, required this.updateP2AndSyncAndResetTimer});

  @override
  State<TableCanne> createState() => _TableCanneState();
}

class _TableCanneState extends State<TableCanne> {
  // Liste des camions en attente
  List<Map<String, String>> camionsAttente = [];
  // Liste des camions déjà déchargés
  List<dynamic> camionsDechargerTable = [];
  // Booléen pour suivre si le chargement des camions en attente est en cours ou pas
  bool _isLoading = true;
  

  Timer? _timer; // Variable pour stocker le Timer
  

  //variable pour suiivre si une synchronisation est en cour ou pas avant de proceder a la mise a jour du POISP2 parceque 
  //Le Timer.periodic et le RefreshIndicator peuvent entrer en conflit si les deux tentent de mettre à jour les données en même temps
  bool _isSyncing = false;


  @override
  void initState() {
    super.initState();
    _chargerCamionsDechargerTableDerniereHeure(); // Charger les camions déchargés 
    _chargerCamionsAttente(); // Charger les camions en attente à l'initialisation
  }

  @override
  void dispose() {
    _timer?.cancel(); // Annuler le Timer lors de la destruction du widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int nombreDeCamionEnAttente  = camionsAttente.length ;
    int nombreDeCamionDechargerTable  = camionsDechargerTable.length ;
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshCamionsAttente,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Camions en attente ($nombreDeCamionEnAttente)',
                      style:GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),

                    ),
                  ),
                  Expanded(
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator()) // Afficher le CircularProgressIndicator si en chargement
                        : camionsAttente.isEmpty
                            ? Center(
                                child: ListView(
                                  children: [
                                    const SizedBox(height: 50,),
                                    Text(
                                    'Aucun camion en attente',
                                    style: GoogleFonts.poppins(fontSize: 16),
                                    textAlign: TextAlign.center, // Centrer le texte horizontalement
                                  ),
                                  ],
                                ),
                              )

                            : ListView.builder(
                                itemCount: camionsAttente.length,
                                itemBuilder: (context, index) {
                                  var camion = camionsAttente[index];
                                  var datePremPeseeFormater = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.parse(camion['DATEHEUREP1']!));
                                  return Dismissible(
                                    key: Key(camion['VE_CODE']!), // Clé unique pour chaque élément
                                    direction: DismissDirection.startToEnd,
                                    onDismissed: (direction) async {
                                      await _enregistrerCamionTable(camion, index); // Enregistrer le camion lors du glissement
                                    },
                                    background: Container(
                                      color: Colors.green, // Couleur d'arrière-plan lors du glissement
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: const Icon(Icons.check, color: Colors.white),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.only(bottom: 15),
                                      margin: const EdgeInsets.only(left: 20),
                                      child: Card(
                                        color: camion['TECH_COUPE'] == 'RV' || camion['TECH_COUPE'] == 'RB' ? const Color(0xFFF8E7E7) : Colors.white,
                                        child: ListTile(
                                          title: Text('${camion['VE_CODE']} (${camion['PS_CODE']})', style: GoogleFonts.poppins(fontSize: 14),),
                                          subtitle: Text('poidsP1 : ${camion['PS_POIDSP1']} tonne, $datePremPeseeFormater', style: GoogleFonts.poppins(fontSize: 14)),
                                          trailing: Checkbox(
                                            value: false,
                                            onChanged: (bool? value) async {
                                              if (value == true) {
                                                await _enregistrerCamionTable(camion, index); // Enregistrer le camion si la case est cochée
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 30),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshCamionDechargerTable,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Camion Déchargé sur la table dernière heure($nombreDeCamionDechargerTable)',
                      style:GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: camionsDechargerTable.length,
                      itemBuilder: (context, index) {
                        var camion = camionsDechargerTable[index];
                        
                        return Container(
                            color:  Colors.white,
                            child: ListTile(
                            title: Text('${camion.veCode} (${camion.parcelle})',style: GoogleFonts.poppins(fontSize: 14)), // accès direct à la propriété
                            // var datePremPeseeFormater = DateFormat('dd/MM/yyyy HH:mm:ss').format(camion.dateHeureP1); // accès direct à la propriété
                            // subtitle: Text(
                            //   'poidsP1: ${camion.poidsP1} tonne, ${camion.poidsP2 != null ? 'poidsP2: ${camion.poidsP2} tonne, ' : ''} $datePremPeseeFormater',
                            //   style: GoogleFonts.poppins(fontSize: 14)
                            // ),
                            subtitle: Text(
                              'poidsP1: ${camion.poidsP1} tonnes, ${camion.poidsP2 != null ? 'poidsP2: ${camion.poidsP2} tonnes, ' : 'PoidsTare ${camion.poidsTare} tonnes, '} poidsNet: ${camion.poidsNet} tonnes',
                              style: GoogleFonts.poppins(fontSize: 14)
                            ),
                          ),
                          
                        );

                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        
          
        ],
      ),
      
    );
  }



  // Fonction pour récupérer les camions en attente depuis l'API
  Future<void> _chargerCamionsAttente() async {
    try {
      // Appeler la fonction avec un timeout
      camionsAttente = await getCamionAttenteFromAPI();

      // Appeler la fonction pour récupérer les camions déchargés
      final camionsCours = await listerCamionDechargerCours(); // Liste des camions déchargés (DechargerTable)
      final camionsTable = await listerCamionDechargerTable(); // Liste des camions déchargés (DechargerTable)

      // Combiner les camions déchargés de DechargerCours et DechargerTable
      // final allCamionsDecharger = [
      //   ...camionsDechargerTable.map((camion ) => camion  ),
      //   ...camionsCours
      // ];

      final List<dynamic> allCamionsDecharger = [
        ...camionsTable,
        ...camionsCours
      ];


      // Filtrer les camions en attente pour exclure ceux déjà déchargés
      final filteredCamionsAttente = camionsAttente.where((camionAttente) {
        DateTime dateHeureP1Attente = DateTime.parse(camionAttente['DATEHEUREP1']!);

        return !allCamionsDecharger.any((camion) {
         
          DateTime dateHeureP1Decharge = camion.dateHeureP1; 

          return dateHeureP1Attente.isAtSameMomentAs(dateHeureP1Decharge);
        });
      }).toList();

       if (mounted) {  
        setState(() {  
          camionsAttente = filteredCamionsAttente; // Met à jour la liste des camions  
          _isLoading = false; // Mise à jour de l'état de chargement  
        });  
      } 
    } catch (e) {
      //c'est important de verifier si c'est monter pour eviter des erreur d'appel a un context qui n'existe plus
       if (mounted) {
        setState(() {   
          _isLoading = false; // Mise à jour de l'état de chargement  
        });  
        _showMessageWithTime("le chargement des camions en attenter à echoué. Vérifiez votre connexion internet.",5000);
      }
    } 
  }


  Future<void> _refreshCamionsAttente() async{
    _chargerCamionsAttente();
    widget.updateP2AndSyncAndResetTimer;
  }


  // Fonction pour récupérer les camions déchargés sur la table a canne
  Future<void> _chargerCamionsDechargerTableDerniereHeure() async {
    try {
      final camions = await listerCamionDechargerTableDerniereHeure();
      
      setState(() {
        camionsDechargerTable = camions;
  
      });
    } catch (err) {
      _showMessageWithTime('Erreur lors de la récupération des camions déchargés enregistrer dans la base de donnee local', 4000);
    }
  }

  /*
  Future<void> _updtatePoidsP2() async {
    String updated = await getPoidsP2FromFPESEE(); 
    if (updated == "error"){    
      _showMessageWithTime("La Mise a jour du poids P2 camions déchargés à echoué . Veuillez vérifier également votre connexion internet.",6000);
    } 
    // else if (updated == "true") {
    //   _showMessageWithTime("La Recuperation du poids de la deuxieme pesee des camons déchargés effectuée avec succès",4000);

    // }
    // else{
    //   _showMessageWithTime("Les Poids de la deuxieme pesee des camions dechargés ont été recuperé",4000);
    // }
  }
  */



  // pour éviter les conflits de mise a jour manuelle et automatique lorsque les deux se font au meme moment
  Future<void> _refreshCamionDechargerTable() async {
    //s'il n'ya pas de synchronisation
    if (!_isSyncing) {
      setState(() {
        _isSyncing = true;
      });
      //await _updtatePoidsP2();
      //await synchroniserDonnee;
      //await _chargerCamionsDechargerTableDerniereHeure();
      widget.updateP2AndSyncAndResetTimer();

      setState(() {
        _isSyncing = false;
      });

      // _resetTimer(); // Réinitialiser le Timer après la mise à jour manuelle
    }
  }


  Future<void> _enregistrerCamionTable(Map<String, String> camion, int index) async {
    try {
      final veCode = camion['VE_CODE']!;
      final poidsP1 = double.parse(camion['PS_POIDSP1']!);
      final dateHeureP1 = DateTime.parse(camion['DATEHEUREP1']!);
      final techCoupe = camion['TECH_COUPE']!;
      final parcelle = camion['PS_CODE']!;

      bool success;

      // Enregistrer dans DechargerTable
      success = await enregistrerDechargementTable(
        veCode: veCode,
        poidsP1: poidsP1,
        techCoupe: techCoupe,
        parcelle:  parcelle,
        dateHeureP1: dateHeureP1,       
      );

      if (success) {
        setState(() {
          camionsAttente.removeAt(index); // Retirer le camion de la liste des camions en attente
        });

        _chargerCamionsDechargerTableDerniereHeure();
          
        //_showMessageWithTime('Déchargement sur la table à canne enregistré avec succès.', 3000);

      } else {
        _showMessageWithTime('Échec de l\'enregistrement du camion déchargé sur la table à canne.',5000);
      }

      
    } catch (err) {
      _showMessageWithTime('Erreur lors de l\'enregistrement du camion: $err',5000);
    }
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
