import 'package:lanchonete/Constants.dart';
import 'package:lanchonete/Controller/Comanda.Controller.dart';
import 'package:lanchonete/Controller/Theme.Controller.dart';
import 'package:lanchonete/Pages/Login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ComandaController(),
      ),
      ChangeNotifierProvider(create: (context) => ThemeController())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    return MaterialApp(
      title: 'Lanchonete',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: themeController.isDark ? Brightness.dark : Brightness.light,
        primaryColor: Constants.primaryColor,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 20,
            color: themeController.isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
          headline2: TextStyle(
            fontSize: 20,
            color: themeController.isDark ? Colors.white : Colors.black,
            fontStyle: FontStyle.italic,
          ),
          bodyText1: TextStyle(
              fontSize: 20,
              color: themeController.isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
          bodyText2: TextStyle(
              fontSize: 20,
              color: themeController.isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
      home: LoginPage(),
    );
  }
}
