import 'package:lanchonete/Components/Imagem_Produto_Widget.dart';
import 'package:lanchonete/Controller/Comanda.Controller.dart';
import 'package:lanchonete/Controller/usuario_controller.dart';
import 'package:lanchonete/Models/Itens_Grade_model.dart';
import 'package:lanchonete/Models/produtos_model.dart';
import 'package:lanchonete/Services/ProdutosService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'Grade_produto_widget.dart';

class ProdutoItem extends StatefulWidget {
  final Produtos? produto;
  final int? mesa;
  final int? categoria;

  const ProdutoItem(
      {Key? key, this.produto, this.mesa, required this.categoria})
      : super(key: key);

  @override
  _ProdutoItemState createState() => _ProdutoItemState();
}

class _ProdutoItemState extends State<ProdutoItem> {
  final produtosService = ProdutosService();

  var f = new NumberFormat("##0.00", "pt_BR");

  @override
  Widget build(BuildContext context) {
    final comandaController = Provider.of<ComandaController>(context);
    return _buildItem(comandaController);
  }

  Future<void> _buildGradeProduto(Produtos produtos) async {
    final ProdutosService produtosService = ProdutosService();
    var itensList = ValueNotifier<List<ItensGrade>>([]);
    final gradeList = await produtosService.fetchGradesProduto(produtos.codigo);
    //add como primeiro item o produto selecionado
    itensList.value.add(ItensGrade(
      produto: produtos.codigo,
      nome: produtos.nome,
      quantidade: 1,
      grade: gradeList,
    ));

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ValueListenableBuilder<List<ItensGrade>>(
            valueListenable: itensList,
            builder: (context, itens, _) {
              return WidgetGradeProduto(
                itensList: itensList,
                categoria: widget.categoria!,
                produto: widget.produto!,
              );
            }),
      ),
    );
  }

  Widget _acoes(ComandaController comandaController) {
    var quantidade = comandaController.getQuantidade(widget.produto!.codigo);
    final usuarioController = Provider.of<UsuarioController>(context);
    return Row(
      children: [
        Column(children: [
          MaterialButton(
            height: 20,
            onPressed: () {
              if (widget.produto!.grade > 0) {
                _buildGradeProduto(widget.produto!);
              } else {
                comandaController.adicionaItem(
                  widget.produto!,
                  '',
                  usuario: usuarioController.usuarioLogado.codigo,
                );
              }
            },
            color: Colors.green,
            child: Icon(
              Icons.add,
              size: 25,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(5),
            shape: CircleBorder(),
          ),
          Text(
            widget.produto!.grade > 0
                ? quantidade.toStringAsFixed(1)
                : quantidade.toStringAsFixed(0),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          MaterialButton(
            height: 20,
            onPressed: () {
              if (widget.produto!.grade > 0) {
                comandaController.diminuirQuantidade(widget.produto!.codigo);
                if (quantidade == 0) {
                  comandaController.removeItem(widget.produto!.codigo);
                }
              } else {
                comandaController.removeItem(widget.produto!.codigo);
              }
            },
            color: Colors.red,
            child: Icon(
              Icons.remove,
              size: 25,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(5),
            shape: CircleBorder(),
          ),
        ]),
      ],
    );
  }

  Widget _conteudoCentral() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 108,
        child: Column(
          children: [
            Text(
              widget.produto!.nome,
              maxLines: 3,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
              textAlign: TextAlign.start,
            ),
            Text(
              'R\$ ${f.format(widget.produto!.valor)}',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(ComandaController comandaController) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(color: Colors.black12, spreadRadius: 2.0, blurRadius: 5.0)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ImagemProdutoWidget(codProduto: widget.produto!.codigo),
          _conteudoCentral(),
          _acoes(comandaController),
        ],
      ),
    );
  }
}
