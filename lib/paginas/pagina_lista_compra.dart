import 'package:flutter/material.dart';
import 'package:lista_compras/paginas/mensagem.dart';
import 'package:lista_compras/paginas/pagina_entidade.dart';

import '../entidades/entidade.dart';
import '../entidades/lista_compra.dart';
import 'lista_produtos.dart';

class PaginaListaCompra extends StatefulWidget
    with PaginaEntidade{
  @override
  _PaginaListaCompraState createState() =>
      _PaginaListaCompraState();
  PaginaListaCompra({@required operacaoCadastro, entidade}){
    this.operacaoCadastro = operacaoCadastro;
    this.entidade = entidade;
  }
}



class _PaginaListaCompraState extends State<PaginaListaCompra>
    with EstadoPaginaEntidade, ListaProdutos {

  final _controladorNome = TextEditingController();
  List<Entidade> _itens = <Entidade>[];

  @override
  void initState() {
    super.initState();
    estadoPagina = this;//Por causa do setState
    controleCadastroTipoProduto.emitirLista();
    if (widget.operacaoCadastro == OperacaoCadastro.edicao) {
      _controladorNome.text = (widget.entidade as ListaCompra).nome;
      selecionarProdutos(0);
    }
  }

  @override
  void dispose(){
    controleCadastroTipoProduto.finalizar();
    controleCadastroProduto.finalizar();
    _controladorNome.dispose();
    super.dispose();
  }

  @override
  bool dadosCorretos(BuildContext contexto){
    ListaCompra listaCompra = widget.entidade as ListaCompra;
    if ((listaCompra.nome == null) || (listaCompra.nome == '')){
      informar(contexto, 'É necessário informar o nome da lista.');
      return false;
    }
    if (!listaCompra.temItens()){
      informar(contexto, 'É necessário incluir produtos na lista.');
      return false;
    }
    return true;
  }

  @override
  void transferirDadosParaEntidade(){
    ListaCompra listaCompra = widget.entidade as ListaCompra;
    listaCompra.nome = _controladorNome.text;
    // Os itens foram inseridos a partir da página de
    // seleção de produtos.
  }

  @override
  void selecionarProdutos(int idTipoProduto) async {
    ListaCompra listaCompra = widget.entidade as ListaCompra;
    produtos =
        listaCompra.retornarProdutosPorTipo(idTipoProduto);
    estadoPagina.setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  List<Widget> criarConteudoFormulario(BuildContext
  contexto){
    return [TextField(
      controller: _controladorNome,
      decoration: const InputDecoration(
        labelText: 'Nome',
      ),
    ),
    ];
  }
}
