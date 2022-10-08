import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MensajeriaController {
  late Stream messageStream = const Stream.empty();
  late String roomID = "", messageId = "", myUid = "", myName = "";
  User? userInfo = FirebaseAuth.instance.currentUser;

  Future<void> initChatRoom() async {
    if (userInfo != null) {
      myUid = userInfo!.uid;
      DocumentSnapshot qs = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userInfo!.uid)
          .get();
      myName = '${qs["nombre"]} ${qs["apellidos"]}';
      roomID = myUid;
    }
    try {
      messageStream = FirebaseFirestore.instance
          .collection("Mensajeria")
          .doc(roomID)
          .collection("Chats")
          .orderBy("ts", descending: true)
          .snapshots();
    } catch (e) {
      debugPrint('Error en la obtención de mensajes:\n$e');
    }
  }

  Future<void> sendMessage(String mensaje) async {
    if (messageId.isEmpty) {
      messageId = getRandomString(20);
    }
    DocumentReference docRef = FirebaseFirestore.instance
        .collection("Mensajeria")
        .doc(roomID)
        .collection("Chats")
        .doc(messageId);
    DateTime ts = DateTime.now();
    try {
      await docRef.set(
        {
          "Mensaje": mensaje,
          "Remitente": myName,
          "ts": ts,
        },
      );
      await updateLastMessageSend(
        {
          "UltimoMensaje": mensaje,
          "UltimoRemitente": myName,
          "ts": ts,
          "ChatDe": myName,
        },
      );
    } catch (e) {
      debugPrint('Error en la creacion de un mensaje nuevo:\n$e');
    }
    messageId = "";
  }

  Future updateLastMessageSend(Map<String, dynamic> data) async {
    try {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection("Mensajeria").doc(roomID);
      await docRef.set(data);
    } catch (e) {
      debugPrint("Error al actualizar el último mensaje");
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
