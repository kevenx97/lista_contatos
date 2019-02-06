import 'dart:io';
import 'package:flutter/material.dart';
import 'package:contatos/helpers/contato.dart';
import 'package:contatos/ui/perfil_contato.dart';

class ListaContatos extends StatefulWidget {
  @override
  _ListaContatosState createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  ContatoHelpers contatoHelper = ContatoHelpers();
  List<Contato> _contatos = List();

  @override
  void initState() {
    super.initState();

    _getAllContatos();
  }

  void _getAllContatos() {
    contatoHelper.getAllContatos().then((lista) {
    print(lista);
      setState(() {
        _contatos = lista;
      });
    });
  }

  void _navigationPerfilContato({Contato contato}) async {
    final retornoContato = await Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) {
        return PerfilContato(contato: contato);
      }),
    );
    if (retornoContato != null) {
      if (contato != null) {
        await contatoHelper.updateContato(retornoContato);
      } else {
        await contatoHelper.saveContato(retornoContato);
      }
      _getAllContatos();
    }
  }

  Widget buildItemContatos(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: GestureDetector(
        onTap: () {
          _navigationPerfilContato(contato: _contatos[index]);
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: _contatos[index].img == null
                          ? AssetImage('images/user.png')
                          : FileImage(File(_contatos[index].img)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _contatos[index].nome ?? '...',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _contatos[index].email ?? '...',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _contatos[index].telefone ?? '...',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text('Contatos'),
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              print('teste');
            },
          )
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: _contatos.length,
        itemBuilder: (BuildContext context, int index) {
          return buildItemContatos(context, index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigationPerfilContato,
        child: Icon(Icons.add),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}
