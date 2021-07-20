import 'dart:ui';

import 'package:lanchonete/Constants.dart';
import 'package:lanchonete/Controller/Mesas.Controller.dart';
import 'package:lanchonete/Models/comanda_model.dart';
import 'package:lanchonete/Models/itens_model.dart';
import 'package:lanchonete/Pages/Categoria_page.dart';
import 'package:lanchonete/Pages/EncerramentoComanda_page.dart';
import 'package:lanchonete/Services/ComandaService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetalheComandaPage extends StatefulWidget {
  final int numeroMesa;

  const DetalheComandaPage({Key key, this.numeroMesa}) : super(key: key);

  @override
  _DetalheComandaPageState createState() => _DetalheComandaPageState();
}

class _DetalheComandaPageState extends State<DetalheComandaPage> {
  var f = NumberFormat('##0.00', 'pt_BR');
  final comandaService = ComandaService();
  Comanda comanda = Comanda();
  bool carregando = false;
  final recarregarItens = ValueNotifier(false);

  _buildComplementos(Itens item) {
    return item.complementos.isNotEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: item.complementos
                .map(
                  (e) => ListTile(
                    visualDensity: VisualDensity(vertical: 0.1),
                    dense: true,
                    title: Text(
                      ' +  ${e.nome}',
                      style: TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      '${e.quantidade.toString()} * ${f.format(e.valor)} = ${f.format(e.quantidade * e.valor)}',
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
              Navigator.pop(context);
            },
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              comandaService.deletarItemComanda(item.codigo).then((value) {
                if (value) {
                  comandaService.notificarOperacional();
                  final snackBar = SnackBar(
                    content: Text('Item deletado com sucesso!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  comanda.itens.remove(item);
                  if (comanda.itens.length == 0) {
                    Navigator.pop(context);
                    MesaController.instance.atualizar.value = true;
                  } else {
                    recarregarItens.value = true;
                  }
                } else {
                  final snackBar = SnackBar(
                    content: Text('Falha ao deletar Item da comanda!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                Navigator.pop(context);
              });
            },
            child: Text(
              'Confirmar',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  _buildObservacao(Itens item) {
    return item.obs != ''
        ? ListTile(
            title: Text(
              'Observação:',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              item.obs,
              style: TextStyle(fontSize: 15),
            ),
          )
        : SizedBox();
  }

  _buildTotal(Itens item) {
    double totalComplementos = 0;

    for (var item in item.complementos) {
      totalComplementos += item.valor * item.quantidade;
    }

    return ListTile(
      title: Text(
        'Total: ',
        textAlign: TextAlign.end,
      ),
      trailing: Text(f.format(item.valor + totalComplementos)),
    );
  }

  Widget _itemLista(Itens item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Text(
            item.nome.trim().padRight(18).substring(0, 18) ?? "",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                f.format(item.valor),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  _confirmarExclusao(item);
                },
              ),
            ],
          ),
        ),
        _buildComplementos(item),
        item.complementos.length > 0 ? _buildTotal(item) : SizedBox(),
        _buildObservacao(item)
      ],
    );
  }

  _confirmarEncerramento() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(
          'Deseja encerrar a Comanda ${widget.numeroMesa}?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) {
                  return EncerramentoComanda(
                    comanda: widget.numeroMesa,
                  );
                }),
              );
            },
            child: Text(
              'Confirmar',
              style: TextStyle(color: Colors.green),
            ),
          ),
        ],
      ),
    );
  }

  _botao() {
    return Container(
      margin: EdgeInsets.all(5.0),
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton(
        onPressed: () {
          _confirmarEncerramento();
        },
        child: Text(
          'Encerrar',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      carregando = true;
    });
    comandaService.fetchComanda(widget.numeroMesa).then((value) {
      setState(() {
        comanda = value;
        carregando = false;
      });
    }).catchError((error) {
      final snackBar = SnackBar(
          content: Text(
              'Erro ao buscar detalhes da Comanda ${widget.numeroMesa.toString()}! ${error.toString()}'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        carregando = false;
      });
    });
  }

  _buildItens() {
    return Flexible(
      child: ListView.builder(
        itemCount: comanda.itens.length,
        itemBuilder: (context, index) => Card(
          margin: EdgeInsets.all(1),
          elevation: 5,
          child: _itemLista(comanda.itens[index]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
              'Produtos | Mesa ${widget.numeroMesa.toString().padLeft(2, '0')}',
              style: Theme.of(context).textTheme.headline1),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: recarregarItens,
        builder: (context, value, child) => Column(
          children: [
            !carregando
                ? comanda.itens.isNotEmpty
                    ? _buildItens()
                    : Center(
                        child: Text(
                          'Não há itens!',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      )
                : Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Constants.primaryColor,
                    ),
                  ),
            !carregando
                ? Text(
                    'Total ${f.format(comanda.valor ?? 0)}',
                    style: TextStyle(fontSize: 35),
                  )
                : Center(child: Text('Aguarde carregando!')),
            Container(
              alignment: Alignment.bottomCenter,
              height: 60,
              margin: EdgeInsets.only(left: 10, right: 10),
              width: MediaQuery.of(context).size.width,
              child: _botao(),
            )
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
            backgroundColor: Constants.primaryColor,
            child: Icon(
              Icons.add_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) => CategoriaPage(numeroMesa: widget.numeroMesa),
                ),
              );
            }),
      ),
    );
  }
}
