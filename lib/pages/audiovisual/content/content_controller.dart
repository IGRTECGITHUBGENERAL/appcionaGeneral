import 'package:cloud_firestore/cloud_firestore.dart';

class ContentController {
  late QuerySnapshot qs;
  String idciudad="null";
  Future<dynamic> getSinglePodcast(String id) async {

    DocumentSnapshot qs = await FirebaseFirestore.instance
        .collection('Audiovisual')
        .doc(id)
        .get();
    return qs;
  }
}
