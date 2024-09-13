import 'package:lanchonete/Components/Acoes_widget.dart';
import 'package:lanchonete/Components/Item_Lista_widget.dart';
import 'package:lanchonete/Models/itens_model.dart';
import 'package:flutter/material.dart';

import 'package:lanchonete/Controller/Comanda.Controller.dart';
import 'package:intl/intl.dart';
import 'package:lanchonete/Pages/Tela_carregamento_page.dart';
import 'package:provider/provider.dart';

class CarrinhoPage extends StatefulWidget {
  final int mesa;

  CarrinhoPage({
    Key? key,
    required this.mesa,
  }) : super(key: key);

  @override
  _CarrinhoPageState createState() => _CarrinhoPageState();
}

class _CarrinhoPageState extends State<CarrinhoPage> {
  var f = NumberFormat('##0.00', 'pt_BR');

  @override
  Widget build(BuildContext context) {
    final comandaController = Provider.of<ComandaController>(context);

    _confirmarSalvamento() {
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text('Confirmar Comanda?', textAlign: TextAlign.center),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar',
                      style: TextStyle(
                        color: Colors.redAccent,
                      )),
                ),
                SizedBox(
                  width: 30,
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TelaCarregamento(
                          messageAwait: 'Aguarde enviando comanda...',
                          messageSuccess: 'Comanda enviada com sucesso!',
                          messageError: 'Erro ao enviar comanda!',
                          finalization: false,
                          mesa: widget.mesa,
                          comanda: 0,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Confirmar',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    _buildComplementos(Itens item) {
      return item.complementos!.isNotEmpty
          ? Column(
              mainAxisSize: MainAxisSize.max,
              children: item.complementos!
                  .map(
                    (e) => ListTile(
                      visualDensity: VisualDensity(vertical: 0.1),
                      dense: true,
                      title: Text(
                        ' +  ${e.nome}',
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        '${e.quantidade.toString()} * ${f.format(e.valor)} = ${f.format(e.quantidade! * e.valor)}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  )
                  .toList(),
            )
          : SizedBox();
    }

    _confirmarExclusao(Itens item) {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(
            'Deseja excluir este item?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'Cancelar',
                style: TextStyle(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'Confirmar',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        ),
      ).then((confirmar) {
        if (confirmar) {
          Provider.of<ComandaController>(context, listen: false)
              .removeItemCarrinho(item);
          setState(() {});
        }
      });
    }

    _buildObservacao(Itens item) {
      return item.obs != null && item.obs!.isNotEmpty
          ? ListTile(
              title: Text(
                'Observação:',
                style: TextStyle(fontSize: 15),
              ),
              subtitle: Text(
                item.obs ?? '',
                style: TextStyle(fontSize: 15),
              ),
            )
          : SizedBox();
    }

    _buildTotal(Itens item) {
      double totalComplementos = 0;

      for (var item in item.complementos!) {
        totalComplementos += item.valor * item.quantidade;
      }

      return ListTile(
        title: Text(
          'Total: ',
          textAlign: TextAlign.end,
        ),
        trailing: Text(f.format(item.valor! + totalComplementos)),
      );
    }

    Widget _itemLista(Itens item) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ItemListaWidget(item: item, onDelete: _confirmarExclusao),
          _buildComplementos(item),
          item.complementos!.length > 0 ? _buildTotal(item) : SizedBox(),
          Row(
            children: [
              Expanded(child: _buildObservacao(item)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: AcoesWidget(item: item),
              ),
            ],
          ),
        ],
      );
    }

    _buildList(List<Itens> itens) {
      return Flexible(
        child: ListView.builder(
          itemCount: itens.length,
          itemBuilder: (context, index) => Card(
            margin: EdgeInsets.all(1),
            elevation: 5,
            child: _itemLista(itens[index]),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Carrinho | Mesa Nº ${widget.mesa.toString().padLeft(2, '0')}',
        ),
      ),
      body: Column(
        children: [
          Consumer<ComandaController>(
            builder: (context, comanda, _) {
              return comanda.itens.isNotEmpty
                  ? _buildList(comanda.itens)
                  : Center(
                      child: Text(
                        'Não há itens!',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    );
            },
          ),
          !comandaController.isEmpty
              ? Consumer<ComandaController>(builder: (context, comanda, _) {
                  return Text(
                    'Total ${f.format(comanda.valorComanda)}',
                    style: TextStyle(fontSize: 35),
                  );
                })
              : SizedBox(),
          !comandaController.isEmpty
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () {
                      _confirmarSalvamento();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Enviar Comanda',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
