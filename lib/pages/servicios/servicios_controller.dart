import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:appciona/models/servicio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart' as p;

class ServiciosController {
  final String fileUploadFailed = "File_Upload_Failed";
  final String getPositionFailed = "Get_Position_Failed";
  final String docServiceCreationFailed = "Doc_Service_Creation_Failed";
  final String docCreationSuccessful = "Doc_Creation_Successful";

  Servicio sugg = Servicio();
  late File? file;
  bool enviarCoord = false;

  Future<String> createDoc() async {
    try {
      if (file != null) {
        sugg.archivo = await uploadFile(file, sugg.titulo!);
        if (sugg.archivo!.startsWith(fileUploadFailed)) return fileUploadFailed;
      } else {
        sugg.archivo = "";
      }
      if (enviarCoord) {
        try {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          sugg.ubicacion = {
            'Latitud': position.latitude.toString(),
            'Longitud': position.longitude.toString(),
          };
        } catch (e) {
          return getPositionFailed;
        }
      } else {
        sugg.ubicacion = {
          'Latitud': '',
          'Longitud': '',
        };
      }
      CollectionReference alimentoReference =
          FirebaseFirestore.instance.collection('Servicios');
      String uidGen = getRandomString(20);
      await alimentoReference.doc(uidGen).set({
        'Titulo': sugg.titulo,
        'Descripcion': sugg.descripcion,
        'Archivo': sugg.archivo,
        'Revisado': sugg.revisado,
        'Ubicacion': jsonDecode(jsonEncode(sugg.ubicacion)),
        'uid': uidGen,
      });
      return docCreationSuccessful;
    } catch (e) {
      return docServiceCreationFailed;
    }
  }

  Future<String> uploadFile(File? archivo, String nombre) async {
    try {
      var file = File(archivo!.path);
      final Reference storageReference =
          FirebaseStorage.instance.ref().child("Servicios");
      TaskSnapshot taskSnapshot = await storageReference
          .child("$nombre${getRandomString(10)}.${p.extension(archivo.path)}")
          .putFile(file);

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (ex) {
      debugPrint('Error al subir archivo: $ex');
      return fileUploadFailed;
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
