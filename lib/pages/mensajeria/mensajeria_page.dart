import 'package:appciona/config/palette.dart';
import 'package:appciona/pages/mensajeria/mensajeria_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:overlay_support/overlay_support.dart';

class MensajeriaPage extends StatefulWidget {
  const MensajeriaPage({Key? key}) : super(key: key);

  @override
  State<MensajeriaPage> createState() => _MensajeriaPageState();
}

class _MensajeriaPageState extends State<MensajeriaPage> {
  final MensajeriaController _controller = MensajeriaController();
  final TextEditingController _messageCtrl = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String _messageText = "";

  Future sendMessage() async {
    if (_messageCtrl.text.isNotEmpty) {
      _messageText = _messageCtrl.text;
      _messageCtrl.clear();
      await _controller.sendMessage(_messageText).then((value) => {});
    }
    setState(() {});
    _scrollController.animateTo(
      0.0,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Future initChatRoom() async {
    await _controller.initChatRoom();
    /*
    DocumentReference chatsReference = FirebaseFirestore.instance
        .collection("Mensajeria")
        .doc(_controller.roomID);
    chatsReference.snapshots().listen(
      ((event) {
        String last = event.get("UltimoRemitente");
        if (last != _controller.myName) {}
      }),
    );*/
    setState(() {});
  }

  @override
  void initState() {
    initChatRoom();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0XFFF3F4F6),
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        title: const Text(
          "Mensajería",
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
        actions: [
          Image.asset(
            'assets/images/logo-green.png',
            fit: BoxFit.contain,
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              reverse: true,
              controller: _scrollController,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo-green.png',
                    width: size.width * 0.40,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    child: const Text(
                      '¡Bienvenido!, este espacio, está destinado para que puedas comunicarte con nosotros de una forma más directa y personalizada.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.80,
                    child: const Divider(
                      thickness: 1,
                      color: Palette.appcionaPrimaryColor,
                    ),
                  ),
                  _mensajeria(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color: const Color(0XFFF3F4F6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: _textBox(
                        size,
                        'Escribe tu mensaje',
                        _messageCtrl,
                        TextInputType.multiline,
                        TextInputAction.send,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, right: 5.0),
                      child: IconButton(
                        onPressed: sendMessage,
                        icon: const Icon(
                          Icons.send,
                          color: Palette.appcionaSecondaryColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  StreamBuilder<dynamic> _mensajeria() {
    return StreamBuilder(
      stream: _controller.messageStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          QuerySnapshot data = snapshot.data as QuerySnapshot;
          return ListView.builder(
            primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.only(bottom: 70, top: 16),
            itemCount: data.docs.length,
            reverse: true,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = data.docs[index];
              if (ds["Remitente"] == _controller.myName) {
                return _userMessage(ds["Mensaje"]);
              } else {
                return _adminMessage(ds["Mensaje"]);
              }
            },
          );
        } else if (snapshot.hasError) {
          return const SizedBox.shrink();
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget _userMessage(String mensaje) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(
              top: 5,
              bottom: 5,
              left: 20,
            ),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(
              mensaje,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Palette.appcionaSecondaryColor,
            borderRadius: BorderRadius.circular(40),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.all(5.0),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Icon(
            CupertinoIcons.person_fill,
            color: Palette.appcionaSecondaryColor.shade100,
            size: 26,
          ),
        ),
      ],
    );
  }

  Widget _adminMessage(String mensaje) {
    return Row(
      children: [
        Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          child: Image.asset(
            'assets/images/logo-green.png',
            width: 40,
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(
              top: 5,
              bottom: 5,
              right: 20,
            ),
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: Palette.appcionaPrimaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Text(
              mensaje,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Container _textBox(Size size, String labelText, TextEditingController ctrl,
      TextInputType tit, TextInputAction tia) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.appcionaPrimaryColor.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextFormField(
        textInputAction: tia,
        keyboardType: tit,
        controller: ctrl,
        style: TextStyle(color: Palette.appcionaPrimaryColor.shade700),
        minLines: 1,
        maxLines: 4,
        onEditingComplete: sendMessage,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
          hintText: labelText,
          hintStyle: TextStyle(
            color: Palette.appcionaPrimaryColor.shade600,
            fontWeight: FontWeight.w500,
          ),
          errorStyle: const TextStyle(fontWeight: FontWeight.bold),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
