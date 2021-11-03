import 'dart:convert';

class GradeProduto {
  final int codigo;
  final double valor;
  final String tamanho;

  GradeProduto(
      {required this.codigo, required this.valor, required this.tamanho});

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'valor': valor,
      'tamanho': tamanho,
    };
  }

  factory GradeProduto.fromMap(Map<String, dynamic> map) {
    return GradeProduto(
      codigo: map['codigo'] ?? 0,
      valor: map['valor'] * 100 / 100 ?? 0,
      tamanho: map['tamanho'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GradeProduto.fromJson(String source) =>
      GradeProduto.fromMap(json.decode(source));
}
