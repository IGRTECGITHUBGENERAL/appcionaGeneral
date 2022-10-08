import 'dart:io';
import 'package:appciona/config/notification_helper.dart';
import 'package:appciona/config/palette.dart';
import 'package:appciona/pages/mensajeria/mensajeria_page.dart';
import 'package:appciona/pages/servicios/servicios.dart';
import 'package:appciona/pages/widgets/alerts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../firebaseServices/google_sign_in.dart';
import '../../models/ciudades.dart';
import '../agenda/agenda_page.dart';
import '../encuestas/encuestas_page.dart';
import '../account/login/login_page.dart';
import 'drawer_controller.dart';
import 'package:appciona/config/shared_preferences_helper.dart';
List<Ciudades> ciudades = [];
List<String> ciudadesNombres=[];
var currentSelectedValue;

class DrawerWidget extends StatefulWidget {
  final int userState;
  const DrawerWidget({Key? key, required this.userState}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final DrawerWidgetController _controller = DrawerWidgetController();
  String numberMensajeria = "";

  Future<void> getWhatsappNumber() async {
    QuerySnapshot ds =
        await FirebaseFirestore.instance.collection("WhatSapp").get();
    numberMensajeria = ds.docs.first["Telefono"];
    setState(() {});
  }

  Future<void> loadUserData() async {
    await _controller.getUserData();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getListCitysUID();
    getWhatsappNumber();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: widget.userState == 1
            ? _columnLogued()
            : widget.userState == 2
                ? _columnWaiting()
                : _columnNotLogued(),
      ),
    );
  }

  Column _columnWaiting() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: Image.asset('assets/images/logo-green.png'),
        ),
        const ListTile(
          leading: CircularProgressIndicator(),
          title: LinearProgressIndicator(),
          onTap: null,
        ),
        const ListTile(
          leading: CircularProgressIndicator(),
          title: LinearProgressIndicator(),
          onTap: null,
        ),
        const ListTile(
          leading: CircularProgressIndicator(),
          title: LinearProgressIndicator(),
          onTap: null,
        ),
      ],
    );
  }

  Column _columnNotLogued() {
    var posicion="hola";
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: Image.asset('assets/images/logo-green.png'),
        ),
        ListTile(
          leading: const Icon(
            Icons.login,
            color: Palette.appcionaSecondaryColor,
          ),
          title: const Text("Iniciar sesión"),
          onTap: () => Navigator.of(context, rootNavigator: true)
              .push(
                CupertinoPageRoute(
                  builder:
                  (context) => const LoginPage(),

                ),
              )
              .then(
                (value) => setState(() { SharedPreferencesHelper.deleteEncuestaData(); } ),

              ),
        ),
        ListTile(
          leading: const Icon(
            Icons.login,
            color: Palette.appcionaSecondaryColor,
          ),
          title: const Text("Encuestas"),
          onTap: () => Navigator.of(context, rootNavigator: true)
              .push(
            CupertinoPageRoute(
              builder: (context) => const EncuestasPage(),
            ),
          )
              .then(
                (value) => setState(() {}),
          ),
        ),
        typeFieldWidget()



        /*ListTile(
          leading: const Icon(
            Icons.logout,
            color: Palette.appcionaSecondaryColor,
          ),
          title: const Text("añadir bartolome"),
          onTap: () async {
            try {
              final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
              bool result = await provider.googleLogout();
              if (!result) {
                await FirebaseAuth.instance.signOut();

                SharedPreferencesHelper.addCityData("vkS40AndXTPEJ2p3MFlt");
                //   SharedPreferencesHelper.deleteUserData();
              }
            } on ProviderNotFoundException catch (e) {
              await FirebaseAuth.instance.signOut();
              // SharedPreferencesHelper.deleteUserData();
              SharedPreferencesHelper.addCityData("vkS40AndXTPEJ2p3MFlt");
            } catch (e) {
              Alerts.messageBoxMessage(context, '¡UPS!',
                  'Parece que hubo un error al cerrar sesión.');
            }
            setState(() {});
          },
        ),*/
      ],
    );
  }

  Column _columnLogued() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: Image.asset('assets/images/logo-green.png'),
        ),
        FutureBuilder(
          future: loadUserData(),
          builder: (context, data) {
            return ListTile(
              title: Text(
                "¡Bienvenido ${_controller.userName}!",
                textAlign: TextAlign.center,
              ),
              subtitle: Text(
                _controller.userEmail,
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            CupertinoIcons.mail,
            color: Palette.appcionaPrimaryColor,
          ),
          title: const Text("Mensajería"),
          trailing: ValueListenableBuilder(
            valueListenable: NotificationHelper.notification,
            builder: (context, value, widget) {
              if (value as bool) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 3.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    color: Palette.appcionaPrimaryColor.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    CupertinoIcons.bell,
                    color: Palette.appcionaPrimaryColor.shade500,
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          onTap: () => {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const MensajeriaPage(),
              ),
            )
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.book,
            color: Palette.appcionaPrimaryColor,
          ),
          title: const Text("Agenda"),
          onTap: () => {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const AgendaPage(),
              ),
            )
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.question_answer_outlined,
            color: Palette.appcionaPrimaryColor,
          ),
          title: const Text("Encuestas"),
          onTap: () => {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const EncuestasPage(),
              ),
            )
          },
        ),
        ListTile(
          leading: const ImageIcon(
            AssetImage('assets/icons/servicios_mono.png'),
            color: Palette.appcionaPrimaryColor,
          ),
          title: const Text("Servicios"),
          onTap: () => {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const ServiciosPage(),
              ),
            )
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.logout,
            color: Palette.appcionaSecondaryColor,
          ),
          title: const Text("Cerrar sesión"),
          onTap: () async {
            try {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              bool result = await provider.googleLogout();
              if (!result) {
                await FirebaseAuth.instance.signOut();

               SharedPreferencesHelper.deleteUserData();

              }
            } on ProviderNotFoundException catch (e) {
              await FirebaseAuth.instance.signOut();
              SharedPreferencesHelper.deleteUserData();
             } catch (e) {
              Alerts.messageBoxMessage(context, '¡UPS!',
                  'Parece que hubo un error al cerrar sesión.');
            }
            setState(() {});
          },
        ),

      ],
    );
  }
  void openwhatsapp() async {
    if (numberMensajeria.isNotEmpty) {
      var whatsapp = "https://wa.me/+$numberMensajeria";
      var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp";
      var whatappURLIos = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
      if (Platform.isIOS) {
        if (!await launchUrl(Uri.parse(whatappURLIos))) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Necesitas instalar WhatsApp."),
            ),
          );
        }
        /*
      if (await canLaunch(whatappURLIos)) {
        await launch(whatappURLIos, forceSafariVC: false);
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Necesitas instalar WhatsApp."),
          ),
        );
      }*/
      } else {
        if (!await launchUrl(Uri.parse(whatsappURlAndroid))) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Necesitas instalar WhatsApp."),
            ),
          );
        }
      }
    }
  }
  Future<void> getListCitysUID()  async {

    late QuerySnapshot qs;
    qs = await FirebaseFirestore.instance
        .collection("Ciudades")
        .get();
    ciudades = qs.docs
        .map((e) => Ciudades(
      UID: e.id,
      Nombre: e["Nombre"],
    ))
        .toList();
    print("ciudades");
    print(ciudades.length);
    print(ciudades[0].Nombre);
    ciudadesNombres=[];
    ciudades.forEach((data) => ciudadesNombres.add(data.Nombre.toString()));
   setState(() {
     ciudades;
     ciudadesNombres;
   });
  }
  Widget typeFieldWidget() {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: FormField<String>(
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text("Selecciona una ciudad"),
                value: currentSelectedValue,
                isDense: true,
                onChanged: (newValue) {
                  setState(() {

                    try {
                      print(currentSelectedValue);
                     // currentSelectedValue = newValue;
                      int select = ciudadesNombres.indexOf(newValue!);
                      print(ciudades[select].UID);
                      SharedPreferencesHelper.addCityData(ciudades[select].UID.toString());
                      SharedPreferencesHelper.addEncuestaData("Global");
                      ciudadesNombres=[];
                      Navigator.pop(context);
                    }catch(excep){
                      ciudadesNombres=[];
                    }

                  });
                  ciudadesNombres=[];
                },
                items: ciudadesNombres.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );

  }

}
