import 'package:lanchonete/Controller/Config.Controller.dart';
import 'package:lanchonete/Pages/Login_page.dart';
import 'package:flutter/material.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  Future<String>? urlBase;
  String? _urlBase;

  @override
  void initState() {
    super.initState();
    _urlBase = ConfigController.instance.baseURL.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Configurações',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              ConfigController.instance.changeUrlBase(_urlBase);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
            },
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.all(50),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FutureBuilder<String>(
              future: urlBase,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return TextFormField(
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                        initialValue: ConfigController.instance.baseURL.value,
                        keyboardType: TextInputType.number,
                        onChanged: (String url) {
                          _urlBase = url;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Servidor',
                        ),
                      );
                    }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
