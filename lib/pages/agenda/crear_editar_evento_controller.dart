import 'package:appciona/models/agendas.dart';
import 'package:appciona/pages/agenda/agenda_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CrearEditarEventoController {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime24Hour = TimeOfDay.now();
  late DateTime fechaHoraFirebase;
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? timePicked = await showTimePicker(
      context: context,
      initialTime: selectedTime24Hour,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (timePicked != null && timePicked != selectedTime24Hour) {
      selectedTime24Hour = timePicked;
    }
  }

  void save(String titulo, String descripcion, BuildContext context,
      bool edicion, String? uid) async {
    fechaHoraFirebase = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime24Hour.hour, selectedTime24Hour.minute);
    if (edicion) {
      if (await actulizarEvento(titulo, descripcion, fechaHoraFirebase, uid)) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AgendaPage(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0XFF00BAEF),
            elevation: 5,
            margin: const EdgeInsets.all(10),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: const Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: " Evento modificado con éxito",
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        showAlertDialog(context, "Hubo un problema", "Intente nuevamente.");
      }
    } else {
      if (await crearEvento(titulo, descripcion, fechaHoraFirebase)) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AgendaPage(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0XFF00BAEF),
            elevation: 5,
            margin: const EdgeInsets.all(10),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: const Text.rich(
              TextSpan(
                children: [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                  TextSpan(
                    text: " Evento añadido con éxito",
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        showAlertDialog(context, "Hubo un problema", "Intente nuevamente.");
      }
    }
  }

  Future<bool> crearEvento(
      String titulo, String descripcion, DateTime fechaHoraFirebase) async {
    bool result = false;

    try {
      CollectionReference encuestasRef =
          FirebaseFirestore.instance.collection('Agendas');
      await encuestasRef
          .doc()
          .set({
            'Titulo': titulo,
            'Descripcion': descripcion,
            'Fecha': fechaHoraFirebase,
            'usuarioUID': user!.uid,
          })
          .then((value) => result = true)
          .catchError((error) => result = false);
      return result;
    } catch (e) {
      return result;
    }
  }

  showAlertDialog(BuildContext context, String titulo, String contenido) {
    Widget okButton = TextButton(
      child: const Text("OK"),
      onPressed: () {},
    );

    AlertDialog alert = AlertDialog(
      title: Text(titulo),
      content: Text(contenido),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<Agenda?> obtenerAgendasUsuario() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Agendas")
        .where('usuarioUID', isEqualTo: user!.uid)
        .get();
    List<Agenda> agendas = qs.docs
        .map((e) => Agenda(
              UsuarioId: e["usuarioUID"],
              Titulo: e["Titulo"],
              Descripcion: e["Descripcion"],
              Fecha: DateTime.parse(e['Fecha'].toDate().toString()),
            ))
        .toList();
    agendas = agendas
        .where((element) => element.Fecha.isAfter(DateTime.now()))
        .toList();
  }

  Future<bool> actulizarEvento(String titulo, String descripcion,
      DateTime fechaHoraFirebase, String? uid) async {
    bool result = false;
    final db = FirebaseFirestore.instance.collection('Agendas').doc(uid);
    try {
      await db
          .update({
            'Titulo': titulo,
            'Descripcion': descripcion,
            'Fecha': fechaHoraFirebase
          })
          .then((value) => result = true)
          .catchError((error) => result = false);
      return result;
    } catch (e) {
      return result;
    }
  }
}
