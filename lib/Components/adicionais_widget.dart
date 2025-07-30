import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Controller/Comanda.Controller.dart';
import '../Models/complementos_model.dart';
import '../Models/itens_model.dart';

class AdicionaisWidget extends StatefulWidget {
  final Itens item;
  final List<Complementos> complementos;
  const AdicionaisWidget({
    Key? key,
    required this.item,
    required this.complementos,
  }) : super(key: key);

  @override
  State<AdicionaisWidget> createState() => _AdicionaisWidgetState();
}

class _AdicionaisWidgetState extends State<AdicionaisWidget> {
  var auxItem = Itens();
  var auxComplementos = <Complementos>[];

  @override
  initState() {
    super.initState();
    auxItem = widget.item;
    auxComplementos = widget.complementos;
  }

  _acoesAdicional(int index) {
    return Row(children: [
      Column(mainAxisSize: MainAxisSize.min, children: [
        MaterialButton(
          height: 10,
          onPressed: auxComplementos[index].selecionado!
              ? () {
                  auxComplementos[index].quantidade =
                      auxComplementos[index].quantidade! + 1;

                  auxItem.complementos!.clear();
                  final complementos =
                      auxComplementos.where((e) => e.selecionado!).toList();
                  auxItem.complementos = complementos;
                  setState(() {});
                }
              : null,
          color: Colors.green,
          child: auxComplementos[index].selecionado!
              ? Icon(
                  Icons.exposure_plus_1,
                  size: 20,
                  color: Colors.white,
                )
              : SizedBox(),
          padding: EdgeInsets.all(5),
          shape: CircleBorder(),
        ),
        Text(
          auxComplementos[index].selecionado!
              ? auxComplementos[index].quantidade.toString()
              : '',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        MaterialButton(
          height: 10,
          onPressed: auxComplementos[index].selecionado!
              ? () {
                  auxComplementos[index].quantidade =
                      auxComplementos[index].quantidade! - 1;
                  if (auxComplementos[index].quantidade! < 0)
                    auxComplementos[index].quantidade = 0;
                  auxItem.complementos!.clear();
                  final complementos =
                      auxComplementos.where((e) => e.selecionado!).toList();
                  auxItem.complementos = complementos;
                  setState(() {});
                }
              : null,
          color: Colors.red,
          child: auxComplementos[index].selecionado!
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

  _itemAdicional(int index) {
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * .9,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Checkbox(
                checkColor: Colors.green,
                onChanged: (bool? value) {
                  auxComplementos[index].selecionado =
                      !auxComplementos[index].selecionado!;
                  if (auxComplementos[index].selecionado!) {
                    auxComplementos[index].quantidade = 1;
                  } else {
                    auxComplementos[index].quantidade = 0;
                  }
                  auxItem.complementos!.clear();
                  final complementos =
                      auxComplementos.where((e) => e.selecionado!).toList();
                  auxItem.complementos = complementos;
                  setState(() {});
                },
                value: auxComplementos[index].selecionado,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .4,
              child: Text(
                auxComplementos[index].nome!,
              ),
            ),
            Flexible(
              flex: 2,
              child: SizedBox(
                child: _acoesAdicional(index),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _adicionais(Itens item) {
    return SimpleDialog(
      title: Text('Adicionais'),
      children: [
        Container(
          height: 500,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: widget.complementos.length,
                  itemBuilder: (context, index) {
                    if (auxItem.complementos!.isNotEmpty &&
                        index <= auxItem.complementos!.length - 1) {
                      final itemExistente = auxComplementos.indexWhere((e) =>
                          e.codigo == auxItem.complementos![index].codigo);
                      if (itemExistente > -1) {
                        auxComplementos[itemExistente].selecionado =
                            auxItem.complementos![index].selecionado;
                        auxComplementos[itemExistente].quantidade =
                            auxItem.complementos![index].quantidade;
                      }
                    }
                    return _itemAdicional(index);
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                width: MediaQuery.of(context).size.width,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                    Colors.amber,
                  )),
                  onPressed: () {
                    final comandaController =
                        Provider.of<ComandaController>(context, listen: false);
                    comandaController.adicionaComplementos(
                      item.codigo,
                      auxItem.complementos!,
                    );
                    Navigator.pop(context, true);
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
    );
  }

  _buildBody(Itens item) {
    return _adicionais(item);
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(auxItem);
  }
}
