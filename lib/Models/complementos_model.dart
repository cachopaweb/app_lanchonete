class Complementos {
  int? codigo;
  String? nome;
  dynamic valor;
  bool? selecionado;
  int? quantidade;

  Complementos({this.codigo, this.nome, this.valor, this.quantidade}) {
    this.selecionado = false;
    if (this.quantidade == null) this.quantidade = 0;
  }

  factory Complementos.fromJson(Map<String, dynamic> json) {
    return Complementos(
        codigo: json['codigo'],
        nome: json['nome'],
        valor: json['valor'],
        quantidade: json['quantidade']);
  }

  Map<String, dynamic> toJson() {
    return {
      "codigo": codigo,
      "nome": nome,
      "valor": valor,
      "quantidade": quantidade,
    };
  }
}
