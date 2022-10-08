import 'dart:math';

import 'package:appciona/models/encuestas.dart';
import 'package:appciona/models/respuestas_encuestas.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../config/shared_preferences_helper.dart';
import '../../models/pregunta.dart';

class EncuestasController {
  final User? user = FirebaseAuth.instance.currentUser;
  late QuerySnapshot qs;
  String idciudad="null";
  String ValidaEncuesta="null";

  Future<bool> sendAnswers(RespuestasEncuestas respuestas) async {
    try {
      CollectionReference respuestasEncuestasReference =
          FirebaseFirestore.instance.collection('RespuestasEncuestas');
      await respuestasEncuestasReference.doc().set({
        'uidUsuario': respuestas.uidUsuario,
        'uidEncuesta': respuestas.uidEncuesta,
        'Revisado': respuestas.revisado,
        'Respuestas': respuestas.respuestas,
      });
      return true;
    } catch (e) {
      debugPrint("Error al enviar las respuestas del usuario: $e");
      return false;
    }
  }

  List<Pregunta> getPreguntas(Map<String, dynamic>? formulario) {
    List<Pregunta> preguntas = [];
    formulario!.forEach((key, value) {
      preguntas.add(Pregunta(
        pregunta: value["Pregunta"],
        respuestas: value["Respuestas"],
        tipoPregunta: value["TipoPregunta"],
      ));
    });
    return preguntas;
  }

  Future<Encuestas?> getSingleForm(String uid) async {
    try {

      DocumentSnapshot qs = await FirebaseFirestore.instance
          .collection('Encuestas')
          .doc(uid)
          .get();
      Encuestas encuesta = Encuestas(
        uid: qs.id,
        titulo: qs["Titulo"],
        descripcion: qs["Descripcion"],
        imagen: qs["Imagen"],
        formulario: qs["Formulario"],
        Ciudad: qs["Ciudad"],
      );
      return encuesta;
    } catch (e) {
      return null;
    }
  }

  Future<List<Encuestas>> getForms() async {
    List<Encuestas> encuestas = [];
    try {
      idciudad = await SharedPreferencesHelper.getUidCity() ?? "null";
      ValidaEncuesta = await SharedPreferencesHelper.getUidEncuesta() ?? "null";
      print("qsawait:$idciudad");
      if(ValidaEncuesta=="null") {

        // await FirebaseFirestore.instance.collection("Encuestas").where("Ciudad",isEqualTo: "$idciudad").get();
        // qs = await FirebaseFirestore.instance.collection("Encuestas").get();
        qs = await FirebaseFirestore.instance.collection("Encuestas").where("Ciudad",isEqualTo: "$idciudad").get();
      }
      else if(ValidaEncuesta!="null") {

      // await FirebaseFirestore.instance.collection("Encuestas").where("Ciudad",isEqualTo: "$idciudad").get();
       // qs = await FirebaseFirestore.instance.collection("Encuestas").get();
        qs = await FirebaseFirestore.instance.collection("Encuestas").where("Ciudad",isEqualTo: "bSi74gAMRLVklvs8C8t9").get();
      }
      else{


       // await FirebaseFirestore.instance.collection("Encuestas").where("Ciudad",isEqualTo: "$idciudad").get();
        qs = await FirebaseFirestore.instance.collection("Encuestas").where("Ciudad",isEqualTo: "$idciudad").get();
      }



      encuestas = qs.docs
          .map(
            (e) => Encuestas(
              uid: e.id,
              titulo: e["Titulo"],
              descripcion: e["Descripcion"],
              imagen: e["Imagen"],
            ),
          )
          .toList();
      QuerySnapshot qsUser = await FirebaseFirestore.instance
          .collection('RespuestasEncuestas')
          .where("uidUsuario", isEqualTo: user!.uid)
          .get();
      if (qsUser.docs.isNotEmpty) {
        List<String> uidEncuestas = [];
        for (DocumentSnapshot doc in qsUser.docs) {
          uidEncuestas.add(doc["uidEncuesta"]);
        }
        for (String uid in uidEncuestas) {
          encuestas.removeWhere((element) => element.uid == uid);
        }
      }
      return encuestas;
    } catch (e) {
      debugPrint("Error al obtener las encuestas: $e");
      return encuestas;
    }
  }

  String getRandomString(int length) {
    const characters = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz';
    Random random = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => characters.codeUnitAt(
          random.nextInt(characters.length),
        ),
      ),
    );
  }
}
