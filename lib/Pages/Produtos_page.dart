import 'package:app_lanchonete/Components/IconeCarrinho.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app_lanchonete/Components/ProdutoItem.dart';
import 'package:app_lanchonete/Models/produtos_model.dart';
import 'package:app_lanchonete/Services/ComandaService.dart';
import 'package:app_lanchonete/Services/ProdutosService.dart';

class ProdutosPage extends StatefulWidget {
  final int idCategoria;
  final String categoria;
  final int mesa;

  ProdutosPage({
    Key key,
    @required this.idCategoria,
    @required this.categoria,
    @required this.mesa,
  }) : super(key: key);

  @override
  _ProdutosPageState createState() => _ProdutosPageState();
}

class _ProdutosPageState extends State<ProdutosPage> {
  final produtoService = ProdutosService();
  final comandaService = ComandaService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            '${widget.categoria.trim()} | Mesa ${widget.mesa.toString()}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconeCarrinho(),
          IconButton(
              icon: Icon(
                Icons.done,
                size: 30,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
      body: FutureBuilder<List<Produtos>>(
        future: produtoService.fetchProdutos(widget.idCategoria.toString()),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                var produto = snapshot.data[index];
                return ProdutoItem(
                  produto: produto,
                  mesa: widget.mesa,
                  categoria: widget.idCategoria ?? 0,
                );
              },
            );
          } else {
            return (Center(
              child: CircularProgressIndicator(),
            ));
          }
        },
      ),
    );
  }
}
