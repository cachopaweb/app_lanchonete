import 'package:lanchonete/Models/complementos_model.dart';
import 'package:lanchonete/Models/produtos_model.dart';

class ItemComPro {
  int? cpCodigo;
  int? cpCom;
  Produtos? produto;
  int? cpQuantidade;
  int? cpValor;
  int? cpGra;
  String? cpObs;
  String? cpEstado;
  String? nome;
  List<Complementos>? complementos;
  int? usuario;

  ItemComPro({
    this.cpCodigo,
    this.cpCom,
    this.produto,
    this.cpQuantidade,
    this.cpValor,
    this.cpGra,
    this.cpObs,
    this.cpEstado,
    this.nome,
    this.complementos,
    this.usuario,
  });

  ItemComPro.fromJson(Map<String, dynamic> json) {
    cpCodigo = json['cpCodigo'];
    cpCom = json['cpCom'];
    produto =
        json['produto'] != null ? new Produtos.fromJson(json['produto']) : null;
    cpQuantidade = json['cpQuantidade'];
    cpValor = json['cpValor'];
    cpGra = json['cpGra'];
    cpObs = json['cpObs'];
    cpEstado = json['cpEstado'];
    nome = json['nome'];
    if (json['complementos'] != null) {
      complementos = <Complementos>[];
      json['complementos'].forEach(
        (v) {
          complementos!.add(new Complementos.fromJson(v));
        },
      );
    }
    usuario = json['usuario'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cpCodigo'] = this.cpCodigo;
    data['cpCom'] = this.cpCom;
    if (this.produto != null) {
      data['produto'] = this.produto!.toJson();
    }
    data['cpQuantidade'] = this.cpQuantidade;
    data['cpValor'] = this.cpValor;
    data['cpGra'] = this.cpGra;
    data['cpObs'] = this.cpObs;
    data['cpEstado'] = this.cpEstado;
    data['nome'] = this.nome;
    data['usuario'] = this.usuario;
    if (this.complementos != null) {
      data['complementos'] = this.complementos!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
