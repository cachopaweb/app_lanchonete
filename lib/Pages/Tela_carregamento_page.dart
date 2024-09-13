import 'package:flutter/material.dart';
import 'package:lanchonete/Controller/Comanda.Controller.dart';

import 'package:lanchonete/Controller/Mesas.Controller.dart';
import 'package:lanchonete/Pages/Principal_page.dart';
import 'package:lanchonete/Services/ComandaService.dart';
import 'package:provider/provider.dart';

class TelaCarregamento extends StatefulWidget {
  final int comanda;
  final int mesa;
  final String messageAwait;
  final String messageSuccess;
  final String messageError;
  final bool finalization;

  const TelaCarregamento({
    Key? key,
    required this.comanda,
    required this.mesa,
    required this.messageAwait,
    required this.messageSuccess,
    required this.messageError,
    required this.finalization,
  }) : super(key: key);

  @override
  _TelaCarregamentoState createState() => _TelaCarregamentoState();
}

class _TelaCarregamentoState extends State<TelaCarregamento> {
  bool isLoading = false;
  bool isSuccess = false;
  final comandaService = ComandaService();

  _aguardando() {
    return Column(
      children: [
        Text(widget.messageAwait),
        Container(
          margin: EdgeInsets.only(top: 20),
          child: CircularProgressIndicator(
            backgroundColor: Colors.amber,
          ),
        )
      ],
    );
  }

  _sucesso() {
    return Column(
      children: [
        Container(
          height: 80,
          child: Image.asset(
            'assets/images/confirmacao.png',
            height: 50,
          ),
        ),
        Text(
          widget.messageSuccess,
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  _erro() {
    return Column(
      children: [
        Container(
          height: 80,
          child: Icon(
            Icons.cancel,
            color: Colors.red,
            size: 50,
          ),
        ),
        Text(
          widget.messageError,
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  _finalizarComanda() {
    comandaService.encerrarComanda(widget.comanda).then((value) {
      setState(() {
        isLoading = false;
        isSuccess = value;
      });
    });
  }

  _criarComanda() async {
    var comandaController =
        Provider.of<ComandaController>(context, listen: false);
    var result = await comandaController.insereComanda(widget.mesa);
    if (result) {
      MesaController.instance.atualizar.value = true;
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (_) {
          return PrincipalPage(paginas: Paginas.mesas);
        },
      ), (route) => false);
      final snackbar =
          const SnackBar(content: Text('Comanda inserida com sucesso!'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      setState(() {
        isLoading = false;
        isSuccess = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    if (widget.finalization) {
      _finalizarComanda();
    } else {
      _criarComanda();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isSuccess) {
      Future.delayed(Duration(seconds: 1), () {
        MesaController.instance.atualizar.value = true;
        Navigator.pop(context);
      });
    }
    return Material(
      child: Center(
        child: Container(
          height: 130,
          margin: EdgeInsets.all(5.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: !isLoading
                  ? (isSuccess ? _sucesso() : _erro())
                  : _aguardando(),
            ),
          ),
        ),
      ),
    );
  }
}
