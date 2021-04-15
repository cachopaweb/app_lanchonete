import 'dart:convert';
import 'dart:ui';

import 'package:app_lanchonete/Components/IconeCarrinho.dart';
import 'package:app_lanchonete/Controller/Mesas.Controller.dart';
import 'package:app_lanchonete/Pages/Carrinho_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app_lanchonete/Models/categoria_model.dart';
import 'package:app_lanchonete/Pages/Produtos_page.dart';
import 'package:app_lanchonete/Services/CategoriaService.dart';
import 'package:app_lanchonete/Services/MesaService.dart';

class CategoriaPage extends StatefulWidget {
  final int numeroMesa;

  const CategoriaPage({
    Key key,
    @required this.numeroMesa,
  }) : super(key: key);

  @override
  _CategoriaPageState createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  final mesaService = MesaService();

  Widget _buildCategorias(Categoria item) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => ProdutosPage(
                    idCategoria: item.codigo,
                    categoria: item.nome,
                    mesa: widget.numeroMesa),
              ));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Colors.black,
                  offset: Offset(4.0, 4.0),
                  blurRadius: 5.0,
                  spreadRadius: 1.0)
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                child: FutureBuilder<String>(
                  future: fetchFotoCategoria(item.codigo),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Image.memory(
                        base64Decode(snapshot.data),
                        fit: BoxFit.cover,
                      );
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Colors.amber,
                      ));
                    }
                  },
                ),
              ),
              Container(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.black87),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item.nome,
                        style: TextStyle(
                            fontSize: item.nome.length > 8 ? 18 : 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
            'Categorias | Mesa N° ${widget.numeroMesa.toString().padLeft(2, '0')}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconeCarrinho(
            onClick: () {
              Navigator.of(context).push(CupertinoPageRoute(
                  builder: (_) => CarrinhoPage(mesa: widget.numeroMesa)));
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Categoria>>(
        future: fetchCategorias(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return _buildCategorias(snapshot.data[index]);
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
            );
          } else {
            if (snapshot.hasError) {
              final snackBar = SnackBar(
                  content: Text(
                      'Erro ao buscar categorias!\n ${snapshot.error.toString()}'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.amber[400],
              ));
            }
          }
        },
      ),
    );
  }
}
