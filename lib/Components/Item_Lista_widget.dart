import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:lanchonete/Models/itens_model.dart';

class ItemListaWidget extends StatelessWidget {
  final Itens item;
  final Function(Itens item) onDelete;
  final f = NumberFormat('##0.00', 'pt_BR');

  ItemListaWidget({
    Key? key,
    required this.item,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: item.grade! > 0
          ? Column(
              children: [
                Text(
                  'TAM',
                  style: TextStyle(fontSize: 12),
                ),
                Text('${item.gradeProduto!.tamanho}'),
              ],
            )
          : SizedBox(),
      title: Text(
        item.nome!,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        item.grade! > 0
            ? '${item.quantidade} x ${f.format(item.gradeProduto!.valor)} = ${f.format(item.valor)}'
            : '${item.quantidade} x ${f.format(item.valor)} = ${f.format(item.quantidade! * item.valor!)}',
        style: TextStyle(fontSize: 16),
      ),
      trailing: Column(
        children: [
          Expanded(
            flex: 1,
            child: IconButton(
              iconSize: 20,
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                onDelete(item);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              f.format(item.valor),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
