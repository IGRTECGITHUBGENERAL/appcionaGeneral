import 'package:appciona/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static const String _nameKey = "nameUser";
  static const String _emailKey = "emailUser";
  static const String _uidUser = "uidUser";
  static const String _uidCity = "uidUser";
  static const String _uidEncuesta = "uidEncuesta";

  static Future<SharedPreferences> _prefs() async =>
      await SharedPreferences.getInstance();

  static Future<String?> getNameUser() async =>
      await _prefs().then((value) => value.getString(_nameKey));

  static Future<String?> getEmailUser() async =>
      await _prefs().then((value) => value.getString(_emailKey));

  static Future<String?> getUidUser() async =>
      await _prefs().then((value) => value.getString(_uidUser));

  static Future<String?> getUidCity() async =>
      await _prefs().then((value) => value.getString(_uidCity));

  static Future<String?> getUidEncuesta() async =>
      await _prefs().then((value) => value.getString(_uidEncuesta));

  static Future<bool> createUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      DocumentSnapshot ds = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user!.uid)
          .get();
      UsersModel userData = UsersModel(
        user.uid,
        ds["nombre"],
        ds["apellidos"],
        ds["correo"],
        ds["dni"],
        "",
        ds["ciudad"],
        ds["rol"],
        ds["telefono"],
      );
      SharedPreferences pref = await _prefs();
      pref.setString(_nameKey, '${userData.nombre} ${userData.apellidos}');
      pref.setString(_emailKey, userData.correo.toString());
      pref.setString(_uidUser, userData.uid.toString());
      pref.setString(_uidCity, userData.ciudad.toString());
    } catch (e) {
      debugPrint("Error al crear datos del usuario: $e");
    }
    return true;
  }

  static Future addCityData(String cityUID) async {
    SharedPreferences pref = await _prefs();
    pref.setString(_uidCity, cityUID);

  }
  static Future addEncuestaData(String encuestaUID) async {
    SharedPreferences pref = await _prefs();
    pref.setString(_uidEncuesta, encuestaUID);

  }

  static Future deleteUserData() async {
    SharedPreferences pref = await _prefs();
    pref.remove(_nameKey);
    pref.remove(_emailKey);
    pref.remove(_uidUser);
    pref.remove(_uidCity);
    pref.remove(_uidEncuesta);
    pref.remove(_uidEncuesta);
    pref.clear();
  }
  static Future deleteEncuestaData() async {
    SharedPreferences pref1 = await _prefs();

    pref1.remove(_uidEncuesta);
    pref1.clear();
  }
}
