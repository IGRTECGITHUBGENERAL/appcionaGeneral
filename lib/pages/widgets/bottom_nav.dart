import 'package:flutter/material.dart';

class BNavigator extends StatefulWidget {
  final Function currentIndex;
  const BNavigator({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State createState() => _BNavigatorState();
}

class _BNavigatorState extends State<BNavigator> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: index,
      onTap: (int i) {
        setState(() {
          index = i;
          widget.currentIndex(index);
        });
      },
      unselectedItemColor: Colors.black,
      selectedItemColor: const Color(0XFF00BAEF),
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12,
      unselectedFontSize: 10,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home_outlined,
          ),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.play_circle_outline,
          ),
          label: 'Audiovisual',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.list_outlined,
          ),
          label: 'Servicios',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.map_outlined,
          ),
          label: 'Turismo',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.mail_outline,
          ),
          label: 'Mensajería',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person_outline,
          ),
          label: 'Perfil',
        ),
      ],
    );
  }
}
