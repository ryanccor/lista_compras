import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:sqflite/sqflite.dart';
import 'package:lista_compras/banco_dados/acesso_banco_dados.dart';
import 'package:lista_compras/entidades/entidade.dart';

abstract class ControleCadastro {
  final String tabela;
  final String campoIdentificador;
  late List<Entidade> entidades;

  ControleCadastro(this.tabela, this.campoIdentificador);

  Future<String?> incluir(Entidade entidade)  async {
    final bancoDados = AcessoBancoDados().bancoDados;
    String? id =  bancoDados.ref(tabela).push().key;
    entidade.identificador = id ?? "";
    await bancoDados.ref("$tabela/$id").set(entidade.converterParaMapa());
    return id;
  }

  Future<String> alterar(Entidade entidade) async {
    final bancoDados =  AcessoBancoDados().bancoDados;
    await bancoDados.ref("$tabela/${entidade.identificador}").set(entidade.converterParaMapa());
    return entidade.identificador;
  }

  Future<String> excluir(String identificador) async{
    final bancoDados = await AcessoBancoDados().bancoDados;
    await bancoDados.ref("$tabela/$identificador").remove();
    return identificador;
  }

  Future<Entidade> criarEntidade(Map<String, dynamic> mapaEntidade);

  Future<Entidade?> selecionar(String identificador) async {
    final bancoDados = await AcessoBancoDados().bancoDados;

    var snapshot =
    await bancoDados.ref("$tabela/$identificador").get();
    if(snapshot.exists){
      var strJson = json.encode(snapshot.value);
      Map<String, dynamic> entityMap = json.decode(strJson);
      return criarEntidade(entityMap);
    } else {
      return null;
    }
  }

  Future<List<Entidade>> criarListaEntidades (resultado) async {
    List<Entidade> entidades = <Entidade>[];
    if (resultado.isNotEmpty){
      for (var i in resultado.values){
        print(i);
        var strJson = json.encode(i);
        Map<String, dynamic> entityMap = json.decode(strJson);
        Entidade entidade = await criarEntidade(entityMap);
        entidades.add(entidade);
      }
      return entidades;
    } else {
      return [];
    }
  }

  Future<List<Entidade>> selecionarTodos () async {
    var bancoDados = await AcessoBancoDados().bancoDados;
    var resultado = await bancoDados.ref(tabela).get();
    if(resultado.exists) {
      return await criarListaEntidades(resultado.value);
    }
    return [];
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