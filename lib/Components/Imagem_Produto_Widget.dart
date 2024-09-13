import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:lanchonete/Services/ProdutosService.dart';

class ImagemProdutoWidget extends StatelessWidget {
  final produtosService = ProdutosService();
  final int codProduto;
  final double? altura;
  final double? largura;

  ImagemProdutoWidget({
    Key? key,
    required this.codProduto,
    this.altura = 100.0,
    this.largura = 80.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: altura,
      width: largura,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(8.0),
          topLeft: Radius.circular(8.0),
        ),
        child: FutureBuilder<String?>(
          future: produtosService.fetchFotoProduto(codProduto),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!.length > 0
                  ? Image.memory(
                      base64Decode(snapshot.data!),
                      fit: BoxFit.cover,
                      height: altura,
                      width: largura,
                    )
                  : const Center(
                      child: Text(
                        'Sem Foto',
                        textAlign: TextAlign.center,
                      ),
                    );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.amber,
              ));
            }
          },
        ),
      ),
    );
  }
}
