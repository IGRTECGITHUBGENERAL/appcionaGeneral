import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../config/shared_preferences_helper.dart';

class MediaController {
  late QuerySnapshot qs;
  String idciudad="null";

  Future<dynamic> getMedia(String category) async {
    idciudad = await SharedPreferencesHelper.getUidCity() ?? "null";
    print("qsawait:$idciudad");

    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection("Audiovisual")
        .where("Ciudad",isEqualTo: "$idciudad")

        .get();
    List<DocumentSnapshot> documents = qs.docs;
    documents =
        documents.where((element) => element["Tipo"] == category).toList();
    return documents;

  }
}
