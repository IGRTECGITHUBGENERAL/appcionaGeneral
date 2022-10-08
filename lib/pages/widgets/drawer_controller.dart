import 'package:appciona/config/shared_preferences_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerWidgetController {
  String userName = "userName";
  String userEmail = "";

  Future<void> getUserData() async {
    userName = await SharedPreferencesHelper.getNameUser() ?? "Usuario";
    userEmail = await SharedPreferencesHelper.getEmailUser() ?? "";
  }


}
