import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final String tabelaContato = 'tabelaContato';
final String idColumn = 'idColumn';
final String imgColumn = 'imgColumn';
final String nomeColumn = 'nomeColumn';
final String emailColumn = 'emailColumn';
final String telefoneColumn = 'telefoneColumn';

class ContatoHelpers {
  static final ContatoHelpers _instance = ContatoHelpers.internal();

  factory ContatoHelpers() => _instance;

  ContatoHelpers.internal();

  Database _db;

  Future<Database> get db async => _db != null ? _db : await openDb();

  Future<Database> openDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'contato.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int newerVersion) async {
        await db.execute(
            'CREATE TABLE $tabelaContato($idColumn INTEGER PRIMARY KEY, $imgColumn TEXT, $nomeColumn TEXT, $emailColumn TEXT, $telefoneColumn TEXT)');
      },
    );
  }

  Future<Contato> saveContato(Contato contato) async {
    Database dbContato = await db;
    contato.id = await dbContato.insert(tabelaContato, contato.toMap());
    return contato;
  }

  Future<Contato> getContato(int id) async {
    Database dbContato = await db;
    List<Map> contato = await dbContato.query(
      tabelaContato,
      where: '$idColumn = ?',
      whereArgs: [id],
      columns: [idColumn, imgColumn, nomeColumn, emailColumn, telefoneColumn],
    );

    return contato.length > 0 ? Contato.fromMap(contato.first) : null;
  }

  Future<List> getAllContatos() async {
    Database dbContato = await db;
    List listaMaps = await dbContato.rawQuery('SELECT * FROM $tabelaContato');
    List<Contato> listaContato = List();

    for(Map map in listaMaps) {
      listaContato.add(Contato.fromMap(map));
    }

    return listaContato;
  }

  Future<int> deleteContato(int id) async {
    Database dbContato = await db;
    return dbContato.delete(
      tabelaContato,
      where: '$idColumn = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateContato(Contato contato) async {
    Database dbContato = await db;
    return dbContato.update(
      tabelaContato,
      contato.toMap(),
      where: '$idColumn = ?',
      whereArgs: [contato.id],
    );
  }
}

class Contato {
  int id;
  String img;
  String nome;
  String email;
  String telefone;

  Contato();

  Contato.fromMap(Map map) {
    id = map[idColumn];
    img = map[imgColumn];
    nome = map[nomeColumn];
    email = map[emailColumn];
    telefone = map[telefoneColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      imgColumn: img,
      nomeColumn: nome,
      emailColumn: email,
      telefoneColumn: telefone
    };
    if (id != null) map[idColumn] = id;
    return map;
  }

  @override
  String toString() {
    return 'Contato(id $id, nome: $nome, email: $email, telefone: $telefone, img: $img)';
  }
}
