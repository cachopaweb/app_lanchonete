import 'package:lanchonete/Models/complementos_model.dart';

class Itens {
  int codigo;
  int produto;
  dynamic valor;
  dynamic quantidade;
  String estado;
  String obs;
  int grade;
  String nome;
  List<Complementos> complementos;
  int id;

  Itens(
      {this.id,
      this.produto,
      this.valor,
      this.quantidade,
      this.estado,
      this.obs,
      this.grade,
      this.nome,
      this.complementos,
      this.codigo}) {
    if (this.complementos == null) {
      this.complementos = <Complementos>[];
    }
  }

  factory Itens.fromJson(Map<String, dynamic> json) {
    return Itens(
        codigo: json['cpCodigo'],
        produto: json['cpPro'],
        estado: json['cpEstado'],
        valor: json['cpValor'],
        quantidade: json['cpQuantidade'],
        obs: json['cpObs'],
        grade: json['cpGra'],
        nome: json['nome'],
        complementos: (json['complementos'] as List)
            .map((e) => Complementos.fromJson(e))
            .toList());
  }

  Map<String, dynamic> toJson() {
    return {
      "codigo": codigo,
      "produto": produto,
      "estado": estado,
      "valor": valor,
      "quantidade": quantidade,
      "obs": obs,
      "grade": grade,
      "nome": nome,
      "complementos": complementos.map((c) {
        if (c != null) return c.toJson();
      }).toList()
    };
  }
}
