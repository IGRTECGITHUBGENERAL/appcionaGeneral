import 'package:appciona/config/shared_preferences_helper.dart';
import 'package:appciona/firebaseServices/auth_services.dart';

class LoginController {
  Future<bool> login(String email, String pass) async {
    bool result = false;
    AuthServices as = AuthServices();
    await as.singIn(email, pass).then((uc) {
      if (uc != null) {
        SharedPreferencesHelper.createUserData();
        result = true;
      } else {
        result = false;
      }
    });
    return result;
  }
}
