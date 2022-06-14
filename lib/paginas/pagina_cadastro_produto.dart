import 'package:flutter/material.dart';
import 'package:lista_compras/paginas/pagina_cadastro.dart';
import 'package:lista_compras/paginas/pagina_entidade.dart';
import 'package:lista_compras/paginas/pagina_produto.dart';

import '../controles/controle_cadastro_produto.dart';
import '../entidades/entidade.dart';
import '../entidades/produto.dart';
import 'navegacao.dart';

class PaginaCadastroProduto extends StatefulWidget {
  const PaginaCadastroProduto({Key? key}) : super(key: key);
  @override
  State<PaginaCadastroProduto> createState() =>
      _PaginaCadastroProdutoState();
}
class _PaginaCadastroProdutoState
    extends State<PaginaCadastroProduto> with PaginaCadastro{

  @override
  Widget criarPaginaEntidade(OperacaoCadastro operacaoCadastro,
      Entidade entidade){
    return PaginaProduto(operacaoCadastro:operacaoCadastro,
        entidade:entidade);
  }

  @override
  Entidade criarEntidade(){
    return Produto(nome:'', quantidade: 0.0);
  }

  @override
  List<Widget> criarConteudoItem(Entidade entidade){
    Produto produto = entidade as Produto;
    return [
      Text(
        produto.nome,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 2,),
      Text(
          'Quantidade: ${produto.quantidade.toString()} ${produto.unidade}',
      ),
      SizedBox(height: 2,),
      Text(
          produto.tipoProduto != null ?
          'Tipo: ${produto.tipoProduto.nome}':
          ''
      )
    ];
  }

  @override
  void initState() {
    super.initState();
    controleCadastro = ControleCadastroProduto();
    controleCadastro.emitirLista();
  }

  @override
  void dispose(){
    controleCadastro.finalizar();
    super.dispose();
  }

  @override
  Widget build(BuildContext contexto) {
    return criarPagina(contexto,'Produtos');
  }


  Widget _criarItemGaveta(int indicePagina,
      IconData icone,
      String titulo,
      String pagina) {
    return ListTile(
      leading: Icon(
        icone,
        color: Colors.black,
        size: 25,
      ),
      title: Text(
        titulo,
        style: TextStyle(fontWeight: FontWeight.bold,
            fontSize: 18),
      ),
      onTap: () {
        // blocInterfacePrincipal.eventoAba.add(indicePagina);
        // scaffoldKey.currentState.openEndDrawer();
        Navigator.pushNamed(context, pagina);
      },
    );
  }

  @override
  Widget criarGaveta() {
    // TODO: implement criarGaveta
    return criarGavetaGenerica(Navegacao.produto, _criarItemGaveta);
  }

}
