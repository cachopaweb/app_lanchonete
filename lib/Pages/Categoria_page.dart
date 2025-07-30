import 'dart:convert';

import 'package:lanchonete/Components/IconeCarrinho.dart';
import 'package:lanchonete/Components/ProdutoItem.dart';
import 'package:lanchonete/Controller/Comanda.Controller.dart';
import 'package:lanchonete/Models/produtos_model.dart';
import 'package:lanchonete/Pages/Carrinho_page.dart';
import 'package:lanchonete/Services/ProdutosService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lanchonete/Models/categoria_model.dart';
import 'package:lanchonete/Pages/Produtos_page.dart';
import 'package:lanchonete/Services/CategoriaService.dart';
import 'package:provider/provider.dart';

class CategoriaPage extends StatefulWidget {
  final int numeroMesa;

  const CategoriaPage({
    Key? key,
    required this.numeroMesa,
  }) : super(key: key);

  @override
  _CategoriaPageState createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {
  final _isSearching = ValueNotifier<bool>(false);
  List<Produtos> _listaProdutos = <Produtos>[];
  final _listaProdutosFiltrada = ValueNotifier<List<Produtos>>([]);
  final _serviceProdutos = ProdutosService();

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
                mesa: widget.numeroMesa,
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black,
                offset: Offset(4.0, 4.0),
                blurRadius: 5.0,
                spreadRadius: 1.0,
              )
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: FutureBuilder<String?>(
                  future: fetchFotoCategoria(item.codigo),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.memory(
                          base64Decode(snapshot.data!),
                          fit: BoxFit.cover,
                        ),
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
                        item.nome!,
                        style: TextStyle(
                            fontSize: item.nome!.length > 8 ? 18 : 25,
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

  Widget _cabecalho() {
    return ValueListenableBuilder(
      valueListenable: _isSearching,
      builder: (_, dynamic value, __) {
        return !_isSearching.value
            ? Center(
                child: Text(
                  'Categorias | Mesa N° ${widget.numeroMesa.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : TextFormField(
                onChanged: _pesquisaProdutos,
                autofocus: true,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  suffix: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      _isSearching.value = false;
                    },
                  ),
                ),
              );
      },
    );
  }

  Widget _bodyCategoria() {
    return FutureBuilder<List<Categoria>>(
      future: fetchCategorias(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return _buildCategorias(snapshot.data![index]);
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
          );
        } else {
          if (snapshot.hasError) {
            final snackBar = SnackBar(
                content: Text(
                    'Erro ao buscar categorias!\n Verifique a configuração do Servidor Local!'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            return snackBar;
          } else {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.amber[400],
            ));
          }
        }
      },
    );
  }

  _pesquisaProdutos(String texto) {
    _listaProdutosFiltrada.value = [];
    if (texto.length > 1) {
      _listaProdutosFiltrada.value = _listaProdutos
          .where(
            (e) => e.nome.toUpperCase().contains(texto.toUpperCase()),
          )
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _serviceProdutos
        .fetchProdutos('')
        .then((value) => _listaProdutos = _listaProdutosFiltrada.value = value);
  }

  Widget _bodyPesquisaProduto() {
    return ValueListenableBuilder<List<Produtos>>(
      valueListenable: _listaProdutosFiltrada,
      builder: (context, produtos, _) {
        return ListView(
          children: produtos
              .map((item) => ProdutoItem(
                    produto: item,
                    mesa: widget.numeroMesa,
                    categoria: item.categoria,
                  ))
              .toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        var controller = Provider.of<ComandaController>(context, listen: false);
        var cartIsEmpty = controller.isEmpty;
        if (cartIsEmpty) {
          Navigator.pop(context);
          return;
        } else {
          final snackBar = SnackBar(
              content: Text(
                  'Não é possível sair da tela enquanto houver produtos na mesa!'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: _cabecalho(),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _isSearching.value = !_isSearching.value;
              },
            ),
          ],
        ),
        body: ValueListenableBuilder(
          valueListenable: _isSearching,
          builder: (context, dynamic searching, _) {
            return !searching ? _bodyCategoria() : _bodyPesquisaProduto();
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.amber[500],
          onPressed: () {
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (_) => CarrinhoPage(mesa: widget.numeroMesa),
              ),
            );
          },
          child: IconeCarrinho(
            onClick: () => Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (_) => CarrinhoPage(mesa: widget.numeroMesa),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
