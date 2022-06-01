import 'package:flutter/material.dart';
import 'package:lista_compras/paginas/quantidade.dart';

import '../controles/controle_cadastro_produto.dart';
import '../controles/controle_cadastro_tipo_produto.dart';
import '../entidades/entidade.dart';
import '../entidades/produto.dart';
import '../entidades/tipo_produto.dart';

mixin ListaProdutos {
  List<Entidade> tiposProdutos = <Entidade>[];
  List<Entidade> produtos = <Entidade>[];
  ControleCadastroTipoProduto controleCadastroTipoProduto =
      ControleCadastroTipoProduto();
  ControleCadastroProduto controleCadastroProduto = ControleCadastroProduto();
  late State estadoPagina;

  void selecionarProdutos(int idTipoProduto) async {
    produtos = await controleCadastroProduto.selecionarPorTipo(idTipoProduto);
    estadoPagina.setState(() {});
  }

  Widget criarItemListaTipoProduto(BuildContext contexto, int indice) {
    return GestureDetector(
      child: Card(
        child: Container(
            width: 100, //MediaQuery.of(contexto).size.width,
            alignment: Alignment.center,
            padding: EdgeInsets.all(5.0),
            child: Text(
              (tiposProdutos[indice] as TipoProduto).nome,
            )),
      ),
      onTap: () {
        selecionarProdutos(tiposProdutos[indice].identificador);
      },
    );
  }

  Widget criarListaTiposProdutos(bool incluiOpcaoTodos) {
    return StreamBuilder(
        //key: Key('janela'),
        stream: controleCadastroTipoProduto.fluxo,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            tiposProdutos = snapshot.data as List<TipoProduto>;
            if (incluiOpcaoTodos) {
              tiposProdutos.add(TipoProduto(idTipoProduto: 0, nome: 'Todos'));
            }
            return ListView.builder(
                padding: EdgeInsets.all(5.0),
                scrollDirection: Axis.horizontal,
                itemCount: tiposProdutos.length,
                itemBuilder: (context, index) {
                  return criarItemListaTipoProduto(context, index);
                });
          } else {
            return Container();
          }
        });
  }

  Widget criarItemListaProduto(BuildContext contexto, int indice) {
    Produto produtoSelecionado = produtos[indice] as Produto;
    return Card(
      color: produtoSelecionado.quantidade > 0 ? Colors.blue[50] : Colors.white,
      child: Row(
        children: <Widget>[
          Container(
            width: 200,
            //MediaQuery.of(contexto).size.width,
            height: 80,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(5.0),
            child: Text(
              produtoSelecionado.nome,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          Quantidade(
            quantidadeInicial: produtoSelecionado.quantidade,
            eventoNovaQuantidade: (valor) {
              estadoPagina.setState(() {
                produtoSelecionado.quantidade = valor;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget criarListaProdutos() {
    return ListView.builder(
        padding: EdgeInsets.all(5.0),
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          return criarItemListaProduto(context, index);
        });
  }
}
