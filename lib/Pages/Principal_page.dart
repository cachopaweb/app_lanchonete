import 'package:lanchonete/Pages/Config_page.dart';
import 'package:lanchonete/Pages/Consulta_Produtos_page.dart';
import 'package:lanchonete/Pages/Home_page.dart';
import 'package:lanchonete/Pages/Mesas_page.dart';
import 'package:flutter/material.dart';

import '../Constants.dart';

enum Paginas { home, mesas, consultaProdutos, configuracao }

class PrincipalPage extends StatefulWidget {
  final Paginas paginas;

  const PrincipalPage({Key? key, required this.paginas}) : super(key: key);

  @override
  _PrincipalPageState createState() => _PrincipalPageState(paginas.index);
}

class _PrincipalPageState extends State<PrincipalPage> {
  int _selectedIndex;

  _PrincipalPageState(this._selectedIndex);

  @override
  Widget build(BuildContext context) {
    List<Widget> _paginas = <Widget>[
      HomePage(),
      MesasPage(),
      ConsultaProdutosPage(),
      ConfigPage(),
    ];
    return Scaffold(
      body: _paginas.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Constants.primaryColor,
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.black,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Constants.primaryColor,
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            backgroundColor: Constants.primaryColor,
            icon: Icon(Icons.grid_on),
            label: 'Mesas',
          ),
          BottomNavigationBarItem(
            backgroundColor: Constants.primaryColor,
            icon: Icon(Icons.inventory),
            label: 'Produtos',
          ),
          BottomNavigationBarItem(
            backgroundColor: Constants.primaryColor,
            icon: Icon(Icons.settings),
            label: 'Config.',
          ),
        ],
      ),
    );
  }
}
