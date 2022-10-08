import 'package:appciona/config/palette.dart';
import 'package:appciona/models/respuestas_encuestas.dart';
import 'package:appciona/pages/widgets/alerts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../models/encuestas.dart';
import '../../models/pregunta.dart';
import 'encuestas_controller.dart';

class EncuestasSingleTestPage extends StatefulWidget {
  final String uidEncuesta;
  const EncuestasSingleTestPage({
    Key? key,
    required this.uidEncuesta,
  }) : super(key: key);

  @override
  State<EncuestasSingleTestPage> createState() =>
      _EncuestasSingleTestPageState();
}

class _EncuestasSingleTestPageState extends State<EncuestasSingleTestPage> {
  final EncuestasController _controller = EncuestasController();
  final _formKey = GlobalKey<FormBuilderState>();

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final User? usr = FirebaseAuth.instance.currentUser;
      if (_formKey.currentState!.value.containsValue(null)) {
        Alerts.messageBoxMessage(context, '¡Espere!',
            'Por favor, responda todas las preguntas para poder enviar el formulario');
      } else {
        RespuestasEncuestas respuestas = RespuestasEncuestas(
          uidUsuario: usr!.uid,
          uidEncuesta: widget.uidEncuesta,
          revisado: false,
          respuestas: _formKey.currentState!.value,
        );

        Alerts.messageBoxLoading(context, 'Enviando respuestas');
        if (await _controller.sendAnswers(respuestas)) {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Palette.appcionaSecondaryColor,
              content: Text(
                  "¡Gracias por tu opinión! Respuestas enviadas con éxito"),
            ),
          );
        } else {
          Navigator.of(context, rootNavigator: true).pop();
          Alerts.messageBoxMessage(context, 'Ups',
              'Hubo un error al subir tus respuestas, por favor, intentalo más tarde.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder(
          future: _controller.getSingleForm(widget.uidEncuesta),
          builder: (context, data) {
            if (data.hasData) {
              Encuestas encuesta = data.data as Encuestas;
              List<Pregunta> preguntas =
                  _controller.getPreguntas(encuesta.formulario);
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      AppBar(
                        elevation: 0,
                        backgroundColor: Colors.white,
                        leading: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Palette.appcionaPrimaryColor,
                          ),
                        ),
                        title: Text(
                          '${encuesta.titulo}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Palette.appcionaPrimaryColor,
                          ),
                        ),
                        centerTitle: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 5.0,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: '${encuesta.imagen}',
                            placeholder: (context, url) =>
                                Image.asset('assets/images/logo-green.png'),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/images/logo-green.png'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: encuesta.descripcion!.isEmpty
                            ? const EdgeInsets.all(0)
                            : const EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 5.0,
                              ),
                        child: Text('${encuesta.descripcion}'),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orange.shade200,
                        ),
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 15,
                        ),
                        child: FormBuilder(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            children: [
                              ListView.builder(
                                primary: false,
                                shrinkWrap: true,
                                itemCount: preguntas.length,
                                itemBuilder: (context, index) {
                                  switch (preguntas[index].tipoPregunta) {
                                    case 'Cerrada':
                                      return _questionCerrada(preguntas, index);
                                    case 'OpcionMultiple':
                                      return _questionOpcionMultiple(
                                          preguntas, index);
                                    case 'Abierta':
                                      return _questionAbierta(preguntas, index);
                                    default:
                                      return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0XFF007474),
                        ),
                        onPressed: submit,
                        child: const Text(
                          "Enviar mis respuestas",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              );
            } else if (data.hasError) {
              return Center(
                child: Text('${data.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _questionCerrada(List<Pregunta> preguntas, int index) {
    return Column(
      children: [
        Text(
          '${preguntas[index].pregunta}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown.shade800,
            fontSize: 18,
          ),
        ),
        Divider(
          color: Colors.brown.shade900,
          thickness: 1,
        ),
        FormBuilderChoiceChip(
          name: '${preguntas[index].pregunta}',
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          backgroundColor: const Color(0XFFFFEFD5),
          selectedColor: Colors.brown.shade300,
          alignment: WrapAlignment.spaceBetween,
          options: List.generate(
            preguntas[index].respuestas!.length,
            (indexAnswers) => FormBuilderChipOption(
              value: '${preguntas[index].respuestas![indexAnswers]}',
              child: Text('${preguntas[index].respuestas![indexAnswers]}'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _questionOpcionMultiple(List<Pregunta> preguntas, int index) {
    return Column(
      children: [
        Text(
          '${preguntas[index].pregunta}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown.shade800,
            fontSize: 18,
          ),
        ),
        Divider(
          color: Colors.brown.shade900,
          thickness: 1,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0XFFFFEFD5),
          ),
          child: FormBuilderCheckboxGroup(
            name: '${preguntas[index].pregunta}',
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            activeColor: Colors.brown,
            options: List.generate(
              preguntas[index].respuestas!.length,
              (indexAnswers) => FormBuilderChipOption(
                value: '${preguntas[index].respuestas![indexAnswers]}',
                child: Text('${preguntas[index].respuestas![indexAnswers]}'),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _questionAbierta(List<Pregunta> preguntas, int index) {
    return Column(
      children: [
        Text(
          '${preguntas[index].pregunta}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown.shade800,
            fontSize: 18,
          ),
        ),
        Divider(
          color: Colors.brown.shade900,
          thickness: 1,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color(0XFFFFEFD5),
          ),
          child: FormBuilderTextField(
            name: '${preguntas[index].pregunta}',
            decoration: InputDecoration(
              labelText: 'Respuesta',
              labelStyle: TextStyle(
                color: Colors.brown.shade600,
              ),
              border: InputBorder.none,
            ),
            cursorColor: Colors.brown.shade600,
            maxLines: null,
            onChanged: (value) {},
            validator: (value) {},
            keyboardType: TextInputType.text,
          ),
        ),
      ],
    );
  }
}
