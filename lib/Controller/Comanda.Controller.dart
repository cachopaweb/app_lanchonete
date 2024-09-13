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
      if (element.complementos!.length > 0) {
        soma += element.complementos!
            .map((e) => e.valor * e.quantidade)
            .reduce((value, value2) => value + value2);
      }
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
  bool get isEmpty => itens.isEmpty;

  void adicionaItem(Produtos produto, String idAgrupamento,
      {GradeProduto? gradeProduto,
      double quantidade = 1.0,
      required int usuario}) {
    itens.add(
      Itens(
        codigo: itens.length + 1,
        produto: produto.codigo,
        quantidade: quantidade,
        valor: produto.valor,
        nome: produto.nome,
        grade: produto.grade,
        gradeProduto: gradeProduto,
        usuario: usuario,
        idAgrupamento: (gradeProduto != null) ? idAgrupamento : '',
      ),
    );
    notifyListeners();
  }

  void clear() {
    itens.clear();
    notifyListeners();
  }

  void removeItem(int? codProduto) {
    itens.removeWhere((e) => e.produto == codProduto);
    notifyListeners();
  }

  void removeItemCarrinho(Itens item) {
    if (item.gradeProduto != null) {
      itens.removeWhere((e) => e.idAgrupamento == item.idAgrupamento);
    } else {
      itens.removeWhere((e) => e.codigo == item.codigo);
    }
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
      return resultado;
    } catch (e) {
      throw Exception(e);
    }
  }

  adicionaObservacao(int? codItem, String obs) {
    var indice = itens.indexWhere((element) => element.codigo == codItem);
    itens[indice].obs = obs;
    notifyListeners();
  }

  adicionaComplementos(int? codItem, List<Complementos> complementos) {
    var indice = itens.indexWhere((element) => element.codigo == codItem);
    itens[indice].complementos = complementos;
    notifyListeners();
  }

  Future<bool> deletarItemComanda(int codigo) async {
    final comandaService = ComandaService();
    try {
      final result = await comandaService.deletarItemComanda(codigo);
      notifyListeners();
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Comanda> buscaComanda(int codigo) async {
    final comandaService = ComandaService();
    try {
      final result = await comandaService.fetchComanda(codigo);
      notifyListeners();
      return result;
    } catch (e) {
      throw Exception(e);
    }
  }
}
