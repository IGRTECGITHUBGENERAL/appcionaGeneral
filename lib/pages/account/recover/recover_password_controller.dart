import 'package:firebase_auth/firebase_auth.dart';

class RecoverPasswordController {
  Future<bool> recover(String email) async {
    bool result = false;
    try {
      FirebaseAuth fa = FirebaseAuth.instance;
      await fa
          .sendPasswordResetEmail(email: email)
          .then((value) => result = true)
          .catchError((value) => result = false);
      return result;
    } catch (e) {
      return result;
    }
  }
}
