import 'dart:convert';
import 'package:Gedcocanne/assets/images_references.dart';
import 'package:Gedcocanne/auth/services/login_services.dart';
import 'package:Gedcocanne/auth/services/register_services.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:toastification/toastification.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordViewState createState() => ChangePasswordViewState();
}

class ChangePasswordViewState extends State<ChangePasswordScreen> {
  // Votre code pour l'état de la classe ici


  final _formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _matriculeController = TextEditingController();
  String? matricule;
  String? oldPasswordError; // Pour gérer l'affichage de l'erreur

  @override
  void initState() {
    super.initState();
     _loadUserMatricule();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _matriculeController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icône de retour
                    Container(
                      margin: const EdgeInsets.only(bottom: 20, left: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(96, 209, 189, 189)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF265175)),
                        onPressed: () {
                          Navigator.pop(context); // Revenir à la page précédente
                        },
                      ),
                    ),
                    // Espacement flexible pour pousser l'image vers le centre
                    const Spacer(),
                    // Image centrée
                    Container(
                      margin: const  EdgeInsets.only(right: 40),
                      height: 100, // Ajustez la hauteur selon vos besoins
                      width: 220,
                      child: Image.asset(
                        Imagesreferences.logo,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Espacement flexible pour maintenir l'image centrée
                    const Spacer(),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: Transform.rotate(
                                angle: 0.1, // Ajuster l'angle en radians
                                child: Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(Imagesreferences.sucreRoux),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(Imagesreferences.princesseTatie),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 200,
                              width: 200,
                              child: Transform.rotate(
                                angle: -0.1, // Ajuster l'angle en radians
                                child: Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(Imagesreferences.sucreBlanc),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 80 - 200 - 75,
                    maxWidth: 700, 
                  ),
                  decoration: const BoxDecoration(
                    boxShadow: [BoxShadow(color: Color.fromARGB(255, 252, 250, 250), blurRadius: 10, spreadRadius: 8, offset: Offset(5, 5))],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 2,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "CHANGER DE MOT DE PASSE",
                                style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 2,
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextFormField(
                            controller: _matriculeController,
                            readOnly: true,
                            style: GoogleFonts.poppins(fontSize: 24),
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xFF265175), width: 1.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xFF9B5229), width: 1.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(Icons.person),
                              labelText: 'Matricule',
                              hintStyle: GoogleFonts.poppins(fontSize: 22),
                              labelStyle: GoogleFonts.poppins(fontSize: 22),
                              floatingLabelStyle: GoogleFonts.poppins(fontSize: 22),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextFormField(
                            controller: _oldPasswordController,
                            style: GoogleFonts.poppins(fontSize: 24),
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: 'Ancien mot de passe',
                              //hintText: "Saisir le mot d",
                              hintStyle: GoogleFonts.poppins(fontSize: 22),
                              labelStyle: GoogleFonts.poppins(fontSize: 22),
                              floatingLabelStyle: GoogleFonts.poppins(fontSize: 22),
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              filled: true,
                              fillColor: Colors.white,
                              errorText: oldPasswordError, 
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 1.5),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFF265175), width: 1.5),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xFF9B5229), width: 1.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xFF265175), width: 1.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir votre ancien mot de passe';
                              }
                              return null;
                            },
                          ),
                        ),


                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: TextFormField(
                            controller: _newPasswordController,
                            style: GoogleFonts.poppins(fontSize: 22),
                            obscureText: true,
                            decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                color: Color(0xFF265175), width: 1.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red, width: 1),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color(0xFF265175), width: 1.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                color: Color(0xFF9B5229), width: 1.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              labelText: 'Nouveau mot de passe',
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              fillColor: Colors.white,
                              //hintText: "Saisir le mot de passe de l'agent",
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              hintStyle: GoogleFonts.poppins(fontSize: 22),
                              labelStyle: GoogleFonts.poppins(fontSize: 22),
                              floatingLabelStyle: GoogleFonts.poppins(fontSize: 22),
                            ),
                            
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez saisir votre nouveau mot de passe';
                              }
                              return null;
                            },
                          ),
                        ),
                        
                        Container(
                          height: 60,
                          width: double.infinity,
                          margin: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  const Color(0xFF9B5229),
                              textStyle: GoogleFonts.poppins(fontSize: 20,),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              side: const BorderSide(
                                color: Color.fromARGB(255, 148, 104, 38),
                                width: 0.2,
                              ),
                              shadowColor: Colors.white,
                              elevation: 10,
                            ),
                            onPressed: _submit,
                            child: Text('Modifier', style: GoogleFonts.poppins(color: Colors.white ,fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 30),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final oldPassword = _oldPasswordController.text;
      final newPassword = _newPasswordController.text;

      // Vérifier si l'ancien mot de passe est correct
      final currentPassword = await getCurrentUserPassword();
      if (hashPassword(oldPassword) == currentPassword) {
        // Si l'ancien mot de passe est correct, réinitialiser l'erreur
        setState(() {
          oldPasswordError = null;
        });

        //Mettre à jour le mot de passe
        final success = await updatePassword(matricule!, newPassword);
        if (success) {
          _showSuccessMessage('Mot de passe changé avec succès !');
          _resetFields();
        } else {
          _showErrorMessage('Erreur lors du changement de mot de passe', Colors.black);
        }
      } else {
        // Si l'ancien mot de passe est incorrect, afficher l'erreur
        setState(() {
          oldPasswordError = 'Mot de passe incorrect';
        });
      }
    }
  }
 

  //effacer  les donnee saisi
  void _resetFields() {
    _oldPasswordController.clear();
    _newPasswordController.clear();
  }

  Future<void> _loadUserMatricule() async {
    final userMatricule = await getCurrentUserMatricule();
    setState(() {
      matricule = userMatricule;
      _matriculeController.text = userMatricule ?? '';
    });
  }


  // Fonction pour afficher les messages d'erreur
  // void _showMessage(String message) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message),
  //     duration: const Duration(seconds: 10)), // Durée de 10 secondes
  //   );
    
  // }

  
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


  
  void _showSuccessMessage(String message){
    toastification.show(
      context: context,
      alignment: Alignment.topCenter,
      style: ToastificationStyle.flatColored,
      type: ToastificationType.success,
      title: Text(message, style: GoogleFonts.poppins(fontSize: 18)),
      autoCloseDuration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(30),
    );
  }



  // Fonction pour hacher le mot de passe avec SHA-256
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }
}


