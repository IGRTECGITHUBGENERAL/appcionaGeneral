import 'package:appciona/config/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUpController {
  List<DropdownMenuItem<String>> listCiudades = [];
  String? ciudadSelected = 'Mi ciudad';

  Future<void> getCiudades() async {
    try {
      QuerySnapshot qs = await FirebaseFirestore.instance
          .collection("Ciudades")
          .orderBy("Nombre")
          .get();
      List<Ciudad> ciudades = qs.docs
          .map((e) => Ciudad(
                nombre: e["Nombre"],
                uid: e.id,
              ))
          .toList();
      listCiudades.clear();
      listCiudades.add(
        DropdownMenuItem<String>(
          value: 'Mi ciudad',
          child: Text(
            'Mi ciudad',
            style: TextStyle(
              color: Palette.appcionaPrimaryColor.shade400,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      for (Ciudad element in ciudades) {
        listCiudades.add(
          DropdownMenuItem<String>(
            value: element.uid,
            child: Text(element.nombre!),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error en la obtención de ciudades: $e');
    }
  }
}

class Ciudad {
  final String? nombre;
  final String? uid;

  Ciudad({
    this.nombre,
    this.uid,
  });
}
