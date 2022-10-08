import 'package:appciona/models/turismo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantesHotelesController {
  Future<List<Turismo>> getServices(String tipoSelected) async {
    QuerySnapshot qs =
        await FirebaseFirestore.instance.collection('Turismo').get();
    List<DocumentSnapshot> documents = qs.docs;
    return documents
        .map(
          (e) => Turismo(
            correo: e['Correo'],
            direccion: e['Direccion'],
            imagen: e['Imagen'],
            telefono: e['Telefono'],
            tipo: e['Tipo'],
            titulo: e['Titulo'],
          ),
        )
        .where((element) => element.tipo == tipoSelected)
        .toList();
  }
}
