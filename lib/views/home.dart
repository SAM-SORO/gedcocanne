import 'dart:async';
import 'package:Gedcocanne/services/api/cours_canne_services.dart';
import 'package:Gedcocanne/services/api/gespont_services.dart';
import 'package:Gedcocanne/services/api/table_canne_services.dart';
import 'package:Gedcocanne/services/api/update_poids_second_service.dart';
import 'package:Gedcocanne/services/isar/sync_agent_service.dart';
import 'package:flutter/material.dart';
import 'package:Gedcocanne/auth/services/login_services.dart';
import 'package:Gedcocanne/auth/views/login_screen.dart';
import 'package:Gedcocanne/views/appbar.dart';
import 'package:Gedcocanne/views/cours_canne.dart';
import 'package:Gedcocanne/views/sidebar.dart';
import 'package:Gedcocanne/views/table_canne.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:toastification/toastification.dart';

class Home extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode; // Passer l'état du mode sombre

  const Home({super.key, required this.toggleTheme, required this.isDarkMode});


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndexValue = 0;
  bool _isLoading = true;  //variable pour suivre s'il y'a chargement permettra d'utiliser un circular indicator lorsque les verifications seront en cours
  Timer? _timerSync; // minuter pour la frequence de synchronisation
  Timer? _timerUpdating; //minuteur pour la frequence de recuperation du poids de la deuxieme pese
  bool _isSwitched = false; // permet de suivre si le switch du filtre des camions en attente  a ete activer

  List<Map<String, String>> camionsAttente = [];


  //fonction permettant de gérer et de mettre à jour l'état du Switch.
  void _onSwitchChanged(bool value) {
    setState(() {
      _isSwitched = value;
    });

    //comment trouver l'instance d'une classe
    // Trouver l'instance de CoursCanne
    // final coursCanneState = context.findAncestorStateOfType<CoursCanneState>();
    // coursCanneState?.refreshCamionsAttente(); // Appel à la méthode publique
  }

  //late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription; // Abonnement mis à jour
  
  @override
  void initState() {
    super.initState();
    _checkUserConnection();
    _startSyncDonneeTimer();
    _startTimerUpdatedPoidsP2(); 
  
    //_checkNetworkConnection(); // Vérifie la connexion au réseau*
    // _listenConnectivity(); // Écouter les changements de réseau
  }

  @override
    void dispose() {
      _timerSync?.cancel(); // Annuler le Timer de synchronisation
      _timerUpdating?.cancel(); // Annuler le Timer de mise à jour de Poids P2
      //_connectivitySubscription.cancel(); // Annule l'abonnement au flux de connectivité
      super.dispose();
    }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );

    }else{
    
      // Obtenir la largeur de l'écran
      double screenWidth = MediaQuery.of(context).size.width;

      return Scaffold(
        appBar: AppbarView(
          currentIndex: _currentIndexValue, // Passer l'index actuel
          isSwitched: _isSwitched, // passer l'etat du switch
          onSwitchChanged: _onSwitchChanged, //onSwitchChanged: _onSwitchChanged permet à AppbarView de notifier Home lorsque l'état du Switch change, permettant ainsi à Home de mettre à jour son état interne et de réagir à ce changement.

        ),
        drawer: Sidebar(
          //fonction qui sera utiliser pour la synchro manuelle
          synchroniserManuellement: _synchroniserDonnee,
          //permettra de mettre a jour le timer de synchronisation
          resetSyncTimer: _resetSyncTimer,
          //permettra de reprendre  le timer de mise ajour du poidsP2
          cancelSyncAndUpdatingTimer: _cancelSyncAndUpdatingP2Timer,
          
          toggleTheme: widget.toggleTheme, // Passer la fonction toggleTheme permettant de changer le theme

          isDarkMode: widget.isDarkMode, // Passer l'état du mode sombre

          camionsAttente: camionsAttente,
          
        ),

        bottomNavigationBar: SalomonBottomBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndexValue,
          itemPadding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: screenWidth * 0.095, // Ajuster le padding horizontal à la moitié de l'écran
          ),
          onTap: (i) => setState(() => _currentIndexValue = i),
          items: [
            /// Home
            SalomonBottomBarItem(
              icon: const Icon(Icons.table_restaurant_outlined),
              title: const Text("Table à canne"),
              selectedColor: Colors.purple,
            ),

            /// Likes
            SalomonBottomBarItem(
              icon: const Icon(Icons.dashboard_customize_outlined),
              title: const Text("Cours à canne"),
              selectedColor: Colors.purple,
            ),
          ],
        ),
        body: 
        
        screenList[_currentIndexValue],
        // body: _currentIndexValue == 0 ? TableCanne() : CoursCanne(),
      );
  


    }
  }

  //Si vous voulez que les modifications dans TableCanne ou CoursCanne soient reflétées dans Home, la méthode la plus simple serait d'appeler une fonction de mise à jour dans le parent (par exemple via un Callback) pour notifier le parent que la liste a été modifiée.

  List<Widget> get screenList => [
    TableCanne(
      updateP2AndSyncAndResetTimer: _resetSyncAndUpdatingP2Timer,
      camionsAttente: camionsAttente,
      onCamionsAttenteUpdated: _updateCamionsAttente,  // Ajouter le callback pour mise à jour
      chargerCamionsAttente: _chargerCamionsAttente, // Passer la fonction ici
    ),
    
    CoursCanne(
      updateP2AndSyncAndResetTimer: _resetSyncAndUpdatingP2Timer,
      isSwitched: _isSwitched,
      camionsAttente: camionsAttente,
      onCamionsAttenteUpdated: _onCamionSupprime,  // Ajouter le callback pour mise à jour
      chargerCamionsAttente: _chargerCamionsAttente, // Passer la fonction ici
      
    ),
  ];


  // Fonction pour mettre à jour la liste des camions
  void _updateCamionsAttente(List<Map<String, String>> updatedCamions) {
    setState(() {
      camionsAttente = updatedCamions;
    });
  }

  //contrairement a l'onglet table canne. la page decharger a une liste local. et la liste qu'il partage avec l'onglet Table canne au vue du filtre qui peut se faire laba.  donc lorsqu'on doit enleve un element dans la liste local il faut le supprimer dans la liste du parent pour ne pas qu'il persiste. on ne peut pas supprimer comme avec le cas des caions en attente
  void _onCamionSupprime(Map<String, String> camionSupprime) {
    setState(() {
      // Filtrer la liste des camions en attente du parent pour supprimer celui qui a été affecté
      camionsAttente.removeWhere((camion) => camion['VE_CODE'] == camionSupprime['VE_CODE']);
    });
  }

  
  //Lancer le timer pour la synchronisation des donnee chaque 30minutes
  void _startSyncDonneeTimer() {
    _timerSync = Timer.periodic(const Duration(minutes: 30), (timer) async {
      if (await thereAreSynchronisationForAgent()){
        _synchroniserDonnee();
      }
    });
  }


  
  //Lancer le timer de recuperation du poids de la deuxime pesee des camions decharger chaque 
  Future<void> _startTimerUpdatedPoidsP2() async {
    _timerUpdating = Timer.periodic(const Duration(minutes: 12), (timer) async {
      if (await thereAreSynchronisationOfP2FromAPI()){
        _updtatePoidsP2();
      }
    });
  }


  // Fonction pour récupérer les camions en attente depuis l'API
  Future<void> _chargerCamionsAttente() async {
    try {
      // Appeler la fonction avec un timeout
      final List<Map<String, String>> camionsAttenteData = await getCamionAttenteFromAPI();
      List<Map<String, dynamic>> camionsCoursData = await getCamionDechargerCoursFromAPI();
      List<Map<String, dynamic>> camionsTableData = await getCamionDechargerTableFromAPI();

      // Vérifier si les données sont nulles ou vides
      if (camionsAttenteData.isEmpty) {
        camionsAttente = []; // Assurez-vous que camionsAttente est une liste vide si aucune donnée n'est récupérée
      } else {
        camionsAttente = camionsAttenteData;
      }

      if (camionsCoursData.isEmpty) {
        camionsCoursData = [];
      }

      if (camionsTableData.isEmpty) {
        camionsTableData = [];
      }

      // Combiner les camions déchargés de DechargerCours et DechargerTable
      final List<Map<String, dynamic>> allCamionsDecharger = [
        ...camionsTableData,
        ...camionsCoursData,
      ];

      // Filtrer les camions en attente pour exclure ceux déjà déchargés
      final filteredCamionsAttente = camionsAttente.where((camionAttente) {
        DateTime dateHeureP1Attente = DateTime.parse(camionAttente['DATEHEUREP1']!);

        return !allCamionsDecharger.any((camion) {
          DateTime dateHeureP1Decharge = DateTime.parse(camion['dateHeureP1']); // Assurez-vous que les clés et formats sont corrects

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
      // Vérifier si le widget est monté avant d'appeler setState
      if (mounted) {
        setState(() {   
          _isLoading = false; // Mise à jour de l'état de chargement  
        });  
        _showErorMessage("Le chargement des camions en attente a échoué. Connectez vous au réseau.");
      }
    }
  }




  // Vérifie l'état de la connexion réseau et affiche un message à l'utilisateur si l'appareil est hors ligne
  // Future<void> _checkNetworkConnection() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());
  //   if (connectivityResult == ConnectivityResult.none) {
  //     _showErorMessage("Vous êtes hors ligne. Connectez vous au réseau.");
  //   }
  // }

 // Écouter les changements de réseau
  // void _listenConnectivity() {
  //   _connectivitySubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
  //     if (results.contains(ConnectivityResult.none)) {
  //       _showErorMessage("Vous êtes hors ligne. Connectez vous au réseau.");
  //     }
  //   });
  // }

  

  //Methode qui annulera le timer de synchronisation actuel et le redémarrera (sera utile lors de la synchronisation manuelle dans la sidebar)
  void _resetSyncTimer() {
    _timerSync?.cancel(); // Annuler le timer actuel
    _startSyncDonneeTimer(); // Redémarrer le timer de synchronisation
  }

  //me perlettra d'annuler le timer(minuteur) de synchronisation et de mise a jour du poidsP2 periodique après deconnexion dans la sidebar
  void _cancelSyncAndUpdatingP2Timer(){
    _timerSync?.cancel(); // arrete le timer de synvhronisation
    _timerUpdating?.cancel(); //arrete le timer de recuperation du poids de la deuxime pesee des camions decharger

  }

  //me permettra de redemarer les timer de recuperation du poids P2 et de synchronisation apres mise a jour manuel (pul to refresh)
  void _resetSyncAndUpdatingP2Timer(){
    _timerUpdating?.cancel(); //arrete le minuteur de mise a jour du poids P2
    _timerSync?.cancel(); //arrete le minuteur de synchronisation
    _updtatePoidsP2();  // mettre a jour le poids P2
    _synchroniserDonnee(); //synchroniser les donnee
    _startTimerUpdatedPoidsP2(); // redemarer le minuteur de mise a jour du poids P2
    _startSyncDonneeTimer(); // Redémarrer le timer de synchronisation des donnee
  }


  //verifier si l'utilisateur a une session ou pas
  Future<void> _checkUserConnection() async {
    
    setState(() {
      _isLoading = false;
    });

    bool connected = await userIsInSession();
    
    if (!connected) {
      // Annuler les timers de synchronisation avant de rediriger l'utilisateur vers la page de connexion
      _timerSync?.cancel();
      _timerUpdating?.cancel();

      // Vérifier si le widget est encore monté avant de naviguer
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } else {
      _chargerCamionsAttente();
      // Si le widget est encore monté, mettre à jour l'état
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  // la mise a jour du poids P2 correspond a la recuperation du poids de la deuxieme pesee des camions decharger
  Future<void> _updtatePoidsP2() async {
    if (await thereAreSynchronisationOfP2FromAPI()){
      String updated = await updatePoidsP2ForCamionsWithP2Null(); 
      if (updated == "error"){    
        _showErorMessage("La Mise a jour du poids P2 camions déchargés à echoué . Veuillez vérifier également votre connexion internet.");
      } 
    }
    
  }

  //faire la synchronisation des donnee( revient a les envoyer sur le serveur distant)
  Future<void> _synchroniserDonnee() async {
    bool allSuccess = true; //permet de voir si la snchronisation c'est fait sans echecs pour un cas. par defaut on le suppose
    bool thereAreSynchronisation = false; //permet de savoir s'il y'a eu une synchronisation ou pas on va avec le faite que no

    //avec cette maniere il executera toute les synchronisation qu'il y'a a faire, si un echoue on continue mais a la fin on precise que la synchronisation n'a pas ete fait cela peut etre du a un qui ne fonctionne pas ou que les serveurs sont ete
    try {
      if (await thereAreSynchronisationForAgent()) {
        //print('synchro pour agent');
        allSuccess &= await synchroniserAgent();
        thereAreSynchronisation = true;
      }

      if (!allSuccess) {
        // s'il y'a eu un souci de synchro
        _showErorMessage("La synchronisation a échoué. Connectez vous au réseau.");
      }else if(thereAreSynchronisation){
        //s'il y'a eu synchronisation
        _showSuccessMessage('Snchronisation effectuée avec succès');
      }
      
    } catch (e) {
      _showErorMessage("La synchronisation a échoué. Connectez vous au réseau $e.");
    }
  }


  
  void _showErorMessage(String message){
    toastification.show(
      context: context,
      alignment: Alignment.topRight,
      style: ToastificationStyle.flatColored,
      type: ToastificationType.error,
      title: Text(message, style: GoogleFonts.poppins(fontSize: 18)),
      autoCloseDuration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(30),
    );
  }

   void _showSuccessMessage(String message){
    toastification.show(
      context: context,
      alignment: Alignment.topRight,
      style: ToastificationStyle.flatColored,
      type: ToastificationType.success,
      title: Text(message, style: GoogleFonts.poppins(fontSize: 18)),
      autoCloseDuration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(30),
    );
  }

  


  // Fonction pour afficher les messages en precisant le temps que cela doit faire
  // void _showE(String message, int time) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message, style: GoogleFonts.poppins(fontSize: 19),), duration: Duration(milliseconds: time),),
  //   );
  // }





      //l'ancien bottomNavigationBar
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndexValue,
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.black,
      //   selectedFontSize: 22,
      //   unselectedFontSize: 18,
      //   iconSize: 30,
      //   elevation: 80,
      //   backgroundColor: Colors.white,
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.table_restaurant_outlined), label: 'Table à Canne'),
      //     BottomNavigationBarItem(icon: Icon(Icons.dashboard_customize_outlined), label: 'Cours à Canne'),
      //   ],
      //   onTap: (index) => setState(() {
      //     _currentIndexValue = index;
      //   }),
      // ),
  

}















