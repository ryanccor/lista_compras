import 'package:lista_compras/banco_dados/dicionario_dados.dart';
import 'package:lista_compras/controles/controle_cadastro.dart';
import 'package:lista_compras/entidades/entidade.dart';
import 'package:lista_compras/entidades/tipo_produto.dart';

class ControleCadastroTipoProduto extends ControleCadastro{
  ControleCadastroTipoProduto()
      : super(DicionarioDados.tabelaTipoProduto,
      DicionarioDados.idTipoProduto);

  @override
  Future<Entidade> criarEntidade(Map<String, dynamic> mapaEntidade)
  async{
    return TipoProduto.criarDeMapa(mapaEntidade);
  }
}
