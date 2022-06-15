import 'package:lista_compras/banco_dados/dicionario_dados.dart';
import 'package:lista_compras/entidades/entidade.dart';
import 'package:lista_compras/entidades/tipo_produto.dart';

const List<String> unidadesProdutos =
['','un','kg','g', 'mg', 'l', 'ml'];

class Produto extends Entidade {
  TipoProduto _tipoProduto = TipoProduto();
  String nome = '';
  double quantidade = 0.0;
  String unidade = '';
  String idTipoProduto = '';

  Produto({String idProduto = '',
    this.nome = '',
    this.quantidade = 0.0,
  }) : super(idProduto);

  Produto.criarDeMapa(Map<String,dynamic> mapaEntidade) :
        super.criarDeMapa(mapaEntidade){
    print(mapaEntidade);
    identificador = mapaEntidade[DicionarioDados.idProduto];
    nome = mapaEntidade[DicionarioDados.nome];
    quantidade = mapaEntidade[DicionarioDados.quantidade] * 1.0;
    idTipoProduto = mapaEntidade[DicionarioDados.idTipoProduto];
    unidade = mapaEntidade[DicionarioDados.unidade];
  }

  @override
  Entidade criarEntidade(Map<String,dynamic> mapaEntidade){
    return Produto.criarDeMapa(mapaEntidade);
  }

  TipoProduto get tipoProduto => _tipoProduto;

  set tipoProduto(TipoProduto tipoProduto){
    _tipoProduto = tipoProduto;
    idTipoProduto = tipoProduto.identificador;
  }

  @override
  Map<String, dynamic> converterParaMapa(){
    Map<String, dynamic> valores;
    valores = {
      DicionarioDados.idTipoProduto : idTipoProduto,
      DicionarioDados.nome : nome,
      DicionarioDados.quantidade : quantidade,
      DicionarioDados.unidade : unidade,
    };
    //Se identificador é maior que zero, é uma alteração!
    if (identificador != ''){
      valores.addAll({DicionarioDados.idProduto :
      identificador});
    }
    return valores;
  }
}