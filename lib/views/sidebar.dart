import 'package:cocages/assets/imagesReferences.dart';
import 'package:cocages/auth/services/login_services.dart';
import 'package:cocages/auth/views/change_password_screen.dart';
import 'package:cocages/auth/views/login_screen.dart';
import 'package:cocages/auth/views/register_screen.dart';
import 'package:cocages/services/sync_agent_service.dart';
import 'package:cocages/services/sync_decharg_cours_service.dart';
import 'package:cocages/services/sync_decharg_table_service.dart';
import 'package:cocages/services/sync_table_canne_service.dart';
import 'package:cocages/views/bilan_cours.dart';
import 'package:cocages/views/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class Sidebar extends StatefulWidget {
  final Function synchroniserManuellement;
  final Function resetSyncTimer;
  final Function cancelSyncAndUpdatingTimer;

  const Sidebar({
    super.key,
    required this.synchroniserManuellement,
    required this.resetSyncTimer,
    required this.cancelSyncAndUpdatingTimer,
  });

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool isAdminUser = false; // permettra de savoir si c'est un admin ou pas afin de lui permettre d'enregistrer un agent
  bool syncNeeded = false; // Variable pour suivre s'il y'a des donnee qui necessite une synchronisation
  bool isInSync = false; //variable pour suivre si la synchonisation se fait ou pas  pour faire sortir le circular indicator 
  

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
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const Home()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.aspect_ratio_rounded, size: 22),
                title: Text(
                  'Stock Cours',
                  style: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
                ),
                onTap: () {
                  Navigator.pop(context); // Ferme le Drawer
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BilanCourScreen()));
                },
              ),
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

              if (isAdminUser)
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
    bool dechargerCoursSyncNeeded = await thereAreSynchronisationForDechargerCours();
    bool dechargerTableSyncNeeded = await thereAreSynchronisationForDechargerTable();
    bool tableCanneSyncNeeded = await thereAreSynchronisationForTableCanne();

    // Si une quelconque synchronisation est nécessaire, `syncNeeded` devient vrai
    setState(() {
      syncNeeded = agentSyncNeeded || dechargerCoursSyncNeeded || dechargerTableSyncNeeded || tableCanneSyncNeeded;
    });
  }


  // Fonction pour afficher les messages en precisant le temps que cela doit faire prerndre
  void _showMessageWithTime(String message, int time) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: GoogleFonts.poppins(fontSize: 19),), duration: Duration(milliseconds: time),),
    );
  }

   // Fonction pour gérer la synchronisation manuelle
  Future<void> _synchronisationManuel() async {
    setState(() {
      isInSync = true;
    });

    // Appelle la fonction de synchronisation fournie par le parent
    await widget.synchroniserManuellement();
    widget.resetSyncTimer(); // Réinitialise le timer de synchronisation automatique

    toastification.show(
      context: context,
      alignment: Alignment.topRight,
      style: ToastificationStyle.flatColored,
      type: ToastificationType.success,
      title: Text('Synchronisation effectuée avec succès', style: GoogleFonts.poppins(fontSize: 18)),
      autoCloseDuration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(30),
      
    );
            

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



/*

///tester un a un les fonctions des synchronisation pour voir si elle fonctionne
Future<void> checkSyncStatus() async {
  bool syncStatus = await thereAreSynchronisationForAgent(); // Attendre la fin de l'opération asynchrone
  bool syncStatus = await thereAreSynchronisationForDechargerCours(); // Attendre la fin de l'opération asynchrone
  bool syncStatus = await thereAreSynchronisationForDechargerTable(); // Attendre la fin de l'opération asynchrone
  bool syncStatus = await thereAreSynchronisationForTableCanne(); // Attendre la fin de l'opération asynchrone
  setState(() {
    syncNeeded = syncStatus; // Mettre à jour l'état une fois l'opération terminée
  });
}


Future<void> _synchroniserDonnee() async {
  
  setState(() {
    isInSync = true; // Mettre à jour l'état pour indiquer qu'il n'y a plus de mise à jour
  });

  try {
    // la logique de synchronisation ici

    bool success = await synchroniserAgent(); // cette fonction selon vos besoins

    bool success = await synchroniserDonneeDechargerCours();

    bool success =await synchroniserDonneeDechargerTable();

    bool success = await synchroniserDonneeTableCanne();
    
    if(success){
      // Si la synchronisation réussit
      setState(() {
        syncNeeded = false; // Mettre à jour l'état pour indiquer qu'il n'y a plus de mise à jour
        isInSync = false;
      });

      _showMessageWithTime('"Synchronisation effectuée avec succès"', 4000);
    }else{
      _showMessageWithTime(
        "Une erreur s'est produite lors de la synchronisation des données. Il se peut que le serveur soit éteint ou qu'il y ait un problème de connexion.",
        6000,
      );
    }

  } catch (e) {

    Navigator.pop(context);
    // En cas d'erreur lors de la synchronisation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("La synchronisation n'a pu être effectuée, vérifire si le serveur est éteint")),
    );

  }
  
}



  //envoyer un message
  Future<void> _synchroniserDonnee() async {
    setState(() {
      isInSync = true; // Indiquer que la synchronisation est en cours
    });

    bool allSyncsSuccessful = true;

    try {
      // Synchronisation des agents
      try {
        bool agentSuccess = await synchroniserAgent();
        if (!agentSuccess) {
          allSyncsSuccessful = false;
          _showMessageWithTime("Échec de la synchronisation des agents.", 4000);
        }
      } catch (e) {
        allSyncsSuccessful = false;
        _showMessageWithTime("Erreur lors de la synchronisation des agents : $e", 4000);
      }

      // Synchronisation des DechargerCours
      try {
        bool dechargerCoursSuccess = await synchroniserDonneeDechargerCours();
        if (!dechargerCoursSuccess) {
          allSyncsSuccessful = false;
          _showMessageWithTime("Échec de la synchronisation des Decharger Cours.", 4000);
        }
      } catch (e) {
        allSyncsSuccessful = false;
        _showMessageWithTime("Erreur lors de la synchronisation des Decharger Cours : $e", 4000);
      }

      // Synchronisation des DechargerTable
      try {
        bool dechargerTableSuccess = await synchroniserDonneeDechargerTable();
        if (!dechargerTableSuccess) {
          allSyncsSuccessful = false;
          _showMessageWithTime("Échec de la synchronisation des Decharger Table.", 4000);
        }
      } catch (e) {
        allSyncsSuccessful = false;
        _showMessageWithTime("Erreur lors de la synchronisation des Decharger Table : $e", 4000);
      }

      // Synchronisation des TableCanne
      try {
        bool tableCanneSuccess = await synchroniserDonneeTableCanne();
        if (!tableCanneSuccess) {
          allSyncsSuccessful = false;
          _showMessageWithTime("Échec de la synchronisation des Table Canne.", 4000);
        }
      } catch (e) {
        allSyncsSuccessful = false;
        _showMessageWithTime("Erreur lors de la synchronisation des Table Canne : $e", 4000);
      }

      if (allSyncsSuccessful) {
        setState(() {
          syncNeeded = false;
          isInSync = false;
        });
        _showMessageWithTime("Synchronisation effectuée avec succès", 4000);
      } else {
        setState(() {
          isInSync = false;
        });
        _showMessageWithTime("Une ou plusieurs synchronisations ont échoué.", 6000);
      }
    } catch (e) {
      setState(() {
        isInSync = false;
      });
      _showMessageWithTime("Erreur générale lors de la synchronisation : $e", 6000);
    }
}

//faire la synchronisation pour tous meme si un echoue, a la fin on dira qu'il y'a eu erreur pour certains
Future<void> _synchroniserDonnee() async {
  setState(() {
    isInSync = true;
  });

  bool success = true;

  try {
    if (await thereAreSynchronisationForAgent()) {
      success &= await synchroniserAgent();
    }

    if (await thereAreSynchronisationForDechargerCours()) {
      success &= await synchroniserDonneeDechargerCours();
    }

    if (await thereAreSynchronisationForDechargerTable()) {
      success &= await synchroniserDonneeDechargerTable();
    }

    if (await thereAreSynchronisationForTableCanne()) {
      success &= await synchroniserDonneeTableCanne();
    }

    if (success) {
      setState(() {
        syncNeeded = false;
        isInSync = false;
      });
      _showMessageWithTime('Synchronisation effectuée avec succès', 4000);
    } else {
      _showMessageWithTime("Une erreur s'est produite lors de la synchronisation des données.", 6000);
    }
  } catch (e) {
    setState(() {
      isInSync = false;
    });
    _showMessageWithTime("Erreur de synchronisation. Veuillez vérifier votre connexion.", 6000);
  }
}
Future<void> _synchroniserDonnee() async {
  setState(() {
    isInSync = true;
  });

  bool success = true;

  try {
    if (await thereAreSynchronisationForAgent()) {
      success &= await synchroniserAgent();
    }

    if (await thereAreSynchronisationForDechargerCours()) {
      success &= await synchroniserDonneeDechargerCours();
    }

    if (await thereAreSynchronisationForDechargerTable()) {
      success &= await synchroniserDonneeDechargerTable();
    }

    if (await thereAreSynchronisationForTableCanne()) {
      success &= await synchroniserDonneeTableCanne();
    }

    if (success) {
      setState(() {
        syncNeeded = false;
        isInSync = false;
      });
      _showMessageWithTime('Synchronisation effectuée avec succès', 4000);
    } else {
      _showMessageWithTime("Une erreur s'est produite lors de la synchronisation des données.", 6000);
    }
  } catch (e) {
    setState(() {
      isInSync = false;
    });
    _showMessageWithTime("Erreur de synchronisation. Veuillez vérifier votre connexion.", 6000);
  }
}



*/