import 'package:appciona/config/palette.dart';
import 'package:appciona/pages/widgets/alerts.dart';
import 'package:flutter/material.dart';

import 'recover_password_controller.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({Key? key}) : super(key: key);

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final RecoverPasswordController _controller = RecoverPasswordController();

  late TextEditingController emailCtrl;
  late bool loginIng = false;
  final GlobalKey<FormState> _keyForm = GlobalKey();

  void recoverPass() async {
    if (_keyForm.currentState!.validate()) {
      setState(() {
        loginIng = true;
      });

      if (await _controller.recover(emailCtrl.text)) {
        Alerts.messageBoxCustom(
          context,
          const Text('Hecho'),
          Text('Se ha enviado un correo electrónico a ${emailCtrl.text}'),
          [
            TextButton(
              onPressed: () {
                int counter = 0;
                Navigator.of(context).popUntil((route) => counter++ >= 2);
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      } else {
        Alerts.messageBoxMessage(context, 'Ups',
            'Parece que hubo un error al procesar la petición, intentelo nuevamente más tarde.');
      }

      setState(() {
        loginIng = false;
      });
    }
  }

  @override
  void initState() {
    emailCtrl = TextEditingController(text: '');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Palette.appcionaPrimaryColor,
          ),
        ),
        title: const Text(
          'Recuperar contraseña',
          style: TextStyle(
            color: Palette.appcionaPrimaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _keyForm,
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.asset(
                      'assets/images/logo-green.png',
                      width: size.width * 0.80,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    width: size.width * 0.80,
                    child: const Text(
                      'Introduce tu dirección de correo electrónico y nosotros nos encargaremos de enviarte las indicaciones para recuperar tu contraseña.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _textBox(
                    size,
                    'Correo electrónico',
                    emailCtrl,
                    TextInputType.emailAddress,
                    TextInputAction.done,
                    false,
                  ),
                  _buttonSend(size),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _buttonSend(Size size) {
    return ElevatedButton(
      onPressed: recoverPass,
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
                  'Enviar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  Container _textBox(Size size, String labelText, TextEditingController ctrl,
      TextInputType tit, TextInputAction tia, bool isPassword) {
    return Container(
      width: size.width * 0.75,
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        textInputAction: tia,
        keyboardType: tit,
        controller: ctrl,
        obscureText: isPassword,
        validator: (value) {
          return value!.isEmpty ? 'El campo está vacío' : null;
        },
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          labelText: labelText,
          labelStyle: const TextStyle(
            color: Color(0XFF007474),
            fontWeight: FontWeight.bold,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2,
              color: Color(0XFF005059),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2,
              color: Color(0XFF005059),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2,
              color: Color(0XFF005059),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.red.shade900,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
