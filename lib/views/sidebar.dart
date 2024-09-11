import 'package:Gedcocanne/assets/images_references.dart';
import 'package:Gedcocanne/auth/services/login_services.dart';
import 'package:Gedcocanne/auth/views/change_password_screen.dart';
import 'package:Gedcocanne/auth/views/login_screen.dart';
import 'package:Gedcocanne/auth/views/register_screen.dart';
import 'package:Gedcocanne/services/isar/sync_agent_service.dart';
import 'package:Gedcocanne/views/bilan_cours.dart';
import 'package:Gedcocanne/views/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class Sidebar extends StatefulWidget {
  final Function synchroniserManuellement;
  final Function resetSyncTimer;
  final Function cancelSyncAndUpdatingTimer;
  final Function(bool) toggleTheme; // Ajout de ce paramètre
  final bool isDarkMode;  // Ajouter cette propriété
  final List<Map<String, String>> camionsAttente;

  const Sidebar({
    super.key,
    required this.synchroniserManuellement,
    required this.resetSyncTimer,
    required this.cancelSyncAndUpdatingTimer,
    required this.toggleTheme, // Ajout de ce paramètre
    required this.isDarkMode,  // Recevoir cette propriété
    required this.camionsAttente,

  });



  @override
  SidebarState createState() => SidebarState();
}

class SidebarState extends State<Sidebar> {
  bool isAdminUser = false; // permettra de savoir si c'est un admin ou pas afin de lui permettre d'enregistrer un agent
  bool syncNeeded = false; // Variable pour suivre s'il y'a des donnee qui necessite une synchronisation
  bool isInSync = false; //variable pour suivre si la synchonisation se fait ou pas  pour faire sortir le circular indicator 
  bool isDarkMode = false;  // Ajout de la propriété pour le mode sombre
  

  @override
  void initState() {
    super.initState();
    checkAdminStatus();
    checkSyncStatus(); // Vérifire le statut de synchronisation lors de l'initialisation
    
  }
  

  @override
  Widget build(BuildContext context) {
    //  final screenHeight = MediaQuery.of(context).size.height; //prend la hauteur de l'ecran

    // Retirer le focus des champs de texte avant de construire la sidebar
    FocusScope.of(context).unfocus();
 
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 100, // Hauteur typique d'une AppBar
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white, // Couleur de fond du DrawerHeader
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5), // Couleur de l'ombre avec opacité
                  spreadRadius: -3, // Rayon d'expansion de l'ombre
                  blurRadius: 15, // Rayon de flou de l'ombre
                  offset: const Offset(0, 6), // Décalage de l'ombre (x, y)
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.of(context).pop(); // Fermer le tiroir
                  },
                ),
                const SizedBox(width: 2), // Espacement entre l'icône et l'image
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: Image.asset(
                      Imagesreferences.logo,
                      height: 60, // Ajuste la hauteur pour éviter les erreurs
                      fit: BoxFit.cover, // Ajuste l'image pour s'adapter
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.home, size: 22),
                  title: Text(
                    'Menu Principale',
                    style: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Ferme le Drawer
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Home(
                          toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode // Passe la méthode toggleTheme
                        ),
                      ),
                    );
                  },
                  
                ),

                const SizedBox(height: 10),

                ListTile(
                  leading: const Icon(Icons.aspect_ratio_rounded, size: 22),
                  title: Text(
                    'Rapport Canne Broye',
                    style: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Ferme le Drawer
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BilanCourScreen(camionsAttente: widget.camionsAttente) ));
                  },
                ),

                const SizedBox(height: 10),

                ListTile(
                  leading: Icon(Icons.sync, color: syncNeeded ? const  Color(0xFFFFB300) : Colors.grey, size: 22),
                  title: Text(
                    'Synchroniser',
                    style: GoogleFonts.poppins(color: syncNeeded ? Colors.black : const Color.fromARGB(123, 158, 158, 158), fontSize: 18),
                  ),
                  trailing: isInSync ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(),) : null, // Indicateur de chargement pour la synchronisation

                  onTap: syncNeeded ? (){
                    _synchronisationManuel();
                  } : null,
                ),

                if (isAdminUser)...[

                  const SizedBox(height: 10),

                  ListTile(
                    leading: const Icon(Icons.person_add, color: Color(0xFFFFB300), size: 22),
                    title: Text(
                      'Enregistrer un agent',
                      style: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
                    ),
                    onTap: () {
                      Navigator.pop(context); // Ferme le Drawer
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterAgentScreen()));
                    },
                  ),
                
                ],

                const SizedBox(height: 10),
                  
                ListTile(
                  leading: const Icon(Icons.person_add, color: Color(0xFFFFB300), size: 22),
                  title: Text(
                    'Changer mot de passe',
                    style: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Ferme le Drawer
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
                  },
                ),

                const SizedBox(height: 20),

                SwitchListTile(
                  secondary: const Icon(Icons.dark_mode),
                  title: Text(
                    'Mode Sombre',
                    style: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
                  ),
                  value: widget.isDarkMode,  // Utiliser l'état reçu
                  onChanged: (value) {
                    widget.toggleTheme(value); // Appeler la fonction pour changer le thème
                  },
                ),

                // ListTile(
                //     leading: const Icon(Icons.settings),
                //     title: Text("Thème sombre", style: GoogleFonts.roboto()),
                //     trailing: Switch(
                //       value: widget.isDarkMode,
                //       onChanged: (bool value) {
                //         widget.toggleTheme(value);
                //       },
                //     ),
                // ),


              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0), // Padding pour éloigner du bord inférieur
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 40),
              leading: const Icon(Icons.logout, color: Colors.purple),
              title: Text(
                'Se déconnecter',
                style: GoogleFonts.poppins(color: Colors.blue, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context); // Ferme le Drawer
                _destroySession(); // Détruire la session
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
                //_showMessageWithTime("Déconnexion", 2000);
                toastification.show(
                  alignment: Alignment.topRight,
                  style: ToastificationStyle.flatColored,
                  type: ToastificationType.success,
                  context: context, // optional if you use ToastificationWrapper
                  title: Text('Deconnexion!', style: GoogleFonts.poppins(fontSize: 18)),
                  autoCloseDuration: const Duration(seconds:  4),
                );
              },
            ),
          ),
        ],
      ),
    );

  }

  Future<void> checkAdminStatus() async {
    bool userStatusIsAdmin = await isAdmin(); //renvoi true si c'est un admin et false si c'estpas le cas
    setState(() {
      isAdminUser = userStatusIsAdmin; // Mettre à jour l'état une fois l'opération terminée
    });
  }

  //permet de verifier s'il y'a une synchronisation a faire afin d'activer l'option de synchronisation ou pas
  Future<void> checkSyncStatus() async {
    bool agentSyncNeeded = await thereAreSynchronisationForAgent();

    // Si une quelconque synchronisation est nécessaire, `syncNeeded` devient vrai
    setState(() {
      syncNeeded = agentSyncNeeded;
    });
  }


  // Fonction pour afficher les messages en precisant le temps que cela doit faire prerndre
  // void _showMessageWithTime(String message, int time) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message, style: GoogleFonts.poppins(fontSize: 19),), duration: Duration(milliseconds: time),),
  //   );
  // }

   // Fonction pour gérer la synchronisation manuelle
  Future<void> _synchronisationManuel() async {
    setState(() {
      isInSync = true;
    });

    // Appelle la fonction de synchronisation fournie par le parent
    await widget.synchroniserManuellement();
    widget.resetSyncTimer(); // Réinitialise le timer de synchronisation automatique

    // toastification.show(
    //   context: context,
    //   alignment: Alignment.topRight,
    //   style: ToastificationStyle.flatColored,
    //   type: ToastificationType.success,
    //   title: Text('Synchronisation effectuée avec succès', style: GoogleFonts.poppins(fontSize: 18)),
    //   autoCloseDuration: const Duration(seconds: 3),
    //   margin: const EdgeInsets.all(30),
      
    // );
            

    setState(() {
      isInSync = false;  //arrete de tourner
      syncNeeded = false; // les synchronisations on ete faite on peut grisé maintenant l'option
    });


  }

  //fonction qui gere la deconnexion
  Future<void> _destroySession() async {
    
    await widget.cancelSyncAndUpdatingTimer(); //annuler le timer de synchronisation
  
    await logout();
  }


}

