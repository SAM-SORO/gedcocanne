import 'package:cocages/views/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //
    return OverlaySupport.global(child: MaterialApp(
      title: 'COCAGES',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.robotoTextTheme(), // Appliquer Roboto à tout le texte
        primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
          // backgroundColor: Colors.white,
          elevation: 4, // Ombre pour l'AppBar
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          
        ),
          useMaterial3: true,
      ),
      home: const Home(),
    ),
  );
    
     
  }
}

