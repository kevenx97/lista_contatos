import 'dart:io';
import 'package:flutter/material.dart';
import 'package:contatos/helpers/contato.dart';
import 'package:image_picker/image_picker.dart';

class PerfilContato extends StatefulWidget {
  final Contato contato;

  PerfilContato({this.contato});

  @override
  _PerfilContatoState createState() => _PerfilContatoState();
}

class _PerfilContatoState extends State<PerfilContato> {
  Contato _editContato;
  bool _editingContato = false;

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _focusNome = FocusNode();

  @override
  void initState() {
    super.initState();

    if (widget.contato == null)
      _editContato = Contato();
    else
      _editContato = Contato.fromMap(widget.contato.toMap());
    _nomeController.text = _editContato.nome;
    _emailController.text = _editContato.email;
    _telefoneController.text = _editContato.telefone;
  }

  Future<bool> _requestPop() {
    if (_editingContato) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Descartar Alterações?'),
            content: Text('Ao sair todas as alterações serão perdidas.'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'CANCELAR',
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                elevation: 0,
                color: Colors.redAccent,
                child: Text(
                  'CONFIRMAR',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              )
            ],
          );
        },
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(_editContato.nome ?? 'Novo Contato'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomRight,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: _editContato.img != null
                            ? FileImage(File(_editContato.img))
                            : AssetImage('images/user.png'),
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      width: 36,
                      height: 36,
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 21,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.indigoAccent,
                      ),
                    ),
                    onTap: () {
                      ImagePicker.pickImage(source: ImageSource.camera).then((image) {
                        if (image != null) {
                          setState(() {
                            _editContato.img = image.path;
                            _editingContato = true;
                          });
                        }
                      });
                    },
                  ),
                ],
              ),
              TextField(
                focusNode: _focusNome,
                keyboardType: TextInputType.text,
                controller: _nomeController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.redAccent, fontSize: 16),
                  labelText: 'Nome',
                ),
                style: TextStyle(fontSize: 16, color: Colors.grey[900]),
                onChanged: (text) {
                  _editingContato = true;
                  setState(() {
                    _editContato.nome = text;
                  });
                },
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.redAccent, fontSize: 16),
                  labelText: 'Email',
                ),
                style: TextStyle(fontSize: 16, color: Colors.grey[900]),
                onChanged: (text) {
                  _editingContato = true;
                  _editContato.email = text;
                },
              ),
              TextField(
                keyboardType: TextInputType.phone,
                controller: _telefoneController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.redAccent, fontSize: 16),
                  labelText: 'Telefone',
                ),
                style: TextStyle(fontSize: 16, color: Colors.grey[900]),
                onChanged: (text) {
                  _editingContato = true;
                  _editContato.telefone = text;
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.redAccent,
          child: Icon(Icons.save),
          onPressed: () {
            if (_editContato.nome.isNotEmpty && _editContato.nome != null) {
              Navigator.pop(context, _editContato);
            } else {
              FocusScope.of(context).requestFocus(_focusNome);
            }
          },
        ),
      ),
    );
  }
}
