import 'package:flutter/material.dart';
import 'package:lista_compras/paginas/pagina_cadastro.dart';
import 'package:lista_compras/paginas/pagina_entidade.dart';
import 'package:lista_compras/paginas/pagina_lista_compra.dart';

import '../controles/controle_cadastro_lista_compra.dart';
import '../entidades/entidade.dart';
import '../entidades/lista_compra.dart';

class Navegacao{
  static const principal = '/principal';
  static const tipoProduto = '/tipo_produto';
  static const produto = '/produto';
}


class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({Key? key}) : super(key: key);
  @override
  State<PaginaPrincipal> createState() =>
      _PaginaPrincipalState();
}
class _PaginaPrincipalState extends State<PaginaPrincipal>
    with PaginaCadastro {

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
  Widget criarGaveta(){
    return criarGavetaGenerica(Navegacao.principal, _criarItemGaveta);
  }

  @override
  Widget criarPaginaEntidade(OperacaoCadastro operacaoCadastro,
      Entidade entidade){
    return PaginaListaCompra(operacaoCadastro:operacaoCadastro,
        entidade:entidade);
  }

  @override
  Entidade criarEntidade(){
    return ListaCompra(idCompra: 0,
        nome: '');
  }

  @override
  void initState() {
    super.initState();
    controleCadastro = ControleCadastroListaCompra();
    controleCadastro.emitirLista();
  }

  @override
  void dispose(){
    controleCadastro.finalizar();
    super.dispose();
  }

  @override
  Widget build(BuildContext contexto) {
    return criarPagina(contexto, 'Listas de Compras');
  }

  @override
  List<Widget> criarConteudoItem(Entidade entidade){
    return [
      SizedBox(height: 50,),
      Text(
        (entidade as ListaCompra).nome,
      ),
      SizedBox(height: 50,),
    ];
  }
}

Widget criarGavetaGenerica(String excludePath, Widget Function(int indice, IconData icone, String nome, String caminho) _criarItemGaveta){
  var paths = [Navegacao.principal, Navegacao.produto, Navegacao.tipoProduto];
  Map<String, Map<String, dynamic>> pathData= {
    Navegacao.principal:{
      "title":"Principal",
      "icon":Icons.home,
    },
    Navegacao.produto:{
      "title":"Produtos",
      "icon":Icons.shopping_cart,
    },
    Navegacao.tipoProduto:{
      "title":'Tipos de Produtos',
      "icon":Icons.apps,
    },
  };


  List<Widget> drawerItems = [
    SafeArea(
      child: Container(),
    ),
  ];
  for(int i  =0;i<paths.length; i++){
    String path =paths[i];
    if(path == excludePath){
      continue;
    }
    drawerItems.add(_criarItemGaveta(i+1,
        pathData[path]!["icon"],
        pathData[path]!["title"],
        path));
  }
  return
    Drawer(
      child: Container(
        color: Colors.white,
        child: ListView(
          padding: EdgeInsets.all(0.0),
          children: drawerItems,
        ),
      ),
    );
}