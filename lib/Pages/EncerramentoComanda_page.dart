import 'package:app_lanchonete/Controller/Mesas.Controller.dart';
import 'package:app_lanchonete/Services/ComandaService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EncerramentoComanda extends StatefulWidget {
  final int comanda;

  const EncerramentoComanda({Key key, this.comanda}) : super(key: key);

  @override
  _EncerramentoComandaState createState() => _EncerramentoComandaState();
}

class _EncerramentoComandaState extends State<EncerramentoComanda> {
  bool isLoading = false;
  bool isSuccess = false;
  final comandaService = ComandaService();

  _aguardando() {
    return Column(
      children: [
        Text('Aguarde o encerramento...'),
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
          'Encerramento realizado com sucesso...',
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
          'Erro ao tentar realizar o fechamento!',
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    isLoading = true;
    comandaService.encerrarComanda(widget.comanda).then((value) {      
      setState(() {
        isLoading = false;
        isSuccess = value;
      });
    });
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
