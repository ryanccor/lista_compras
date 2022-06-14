import 'package:flutter/material.dart';
import 'package:lista_compras/controles/controle_cadastro_tipo_produto.dart';
import 'package:lista_compras/entidades/tipo_produto.dart';
import 'package:lista_compras/paginas/pagina_cadastro.dart';
import 'package:lista_compras/paginas/pagina_tipo_produto.dart';
import 'package:lista_compras/paginas/pagina_entidade.dart';
import 'package:lista_compras/entidades/entidade.dart';

import 'navegacao.dart';

class PaginaCadastroTipoProduto extends StatefulWidget{
  const PaginaCadastroTipoProduto({Key? key}) : super(key: key);

  @override
  State<PaginaCadastroTipoProduto> createState() => _PaginaCadastroTipoProdutoState();
}

class _PaginaCadastroTipoProdutoState extends State<PaginaCadastroTipoProduto> with PaginaCadastro {
  @override
  Widget build(BuildContext context) {
    return criarPagina(context,
        'Tipo de Produto');
  }

  @override
  Widget criarPaginaEntidade(
      OperacaoCadastro operacaoCadastro,
      Entidade entidade){
    return PaginaTipoProduto(operacaoCadastro:operacaoCadastro,
        entidade:entidade);
  }


  @override
  Entidade criarEntidade() {
    // TODO: implement criarEntidade
    return TipoProduto(nome: '');
  }

  @override
  List<Widget> criarConteudoItem(Entidade entidade) {
    // TODO: implement criarConteudoItem
    return [
      const SizedBox(height: 35,),
      Text(
          (entidade as TipoProduto).nome
      ),
      const SizedBox(height: 35,),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controleCadastro = ControleCadastroTipoProduto();
    controleCadastro.emitirLista();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controleCadastro.finalizar();
    super.dispose();
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
      return criarGavetaGenerica(Navegacao.tipoProduto, _criarItemGaveta);
  }
}
