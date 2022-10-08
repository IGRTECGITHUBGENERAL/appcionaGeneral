import 'package:appciona/models/senderismo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SenderismoController {
  List<Senderismo> itemSenderismo = [];
  late QuerySnapshot qs;

  Future<int> getItemsSize() async {
    int lenght = 0;
    try {
      qs = await FirebaseFirestore.instance.collection("Senderismo").get();
      lenght = qs.docs.length;
    } catch (e) {
      debugPrint("Error al obtener la cantidad de items para senderismo: $e");
    }
    return lenght;
  }

  Future<void> getFirstItems() async {
    try {
      qs = await FirebaseFirestore.instance
          .collection("Senderismo")
          .limit(10)
          .get();
      itemSenderismo = qs.docs
          .map((e) => Senderismo(
                uid: e.id,
                titulo: e["Titulo"],
                distancia: e["Distancia"],
                desnivel: e["Desnivel"],
                descripcion: e["Descripcion"],
                mapa: e["Mapa"],
                imagenes: e["Imagenes"],
              ))
          .toList();
    } catch (e) {
      debugPrint("Error al obtener los primeros items de senderismo: $e");
    }
  }

  Future<void> getNextItems() async {
    var lastVisible = qs.docs[qs.docs.length - 1];

    qs = await FirebaseFirestore.instance
        .collection("Senderismo")
        .startAfterDocument(lastVisible)
        .limit(10)
        .get();
    List<Senderismo> itemsNext = qs.docs
        .map(
          (e) => Senderismo(
            uid: e.id,
            titulo: e["Titulo"],
            distancia: e["Distancia"],
            desnivel: e["Desnivel"],
            descripcion: e["Descripcion"],
            mapa: e["Mapa"],
            imagenes: e["Imagenes"],
          ),
        )
        .toList();
    itemSenderismo.addAll(itemsNext);
  }

  Future<Senderismo> getSingleItem(String uid) async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection("Senderismo")
        .doc(uid)
        .get();
    Senderismo item = Senderismo(
      uid: uid,
      titulo: ds["Titulo"],
      distancia: ds["Distancia"],
      desnivel: ds["Desnivel"],
      descripcion: ds["Descripcion"],
      mapa: ds["Mapa"],
      imagenes: ds["Imagenes"],
    );
    return item;
  }
}
