import 'package:lanchonete/Controller/Comanda.Controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class IconeCarrinho extends StatelessWidget {
  final Function? onClick;
  const IconeCarrinho({Key? key, this.onClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final comandaController = Provider.of<ComandaController>(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.shopping_cart_outlined),
          onPressed: comandaController.totalItens > 0 ? onClick as void Function()? : null,
        ),
        Positioned(
          top: 8,
          left: 15,
          child: comandaController.totalItens > 0
              ? Container(
                  height: 15,
                  width: 15,
                  decoration:
                      BoxDecoration(shape: BoxShape.circle, color: Colors.red),
                  child: Center(
                      child: Text(
                    '${comandaController.totalItens}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  )),
                )
              : Container(),
        ),
      ],
    );
  }
}
