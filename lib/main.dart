import 'package:flutter/material.dart';
import 'package:lista_compras/paginas/navegacao.dart';
import 'package:lista_compras/paginas/pagina_cadastro_produto.dart';
import 'package:lista_compras/paginas/pagina_cadastro_tipo_produto.dart';

void main() {
  runApp(ListaCompras());
}


class ListaCompras extends StatelessWidget {
  const ListaCompras({Key? key}) : super(key: key);

  static Map<String, WidgetBuilder> criarRotasNavegacao() {
    return <String, WidgetBuilder>{
      Navegacao.principal: (BuildContext context) =>
          PaginaPrincipal(),
      Navegacao.tipoProduto : (BuildContext context) =>
          PaginaCadastroTipoProduto(),
      Navegacao.produto : (BuildContext context) =>
          PaginaCadastroProduto(),
    };
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Listas de Compras',
      theme: ThemeData(
      ),
      routes: criarRotasNavegacao(),
      home: PaginaPrincipal(),
    );
  }
}

