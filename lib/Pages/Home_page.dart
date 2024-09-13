import 'package:lanchonete/Components/CustomSwitch.dart';
import 'package:lanchonete/Pages/Categoria_page.dart';
import 'package:lanchonete/Pages/DetalheComanda_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int numMesa = 0;

  @override
  Widget build(BuildContext context) {
    final double largura = MediaQuery.of(context).size.width;

    _trataMensagem() {
      return showDialog(
        context: context,
        useSafeArea: true,
        builder: (context) => SimpleDialog(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Número da Comanda ou Mesa é obrigatório!',
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Mesas | Comandas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [CustomSwitch()],
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Comanda ou Mesa',
                style: TextStyle(
                    color: Theme.of(context).textTheme.displayLarge!.color),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                onChanged: (value) {
                  setState(() {
                    numMesa = int.parse(value);
                  });
                },
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: largura / 3,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (numMesa == 0) {
                          _trataMensagem();
                          return;
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CategoriaPage(
                                numeroMesa: numMesa,
                              ),
                            ));
                      },
                      child: Center(
                        child: Container(
                          child: Text(
                            'Inserir Item',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                    width: largura / 3,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (numMesa == 0) {
                          _trataMensagem();
                          return;
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetalheComandaPage(numeroMesa: numMesa),
                            ));
                      },
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Text(
                            'Ver Detalhes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
