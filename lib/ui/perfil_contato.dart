import 'dart:io';
import 'package:flutter/material.dart';
import 'package:contatos/helpers/contato.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(_editContato.nome ?? 'Novo Contato'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
        child: Column(
          children: <Widget>[
            Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: _editContato.img != null
                        ? FileImage(File(_editContato.img))
                        : AssetImage('images/user.png')),
              ),
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
    );
  }
}
