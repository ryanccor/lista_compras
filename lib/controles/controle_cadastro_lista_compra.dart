import '../banco_dados/dicionario_dados.dart';
import '../entidades/entidade.dart';
import '../entidades/item_lista_compra.dart';
import '../entidades/lista_compra.dart';
import 'controle_cadastro.dart';
import 'controle_cadastro_item_lista_compra.dart';

class ControleCadastroListaCompra extends ControleCadastro{
  ControleCadastroItemListaCompra controleCadastroItemLista =
  ControleCadastroItemListaCompra();
  ControleCadastroListaCompra()
      : super(DicionarioDados.tabelaListaCompra,
      DicionarioDados.idListaCompra);

  @override
  Future<Entidade> criarEntidade(Map<String, dynamic> mapaEntidade)
  async {
    ListaCompra listaCompra = ListaCompra.criarDeMapa(mapaEntidade);
    List<Entidade> itens = await
    controleCadastroItemLista.selecionarDaListaCompra(
        listaCompra.identificador);
    itens.forEach((element) {
      listaCompra.incluirItem(element as ItemListaCompra);
    });
    return listaCompra;
  }
  Future<int> processarItens(ListaCompra listaCompra) async {
    int resultado = 0;

    controleCadastroItemLista.excluirDaListaCompra(
        listaCompra.identificador);
    for (int i = 0; i < listaCompra.itens.length; i++){
      //Corrige o idCompra da lista de tens
      listaCompra.itens[i].identificador = listaCompra.identificador;
      resultado = await controleCadastroItemLista.incluir(
          listaCompra.itens[i]);
    }
    return resultado;
  }
  @override
  Future<int> incluir(Entidade entidade) async {
    ListaCompra listaCompra = entidade as ListaCompra;
    int resultado;
    resultado = await super.incluir(listaCompra);
    if (resultado > 0){
      listaCompra.identificador = resultado;
      resultado = await processarItens(listaCompra);
    }
    return resultado;
  }
  @override
  Future<int> alterar (Entidade entidade) async {
    ListaCompra listaCompra = entidade as ListaCompra;
    int resultado;
    resultado = await super.alterar(listaCompra);
    if (resultado > 0){
      resultado = await processarItens(listaCompra);
    }
    return resultado;
  }
  @override
  Future<int> excluir(int identificador) async {
    int resultado;
    resultado = await super.excluir(identificador);
    if (resultado > 0){
      resultado = await
      controleCadastroItemLista.excluirDaListaCompra(
          identificador);
    }
    return resultado;
  }
} //Fim d