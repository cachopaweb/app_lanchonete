import 'package:lanchonete/Components/CardsMesas.dart';
import 'package:lanchonete/Controller/Mesas.Controller.dart';
import 'package:lanchonete/Models/mesa_model.dart';
import 'package:lanchonete/Services/MesaService.dart';
import 'package:flutter/material.dart';

class MesasPage extends StatefulWidget {
  @override
  _MesasPageState createState() => _MesasPageState();
}

class _MesasPageState extends State<MesasPage> {
  final mesaService = MesaService();
  List<Mesa> listaMesas = <Mesa>[];
  @override
  void initState() {
    super.initState();
    mesaService
        .fetchMesas()
        .then((dados) => setState(() {
              listaMesas = dados;
            }))
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Erro ao Buscar mesas!\n Verifique a configuração do Servidor Local!'),
        ),
      );
    });
  }

  List<Widget> buildMesas(bool atualizar) {
    if (atualizar) {
      mesaService.fetchMesas().then((dados) => setState(() {
            listaMesas = dados;
          }));
      MesaController.instance.atualizar.value = false;
    }
    List<Widget> cards = <Widget>[];
    if (listaMesas.length > 0) {
      for (var mesa in listaMesas) {
        cards.add(
          CardsMesas(
              numeroMesa: int.parse(mesa.nome!),
              estado: mesa.estado,
              valor: mesa.valor ?? 0.0),
        );
      }
    } else {
      cards.add(CardsMesas(
        numeroMesa: 1,
        estado: 'A',
        valor: 0,
      ));
    }
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 60), () {
      MesaController.instance.atualizar.value = true;
    });

    return ValueListenableBuilder<bool>(
      valueListenable: MesaController.instance.atualizar,
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text(
            'Mesas | Comandas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
        body: GridView.count(
          crossAxisCount: 3,
          children: buildMesas(value),
        ),
      ),
    );
  }
}
