import 'package:flutter/material.dart';
import 'package:lista_compras/controles/controle_cadastro_item_lista_compra.dart';
import 'package:lista_compras/entidades/item_lista_compra.dart';
import 'package:lista_compras/paginas/mensagem.dart';
import 'package:lista_compras/paginas/pagina_entidade.dart';
import 'package:lista_compras/paginas/pagina_selecao_produtos.dart';

import '../entidades/entidade.dart';
import '../entidades/lista_compra.dart';
import 'lista_produtos.dart';

class PaginaListaCompra extends StatefulWidget with PaginaEntidade {
  @override
  _PaginaListaCompraState createState() => _PaginaListaCompraState();
  PaginaListaCompra({@required operacaoCadastro, entidade}) {
    this.operacaoCadastro = operacaoCadastro;
    this.entidade = entidade;
  }
}

class _PaginaListaCompraState extends State<PaginaListaCompra>
    with EstadoPaginaEntidade, ListaProdutos {
  final _controladorNome = TextEditingController();
  final _controleItemLista = ControleCadastroItemListaCompra();
  List<Entidade> _itens = <Entidade>[];

  @override
  void initState() {
    super.initState();
    estadoPagina = this; //Por causa do setState
    controleCadastroTipoProduto.emitirLista();
    if (widget.operacaoCadastro == OperacaoCadastro.edicao) {
      _controladorNome.text = (widget.entidade as ListaCompra).nome;

      selecionarProdutos(0);
    }
  }

  @override
  void dispose() {
    controleCadastroTipoProduto.finalizar();
    controleCadastroProduto.finalizar();
    _controleItemLista.finalizar();
    _controladorNome.dispose();
    super.dispose();
  }

  @override
  bool dadosCorretos(BuildContext contexto) {
    ListaCompra listaCompra = widget.entidade as ListaCompra;
    if ((listaCompra.nome == null) || (listaCompra.nome == '')) {
      informar(contexto, 'É necessário informar o nome da lista.');
      return false;
    }
    if (!listaCompra.temItens()) {
      informar(contexto, 'É necessário incluir produtos na lista.');
      return false;
    }
    return true;
  }

  @override
  void transferirDadosParaEntidade() {
    ListaCompra listaCompra = widget.entidade as ListaCompra;
    listaCompra.nome = _controladorNome.text;
    for (ItemListaCompra item in listaCompra.itens) {
      item.quantidade = item.produto.quantidade;
    }
    // Os itens foram inseridos a partir da página de
    // seleção de produtos.
  }

  @override
  void selecionarProdutos(String idTipoProduto) async {
    ListaCompra listaCompra = widget.entidade as ListaCompra;
    print("selecionando produtos da lista ${listaCompra.identificador}");
    print("lista vazia ${listaCompra.itens.isEmpty}");
    print("itens: ${listaCompra.itens}");
    if (listaCompra.identificador != "") {
      List<Entidade> itens = await _controleItemLista
          .selecionarDaListaCompra(listaCompra.identificador);
      for (Entidade item in itens) {
        listaCompra.incluirItem(item as ItemListaCompra);
      }
    }
    produtos = listaCompra.retornarProdutosPorTipo(idTipoProduto);
    estadoPagina.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return criarPagina(context, widget.operacaoCadastro, "Lista de Compras");
  }

  @override
  List<Widget> criarConteudoFormulario(BuildContext contexto) {
    return [
      TextField(
        controller: _controladorNome,
        decoration: const InputDecoration(
          labelText: 'Nome',
        ),
      ),
      Container(
        color: Colors.grey,
        margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
        child: Column(
          children: [
            Container(height: 50, child: criarListaTiposProdutos(true)),
            Container(child: criarListaProdutos()),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return PaginaSelecaoProdutos(
                      entidade: widget.entidade,
                      operacaoCadastro: OperacaoCadastro.selecao,
                    );
                  })).then((value) => setState(() {
                        selecionarProdutos(0);
                      }));
                },
                child: Icon(Icons.add))
          ],
        ),
      ),
    ];
  }
}
