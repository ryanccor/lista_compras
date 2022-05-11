import 'package:flutter/material.dart';
import 'package:lista_compras/entidades/entidade.dart';

enum OperacaoCadastro {inclusao, edicao, selecao}

mixin PaginaEntidade {
  late OperacaoCadastro operacaoCadastro;
  late Entidade entidade;
}

mixin EstadoPaginaEntidade {
  List<Widget> criarConteudoFormulario(BuildContext context);
  
  void transferirDadosParaEntidade();
  
  bool dadosCorretos(BuildContext context);
  
  String prepararTitulo(OperacaoCadastro operacao, String titulo){
    switch (operacao) {
      case OperacaoCadastro.inclusao:
        return 'Inclusão de ' + titulo;
      case OperacaoCadastro.edicao:
        return 'Edição de ' + titulo;
      case OperacaoCadastro.selecao:
        return 'Seleção de ' + titulo;
    }
  }
  
  Widget criarFormulario(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: criarConteudoFormulario(context) + [
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                  onPressed: (){
                    transferirDadosParaEntidade();
                    if (dadosCorretos(context)) {
                      Navigator.pop(context, true);
                    }
                  }, 
                  child: const Text('Salvar')
              ),
              const SizedBox(
                width: 50.0,
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context,false);
                  }, 
                  child: const Text('Cancelar'))
            ],
          )
        ],
      ),
    );
  }
  
  Widget criarPagina(BuildContext context, OperacaoCadastro operacao, String titulo){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          prepararTitulo(operacao, titulo)
        ),
        centerTitle: true,
      ),
      body: criarFormulario(context),
    );
  }
}