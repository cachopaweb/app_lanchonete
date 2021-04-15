import 'package:app_lanchonete/Pages/Principal_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                height: 200,
                child: Image.asset('assets/images/Logo_147.png'),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'Usuário',
                style: TextStyle(color: Colors.white),
              ),
              TextFormField(
                autofocus: true,
                keyboardType: TextInputType.text,
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  height: 40,
                  child: RaisedButton(
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
                    color: Colors.amber,
                    elevation: 5,
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          CupertinoPageRoute(builder: (_) {
                        return PrincipalPage(
                          paginas: Paginas.home,
                        );
                      }));
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
