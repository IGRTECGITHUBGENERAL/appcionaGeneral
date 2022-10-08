import 'package:appciona/config/palette.dart';
import 'package:appciona/pages/turismo/lugares_interes/lugares_interes_page.dart';
import 'package:appciona/pages/turismo/qr/qr_page.dart';
import 'package:appciona/pages/turismo/restaurantes_hoteles/restaurantes_hoteles_page.dart';
import 'package:appciona/pages/turismo/senderismo/senderismo_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TurismoMainPage extends StatefulWidget {
  final Widget drawer;
  const TurismoMainPage({
    Key? key,
    required this.drawer,
  }) : super(key: key);

  @override
  State<TurismoMainPage> createState() => _TurismoMainPageState();
}

class _TurismoMainPageState extends State<TurismoMainPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: const Text(
          "Turismo",
          style: TextStyle(
            color: Palette.appcionaPrimaryColor,
          ),
        ),
        centerTitle: true,
        actions: [
          Image.asset(
            'assets/images/logo-green.png',
            fit: BoxFit.contain,
          )
        ],
        iconTheme: const IconThemeData(
          color: Palette.appcionaPrimaryColor,
        ),
      ),
      drawer: Drawer(
        child: widget.drawer,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 5.0,
            ),
            child: Center(
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceAround,
                    children: [
                      _turismoImageCard(
                        size,
                        'assets/icons/lugares_interes_colors.png',
                        'Lugares de interés',
                        const LugaresInteresPage(),
                      ),
                      _turismoImageCard(
                        size,
                        'assets/icons/senderismo_colors.png',
                        'Senderismo',
                        const SenderismoPage(
                          assetImagePlaceholder:
                              'assets/icons/senderismo_colors.png',
                        ),
                      ),
                      _turismoImageCard(
                        size,
                        'assets/icons/restaurant_colors.png',
                        'Restaurantes',
                        const RestaurantesHotelesPage(
                          tipo: 'Restaurante',
                        ),
                      ),
                      _turismoImageCard(
                        size,
                        'assets/icons/hotel_colors.png',
                        'Hoteles',
                        const RestaurantesHotelesPage(
                          tipo: 'Hotel',
                        ),
                      ),
                      _turismoImageCard(
                        size,
                        'assets/icons/qr_colors.png',
                        'Códigos QR',
                        const QRPage(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Card _turismoImageCard(
      Size size, String image, String title, Widget widgetPage) {
    return Card(
      elevation: 7,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => widgetPage),
        ),
        child: Container(
          width: size.width * 0.43,
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Image.asset(image),
              const Divider(),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
