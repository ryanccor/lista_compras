import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dicionario_dados.dart';


class AcessoBancoDados{

  static AcessoBancoDados? _acessoBancoDados;
  Database? _bancoDados;

  AcessoBancoDados._criarInstancia();

  factory AcessoBancoDados(){
    _acessoBancoDados ??= AcessoBancoDados._criarInstancia();
    return _acessoBancoDados!;
  }

  // unknown porque eu não sei o que é o terceiro parametro
  Future<void> _recriarTabelas(Database bancoDados, int versao, int unknown) async{
    await bancoDados.execute('DROP TABLE IF EXISTS '
        '${DicionarioDados.tabelaTipoProduto} '
    );
    await _criarTabelas (bancoDados, versao);
  }

  Future<void> _criarTabelas (Database bancoDados, int versao) async {
    // Criação das tabelas de tipos de produto
    await bancoDados.execute('CREATE TABLE IF NOT EXISTS '
        '${DicionarioDados.tabelaTipoProduto} ('
        '${DicionarioDados.idTipoProduto} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'
        ' ${DicionarioDados.nome} TEXT NOT NULL'
        ')'
    );

    // Criação da tabela de produtos
    await bancoDados.execute('CREATE TABLE IF NOT EXISTS ${DicionarioDados.tabelaProduto} ('
        '${DicionarioDados.idProduto} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'
        '${DicionarioDados.idTipoProduto} INTEGER NOT NULL,'
        '${DicionarioDados.nome} TEXT NOT NULL,'
        '${DicionarioDados.quantidade} REAL NOT NULL,'
        '${DicionarioDados.unidade} TEXT,'
        'FOREIGN KEY (${DicionarioDados.idTipoProduto}) '
        'REFERENCES ${DicionarioDados.tabelaTipoProduto} (${DicionarioDados.idTipoProduto}) ON UPDATE CASCADE'
        ')'
    );

    //Criaçao da tabela de itens das listas
    await bancoDados.execute('CREATE TABLE IF NOT EXISTS ${DicionarioDados.tabelaItemListaCompra} ('
        ' ${DicionarioDados.idListaCompra} INTEGER NOT NULL,'
        ' ${DicionarioDados.numeroItem} INTEGER NOT NULL,'
        ' ${DicionarioDados.idProduto} INTEGER NOT NULL,'
        ' ${DicionarioDados.quantidade} REAL NOT NULL,'
        ' ${DicionarioDados.selecionado} TEXT NOT NULL,'
        ' PRIMARY KEY (${DicionarioDados.idListaCompra},${DicionarioDados.numeroItem}),'
        ' FOREIGN KEY (${DicionarioDados.idListaCompra}) '
        ' REFERENCES ${DicionarioDados.tabelaListaCompra}(${DicionarioDados.idListaCompra})'
          ' ON UPDATE CASCADE '
          ' ON DELETE CASCADE, '
        ' FOREIGN KEY (${DicionarioDados.idProduto}) '
        ' REFERENCES ${DicionarioDados.tabelaProduto}(${DicionarioDados.idProduto})'
          ' ON UPDATE CASCADE '
          ' ON DELETE CASCADE '
        ')'
    );

    //Criação da tabela de listas de compras
    await bancoDados.execute("""
        CREATE TABLE IF NOT EXISTS
          ${DicionarioDados.tabelaListaCompra} (
           ${DicionarioDados.idListaCompra} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
           ${DicionarioDados.nome} TEXT NOT NULL
        )
        """);

  }

  Future<Database> _abrirBancoDados() async {
    Directory diretorio = await getApplicationDocumentsDirectory();
    String caminhoBancoDados = diretorio.path + DicionarioDados.arquivoBancoDados;

    var bancoDados = await openDatabase(caminhoBancoDados, version: 3, onCreate: _criarTabelas, onUpgrade: _recriarTabelas);

    return bancoDados;
  }

  void fechar(){
    if(_bancoDados ==  null){
      return;
    }
    _bancoDados!.close();
  }

  Future<Database> get bancoDados async {
    _bancoDados ??= await _abrirBancoDados();

    return _bancoDados!;
  }
}