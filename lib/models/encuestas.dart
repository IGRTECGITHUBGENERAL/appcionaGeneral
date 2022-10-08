class Encuestas {
  String? uid;
  String? titulo;
  String? descripcion;
  String? imagen;
  String? Ciudad;
  Map<String, dynamic>? formulario;

  Encuestas({
    this.uid,
    this.titulo,
    this.descripcion,
    this.imagen,
    this.formulario,
    this.Ciudad,
  });

  factory Encuestas.fromJson(Map<String, dynamic> json) => Encuestas(
        uid: json["uid"].toString(),
        titulo: json["Titulo"].toString(),
        descripcion: json["Descripcion"].toString(),
        imagen: json["Imagen"].toString(),
        formulario: json["Formulario"],
         Ciudad: json["Ciudad"],
      );

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'Titulo': titulo,
      'Descripcion': descripcion,
      'Imagen': imagen,
      'Formulario': formulario,
      'Ciudad': Ciudad,
    };
  }
}
