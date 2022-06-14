import 'package:flutter/material.dart';
import 'package:lista_compras/paginas/mensagem.dart';
import 'package:lista_compras/paginas/pagina_entidade.dart';
import 'package:lista_compras/entidades/entidade.dart';
import 'package:lista_compras/controles/controle_cadastro.dart';

mixin PaginaCadastro{
  late ControleCadastro controleCadastro;

  List<Entidade> entidades = <Entidade>[];

  List<Widget> criarConteudoItem(Entidade entidade);

  Widget criarPaginaEntidade(OperacaoCadastro operacaoCadastro, Entidade entidade);

  void mostrarBarraMensagem(BuildContext context, String mensagem){
    final SnackBar barraMensagem = SnackBar(
        content: Text(mensagem)
    );

    ScaffoldMessenger.of(context).showSnackBar(barraMensagem);
  }

  void abrirPaginaEntidade(BuildContext context, OperacaoCadastro operacaoCadastro, Entidade entidade) async {
    bool confirmado = await Navigator.push(context,
      MaterialPageRoute(builder: (context) {
        return criarPaginaEntidade(operacaoCadastro, entidade);
      })
    );

    if (confirmado) {
      int resultado;

      if (operacaoCadastro == OperacaoCadastro.inclusao) {
        resultado = await controleCadastro.incluir(entidade);
      } else {
        resultado = await controleCadastro.alterar(entidade);
      }
      if (resultado > 0) {
        controleCadastro.emitirLista();
        mostrarBarraMensagem(context,
        operacaoCadastro == OperacaoCadastro.inclusao
        ? 'Inclusão realizada com sucesso.'
        : 'Alteração realizada com sucesso.'
            );
      } else {
        mostrarBarraMensagem(context, 'Operação não foi realizada.');
      }
    }
  }

  Widget criarItemLista(context, indice) {
    return Dismissible(
        key: Key(entidades[indice].identificador.toString()),
        background: Container(
          color: Colors.redAccent,
          alignment: Alignment.centerLeft,
          child: const Align(
            alignment: Alignment(-0.9,0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        child: GestureDetector(
          child: Card(
            child: Container(
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: criarConteudoItem(entidades[indice]),
              ),
            ),
          ),
          onTap: (){
            abrirPaginaEntidade(context, OperacaoCadastro.edicao, entidades[indice].criarCopia());
          },
        ),
        confirmDismiss: (direcao) async {
          bool? confirmado = await confirmar(context, 'Deseja realmente excluir?');
          return confirmado;
          },
        onDismissed: (direcao) async {
          int resultado = await controleCadastro.excluir(entidades[indice].identificador);
          if(resultado > 0) {
            controleCadastro.emitirLista();
            mostrarBarraMensagem(context, 'Exclusão realizada com sucesso.');
          }
        },
    );
  }

  Widget criarLista(){
    if (controleCadastro == null) {
      print("criarLista");
      return Container(
        child: const Text(
          'Controle não instanciado',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      );
    }
    return StreamBuilder(
        stream: controleCadastro.fluxo,
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            entidades = snapshot.data as List<Entidade>;
            return ListView.builder(
                padding: const EdgeInsets.all(5.0),
                itemCount: entidades.length,
                itemBuilder: (context, index) {
                  return criarItemLista(context, index);
                });
          } else {
            return Container(
              alignment: Alignment.center,
              child: const Text('Inclua os intems!',
                style: TextStyle(fontSize: 30),
              ),
            );
          }
        }
    );
  }

  Entidade criarEntidade();

  Widget criarGaveta();

  Widget criarPagina(BuildContext contexto, String titulo){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titulo,
        ),
        centerTitle: true,
      ),
      drawer: criarGaveta(),
      body: criarLista(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed:() {
          abrirPaginaEntidade(contexto,
              OperacaoCadastro.inclusao,
              criarEntidade());
        },
      ),
    );
  }
}