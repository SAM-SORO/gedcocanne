import 'package:cocages/assets/imagesReferences.dart';
import 'package:cocages/auth/services/register_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toastification/toastification.dart';

class RegisterAgentScreen extends StatefulWidget {
  const RegisterAgentScreen({super.key});

  @override
  _RegisterAgentViewState createState() => _RegisterAgentViewState();
}

class _RegisterAgentViewState extends State<RegisterAgentScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Variable pour le champ de sélection
  String? _selectedRole = 'user';
  final List<String> _roles = ['admin', 'user']; // Options pour le Dropdown

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

  void _resetFields() {
    _loginController.clear();
    _passwordController.clear();
    setState(() {
      _selectedRole = 'user';
    });
  }


  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      // Récupère les informations d'enregistrement
      final matricule = _loginController.text.trim();
      final password = _passwordController.text;

      // Essaye de s'enregistrer avec les informations
      try {
        // enregistrer
        final isRegistered = await registerAgent(matricule, password, _selectedRole!);

        if (isRegistered) {
          toastification.show(
            context: context,
            alignment: Alignment.topRight,
            style: ToastificationStyle.flatColored,
            type: ToastificationType.success,
            title: Text('Enregistrement effectué avec succès!', style: GoogleFonts.poppins(fontSize: 18)),
            autoCloseDuration: const Duration(seconds: 4),
            margin: EdgeInsets.all(30),
          );
          _resetFields(); // Réinitialiser les champs après un enregistrement réussi
        } else {
          toastification.show(
            context: context,
            alignment: Alignment.topRight,
            style: ToastificationStyle.flatColored,
            type: ToastificationType.error,
            title: Text('Erreur lors de l\'enregistrement!', style: GoogleFonts.poppins(fontSize: 18)),
            autoCloseDuration: const Duration(seconds: 4),
            margin: EdgeInsets.all(30),
          );
        }
      } catch (e) {
        // Gère les erreurs potentielles
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur d\'enregistrement : $e')),
        );
      }
    }
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
                      margin: EdgeInsets.only(bottom: 20, left: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Color.fromARGB(96, 209, 189, 189)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, size: 20, color: Colors.blue),
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
                                "ENREGISTRER UN AGENT",
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
                              hintText: "Saisir le matricule de l'agent",
                              hintStyle: GoogleFonts.poppins(fontSize: 22),
                              labelStyle: GoogleFonts.poppins(fontSize: 22),
                              floatingLabelStyle: GoogleFonts.poppins(fontSize: 22),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer le matricule de l\'agent';
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
                                borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(color: Color.fromARGB(255, 180, 55, 202), width: 1.5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              labelText: 'Mot de passe',
                              fillColor: Colors.white,
                              hintText: "Saisir le mot de passe de l'agent",
                              prefixIcon: const Icon(Icons.lock_outline_rounded),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              hintStyle: GoogleFonts.poppins(fontSize: 22),
                              labelStyle: GoogleFonts.poppins(fontSize: 22),
                              floatingLabelStyle: GoogleFonts.poppins(fontSize: 22),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer un mot de passe';
                              }
                              return null;
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
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
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              labelText: 'Rôle',
                              labelStyle: GoogleFonts.poppins(fontSize: 22),
                              prefixIcon: const Icon(Icons.work_outline_rounded, color: Colors.black,),
                            ),
                            
                            value: _selectedRole,
                            items: _roles.map((role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role, style: GoogleFonts.poppins(fontSize: 22)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Veuillez sélectionner un rôle';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          height: 60,
                          width: double.infinity,
                          margin: const EdgeInsets.all(20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:  Color(0xFF9B5229),
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
                            child: Text('ENREGISTRER', style: GoogleFonts.poppins(color: Colors.white ,fontSize: 24, fontWeight: FontWeight.bold)),
                          ),
                        ),
                        SizedBox(height: 20),

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
    // Fonction pour afficher les messages d'erreur
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message),
      duration: const Duration(seconds: 10)), // Durée de 10 secondes
    );
    
  }

}


