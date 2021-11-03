import 'package:lanchonete/Models/grade_produto_model.dart';

class ItensGrade {
  final int produto;
  final String nome;
  final double quantidade;
  final List<GradeProduto> grade;

  ItensGrade({
    required this.produto,
    required this.nome,
    required this.quantidade,
    required this.grade,
  });

  double valorFromTamanho(String tamanho) {
    var item = grade.firstWhere((item) => item.tamanho == tamanho);
    return item.valor;
  }
}
