import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lanchonete/Controller/usuario_controller.dart';
import 'package:lanchonete/Models/Itens_Grade_model.dart';
import 'package:lanchonete/repositories/functions_repository.dart';
import 'package:provider/provider.dart';

import 'package:lanchonete/Components/Imagem_Produto_Widget.dart';
import 'package:lanchonete/Controller/Comanda.Controller.dart';
import 'package:lanchonete/Models/grade_produto_model.dart';
import 'package:lanchonete/Models/produtos_model.dart';
import 'package:lanchonete/Services/ProdutosService.dart';

enum Sabores { umSabor, doisSabores, tresSabores, quatroSabores }

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
  String idAgrupamento = '';
  final produtosService = ProdutosService();

  final tamanhoSelecionado = ValueNotifier<String>('G');
  final qtdSaboresEscolhido = ValueNotifier<Sabores>(Sabores.umSabor);

  var f = new NumberFormat("##0.00", "pt_BR");

  Future<void> getIdAgrupamento() async {
    try {
      final repository = FunctionsRepository();
      final response =
          await repository.fetchIncrementaGenerator('GEN_ID_AGRUPAMENTO');
      idAgrupamento = response.toString();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getIdAgrupamento();
  }

  String saboresToImage(Sabores sabores) {
    String imagem = 'assets/images/1 sabor/1.png';
    switch (sabores) {
      case Sabores.umSabor:
        imagem = 'assets/images/1 sabor/1.png';
        break;
      case Sabores.doisSabores:
        {
          switch (widget.itensList.value.length) {
            case 1:
              imagem = 'assets/images/2 sabores/1.png';
              break;
            case 2:
              imagem = 'assets/images/2 sabores/2.png';
              break;
            default:
              imagem = 'assets/images/2 sabores/1.png';
              break;
          }
          break;
        }
      case Sabores.tresSabores:
        {
          switch (widget.itensList.value.length) {
            case 1:
              imagem = 'assets/images/3 sabores/1.png';
              break;
            case 2:
              imagem = 'assets/images/3 sabores/2.png';
              break;
            case 3:
              imagem = 'assets/images/3 sabores/3.png';
              break;
            default:
              imagem = 'assets/images/3 sabores/1.png';
              break;
          }
          break;
        }
      case Sabores.quatroSabores:
        {
          switch (widget.itensList.value.length) {
            case 1:
              imagem = 'assets/images/4 sabores/1.png';
              break;
            case 2:
              imagem = 'assets/images/4 sabores/2.png';
              break;
            case 3:
              imagem = 'assets/images/4 sabores/3.png';
              break;
            case 4:
              imagem = 'assets/images/4 sabores/4.png';
              break;
            default:
              imagem = 'assets/images/4 sabores/1.png';
              break;
          }
          break;
        }
    }
    return imagem;
  }

  _buildPizzas() {
    final size = MediaQuery.of(context).size;
    return ValueListenableBuilder<Sabores>(
      valueListenable: qtdSaboresEscolhido,
      builder: (context, _, __) {
        return GestureDetector(
          onTap: () => _addOutroSabor(widget.itensList),
          child: SizedBox(
            height: size.height * 0.4,
            child: Image.asset(
              saboresToImage(
                qtdSaboresEscolhido.value,
              ),
            ),
          ),
        );
      },
    );
  }

  _buildTitulos(String titulo) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 30,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(3, 4),
                  blurRadius: 2,
                )
              ]),
          child: Center(
            child: Text(
              titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
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
                      if (grade.tamanho == 'P' ||
                          grade.tamanho == 'M' ||
                          grade.tamanho == 'G') {
                        qtdSaboresEscolhido.value = Sabores.umSabor;
                      }
                    },
                    child: ValueListenableBuilder<String>(
                        valueListenable: tamanhoSelecionado,
                        builder: (context, tamanhoEscolhido, widget) {
                          return Card(
                            color: grade.tamanho == tamanhoEscolhido
                                ? Colors.green
                                : Colors.white,
                            elevation: 10,
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
                },
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  _buildBotaoConfirmar(ComandaController comandaController) {
    final usuarioController = Provider.of<UsuarioController>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
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
                  grupo: 0,
                ),
                idAgrupamento,
                gradeProduto: grade,
                quantidade: item.quantidade,
                usuario: usuarioController.usuarioLogado.codigo,
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

  Widget _buildSabores() {
    final size = MediaQuery.of(context).size;
    return ValueListenableBuilder<Sabores>(
        valueListenable: qtdSaboresEscolhido,
        builder: (context, _, __) {
          return Expanded(
            flex: 1,
            child: ValueListenableBuilder<String>(
                valueListenable: tamanhoSelecionado,
                builder: (context, tamanho, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SaboresWidget(
                          widget: widget,
                          qtdSaboresEscolhido: qtdSaboresEscolhido,
                          width: size.width * 0.5 / 4,
                          tamanho: tamanho,
                          qtdSabores: 1),
                      SaboresWidget(
                          widget: widget,
                          qtdSaboresEscolhido: qtdSaboresEscolhido,
                          width: size.width * 0.5 / 4,
                          tamanho: tamanho,
                          qtdSabores: 2),
                      SaboresWidget(
                          widget: widget,
                          qtdSaboresEscolhido: qtdSaboresEscolhido,
                          width: size.width * 0.5 / 4,
                          tamanho: tamanho,
                          qtdSabores: 3),
                      SaboresWidget(
                          widget: widget,
                          qtdSaboresEscolhido: qtdSaboresEscolhido,
                          width: size.width * 0.5 / 4,
                          tamanho: tamanho,
                          qtdSabores: 4),
                    ],
                  );
                }),
          );
        });
  }

  Widget _buildNomePizzas() {
    return ValueListenableBuilder<Sabores>(
      valueListenable: qtdSaboresEscolhido,
      builder: (context, _, __) {
        return ValueListenableBuilder<String>(
          valueListenable: tamanhoSelecionado,
          builder: (context, _, __) {
            String nome = '';
            for (var item in widget.itensList.value) {
              if (widget.itensList.value.length == 1) {
                nome = '${item.nome} [${tamanhoSelecionado.value}]';
              } else {
                nome =
                    '${nome.replaceAll('/', '').replaceAll('[P]', '').replaceAll('[M]', '').replaceAll('[G]', '')} / ${item.nome} [${tamanhoSelecionado.value}]';
              }
            }
            return Center(
              child: Text(
                nome,
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildItemGrade(ValueNotifier<List<ItensGrade>> itensList,
      ComandaController comandaController) {
    return Column(
      children: [
        _buildNomePizzas(),
        _buildPizzas(),
        _buildTitulos('Sabores/Tamanhos'),
        _buildSabores(),
        _buildTamanhos(),
        _buildTotal(itensList),
        _buildBotaoConfirmar(comandaController),
      ],
    );
  }

  _addOutroSabor(ValueNotifier<List<ItensGrade>> itensList) {
    if ((qtdSaboresEscolhido.value == Sabores.umSabor) &&
        widget.itensList.value.length == 1) {
      return;
    }
    if ((qtdSaboresEscolhido.value == Sabores.doisSabores) &&
        widget.itensList.value.length == 2) {
      return;
    }
    if ((qtdSaboresEscolhido.value == Sabores.tresSabores) &&
        widget.itensList.value.length == 3) {
      return;
    }
    if ((qtdSaboresEscolhido.value == Sabores.quatroSabores) &&
        widget.itensList.value.length == 4) {
      return;
    }
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
                future: produtosService
                    .fetchProdutos('?grupo=${widget.produto.grupo}'),
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

class SaboresWidget extends StatelessWidget {
  const SaboresWidget({
    Key? key,
    required this.widget,
    required this.qtdSaboresEscolhido,
    required this.width,
    required this.qtdSabores,
    required this.tamanho,
  }) : super(key: key);

  final String tamanho;
  final int qtdSabores;
  final WidgetGradeProduto widget;
  final ValueNotifier<Sabores> qtdSaboresEscolhido;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if ((tamanho == 'P' || tamanho == 'M' || tamanho == 'G') &&
            qtdSabores > 2) {
          return;
        }
        if (widget.itensList.value.length > qtdSabores) {
          for (var i = 0; i < widget.itensList.value.length - qtdSabores; i++) {
            widget.itensList.value.removeLast();
          }
        }
        qtdSaboresEscolhido.value = Sabores.values[qtdSabores - 1];
      },
      child: SizedBox(
        width: width,
        child: Card(
          color: qtdSaboresEscolhido.value == Sabores.values[qtdSabores - 1]
              ? Colors.green
              : Colors.white,
          elevation: 10,
          child: Center(
            child: Text(
              qtdSabores.toString(),
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color:
                    qtdSaboresEscolhido.value == Sabores.values[qtdSabores - 1]
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
