import 'package:lanchonete/Constants.dart';
import 'package:lanchonete/Models/produtos_model.dart';
import 'package:lanchonete/Services/ProdutosService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsultaProdutosPage extends StatefulWidget {
  @override
  _ConsultaProdutosPageState createState() => _ConsultaProdutosPageState();
}

class _ConsultaProdutosPageState extends State<ConsultaProdutosPage> {
  final produtoService = ProdutosService();
  var f = NumberFormat('R\$ ###.00', 'pt_BR');
  bool carregando = false;
  bool isSearch = false;
  List<Produtos> listaProdutos = <Produtos>[];
  List<Produtos> listaProdutosFiltrada = <Produtos>[];

  @override
  void initState() {
    super.initState();
    carregando = true;
    produtoService.fetchProdutos('').then((value) {
      setState(() {
        carregando = false;
        listaProdutos = listaProdutosFiltrada = value;
      });
    }).catchError((error) {
      setState(() {
        carregando = false;
      });
      final snackBar = SnackBar(
          content: Text(
              'Erro ao buscar produtos! \n Verifique a configuração do Servidor Local!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  _buildListaProdutos() {
    return listaProdutosFiltrada.length > 0
        ? ListView.builder(
            itemCount: listaProdutosFiltrada.length,
            itemBuilder: (context, index) {
              final produto = listaProdutosFiltrada[index];
              return Card(
                elevation: 5,
                child: ListTile(
                  title: Text(produto.nome),
                  leading: Text(produto.codigo.toString()),
                  trailing: Text(f.format(produto.valor)),
                ),
              );
            })
        : Center(
            child: Text('Produto não encontrado!'),
          );
  }

  _searchProdutos(String busca) {
    setState(() {
      if (busca != '') {
        listaProdutosFiltrada = listaProdutos
            .where((element) =>
                element.nome.toUpperCase().contains(busca.toUpperCase()))
            .toList();
      } else {
        setState(() {
          listaProdutosFiltrada = listaProdutos;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: !isSearch
                  ? Text(
                      'Consulta Produtos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : TextFormField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      onChanged: (String texto) {
                        _searchProdutos(texto);
                      },
                    )),
          actions: [
            !isSearch
                ? IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearch = true;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        isSearch = false;
                      });
                    },
                  )
          ],
        ),
        body: !carregando
            ? _buildListaProdutos()
            : Center(
                child: CircularProgressIndicator(
                  backgroundColor: Constants.primaryColor,
                ),
              ));
  }
}
