class Pregunta {
  String? pregunta;
  List<dynamic>? respuestas;
  String? tipoPregunta;

  Pregunta({
    this.pregunta,
    this.respuestas,
    this.tipoPregunta,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) => Pregunta(
        pregunta: json["Pregunta"].toString(),
        respuestas: json["Respuestas"],
        tipoPregunta: json["TipoPregunta"].toString(),
      );

  Map<String, dynamic> toMap() {
    return {
      'Pregunta': pregunta,
      'Respuestas': respuestas,
      'TipoPregunta': tipoPregunta,
    };
  }
}
