import 'package:Gedcocanne/assets/images_references.dart';
import 'package:Gedcocanne/auth/services/login_services.dart';
import 'package:Gedcocanne/services/api/auth_services.dart';
import 'package:Gedcocanne/views/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  // Booléen pour l'état de chargement
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }
  

  @override
  void dispose() {
    _passwordController.dispose();
    _loginController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator()) // Afficher le CircularProgressIndicator si en chargement
        :SafeArea(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 80,
                    width: 300,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Imagesreferences.logo),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 140),
                    
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
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
                        ),
                        Expanded(
                          child: Padding(
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
                        ),
                        Expanded(
                          child: Padding(
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
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - 80 - 200 - 70, maxWidth: 700,),
                    decoration: const BoxDecoration(boxShadow: [BoxShadow(color: Color.fromARGB(255, 252, 250, 250),blurRadius: 10,spreadRadius: 8, offset: Offset(5, 5),),],),
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
                                  "CONNEXION",
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
                              style: GoogleFonts.poppins(fontSize: 24),
                              controller: _loginController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Color(0xFF265175), width: 1.5),
                                  borderRadius: BorderRadius.circular(10),
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
                                fillColor: Colors.white,
                                prefixIcon: const Icon(Icons.person),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red, width: 1),
                                ),
                                labelText: 'Matricule',
                                hintText: "Saisir votre matricule",
                                hintStyle: GoogleFonts.poppins(fontSize: 22),
                                labelStyle: GoogleFonts.poppins(fontSize: 22),
                                floatingLabelStyle: GoogleFonts.poppins(fontSize: 22),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre matricule';
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextFormField(
                              controller: _passwordController,
                              style: GoogleFonts.poppins(fontSize: 24),
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
                                labelText: 'Mot de passe',
                                fillColor: Colors.white,
                                hintText: "Saisir votre mot de passe",
                                prefixIcon: const Icon(Icons.lock_outline_rounded),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                hintStyle: GoogleFonts.poppins(fontSize: 22),
                                labelStyle: GoogleFonts.poppins(fontSize: 22),
                                floatingLabelStyle: GoogleFonts.poppins(fontSize: 22),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Veuillez entrer votre mot de passe';
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
                                foregroundColor: Colors.white, 
                                backgroundColor: const Color(0xFF9B5229), // couleur du texte lorsqu'il est enfoncé
                                textStyle: GoogleFonts.poppins(fontSize: 20),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 148, 104, 38),
                                  width: 0.2,
                                ),
                                elevation: 10,
                                shadowColor: Colors.black.withOpacity(0.5), // couleur de l'ombre
                                padding: const EdgeInsets.symmetric(vertical: 15), // padding pour ajuster la taille du bouton
                              ).copyWith(
                                // Appliquer des styles spécifiques pour les états
                                backgroundColor: WidgetStateProperty.all(const Color(0xFF9B5229)),
                                elevation: WidgetStateProperty.resolveWith<double>((states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return 5; // Élévation lorsqu'enfoncé
                                  }
                                  return 10; // Élévation normale
                                }),
                                shadowColor: WidgetStateProperty.resolveWith<Color>((states) {
                                  if (states.contains(WidgetState.pressed)) {
                                    return Colors.black.withOpacity(0.3); // Ombre lorsqu'enfoncé
                                  }
                                  return Colors.black.withOpacity(0.5); // Ombre normale
                                }),
                              ),
                              onPressed: _submit,
                              child: Text(
                                'SE CONNECTER',
                                style: GoogleFonts.poppins(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                          
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

      setState(() {
        _isLoading = true;
      });
      
      // Récupère les informations d'identification
      final matricule = _loginController.text.trim();
      final password = _passwordController.text.trim();

      // Essaye de se connecter avec les informations d'identification en local
      try {

        final isAuthenticated = await authenticateUserInLocal(matricule, password);
        if (isAuthenticated == "true") {
          setState(() {
            _isLoading = false;
          });
          //_showMessageWithTime('Connexion réussie !', 4000);
          // Redirige vers la page principale ou autre après connexion réussie
          if(mounted){
            Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home(toggleTheme: (bool isDarkMode) {}, isDarkMode: false,)),
          );
          }
          

        }else if (isAuthenticated == "false"){

          String isAuthenticatedWithApi = await authenticateUserFromAPI(matricule, password);
          
          if (isAuthenticatedWithApi=="true" ){
            setState(() {
              _isLoading = false;
            });
            //_showMessageWithTime('Connexion réussie par api !', 4000);
            // Redirige vers la page principale après connexion réussie
            if(mounted){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Home(toggleTheme: (bool isDarkMode) { }, isDarkMode: false,)),
              );
            }
            
          }else if (isAuthenticatedWithApi=="false" ){
            setState(() {
              _isLoading = false;
            });
            //_showMessageWithTime('Matricule ou mot de passe incorrect', 4000);
            _showErrorMessage('Matricule ou mot de passe incorrect!');
          }else{
            setState(() {
              _isLoading = false;
            });
            _showErrorMessage('La connexion au serveur à echoué, connectez vous au reseau');

            //_showMessageWithTime('',4000);
          }
        }else{
          //_showMessageWithTime('L\'authentification à échoué',4000);
          _showErrorMessage('La connexion au serveur à echoué, connectez vous au reseau');

        }

      } catch (e) {
        // Gère les erreurs potentielles, par exemple, en cas de problème avec la base de données
        //print('Erreur de connexion : $e');
        //_showMessageWithTime('La connexion au serveur à echoué verifier votre connexion internet',4000);
        _showErrorMessage('La connexion au serveur à echoué verifier votre connexion internet');
      }
    }
  }

  // void _showSuccessMessage(String message){
  //   toastification.show(
  //     context: context,
  //     alignment: Alignment.topCenter,
  //     style: ToastificationStyle.flatColored,
  //     type: ToastificationType.success,
  //     title: Text(message, style: GoogleFonts.poppins(fontSize: 18)),
  //     autoCloseDuration: const Duration(seconds: 4),
  //     margin: const EdgeInsets.all(30),
  //   );
  // }


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

  // Fonction pour afficher les messages en precisant le temps que cela doit faire
  // void _showMessageWithTime(String message, int time) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text(message, style: GoogleFonts.poppins(fontSize: 19),), duration: Duration(milliseconds: time),),
  //   );
  // }

}




/*


 Container(
                          height: 60,
                          width: double.infinity,
                          margin: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF9B5229),
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
                            child: Text('SE CONNECTER', style: GoogleFonts.poppins(color: Colors.white ,fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                        ),

*/
