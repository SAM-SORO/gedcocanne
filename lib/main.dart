import 'package:Gedcocanne/views/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleTheme(bool isDarkMode) {
    setState(() {
      _isDarkMode = isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Gedcocanne',
        debugShowCheckedModeBanner: false,
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(),
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            elevation: 4,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
          ),
          useMaterial3: true,
        ),
        // darkTheme: ThemeData.dark(),
       darkTheme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(
            ThemeData.dark().textTheme.apply(bodyColor: Colors.white, displayColor: Colors.white),
          ),
          appBarTheme: const AppBarTheme(
            elevation: 4,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
          ),
          scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(surface: Colors.black),
        ),
        home: Home(toggleTheme: toggleTheme, isDarkMode: _isDarkMode),
      ),
    );
  }
}