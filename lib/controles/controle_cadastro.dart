import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:lista_compras/banco_dados/acesso_banco_dados.dart';
import 'package:lista_compras/entidades/entidade.dart';

abstract class ControleCadastro {
  final String tabela;
  final String campoIdentificador;
  late List<Entidade> entidades;

  ControleCadastro(this.tabela, this.campoIdentificador);

  Future<int> incluir(Entidade entidade) async {
    final bancoDados = await AcessoBancoDados().bancoDados;

    int resultado = await bancoDados!.insert(tabela, entidade.converterParaMapa());

    return resultado;
  }

  Future<int> alterar(Entidade entidade) async {
    final bancoDados = await AcessoBancoDados().bancoDados;
    int resultado = await bancoDados!.update(
        tabela,
        entidade.converterParaMapa(),
        where: '$campoIdentificador = ? ',
        whereArgs: [entidade.identificador]);
    return resultado;
  }

  Future<int> excluir(int identificador) async{
    final bancoDados = await AcessoBancoDados().bancoDados;
    int resultado = await bancoDados!.delete(
        tabela,
        where: '$campoIdentificador = ? ',
        whereArgs: [identificador]);
    return resultado;
  }

  Future<Entidade> criarEntidade(Map<String, dynamic> mapaEntidade);

  Future<Entidade?> selecionar(int identificador) async {
    final bancoDados = await AcessoBancoDados().bancoDados;

    List<Map<String,dynamic>> entidades =
    await bancoDados.query(
        tabela,
        where: '$campoIdentificador = ? ',
        whereArgs: [identificador]);
    if (entidades.isNotEmpty){
      return await criarEntidade(entidades.first);
    } else {
      return null;
    }
  }

  Future<List<Entidade>> criarListaEntidades (resultado) async {
    List<Entidade> entidades = <Entidade>[];
    if (resultado.isNotEmpty){
      for (int i = 0; i < resultado.length; i++){
        Entidade entidade = await criarEntidade(resultado[i]);
        entidades.add(entidade);
      }
      return entidades;
    } else {
      return [];
    }
  }

  Future<List<Entidade>> selecionarTodos () async {
    Database? bancoDados = await AcessoBancoDados().bancoDados;
    var resultado = await bancoDados.query(tabela);
    List<Entidade> entidades = await criarListaEntidades(resultado);
    return entidades;
  }

  final StreamController<List<Entidade>> _controladorFluxoEntidades = StreamController<List<Entidade>>();

  Stream<List<Entidade>> get fluxo => _controladorFluxoEntidades.stream;

  Future<void> emitirLista() async {
    entidades = await selecionarTodos();
    _controladorFluxoEntidades.add(entidades);
  }

  void finalizar(){
    _controladorFluxoEntidades.close();
  }

}