import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lanchonete/Models/Itens_Grade_model.dart';
import 'package:provider/provider.dart';

import 'package:lanchonete/Components/Imagem_Produto_Widget.dart';
import 'package:lanchonete/Controller/Comanda.Controller.dart';
import 'package:lanchonete/Models/grade_produto_model.dart';
import 'package:lanchonete/Models/produtos_model.dart';
import 'package:lanchonete/Services/ProdutosService.dart';

class WidgetGradeProduto extends StatefulWidget {
  final Produtos produto;
  final int categoria;
  final ValueNotifier<List<ItensGrade>> itensList;

  WidgetGradeProduto({
    Key? key,
    required this.produto,
    required this.categoria,
    required this.itensList,
  }) : super(key: key);

  @override
  _WidgetGradeProdutoState createState() => _WidgetGradeProdutoState();
}

class _WidgetGradeProdutoState extends State<WidgetGradeProduto> {
  final produtosService = ProdutosService();

  final tamanhoSelecionado = ValueNotifier<String>('G');

  var f = new NumberFormat("##0.00", "pt_BR");

  _buildItensSelecionados() {
    return Expanded(
      flex: 6,
      child: ListView.builder(
        itemCount: widget.itensList.value.length,
        itemBuilder: (context, index) {
          var item = widget.itensList.value[index];
          return Card(
            elevation: 5,
            child: ListTile(
              leading: ImagemProdutoWidget(
                codProduto: item.produto,
              ),
              title: Text(
                item.nome,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                children: [
                  ValueListenableBuilder<String>(
                      valueListenable: tamanhoSelecionado,
                      builder: (context, snapshot, _) {
                        return Text(
                          tamanhoSelecionado.value,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                  ValueListenableBuilder<String>(
                    valueListenable: tamanhoSelecionado,
                    child: Center(child: CircularProgressIndicator()),
                    builder: (context, tamanho, widget) {
                      return Text(
                        '${item.quantidade.toStringAsFixed(2)} x ${f.format(item.valorFromTamanho(tamanho))} = ${f.format(item.valorFromTamanho(tamanho) * item.quantidade)}',
                        style: TextStyle(fontSize: 16),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _buildBotaoAdicionar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 40,
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.amber),
          ),
          child: Icon(Icons.add, color: Colors.black),
          onPressed: () {
            _addOutroSabor(widget.itensList);
          },
        ),
      ),
    );
  }

  _buildTamanhos() {
    return Expanded(
      flex: 2,
      child: Container(
        margin: EdgeInsets.all(8),
        child: FutureBuilder<List<GradeProduto>>(
            future: ProdutosService().fetchGradesProduto(widget.produto.codigo),
            builder: (context, gradeList) {
              if (gradeList.hasData) {
                return GridView.builder(
                    itemCount: gradeList.data!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: gradeList.data!.length),
                    itemBuilder: (context, index) {
                      var grade = gradeList.data![index];
                      return GestureDetector(
                        onTap: () {
                          tamanhoSelecionado.value = grade.tamanho;
                        },
                        child: ValueListenableBuilder<String>(
                            valueListenable: tamanhoSelecionado,
                            builder: (context, tamanhoEscolhido, widget) {
                              return Card(
                                color: grade.tamanho == tamanhoEscolhido
                                    ? Colors.green
                                    : Colors.white,
                                elevation: 7,
                                child: Center(
                                  child: Text(
                                    grade.tamanho,
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: grade.tamanho == tamanhoEscolhido
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  _buildBotaoConfirmar(ComandaController comandaController) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.amber,
            ),
          ),
          child: Text(
            'Confirmar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black,
              fontSize: 20,
            ),
          ),
          onPressed: () async {
            for (var item in widget.itensList.value) {
              var grade = await ProdutosService()
                  .fetchGradeProduto(item.produto, tamanhoSelecionado.value);
              comandaController.adicionaItem(
                Produtos(
                  codigo: item.produto,
                  nome: item.nome,
                  valor: grade.valor * item.quantidade,
                  categoria: widget.categoria,
                  grade: grade.codigo,
                ),
                gradeProduto: grade,
                quantidade: item.quantidade,
              );
            }
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  double _somaTotal(List<ItensGrade> itens, tamanho) {
    var total = itens
        .map((e) => e.valorFromTamanho(tamanho) * e.quantidade)
        .reduce((a, b) => a + b);
    return total;
  }

  _buildTotal(ValueNotifier<List<ItensGrade>> itensList) {
    return Container(
      margin: EdgeInsets.all(8),
      height: 40,
      child: Center(
        child: ValueListenableBuilder<List<ItensGrade>>(
            valueListenable: itensList,
            builder: (context, itens, _) {
              return ValueListenableBuilder<String>(
                  valueListenable: tamanhoSelecionado,
                  builder: (context, tamanho, _) {
                    return Text(
                      'Total: R\$ ${f.format(_somaTotal(itens, tamanho))}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  });
            }),
      ),
    );
  }

  Widget _buildItemGrade(ValueNotifier<List<ItensGrade>> itensList,
      ComandaController comandaController) {
    return Column(
      children: [
        _buildItensSelecionados(),
        _buildBotaoAdicionar(),
        _buildTamanhos(),
        _buildTotal(itensList),
        _buildBotaoConfirmar(comandaController),
      ],
    );
  }

  _addOutroSabor(ValueNotifier<List<ItensGrade>> itensList) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Outro Sabor'),
            ),
            Container(
              child: FutureBuilder<List<Produtos>>(
                future:
                    produtosService.fetchProdutos(widget.categoria.toString()),
                builder: (dialogContext, snapshot) {
                  if (snapshot.hasData) {
                    return Expanded(
                      child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (dialogContext, index) {
                            var produto = snapshot.data![index];
                            return Card(
                              elevation: 5,
                              child: ListTile(
                                leading: ImagemProdutoWidget(
                                    codProduto: produto.codigo),
                                title: Text(
                                  produto.nome,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${f.format(produto.valor)}',
                                  style: TextStyle(fontSize: 16),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () async {
                                    var grades = await ProdutosService()
                                        .fetchGradesProduto(produto.codigo);
                                    var itens = itensList.value
                                        .map(
                                          (e) => ItensGrade(
                                            produto: e.produto,
                                            nome: e.nome,
                                            quantidade: 1 /
                                                (itensList.value.length + 1),
                                            grade: e.grade,
                                          ),
                                        )
                                        .toList();
                                    itensList.value = [
                                      ...itens,
                                      ItensGrade(
                                        produto: produto.codigo,
                                        nome: produto.nome,
                                        quantidade:
                                            1 / (itensList.value.length + 1),
                                        grade: grades,
                                      )
                                    ];
                                    Navigator.of(dialogContext).pop();
                                  },
                                ),
                              ),
                            );
                          }),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.amber,
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final comandaController =
        Provider.of<ComandaController>(context, listen: false);
    return _buildItemGrade(widget.itensList, comandaController);
  }
}
