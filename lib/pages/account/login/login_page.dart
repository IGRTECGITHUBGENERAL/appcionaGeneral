import 'package:appciona/config/palette.dart';
import 'package:appciona/pages/account/recover/recover_password_page.dart';
import 'package:appciona/pages/account/signup/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../widgets/alerts.dart';
import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _controller = LoginController();
  late bool loginIng = false;
  final GlobalKey<FormState> _keyForm = GlobalKey();

  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  void login() async {
    if (_keyForm.currentState!.validate()) {
      setState(() {
        loginIng = true;
      });
      if (await _controller.login(emailCtrl.text, passCtrl.text)) {
        Navigator.pop(context);
      } else {
        Alerts.messageBoxMessage(context, 'Verifica tus datos',
            'Los datos que ingresaste son erróneos');
      }
      setState(() {
        loginIng = false;
      });
    }
  }

  @override
  void initState() {
    emailCtrl = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    passCtrl = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Iniciar sesión',
          style: TextStyle(
            color: Palette.appcionaPrimaryColor,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Palette.appcionaPrimaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _keyForm,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Image.asset(
                      'assets/images/logo-green.png',
                      fit: BoxFit.contain,
                      width: 200,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.10,
                  ),
                  _textBox(
                      size,
                      'Correo electrónico',
                      emailCtrl,
                      TextInputType.emailAddress,
                      TextInputAction.next,
                      false,
                      Icons.email),
                  _textBox(
                    size,
                    'Contraseña',
                    passCtrl,
                    TextInputType.visiblePassword,
                    TextInputAction.done,
                    true,
                    Icons.password,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: login,
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0XFF005059),
                            Color(0XFF007373),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        height: 40,
                        width: size.width * 0.6,
                        alignment: Alignment.center,
                        child: loginIng
                            ? const CircularProgressIndicator()
                            : const Text(
                                'INICIAR SESIÓN',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => const RecoverPasswordPage(),
                      ),
                    ),
                    child: const Text('¿Olvidaste tu contraseña?'),
                  ),
                  Container(
                    width: size.width * 0.60,
                    margin: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    child: const Divider(
                      height: 5,
                      thickness: 1,
                      color: Color(0XFF005059),
                    ),
                  ),
                  const Text('¿No tienes cuenta?'),
                  TextButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => const SignUpPage(),
                        ),
                      ),
                    },
                    child: const Text(
                      'Registrate',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container _textBox(Size size, String labelText, TextEditingController ctrl,
      TextInputType tit, TextInputAction tia, bool isPassword, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.appcionaSecondaryColor.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      width: size.width * 0.75,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextFormField(
        textInputAction: tia,
        keyboardType: tit,
        controller: ctrl,
        obscureText: isPassword,
        validator: (value) {
          return value!.isEmpty ? 'El campo está vacío' : null;
        },
        style: TextStyle(color: Palette.appcionaSecondaryColor.shade700),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          icon: Icon(
            icon,
            color: Colors.brown,
          ),
          hintText: labelText,
          hintStyle: TextStyle(
            color: Palette.appcionaSecondaryColor.shade600,
            fontWeight: FontWeight.w500,
          ),
          errorStyle: const TextStyle(fontWeight: FontWeight.bold),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
