class RespuestasEncuestas {
  String? uidUsuario;
  String? uidEncuesta;
  bool? revisado;
  Map<String, dynamic>? respuestas;

  RespuestasEncuestas({
    this.uidUsuario,
    this.uidEncuesta,
    this.revisado,
    this.respuestas,
  });

  factory RespuestasEncuestas.fromJson(Map<String, dynamic> json) =>
      RespuestasEncuestas(
        uidUsuario: json["uidUsuario"].toString(),
        uidEncuesta: json["uidEncuesta"],
        revisado: json["Revisado"],
        respuestas: json["Respuestas"],
      );

  Map<String, dynamic> toMap() {
    return {
      'uidUsuario': uidUsuario,
      'uidEncuesta': respuestas,
      'Revisado': respuestas,
      'Respuestas': respuestas,
    };
  }
}
