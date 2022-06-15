import 'package:lista_compras/banco_dados/dicionario_dados.dart';
import 'package:lista_compras/controles/controle_cadastro.dart';
import 'package:lista_compras/controles/controle_cadastro_tipo_produto.dart';
import 'package:lista_compras/entidades/entidade.dart';
import 'package:lista_compras/entidades/produto.dart';
import 'package:lista_compras/entidades/tipo_produto.dart';
import 'package:lista_compras/banco_dados/acesso_banco_dados.dart';


class ControleCadastroProduto extends ControleCadastro{
  ControleCadastroTipoProduto controleCadastroTipoProduto =
  ControleCadastroTipoProduto();
  ControleCadastroProduto() : super(DicionarioDados.tabelaProduto,
      DicionarioDados.idProduto);

  @override
  Future<Entidade> criarEntidade(Map<String, dynamic> mapaEntidade)
  async {

    Produto produto = Produto.criarDeMapa(mapaEntidade);
    TipoProduto tipoProduto = await
    controleCadastroTipoProduto.selecionar
      (produto.idTipoProduto) as TipoProduto;
    produto.tipoProduto = tipoProduto;
    return produto;
  }
  Future<List<Entidade>> selecionarPorTipo(String idTipoProduto) async {
    final bancoDados = await AcessoBancoDados().bancoDados;

    List<Map> mapaEntidades;
    if (idTipoProduto != ''){
      var snapshot = await bancoDados.ref(tabela).equalTo(idTipoProduto, key:DicionarioDados.idTipoProduto).get();
      if(snapshot.exists){
        mapaEntidades = snapshot.value as List<Map>;
      } else{
        mapaEntidades = [];
      }


    } else {
      var snapshot = await bancoDados.ref(tabela).equalTo(idTipoProduto, key:DicionarioDados.idTipoProduto).get();
      if(snapshot.exists){
        mapaEntidades = snapshot.value as List<Map>;
      } else{
        mapaEntidades = [];
      }
    }
    List<Entidade> entidades = await
    criarListaEntidades(mapaEntidades);
    return entidades;
  }
}