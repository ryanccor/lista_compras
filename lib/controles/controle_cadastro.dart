import 'dart:async';
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

  Future alterar(Entidade entidade) async {
    final bancoDados =  AcessoBancoDados().bancoDados;
    await bancoDados.ref("$tabela/${entidade.identificador}").set(entidade.converterParaMapa());
  }

  Future excluir(String identificador) async{
    final bancoDados = await AcessoBancoDados().bancoDados;
    await bancoDados.ref("$tabela/$identificador").remove();

  }

  Future<Entidade> criarEntidade(Map<String, dynamic> mapaEntidade);

  Future<Entidade?> selecionar(int identificador) async {
    final bancoDados = await AcessoBancoDados().bancoDados;

    var snapshot =
    await bancoDados.ref("$tabela/$identificador").get();
    if(snapshot.exists){
      return criarEntidade(snapshot.value as Map<String, dynamic>);
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
    var bancoDados = await AcessoBancoDados().bancoDados;
    var resultado = await bancoDados.ref(tabela).get();
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