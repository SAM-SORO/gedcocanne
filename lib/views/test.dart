// GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2, // Nombre de colonnes
//           crossAxisSpacing: 10, // Espacement entre les colonnes
//           mainAxisSpacing: 10, // Espacement entre les lignes
//           childAspectRatio: 1, // Ratio de l'aspect de chaque élément
//         ),
//         itemCount: 20,
//         itemBuilder: (context, index) {
//           return Container(
//             margin: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.blue[100 * (index % 9 + 1)],
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Center(
//               child: Text(
//                 'Item $index',
//                 style: const TextStyle(fontSize: 18, color: Colors.black),
//               ),
//             ),
//           );
//         },
// )


// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Chauffeurs et Camions',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomePage(),
//     );
//   }
// }

// class HomePage extends StatelessWidget {
//   // Exemple de données pour les chauffeurs et les camions
//   final List<String> chauffeurs = List.generate(50, (index) => 'Chauffeur $index');
//   final List<String> camions = List.generate(50, (index) => 'Camion $index');

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chauffeurs et Camions'),
//       ),
//       body: Row(
//         children: <Widget>[
//           // Colonne pour la liste des chauffeurs
//           Expanded(
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     'Liste des Chauffeurs',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: chauffeurs.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(chauffeurs[index]),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Colonne pour la liste des camions
//           Expanded(
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Text(
//                     'Liste des Camions',
//                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: camions.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(camions[index]),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



