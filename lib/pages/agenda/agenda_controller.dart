import 'package:appciona/models/agendas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AgendaController {
  late List<DateTime>? fechasConEventos = [];
  late QuerySnapshot qs;
  String idciudad="null";

  User? user = FirebaseAuth.instance.currentUser;
  List<String> meses = [
    "Enero",
    "Febrero",
    "Marzo",
    "Abril",
    "Mayo",
    "Junio",
    "Julio",
    "Agosto",
    "Septiembre",
    "Octubre",
    "Noviembre",
    "Diciembre"
  ];
  List<String> dias = [
    "Lunes",
    "Martes",
    "Miercoles",
    "Jueves",
    "Viernes",
    "Sábado",
    "Domingo"
  ];

  Future<List<DateTime>?> obtenerFechasConEventos() async {

    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Agendas")
        .where('usuarioUID', isEqualTo: user!.uid)
        .get();
    List<Agenda> agendas = qs.docs
        .map((e) => Agenda(
              uid: e.id,
              UsuarioId: e["usuarioUID"],
              Titulo: e["Titulo"],
              Descripcion: e["Descripcion"],
              Fecha: DateTime.parse(e['Fecha'].toDate().toString()),
            ))
        .toList();
    agendas = agendas
        .where((element) => element.Fecha.isAfter(DateTime.now()))
        .toList();
    for (var agenda in agendas) {
      fechasConEventos!.add(agenda.Fecha);
    }
    return fechasConEventos;
  }

  Future<List<Agenda>?> obtenerAgendas(DateTime fecha) async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Agendas")
        .where('usuarioUID', isEqualTo: user!.uid)
        .get();
    List<Agenda> agendas = [];
    agendas = qs.docs
        .map((e) => Agenda(
              uid: e.id,
              UsuarioId: e["usuarioUID"],
              Titulo: e["Titulo"],
              Descripcion: e["Descripcion"],
              Fecha: DateTime.parse(e['Fecha'].toDate().toString()),
            ))
        .toList();
    agendas = agendas
        .where((element) =>
            element.Fecha.isAfter(fecha) &&
            element.Fecha.isBefore(fecha.add(const Duration(days: 1))))
        .toList();
    return agendas;
  }

  Future<bool> eliminarEvento(String? uid) async {
    bool result = false;

    try {
      final db = FirebaseFirestore.instance.collection('Agendas').doc(uid);
      db
          .delete()
          .then((value) => result = true)
          .catchError((error) => result = false);
      return result;
    } catch (error) {
      return result;
    }
  }
}
