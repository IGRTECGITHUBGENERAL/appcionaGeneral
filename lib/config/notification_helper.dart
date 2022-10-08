import 'dart:async';
import 'package:appciona/config/shared_preferences_helper.dart';
import 'package:appciona/main.dart';
import 'package:appciona/models/mensajeria.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static late StreamSubscription messagignSubscription;
  static ValueNotifier notification = ValueNotifier<bool>(false);

  static Future addMessagingListener() async {
    try {
      String userUid = await SharedPreferencesHelper.getUidUser() ?? "";
      if (userUid.isEmpty) {
        User? user = FirebaseAuth.instance.currentUser;
        userUid = user!.uid;
      }
      Mensajeria mensajeria = Mensajeria();
      messagignSubscription = FirebaseFirestore.instance
          .collection("Mensajeria")
          .doc(userUid)
          .snapshots()
          .listen((DocumentSnapshot event) async {
        if (event.exists) {
          mensajeria.ultimoMensaje = event["UltimoMensaje"];
          mensajeria.ultimoRemitente = event["UltimoRemitente"];
          mensajeria.ts = DateTime.parse(event["ts"].toDate().toString());
          String userName = await SharedPreferencesHelper.getNameUser() ?? "";
          if (userName.isEmpty) {
            DocumentSnapshot qs = await FirebaseFirestore.instance
                .collection('Users')
                .doc(userUid)
                .get();
            userName = '${qs["nombre"]} ${qs["apellidos"]}';
          }
          if (mensajeria.ultimoRemitente != userName) {
            showNotification(mensajeria.ultimoMensaje.toString(), 0);
            notification = ValueNotifier<bool>(true);
          } else {
            notification = ValueNotifier<bool>(false);
          }
        }
      });
    } catch (e) {
      notification = ValueNotifier<bool>(false);
      debugPrint("Error al crear el listener: $e");
    }
  }

  static Future cancelListener() async {
    messagignSubscription.cancel();
  }

  static Future showNotification(String text, int id) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'appciona_channel',
      'Appciona',
      channelDescription: 'Appciona channel for notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flip.show(
      id,
      'Appciona',
      text,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }
}
