import 'package:appciona/config/palette.dart';
import 'package:appciona/models/user_model.dart';
import 'package:appciona/pages/account/signup/signup_controller.dart';
import 'package:appciona/pages/widgets/alerts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../firebaseServices/auth_services.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _keyForm = GlobalKey();
  final SignUpController _controller = SignUpController();

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController surnameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController dniCtrl = TextEditingController();
  TextEditingController telCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();
  TextEditingController passPassCtrl = TextEditingController();

  bool singin = false;

  void getCiudades() async {
    await _controller.getCiudades().then((value) => setState(() {}));
  }

  @override
  void initState() {
    nameCtrl = TextEditingController(text: '');
    surnameCtrl = TextEditingController(text: '');
    emailCtrl = TextEditingController(text: '');
    dniCtrl = TextEditingController(text: '');
    passCtrl = TextEditingController(text: '');
    passPassCtrl = TextEditingController(text: '');
    telCtrl = TextEditingController(text: '');
    getCiudades();
    super.initState();
  }

  signUp() async {
    if (_keyForm.currentState!.validate()) {
      print("presionado");
      if (_controller.ciudadSelected!.startsWith('Mi ciudad')) {
        Alerts.messageBoxMessage(context, 'Ups',
            'Por favor selecciona la ciudad a la que perteneces');
      } else {
        setState(() {
          singin = true;
        });
        AuthServices as = AuthServices();
        await as
            .authSignUp(emailCtrl.text, passCtrl.text)
            .then((UserCredential? user) async {
          if (user != null) {
            print("intentando registrar");
            UsersModel register = UsersModel(
              user.user!.uid,
              nameCtrl.text,
              surnameCtrl.text,
              emailCtrl.text,
              dniCtrl.text,
              passCtrl.text,
              _controller.ciudadSelected.toString(),
              "Usuario",
              telCtrl.text,
            );
            await register.agregarUsuarioFirestore().then((result) async {
              if (result) {
                await as.singIn(emailCtrl.text, passCtrl.text).then((uc) {
                  if (uc != null) {
                    int counter = 0;
                    Navigator.of(context).popUntil((route) => counter++ >= 2);
                  }

                });
              }

            });
          }

          else
          {


            Future.delayed(const Duration(milliseconds: 100), ()
            {


              showGeneralDialog(
                  barrierColor: Colors.black.withOpacity(0.5),
                  transitionBuilder: (context, a1, a2, widget) {
                    return Transform.scale(
                      scale: a1.value,
                      child: Opacity(
                        opacity: a1.value,
                        child: AlertDialog(
                          shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0)),
                          title: Text('¡Usuario existente!',textScaleFactor:1.3 ),
                          content:
                          SingleChildScrollView(
                            child:
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('El usuario ya se encuentra registrado',textScaleFactor:1.2 ,),
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: TextButton(onPressed: (){Navigator.maybePop(context);}, child: Text("salir",style: TextStyle(fontSize: 25),)))
                                ],
                              ),

                          ),
                        ),
                      ),
                    );
                  },
                  transitionDuration: Duration(milliseconds: 300),
                  barrierDismissible: true,
                  barrierLabel: '',
                  context: context,
                  pageBuilder: (context, animation1, animation2) {return Container();});


            });

          }

        });
        setState(() {
          singin = false;
        });
      }
    }
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
          'Registrarse',
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
      body: SingleChildScrollView(
        child: Form(
          key: _keyForm,
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Image.asset(
                    'assets/images/logo-green.png',
                    fit: BoxFit.contain,
                    width: 100,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Introduzca su información para poder crear su cuenta.',
                  ),
                ),
                _textBox(
                  size,
                  'Nombre',
                  nameCtrl,
                  TextInputType.text,
                  TextInputAction.next,
                  false,
                  Icons.person,
                ),
                _textBox(
                  size,
                  'Apellidos',
                  surnameCtrl,
                  TextInputType.text,
                  TextInputAction.next,
                  false,
                  Icons.person_outline,
                ),
                _textBox(
                  size,
                  'Correo electrónico',
                  emailCtrl,
                  TextInputType.emailAddress,
                  TextInputAction.next,
                  false,
                  Icons.email,
                ),
                _textBox(
                  size,
                  'DNI',
                  dniCtrl,
                  TextInputType.text,
                  TextInputAction.next,
                  false,
                  Icons.card_membership,
                ),
                _textBox(
                  size,
                  'Teléfono',
                  telCtrl,
                  TextInputType.phone,
                  TextInputAction.next,
                  false,
                  Icons.phone,
                ),
                _textBox(
                  size,
                  'Contraseña',
                  passCtrl,
                  TextInputType.visiblePassword,
                  TextInputAction.next,
                  true,
                  Icons.lock,
                ),
                _textBox(
                  size,
                  'Confirme contraseña',
                  passPassCtrl,
                  TextInputType.visiblePassword,
                  TextInputAction.next,
                  true,
                  Icons.lock_outline,
                ),
                _dropdown(size),
                _btnRegistrar(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _dropdown(Size size) {
    return Container(
      width: size.width * 0.75,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Palette.appcionaPrimaryColor.shade100,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_city,
            color: Palette.appcionaPrimaryColor.shade400,
          ),
          const SizedBox(
            width: 25,
          ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                style: const TextStyle(
                  color: Palette.appcionaPrimaryColor,
                  fontSize: 16,
                ),
                focusColor: Colors.black,
                isExpanded: true,
                hint: const Text('Mi ciudad'),
                value: _controller.ciudadSelected,
                items: _controller.listCiudades,
                onChanged: (String? value) {
                  setState(() {
                    _controller.ciudadSelected = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton _btnRegistrar(Size size) {
    return ElevatedButton(
      onPressed: singin ? null : signUp,
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
              Color(0XFFFF8C29),
              Color.fromARGB(255, 243, 93, 34),
            ],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          height: 40,
          width: size.width * 0.6,
          alignment: Alignment.center,
          child: singin
              ? RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(text: 'REGISTRANDO...  '),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              : const Text(
                  'REGISTRARME',
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
      TextInputType tit, TextInputAction tia, bool isPassword, IconData icon) {
    return Container(
      width: size.width * 0.75,
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Palette.appcionaPrimaryColor.shade100,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: TextFormField(
        controller: ctrl,
        textInputAction: tia,
        keyboardType: tit,
        obscureText: isPassword,
        validator: (value) {
          if (tit == TextInputType.phone &&
              !value!.contains(RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$'))) {
            return "Formato de número inválido";
          }
          if (isPassword && passCtrl.text != passPassCtrl.text) {
            return "Las contraseñas no coinciden";
          } else if (isPassword && passCtrl.text.length < 6) {
            return "La contraseña debe tener al menos 6 caracteres";
          }
          if(dniCtrl.text==""||dniCtrl==null){
            dniCtrl.text="NA";
          }
          if (value!.isEmpty) {
            return "Campo necesario";
          } else {
            return null;
          }
        },
        style: const TextStyle(
          color: Palette.appcionaPrimaryColor,
        ),
        decoration: InputDecoration(
          icon: Icon(icon),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          hintText: labelText,
          hintStyle: TextStyle(
            color: Palette.appcionaPrimaryColor.shade400,
            fontWeight: FontWeight.bold,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
