import 'package:lista_compras/banco_dados/acesso_banco_dados.dart';
import 'package:lista_compras/banco_dados/dicionario_dados.dart';
import 'package:lista_compras/entidades/entidade.dart';
import 'package:lista_compras/entidades/item_lista_compra.dart';
import 'package:lista_compras/entidades/produto.dart';
import 'package:lista_compras/controles/controle_cadastro.dart';
import 'package:lista_compras/controles/controle_cadastro_produto.dart';

class ControleCadastroItemListaCompra extends ControleCadastro{
  ControleCadastroProduto controleCadastroProduto =
  ControleCadastroProduto();
  ControleCadastroItemListaCompra()
      : super(DicionarioDados.tabelaItemListaCompra,
      DicionarioDados.idListaCompra);

  @override
  Future<Entidade> criarEntidade(Map<String, dynamic> mapaEntidade)

  async {
    ItemListaCompra itemListaCompra = ItemListaCompra.criarDeMapa(mapaEntidade);
    Produto produto = await controleCadastroProduto.selecionar(itemListaCompra.idProduto) as Produto;

    itemListaCompra.produto = produto;
    return itemListaCompra;
  }

  Future<List<Entidade>> selecionarDaListaCompra(String idListaCompra)
  async {
    final bancoDados = await AcessoBancoDados().bancoDados;
    var snapshot = await bancoDados.ref('$tabela').equalTo(idListaCompra, key: DicionarioDados.idListaCompra).get();
    if (snapshot.exists){
      var mapaEntidades = snapshot.value;
      List<Entidade> entidades = await criarListaEntidades(mapaEntidades);
      return entidades;
    }
    return [];
  }

  Future<String> excluirDaListaCompra(String idListaCompra) async {
    final bancoDados = await AcessoBancoDados().bancoDados;
    var snapshot = await bancoDados.ref(tabela).equalTo(idListaCompra, key: DicionarioDados.idListaCompra).get();
    if (snapshot.exists) {
      for (var i in snapshot.children){
        i.ref.remove();
      }
    }
    return idListaCompra;
  }
}