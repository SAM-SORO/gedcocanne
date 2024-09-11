import 'package:flutter/material.dart';
//permet de deplacer mon floating action bottom
class DraggableFAB extends StatefulWidget {
  final VoidCallback onPressed;

  const DraggableFAB({super.key, required this.onPressed});

  @override
  DraggableFABState createState() => DraggableFABState();
}

class DraggableFABState extends State<DraggableFAB> {
  // Position temporaire jusqu'à ce que les dimensions de l'écran soient disponibles
  Offset _offset = const Offset(100, 100); 

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      setState(() {
        // Position initiale par défaut (bas droite, similaire à un FAB standard)
        _offset = Offset(size.width-100, size.height-200);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          left: _offset.dx,
          top: _offset.dy,
          child: Draggable(
            feedback: FloatingActionButton(
              onPressed: widget.onPressed,
              child: const Icon(Icons.add),
            ),
            childWhenDragging: Container(), // Widget visible pendant le déplacement
            onDraggableCanceled: (velocity, offset) {
              setState(() {
                // Limiter la position pour ne pas sortir de l'écran
                double newX = offset.dx.clamp(0.0, size.width - 90);
                double newY = offset.dy.clamp(0.0, size.height - 200);
                _offset = Offset(newX, newY);
              });
            },
            child: FloatingActionButton(
              onPressed: widget.onPressed,
              child: const Icon(Icons.add),
            ),
          ),
        ),
      ],
    );
  }
}


class CamionProvider with ChangeNotifier {
  List<Map<String, String>> _camionsAttente = [];

  List<Map<String, String>> get camionsAttente => _camionsAttente;

  void setCamionsAttente(List<Map<String, String>> camions) {
    _camionsAttente = camions;
    notifyListeners();
  }

  void addCamion(Map<String, String> camion) {
    _camionsAttente.add(camion);
    notifyListeners();
  }

  void removeCamion(Map<String, String> camion) {
    _camionsAttente.remove(camion);
    notifyListeners();
  }
}




  // void debugTasPoids(dynamic tasPoids) {
  //   print('Valeur de tasPoids: $tasPoids');
  //   print('Type de tasPoids: ${tasPoids.runtimeType}');
  // }

//   void _showErrorMessage(String message, Alignment alignment) {
//     toastification.show(
//       context: context,
//       alignment: alignment,  // Utilise l'alignement passé en paramètre
//       style: ToastificationStyle.flatColored,
//       type: ToastificationType.error,
//       title: Text(message, style: GoogleFonts.poppins(fontSize: 18)),
//       autoCloseDuration: const Duration(seconds: 4),
//       margin: const EdgeInsets.all(30),
//     );
// }


// void _showSuccessMessage(String message, Alignment alignment){
//   toastification.show(
//     context: context,
//     alignment: alignment,
//     style: ToastificationStyle.flatColored,
//     type: ToastificationType.success,
//     title: Text(message, style: GoogleFonts.poppins(fontSize: 18)),
//     autoCloseDuration: const Duration(seconds: 4),
//     margin: EdgeInsets.all(30),
//   );
// }


// void _afficherAlerte(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Erreur"),
//           content: Text(message),
//           actions: [
//             TextButton(
//               child: const Text("OK"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }



  // Fonction pour afficher les messages en precisant le temps que cela doit faire
  // void _showMessageWithTime(String message, int milliseconds) {
  //   if (!mounted) return; // Si le widget est démonté, on arrête la méthode
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       duration: Duration(milliseconds: milliseconds),
  //     ),
  //   );
  // }