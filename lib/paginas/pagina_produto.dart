import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //formataçã
import 'package:lista_compras/controles/controle_cadastro_tipo_produto.dart';
import 'package:lista_compras/paginas/pagina_entidade.dart';
import 'package:lista_compras/entidades/tipo_produto.dart';
import 'package:lista_compras/entidades/produto.dart';
import 'package:lista_compras/entidades/entidade.dart';
import 'package:lista_compras/paginas/mensagem.dart';

class PaginaProduto extends StatefulWidget with PaginaEntidade {
  PaginaProduto(
      {Key? key,
      required OperacaoCadastro operacaoCadastro,
      required Entidade entidade})
      : super(key: key) {
    this.operacaoCadastro = operacaoCadastro;
    this.entidade = entidade;
  }

  @override
  State<PaginaProduto> createState() => _PaginaProdutoState();
}

class _PaginaProdutoState extends State<PaginaProduto>
    with EstadoPaginaEntidade {
  final _controladorNome = TextEditingController();
  final _controladorQuantidade = TextEditingController();

  ControleCadastroTipoProduto _controleTipoProduto =
      ControleCadastroTipoProduto();

  List<DropdownMenuItem<TipoProduto>> _itensTipoProduto = [];
  List<DropdownMenuItem<String>> _itensUnidade = [];

  void _carregarUnidades() {
    unidadesProdutos.forEach((unidade) {
      _itensUnidade.add(DropdownMenuItem<String>(
        value: unidade,
        child: Text(unidade),
      ));
    });
  }

  void _carregarTiposProdutos() async {
    _itensTipoProduto = [];
    List<Entidade> entidades = await _controleTipoProduto.selecionarTodos();
    entidades.forEach((entidade) {
      TipoProduto tipoProduto = entidade as TipoProduto;
      print(tipoProduto.nome);
      var item = DropdownMenuItem<TipoProduto>(
        value: tipoProduto,
        child: Text(tipoProduto.nome),
      );

      _itensTipoProduto.add(item);
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    print("_PaginaProdutoState");
    _carregarUnidades();
    setState(() {
      _carregarTiposProdutos();
    });
    //É necessário para forçar a atualização da página
    if (widget.operacaoCadastro == OperacaoCadastro.edicao) {
      Produto produto = widget.entidade as Produto;
      _controladorNome.text = produto.nome;
      _controladorQuantidade.text = produto.quantidade.toString();
      setState(() {});
    }
  }

  @override
  dispose() {
    _controladorNome.dispose();
    _controladorQuantidade.dispose();
    _controleTipoProduto.finalizar();
    super.dispose();
  }

  @override
  List<Widget> criarConteudoFormulario(BuildContext contexto) {
    Produto produto = (widget.entidade as Produto);
    return [
      TextField(
        controller: _controladorNome,
        decoration: InputDecoration(
          labelText: 'Nome',
        ),
      ),
      TextField(
        controller: _controladorQuantidade,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter(RegExp('[0-9,.]'), allow: true)
        ],
        decoration: InputDecoration(
          labelText: 'Quantidade',
        ),
      ),
      DropdownButton(
        isExpanded: true,
        hint: Text('Unidade'),
        items: _itensUnidade,
        value: (widget.entidade as Produto).unidade,
        onChanged: (unidade) {
          //É necessário ter o onChanged para funcionar.
          setState(() {
            (widget.entidade as Produto).unidade = unidade as String;
          });
        },
      ),
      DropdownButton(
        isExpanded: true,
        hint: Text('Tipo do produto'),
        items: _itensTipoProduto,
        value:
            produto.tipoProduto.identificador != '' ? produto.tipoProduto : null,
        onChanged: (tipoProduto) {
          //É necessário ter o onChanged para funcionar.
          setState(() {
            produto.tipoProduto = tipoProduto as TipoProduto;
          });
        },
      ),
    ];
  }

  @override
  bool dadosCorretos(BuildContext contexto) {
    Produto produto = widget.entidade as Produto;
    if ((produto.nome == null) || (produto.nome == '')) {
      informar(context, 'É necessário informar o nome.');
      return false;
    }
    if (produto.idTipoProduto == null) {
      informar(contexto, 'É necessário informar o tipo.');
      return false;
    }
    return true;
  }

  @override
  void transferirDadosParaEntidade() {
    Produto produto = widget.entidade as Produto;
    produto.nome = _controladorNome.text;
    if (_controladorQuantidade.text != '') {
      produto.quantidade = double.parse(_controladorQuantidade.text);
    } else {
      produto.quantidade = 0.0;
    }
    //O tipo e a unidade são definidos pelo setState do DropDownButton
  }

  @override
  Widget build(BuildContext context) {
    return criarPagina(context, widget.operacaoCadastro, 'Produto');
  }
}
