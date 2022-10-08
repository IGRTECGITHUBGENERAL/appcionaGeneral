import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../../../config/shared_preferences_helper.dart';

class ImagenesController {
  List<Album> albums = [];
  late QuerySnapshot qs;
  String idciudad="null";
  Future<int> getAlbumsSize() async {
    int result = 0;
    try {
      idciudad = await SharedPreferencesHelper.getUidCity() ?? "null";
      print("qsawait:$idciudad");
      qs = await FirebaseFirestore.instance.collection("Galerias").where("Ciudad",isEqualTo: "$idciudad").get();
      result = qs.docs.length;
    } catch (e) {
      debugPrint("Error al obtener la cantidad de los albums: $e");
    }
    return result;
  }




  Future getFirstAlbums() async {
    try {

      idciudad = await SharedPreferencesHelper.getUidCity() ?? "null";
      print("qsawait:$idciudad");
      qs = await FirebaseFirestore.instance.collection("Galerias").where("Ciudad",isEqualTo: "$idciudad").get();
      albums = qs.docs
          .map((e) => Album(
                id: e.id,
                titulo: e["Titulo"],
                portada: e["Portada"],
                imagenes: e["Imagenes"],
              ))
          .toList();
    } catch (e) {
      debugPrint("Error al obtener los primeros albumes: $e");
    }
  }

  Future getNextAlbums() async {
    try {
      var lastVisible = qs.docs[qs.docs.length - 1];
      idciudad = await SharedPreferencesHelper.getUidCity() ?? "null";
      qs = await FirebaseFirestore.instance
          .collection("Galerias")

          .startAfterDocument(lastVisible)
          .orderBy("Titulo")
          .limit(10)
          .get();
      List<Album> noticiasNext = qs.docs
          .map((e) => Album(
                id: e.id,
                titulo: e["Nombre"],
                portada: e["Portada"],
                imagenes: e["Imagenes"],
              ))
          .toList();
      albums.addAll(noticiasNext);
    } catch (e) {
      debugPrint('Error en la obtención de los siguientes albums $e');
    }
  }
}

class Album {
  String id;
  String titulo;
  String portada;
  List<dynamic> imagenes;

  Album({
    required this.id,
    required this.titulo,
    required this.portada,
    required this.imagenes,
  });
}
