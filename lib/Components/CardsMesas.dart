import 'package:lanchonete/Constants.dart';
import 'package:lanchonete/Pages/Categoria_page.dart';
import 'package:lanchonete/Pages/DetalheComanda_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CardsMesas extends StatelessWidget {
  final int numeroMesa;
  final String? estado;
  final dynamic valor;

  const CardsMesas({required this.numeroMesa, this.estado, this.valor});

  Color corPorEstado(String? estado) {
    Color corEscolhida = Constants.mesaAberta;
    switch (estado) {
      case 'A':
        corEscolhida = Constants.mesaAberta;
        break;
      case 'O':
        corEscolhida = Constants.mesaOcupada;
        break;
      case 'F':
        corEscolhida = Constants.mesaFechamento;
        break;
      default:
    }
    return corEscolhida;
  }

  String labelPorEstado(String? estado) {
    String corEscolhida = 'Livre';
    switch (estado) {
      case 'A':
        corEscolhida = 'Livre';
        break;
      case 'O':
        corEscolhida = 'Ocupada';
        break;
      case 'F':
        corEscolhida = 'Fechamento';
        break;
      default:
    }
    return corEscolhida;
  }

  @override
  Widget build(BuildContext context) {
    var f = new NumberFormat("R\$ ##0.00", "pt_BR");

    return GestureDetector(
        onTap: () {
          if (estado == 'A') {
            Navigator.of(context).push(
              CupertinoPageRoute(
                  builder: (_) => CategoriaPage(numeroMesa: numeroMesa)),
            );
          } else {
            Navigator.of(context).push(
              CupertinoPageRoute(
                  builder: (_) => DetalheComandaPage(numeroMesa: numeroMesa)),
            );
          }
        },
        child: Container(
          margin: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
              color: corPorEstado(estado),
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0.4, 0.4),
                  blurRadius: 3.0,
                  spreadRadius: 0.1,
                ),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                labelPorEstado(estado),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                this.numeroMesa.toString().padLeft(2, '0'),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 35),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                f.format(valor),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              )
            ],
          ),
        ));
  }
}
