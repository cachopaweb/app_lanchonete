import 'package:lanchonete/Components/Item_Lista_widget.dart';
import 'package:lanchonete/Constants.dart';
import 'package:lanchonete/Controller/Comanda.Controller.dart';
import 'package:lanchonete/Controller/Mesas.Controller.dart';
import 'package:lanchonete/Models/comanda_model.dart';
import 'package:lanchonete/Models/itens_model.dart';
import 'package:lanchonete/Pages/Categoria_page.dart';
import 'package:lanchonete/Pages/Tela_carregamento_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetalheComandaPage extends StatefulWidget {
  final int numeroMesa;

  const DetalheComandaPage({Key? key, required this.numeroMesa})
      : super(key: key);

  @override
  _DetalheComandaPageState createState() => _DetalheComandaPageState();
}

class _DetalheComandaPageState extends State<DetalheComandaPage> {
  var f = NumberFormat('##0.00', 'pt_BR');
  Comanda comanda = Comanda();
  bool carregando = false;
  final recarregarItens = ValueNotifier(false);

  _buildComplementos(Itens item) {
    return item.complementos!.isNotEmpty
        ? Column(
            mainAxisSize: MainAxisSize.min,
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
              Navigator.pop(context);
            },
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.red),
            ),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ComandaController>(context, listen: false)
                  .deletarItemComanda(item.codigo!)
                  .then((value) {
                if (value) {
                  final snackBar = SnackBar(
                    content: Text('Item deletado com sucesso!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  comanda.itens!.remove(item);
                  if (comanda.itens!.length == 0) {
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
                _buscarComanda();
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
              item.obs!,
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
                  return TelaCarregamento(
                    messageAwait: 'Aguarde o encerramento...',
                    messageSuccess: 'Encerramento realizado com sucesso...',
                    messageError: 'Erro ao tentar realizar o fechamento!',
                    comanda: widget.numeroMesa,
                    finalization: true,
                    mesa: widget.numeroMesa,
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
    _buscarComanda();
  }

  _buscarComanda() {
    setState(() {
      carregando = true;
    });
    Provider.of<ComandaController>(context, listen: false)
        .buscaComanda(widget.numeroMesa)
        .then((value) {
      setState(() {
        comanda = value;
        carregando = false;
      });
    }).catchError((error) {
      final snackBar = SnackBar(
          content: Text(
              'Erro ao buscar detalhes da Comanda ${widget.numeroMesa.toString()}!\n Verifique a configuração do Servidor Local!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {
        carregando = false;
      });
    });
  }

  _buildItens() {
    return Flexible(
      child: ListView.builder(
        itemCount: comanda.itens!.length,
        itemBuilder: (context, index) => Card(
          margin: EdgeInsets.all(1),
          elevation: 5,
          child: _itemLista(comanda.itens![index]),
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
              style: Theme.of(context).textTheme.displayLarge),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: recarregarItens,
        builder: (context, dynamic value, child) => Column(
          children: [
            !carregando
                ? comanda.itens!.isNotEmpty
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
            comanda.itens!.isNotEmpty
                ? Container(
                    alignment: Alignment.bottomCenter,
                    height: 60,
                    margin: EdgeInsets.only(left: 10, right: 10),
                    width: MediaQuery.of(context).size.width,
                    child: _botao(),
                  )
                : SizedBox(),
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
