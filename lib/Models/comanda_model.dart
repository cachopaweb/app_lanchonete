import 'package:lanchonete/Models/itens_model.dart';

class Comanda {
  int codigo;
  int mesa;
  dynamic valor;
  List<Itens> itens;

  Comanda({this.codigo, this.mesa, this.valor, this.itens}) {
    if (this.itens == null) {
      this.itens = <Itens>[];
    }
  }

  factory Comanda.fromJson(Map<String, dynamic> json) {
    Comanda comanda = Comanda(
        codigo: json['comCodigo'],
        mesa: json['comMesa'],
        valor: json['comValor'],
        itens: (json['itens'] as List).map((e) => Itens.fromJson(e)).toList());
    return comanda;
  }

  Map<String, dynamic> toJson() {
    return {
      "mesa": mesa,
      "valor": valor,
      "itens": itens.map((item) => item.toJson()).toList()
    };
  }
}
