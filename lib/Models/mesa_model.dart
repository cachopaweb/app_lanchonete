class Mesa {
  int? codigo;
  String? nome;
  String? estado;
  dynamic valor = 0.0;

  Mesa({this.codigo, this.estado, this.nome, this.valor});

  factory Mesa.fromJson(Map<String, dynamic> json) {
    return Mesa(
        codigo: json['mesCodigo'],
        nome: json['mesNome'],
        estado: json['mesEstado'],
        valor: json['mesValor']);
  }
}
