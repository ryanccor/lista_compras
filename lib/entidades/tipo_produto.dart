import 'package:lista_compras/banco_dados/dicionario_dados.dart';
import 'package:lista_compras/entidades/entidade.dart';

class TipoProduto extends Entidade {
  String nome = '';

  TipoProduto({int idTipoProduto = 0,
    this.nome = ''
  }):super(idTipoProduto);

  TipoProduto.criarDeMapa(Map<String,dynamic> mapaEntidade) :
        super.criarDeMapa(mapaEntidade){
    identificador = mapaEntidade[DicionarioDados.idTipoProduto];
    nome = mapaEntidade[DicionarioDados.nome];
  }

  @override
  Entidade criarEntidade(Map<String,dynamic> mapaEntidade){
    return TipoProduto.criarDeMapa(mapaEntidade);
  }

  @override
  Map<String, dynamic> converterParaMapa(){
    Map<String, dynamic> valores;
    valores = {
      DicionarioDados.nome : nome,
    };
    //Se identificador é maior que zero, trata-se de alteração!
    if (identificador > 0){
      valores.addAll({DicionarioDados.idTipoProduto :
      identificador});
    }
    return valores;
  }
}
