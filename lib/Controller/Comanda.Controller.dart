import 'package:lanchonete/Models/comanda_model.dart';
import 'package:lanchonete/Models/complementos_model.dart';
import 'package:lanchonete/Models/grade_produto_model.dart';
import 'package:lanchonete/Models/itens_model.dart';
import 'package:lanchonete/Models/produtos_model.dart';
import 'package:lanchonete/Services/ComandaService.dart';
import 'package:flutter/cupertino.dart';

class ComandaController extends ChangeNotifier {
  List<Itens> itens = [];

  double get valorComanda {
    double soma = 0;
    itens.forEach((element) {
      soma += element.valor!;
    });
    return soma;
  }

  double getQuantidade(int produto) {
    double quantidade = 0;
    itens.forEach((element) {
      if (element.produto == produto) {
        quantidade += element.quantidade!;
      }
    });
    return quantidade;
  }

  int get totalItens => itens.length;

  void adicionaItem(Produtos produto,
      {GradeProduto? gradeProduto, double quantidade = 1.0}) {
    itens.add(Itens(
      codigo: itens.length + 1,
      produto: produto.codigo,
      quantidade: quantidade,
      valor: produto.valor,
      nome: produto.nome,
      grade: produto.grade,
      gradeProduto: gradeProduto,
    ));
    notifyListeners();
  }

  void clear() {
    itens.clear();
    notifyListeners();
  }

  void removeItem(int? codigo) {
    itens.removeWhere((e) => e.produto == codigo);
    notifyListeners();
  }

  void diminuirQuantidade(int? codigo) {
    var item = itens.firstWhere((e) => e.produto == codigo);
    item.quantidade = item.quantidade! - 0.5;
    item.valor = item.valor! * item.quantidade!;
    notifyListeners();
  }

  Future<bool> insereComanda(int? mesa) async {
    final comandaService = ComandaService();
    //retorno da função
    var resultado = false;
    try {
      var comanda = Comanda();
      comanda.mesa = mesa;
      comanda.valor = valorComanda;
      comanda.itens = [...itens];
      //dados da comanda
      var comandaExistente = await comandaService.fetchComanda(mesa);
      if (comandaExistente.itens!.length == 0) {
        resultado = await comandaService.criaComanda(comanda);
      } else {
        resultado = await comandaService.atualizarComanda(comanda);
      }
      if (resultado) {
        //limpa os itens
        clear();
      }
    } catch (error) {
      print(error.toString());
    }
    return resultado;
  }

  adicionaObservacao(int? codItem, String obs) {
    var indice = itens.indexWhere((element) => element.produto == codItem);
    itens[indice].obs = obs;
    notifyListeners();
  }

  adicionaComplementos(int? codItem, List<Complementos> complementos) {
    var indice = itens.indexWhere((element) => element.produto == codItem);
    itens[indice].complementos = complementos;
    notifyListeners();
  }
}
