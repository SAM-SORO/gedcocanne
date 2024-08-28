import 'package:cocages/assets/imagesReferences.dart';
import 'package:flutter/material.dart';

class AppbarView extends StatelessWidget implements PreferredSizeWidget {
  //permet de savoir o,n est sur quel onglet Pour faire en sorte que le Switch n'apparaisse que lorsqu'on est sur l'onglet CoursCanne,
  final int currentIndex; 
  //permet de déterminer si le Switch est activé ou désactivé.
  final bool isSwitched;
  //fonction de type ValueChanged<bool>, c'est-à-dire une fonction qui prend une valeur de type bool en entrée et ne renvoie rien (void)
  final ValueChanged<bool> onSwitchChanged;

  const AppbarView({
    Key? key,
    required this.currentIndex, 
    required this.isSwitched,
    required this.onSwitchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      elevation: 0.0,
      title: Image.asset(
        Imagesreferences.logo,
        height: 200, // Ajustez la hauteur souhaitée
        width: 300,  // Ajustez la largeur souhaitée
        fit: BoxFit.contain, // Ajuste l'image pour s'adapter
      ),
      centerTitle: true,
      actions: <Widget>[

        if (currentIndex == 1)
          Padding(
            padding: const EdgeInsets.only(right: 40),
            child: Switch(
              value: isSwitched,
              onChanged: onSwitchChanged,
              activeTrackColor: Colors.lightGreenAccent,
              inactiveThumbColor: Colors.black,
              activeColor: const Color(0xFF019998),
              // activeColor: Color(0xFFFBA336),

            ),
          ),
      
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
