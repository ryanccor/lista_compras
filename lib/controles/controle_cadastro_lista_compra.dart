import '../banco_dados/dicionario_dados.dart';
import '../entidades/entidade.dart';
import '../entidades/item_lista_compra.dart';
import '../entidades/lista_compra.dart';
import 'controle_cadastro.dart';
import 'controle_cadastro_item_lista_compra.dart';

class ControleCadastroListaCompra extends ControleCadastro {
  ControleCadastroItemListaCompra controleCadastroItemLista =
      ControleCadastroItemListaCompra();
  ControleCadastroListaCompra()
      : super(DicionarioDados.tabelaListaCompra, DicionarioDados.idListaCompra);

  @override
  Future<Entidade> criarEntidade(Map<String, dynamic> mapaEntidade) async {
    ListaCompra listaCompra = ListaCompra.criarDeMapa(mapaEntidade);
    List<Entidade> itens = await controleCadastroItemLista
        .selecionarDaListaCompra(listaCompra.identificador);
    itens.forEach((element) {
      listaCompra.incluirItem(element as ItemListaCompra);
    });
    return listaCompra;
  }

  Future<String?> processarItens(ListaCompra listaCompra) async {
    String? resultado = "";

    controleCadastroItemLista.excluirDaListaCompra(listaCompra.identificador);
    for (int i = 0; i < listaCompra.itens.length; i++) {
      //Corrige o idCompra da lista de tens
      listaCompra.itens[i].identificador = listaCompra.identificador;
      resultado = await controleCadastroItemLista.incluir(listaCompra.itens[i]);
    }
    return resultado;
  }

  @override
  Future<String?> incluir(Entidade entidade) async {
    ListaCompra listaCompra = entidade as ListaCompra;
    String? resultado;
    resultado = await super.incluir(listaCompra);
    if (resultado != "") {
      listaCompra.identificador = resultado ?? "";
      resultado = await processarItens(listaCompra);
    }
    return resultado;
  }

  @override
  Future<String?> alterar(Entidade entidade) async {
    ListaCompra listaCompra = entidade as ListaCompra;
    String? resultado;
    resultado = await super.alterar(listaCompra);
    if (resultado != "") {
      resultado = await processarItens(listaCompra);
    }
    return resultado;
  }

  @override
  Future<String?> excluir(String identificador) async {
    String? resultado;
    resultado = await super.excluir(identificador);
    if (resultado != "") {
      resultado =
          await controleCadastroItemLista.excluirDaListaCompra(identificador);
    }
    return resultado;
  }
} //Fim d