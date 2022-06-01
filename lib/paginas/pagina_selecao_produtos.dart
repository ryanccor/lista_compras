import 'package:flutter/material.dart';
import 'package:lista_compras/paginas/mensagem.dart';
import 'package:lista_compras/paginas/pagina_entidade.dart';

import '../entidades/lista_compra.dart';
import '../entidades/produto.dart';
import 'lista_produtos.dart';

class PaginaSelecaoProdutos extends StatefulWidget with PaginaEntidade {
  PaginaSelecaoProdutos({required operacaoCadastro, required entidade}) {
    this.operacaoCadastro = operacaoCadastro;
    this.entidade = entidade;
  }

  @override
  State<PaginaSelecaoProdutos> createState() => _PaginaSelecaoProdutosState();
}

class _PaginaSelecaoProdutosState extends State<PaginaSelecaoProdutos>
    with EstadoPaginaEntidade, ListaProdutos {
  List<Produto> produtosSelecionados = <Produto>[];

  @override
  void initState() {
    super.initState();
    estadoPagina = this; //do mixin. Por causa do setState
    controleCadastroTipoProduto.emitirLista();
  }

  @override
  void dispose() {
    controleCadastroTipoProduto.finalizar();
    controleCadastroProduto.finalizar();
    super.dispose();
  }

  @override
  List<Widget> criarConteudoFormulario(BuildContext contexto) {
    return [
      SizedBox(
        height: 5,
      ),
      Container(
        color: Colors.amberAccent,
        height: 70,
        width: MediaQuery.of(contexto).size.width,
        //A lista deve estar dentro de um container porque é necessário definir as suas dimensões.
        child: criarListaTiposProdutos(false),
      ),
      SizedBox(
        height: 5,
      ),
      Container(
        color: Colors.black26,
        height: MediaQuery.of(contexto).size.height * 0.55,
        width: MediaQuery.of(contexto).size.width,
        //A lista deve estar dentro de um container porque é necessário definir as suas dimensões.
        child: criarListaProdutos(),
      )
    ];
  }

  @override
  bool dadosCorretos(BuildContext contexto) {
    ListaCompra listaCompra = widget.entidade as ListaCompra;
    if (!listaCompra.temItens()) {
      informar(contexto,
          'É necessário selecionar ao menos um produto (quantidade maior que 0).');
      return false;
    }
    return true; //todo - completar
  }

  @override
  void transferirDadosParaEntidade() {
    ListaCompra listaCompra = widget.entidade as ListaCompra;
    listaCompra.excluirItens();
    for (int i = 0; i < produtos.length; i++) {
      Produto produto = produtos[i] as Produto;
      if (produto.quantidade > 0) {
        listaCompra.incluirProduto(produto, produto.quantidade);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return criarPagina(
        context, OperacaoCadastro.selecao, 'Seleção de Produtos');
  }
}
