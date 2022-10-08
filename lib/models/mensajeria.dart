class Mensajeria {
  String? id;
  String? chatDe;
  String? ultimoMensaje;
  String? ultimoRemitente;
  DateTime? ts;
  Mensajeria({
    this.id,
    this.chatDe,
    this.ultimoMensaje,
    this.ultimoRemitente,
    this.ts,
  });
}

class Chats {
  String? mensaje;
  String? remitente;
  DateTime? ts;

  Chats({
    this.mensaje,
    this.remitente,
    this.ts,
  });
}
