import 'dart:io';
import 'package:flutter/material.dart';
import 'package:contatos/helpers/contato.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:contatos/ui/perfil_contato.dart';

enum OrderOptions { orderaz, orderza }

class ListaContatos extends StatefulWidget {
  @override
  _ListaContatosState createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  ContatoHelpers contatoHelper = ContatoHelpers();
  List<Contato> _contatos = List();
  String _nomeContato = '';

  @override
  void initState() {
    super.initState();

    _getAllContatos();
  }

  void _getAllContatos() {
    contatoHelper.getAllContatos().then((lista) {
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

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(18, 14, 18, 20),
                    child: Text(
                      'Opções de Contato',
                      style: TextStyle(color: Colors.grey[700], fontSize: 18),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Editar',
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _navigationPerfilContato(contato: _contatos[index]);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Ligar para $_nomeContato',
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.phone, color: Colors.white, size: 18),
                    ),
                    onTap: () {
                      launch('tel: ${_contatos[index].telefone}');
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Remover contato',
                      style: TextStyle(fontSize: 18),
                    ),
                    leading: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.delete, color: Colors.white, size: 18),
                    ),
                    onTap: () {
                      contatoHelper.deleteContato(_contatos[index].id);
                      setState(() {
                        _nomeContato = '';
                        _contatos.removeAt(index);
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget buildItemContatos(BuildContext context, int index) {
    return Padding(
      padding: EdgeInsets.all(3),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _nomeContato = _contatos[index].nome;
          });
          _showOptions(context, index);
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
                      fit: BoxFit.cover,
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

  void _ordenarLista(OrderOptions options) {
    switch (options) {
      case OrderOptions.orderaz:
        _contatos.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        _contatos.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
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
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                  const PopupMenuItem<OrderOptions>(
                    child: Text('Ordenar de A-Z'),
                    value: OrderOptions.orderaz,
                  ),
                  const PopupMenuItem<OrderOptions>(
                    child: Text('Ordenar de Z-A'),
                    value: OrderOptions.orderza,
                  ),
                ],
            onSelected: _ordenarLista,
          ),
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
