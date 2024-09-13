import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:lanchonete/Controller/usuario_controller.dart';
import 'package:lanchonete/Pages/Config_page.dart';
import 'package:lanchonete/Pages/Principal_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanchonete/Services/Local_storage.Service.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';

import '../Components/customDropDown.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controllerSenha = TextEditingController();
  final auth = LocalAuthentication();
  bool _isAuthenticating = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      setState(() {
        _isAuthenticating = true;
      });
      setState(() {
        _isAuthenticating = false;
      });
    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
      });
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Login',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConfigPage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.settings,
                  color: Colors.black,
                )),
          ]),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  height: 200,
                  child: Image.asset('assets/images/logo.png'),
                ),
                SizedBox(
                  height: 20,
                ),
                CustomDropDown(),
                SizedBox(
                  height: 20,
                ),
                Container(
                  color: Colors.amber,
                  child: TextFormField(
                    controller: controllerSenha,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Senha',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'A senha é obrigatória';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _buildButtonAcessar(context, _formKey),
                SizedBox(
                  height: 20,
                ),
                _buildIdentificacao()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdentificacao() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Colors.amber,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _isAuthenticating
              ? Text(
                  'Autenticando...',
                  style: TextStyle(fontSize: 12),
                )
              : Text('Bater Ponto'),
          const Divider(height: 10),
          SizedBox(
            height: 90,
            width: 90,
            child: IconButton(
              onPressed: _authenticateWithBiometrics,
              icon: Icon(
                Icons.fingerprint,
                size: 80,
                shadows: [
                  Shadow(
                    offset: Offset(2, 5),
                    color: Colors.black38,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Container _buildButtonAcessar(
      BuildContext context, GlobalKey<FormState> formKey) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      height: 40,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.amber),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login),
            SizedBox(
              width: 10,
            ),
            Text(
              'Acessar',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ],
        ),
        onPressed: () async {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logando no sistema...')),
          );
          if (_formKey.currentState!.validate()) {
            try {
              final localStorage = LocalStorageService();
              final login = await localStorage.get('usuario');
              final usuarioController =
                  Provider.of<UsuarioController>(context, listen: false);
              if (await usuarioController.logar(login, controllerSenha.text)) {
                Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (_) => PrincipalPage(
                      paginas: Paginas.mesas,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Usuario ou senha incorretos...')),
                );
              }
            } catch (e) {
              log(e.toString());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(
                    'Erro ao tentar Logar.',
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
