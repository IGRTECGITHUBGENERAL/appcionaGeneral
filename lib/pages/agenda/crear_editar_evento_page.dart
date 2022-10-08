import 'package:appciona/config/palette.dart';
import 'package:appciona/models/agendas.dart';
import 'package:appciona/pages/agenda/crear_editar_evento_controller.dart';
import 'package:flutter/material.dart';

class CrearEditarEventoPage extends StatefulWidget {
  final bool isEditing;
  final Agenda? agendaInfo;
  const CrearEditarEventoPage({
    Key? key,
    required this.isEditing,
    this.agendaInfo,
  }) : super(key: key);

  @override
  State<CrearEditarEventoPage> createState() => _CrearEditarEventoPageState();
}

class _CrearEditarEventoPageState extends State<CrearEditarEventoPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController tituloCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();
  TextEditingController fechaCtrl = TextEditingController();
  TextEditingController horaCtrl = TextEditingController();
  final CrearEditarEventoController _controller = CrearEditarEventoController();

  save() {
    if (_formKey.currentState!.validate()) {
      if (widget.isEditing) {
        _controller.save(tituloCtrl.text, descripcionCtrl.text, context,
            widget.isEditing, widget.agendaInfo!.uid);
      } else {
        _controller.save(tituloCtrl.text, descripcionCtrl.text, context,
            widget.isEditing, null);
        _formKey.currentState!.reset();
      }
    }
  }

  @override
  void initState() {
    tituloCtrl = TextEditingController(
        text: widget.isEditing ? widget.agendaInfo!.Titulo : '');
    descripcionCtrl = TextEditingController(
        text: widget.isEditing ? widget.agendaInfo!.Descripcion : '');
    _controller.selectedDate =
        widget.isEditing ? widget.agendaInfo!.Fecha : DateTime.now();
    _controller.selectedTime24Hour = widget.isEditing
        ? TimeOfDay(
            hour: widget.agendaInfo!.Fecha.hour,
            minute: widget.agendaInfo!.Fecha.minute)
        : TimeOfDay.now();
    super.initState();
  }

  @override
  void dispose() {
    tituloCtrl.dispose();
    descripcionCtrl.dispose();
    fechaCtrl.dispose();
    horaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: widget.isEditing
            ? const Text(
                'Editar evento',
                style: TextStyle(
                  color: Palette.appcionaPrimaryColor,
                ),
              )
            : const Text(
                'Crear evento',
                style: TextStyle(
                  color: Palette.appcionaPrimaryColor,
                ),
              ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Palette.appcionaPrimaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(60.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextBox(controller: tituloCtrl, label: 'Título'),
                TextBox(controller: descripcionCtrl, label: 'Descripción'),
                formItemsDesign(
                  IconButton(
                      onPressed: () {
                        _controller.selectDate(context);
                      },
                      icon: const Icon(Icons.calendar_month_outlined)),
                  Text("${_controller.selectedDate.toLocal()}".split(' ')[0],
                      style: const TextStyle(color: Color(0xff6f6f6f))),
                ),
                formItemsDesign(
                  IconButton(
                      onPressed: () {
                        _controller.selectTime(context);
                      },
                      icon: const Icon(Icons.watch_later_outlined)),
                  Text(
                      "${_controller.selectedTime24Hour.hour} : ${_controller.selectedTime24Hour.minute}",
                      style: const TextStyle(color: Color(0xff6f6f6f))),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                _bottomSend(size),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomSend(Size size) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(size.width * 0.8, 60.0),
            primary: const Color(0xff2196F3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(60.0),
            ),
          ),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 60.0, vertical: 15.0),
            child: widget.isEditing
                ? const Text(
                    'Guardar cambios',
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )
                : const Text(
                    'Crear',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
          ),
          onPressed: () {
            save();
          },
        );
      },
    );
  }
}

class TextBox extends StatelessWidget {
  const TextBox({Key? key, required this.controller, required this.label})
      : super(key: key);

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return '$label requerido';
        } else {
          return null;
        }
      },
    );
  }
}

formItemsDesign(icon, item) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 7),
    child: Card(child: ListTile(leading: icon, title: item)),
  );
}
