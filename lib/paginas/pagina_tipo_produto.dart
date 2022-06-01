import 'package:flutter/material.dart';
import 'package:lista_compras/paginas/mensagem.dart';
import 'package:lista_compras/paginas/pagina_entidade.dart';
import 'package:lista_compras/entidades/tipo_produto.dart';

class PaginaTipoProduto extends StatefulWidget with PaginaEntidade{
  PaginaTipoProduto({required operacaoCadastro,
    required entidade}){
    this.operacaoCadastro = operacaoCadastro;
    this.entidade = entidade;
  }
  @override
  _PaginaTipoProdutoState createState() =>
      _PaginaTipoProdutoState();
}

class _PaginaTipoProdutoState extends State<PaginaTipoProduto> with EstadoPaginaEntidade{
  final _controladorNome = TextEditingController();

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

  @override
  bool dadosCorretos(BuildContext contexto){
    TipoProduto tipoProduto = widget.entidade as
    TipoProduto;
    if ((tipoProduto.nome == null) ||
        (tipoProduto.nome == '')){
      informar(contexto,
          'É necessário informar o nome.');
      return false;
    }
    return true;
  }

  @override
  void transferirDadosParaEntidade(){
    TipoProduto tipoProduto = widget.entidade as
    TipoProduto;
    tipoProduto.nome = _controladorNome.text;
  }

  @override
  void initState() {
    super.initState();
    if (widget.operacaoCadastro == OperacaoCadastro.edicao) {
      _controladorNome.text = (widget.entidade as TipoProduto).nome;
    }
  }

  @override
  void dispose() {
    _controladorNome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return criarPagina(context,
        widget.operacaoCadastro,
        'Tipo de Produto');
    }
  }
