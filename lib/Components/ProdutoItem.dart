import 'dart:convert';
import 'dart:ui';

import 'package:lanchonete/Constants.dart';
import 'package:lanchonete/Controller/Comanda.Controller.dart';
import 'package:lanchonete/Controller/Theme.Controller.dart';
import 'package:lanchonete/Models/complementos_model.dart';
import 'package:lanchonete/Models/produtos_model.dart';
import 'package:lanchonete/Services/ComplementoService.dart';
import 'package:lanchonete/Services/ProdutosService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProdutoItem extends StatefulWidget {
  final Produtos produto;
  final int mesa;
  final int categoria;

  const ProdutoItem(
      {Key key, this.produto, this.mesa, @required this.categoria})
      : super(key: key);

  @override
  _ProdutoItemState createState() => _ProdutoItemState();
}

class _ProdutoItemState extends State<ProdutoItem> {
  final produtosService = ProdutosService();
  String _observacao = '';
  final complementos = ValueNotifier<List<Complementos>>([]);
  int contador = 0;
  var f = new NumberFormat("##0.00", "pt_BR");

  @override
  void initState() {
    super.initState();
    fetchComplementos(widget.categoria).then((value) {
      complementos.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildItem();
  }

  Widget _imagemProduto() {
    return Container(
      width: 80,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          topLeft: Radius.circular(8.0),
        ),
        child: FutureBuilder<String>(
          future: produtosService.fetchFotoProduto(widget.produto.codigo),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.length > 0
                  ? Image.memory(
                      base64Decode(snapshot.data),
                      fit: BoxFit.cover,
                      height: 125,
                      width: 50,
                    )
                  : const Center(child: Text('Sem Foto'));
            } else {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.amber,
              ));
            }
          },
        ),
      ),
    );
  }

  Future<Widget> _telaObservacao() async {
    final comandaController =
        Provider.of<ComandaController>(context, listen: false);
    return await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Observação'),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextFormField(
              onChanged: (String obs) {
                _observacao = obs;
              },
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Constants.primaryColor,
            ),
            height: 50,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 10, right: 10),
            child: ElevatedButton(
              onPressed: () {
                comandaController.adicionaObservacao(
                    widget.produto.codigo, _observacao);
                Navigator.pop(context);
              },
              child: Text(
                'Salvar',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _acoes() {
    final comandaController =
        Provider.of<ComandaController>(context, listen: false);
    return Row(
      children: [
        Column(children: [
          MaterialButton(
            height: 20,
            onPressed: () {
              contador++;
              comandaController.adicionaItem(widget.produto);
              setState(() {});
            },
            color: Colors.green,
            child: Icon(
              Icons.exposure_plus_1,
              size: 25,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(5),
            shape: CircleBorder(),
          ),
          Text(
            contador.toString(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          MaterialButton(
            height: 20,
            onPressed: () {
              contador--;
              comandaController.removeItem(widget.produto.codigo);
              if (contador < 0) contador = 0;
              setState(() {});
            },
            color: Colors.red,
            child: Icon(
              Icons.exposure_minus_1,
              size: 25,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(5),
            shape: CircleBorder(),
          ),
        ]),
        Column(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
            onPressed: contador > 0
                ? () {
                    _telaObservacao();
                  }
                : null,
            color: Colors.green,
            icon: Icon(
              Icons.edit,
              size: 24,
              color: contador > 0 ? Colors.black : Colors.grey,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          IconButton(
            onPressed: contador > 0
                ? () {
                    _adicionais();
                  }
                : null,
            color: Colors.red,
            icon: Icon(
              Icons.add_circle,
              size: 24,
              color: contador > 0 ? Colors.black : Colors.grey,
            ),
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
              widget.produto.nome,
              maxLines: 3,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black),
              textAlign: TextAlign.start,
            ),
            Text(
              'R\$ ${f.format(widget.produto.valor)}',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem() {
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
        children: [
          _imagemProduto(),
          _conteudoCentral(),
          _acoes(),
        ],
      ),
    );
  }

  _acoesAdicional(int index) {
    return Row(children: [
      Column(mainAxisSize: MainAxisSize.min, children: [
        MaterialButton(
          height: 10,
          onPressed: complementos.value[index].selecionado
              ? () {
                  var auxComplemento = complementos.value;
                  auxComplemento[index].quantidade++;
                  complementos.value = [];
                  complementos.value = auxComplemento;
                }
              : null,
          color: Colors.green,
          child: complementos.value[index].selecionado
              ? Icon(
                  Icons.exposure_plus_1,
                  size: 20,
                  color: Colors.white,
                )
              : SizedBox(),
          padding: EdgeInsets.all(5),
          shape: CircleBorder(),
        ),
        ValueListenableBuilder<List<Complementos>>(
          valueListenable: complementos,
          builder: (context, value, child) => Text(
            value[index].selecionado ? value[index].quantidade.toString() : '',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        MaterialButton(
          height: 10,
          onPressed: complementos.value[index].selecionado
              ? () {
                  var auxComplemento = complementos.value;
                  auxComplemento[index].quantidade--;
                  if (auxComplemento[index].quantidade < 0)
                    auxComplemento[index].quantidade = 0;
                  complementos.value = [];
                  complementos.value = auxComplemento;
                }
              : null,
          color: Colors.red,
          child: complementos.value[index].selecionado
              ? Icon(
                  Icons.exposure_minus_1,
                  size: 20,
                  color: Colors.white,
                )
              : SizedBox(),
          padding: EdgeInsets.all(5),
          shape: CircleBorder(),
        ),
      ])
    ]);
  }

  _itemAdicional(Complementos complemento, int index) {
    final themeController = Provider.of<ThemeController>(context);
    return Container(
      margin: EdgeInsets.only(bottom: 5, right: 2, left: 2),
      decoration: BoxDecoration(
        color: themeController.isDark ? Colors.black87 : Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(0.4, 0.4)),
        ],
        borderRadius: BorderRadius.circular(7.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Checkbox(
            checkColor: Colors.green,
            onChanged: (bool value) {
              var auxComplemento = complementos.value;
              auxComplemento[index].selecionado = !complemento.selecionado;
              if (auxComplemento[index].selecionado) {
                auxComplemento[index].quantidade = 1;
              } else {
                auxComplemento[index].quantidade = 0;
              }
              complementos.value = [];
              complementos.value = auxComplemento;
            },
            value: complemento.selecionado,
          ),
          Text(complemento.nome.padRight(15).substring(0, 15)),
          _acoesAdicional(index),
        ],
      ),
    );
  }

  Future<Widget> _adicionais() async {
    final comandaController =
        Provider.of<ComandaController>(context, listen: false);
    return await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Adicionais'),
        children: [
          Container(
            height: 500,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                  child: ValueListenableBuilder<List<Complementos>>(
                    valueListenable: complementos,
                    builder: (context, lista, child) => ListView.builder(
                        itemCount: lista.length,
                        itemBuilder: (context, index) {
                          return _itemAdicional(lista[index], index);
                        }),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 5),
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () {
                      comandaController.adicionaComplementos(
                        widget.produto.codigo,
                        complementos.value
                            .where((element) => element.selecionado)
                            .toList(),
                      );
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Salvar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
