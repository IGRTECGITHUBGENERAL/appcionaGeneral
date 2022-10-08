// ignore_for_file: non_constant_identifier_names

class Agenda {
  String? uid;
  String? UsuarioId;
  String? Titulo;
  String? Descripcion;
  DateTime Fecha;

  Agenda(
      {this.uid,
      this.UsuarioId,
      this.Titulo,
      this.Descripcion,
      required this.Fecha});
}
