import 'dart:developer';

import 'package:flutter/material.dart';

import '../Models/usuario_model.dart';
import '../Services/Local_storage.Service.dart';
import '../repositories/usuario_repository.dart';

class CustomDropDown extends StatefulWidget {
  const CustomDropDown({Key? key}) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  var dropdownValue = '';
  var listaUsuarios = <UsuarioModel>[];
  var isLoading = false;
  var isError = false;
  final localStorage = LocalStorageService();
  final repository = UsuarioRepository();

  @override
  void initState() {
    super.initState();
    _buscaUsuarios();
    _buscaUsuario();
  }

  _buscaUsuarios() async {
    try {
      setState(() {
        isLoading = true;
      });
      listaUsuarios = await repository.fetchUsuario();
      if ((listaUsuarios.isNotEmpty) && (dropdownValue.isEmpty)) {
        setState(() {
          dropdownValue = listaUsuarios[0].login;
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());
      listaUsuarios = [];
      setState(() {
        isError = true;
      });
    }
  }

  _buscaUsuario() async {
    try {
      setState(() {
        isLoading = true;
      });
      dropdownValue = await localStorage.get('usuario') ?? '';
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      log(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? _buildLoading()
        : isError
            ? _buildError()
            : _buildSuccess();
  }

  _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  _buildError() {
    return Center(
      child: Text(
        'Erro ao buscar Usuarios!',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return dropdownValue.isNotEmpty
        ? Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.amber,
            child: DropdownButton<String>(
              value: dropdownValue,
              elevation: 14,
              alignment: Alignment.center,
              isExpanded: true,
              style: TextStyle(color: Colors.white),
              items: listaUsuarios
                  .map(
                    (model) => DropdownMenuItem<String>(
                      alignment: Alignment.center,
                      value: model.login,
                      child: Text(
                        model.login,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (String? newValue) {
                setState(
                  () {
                    dropdownValue = newValue!;
                    localStorage.put('usuario', dropdownValue);
                  },
                );
              },
            ),
          )
        : _buildLoading();
  }
}
