import 'package:lanchonete/Models/itens_model.dart';

class Comanda {
  int? codigo;
  int? mesa;
  double? valor;
  List<Itens>? itens;

  Comanda({this.codigo, this.mesa, this.valor, this.itens}) {
    if (this.itens == null) {
      this.itens = <Itens>[];
    }
  }

  factory Comanda.fromJson(Map<String, dynamic> json) {
    Comanda comanda = Comanda(
        codigo: json['comCodigo'] ?? 0,
        mesa: json['comMesa'] ?? 0,
        valor: json['comValor'] * 100 / 100 ?? 0,
        itens: (json['itens'] as List).map((e) => Itens.fromJson(e)).toList());
    return comanda;
  }

  Map<String, dynamic> toJson() {
    return {
      "mesa": mesa,
      "valor": valor,
      "itens": itens!.map((item) => item.toJson()).toList()
    };
  }
}
