import 'package:lista_compras/banco_dados/dicionario_dados.dart';
import 'package:lista_compras/entidades/entidade.dart';
import 'package:lista_compras/entidades/item_lista_compra.dart';
import 'package:lista_compras/entidades/produto.dart';

class ListaCompra extends Entidade{
  static const primeiroNumeroItem = 0;
  int _numeroItem = primeiroNumeroItem;
  String nome = '';
  //Facilita a localização de um item
  final Map<int, ItemListaCompra> _itens = {};
  ListaCompra({int idCompra = 0,
    this.nome = ''}) : super(idCompra);
  ListaCompra.criarDeMapa(Map<String,dynamic> mapaEntidade)
      : super.criarDeMapa(mapaEntidade){
    identificador = mapaEntidade[DicionarioDados.idListaCompra];
    nome = mapaEntidade[DicionarioDados.nome];
  }

  @override

  Entidade criarEntidade(Map<String,dynamic> mapaEntidade){
    ListaCompra listaCompra= ListaCompra.criarDeMapa(mapaEntidade);
    for (var item in _itens.values) {
      listaCompra.incluirItem(item.criarCopia() as ItemListaCompra);
    }
    return listaCompra;
  }

  bool temItens(){
    return _itens.isNotEmpty;
  }

  List<ItemListaCompra> get itens{
    return _itens.values.map((e) => e).toList();
  }

  void excluirItens() {
    _itens.clear();
    _numeroItem = primeiroNumeroItem;
  }

  void incluirItem(ItemListaCompra item){
    _itens[item.numeroItem] = item;
    if (item.numeroItem > _numeroItem){
      _numeroItem = item.numeroItem+1;
    }
  }

  void incluirProduto(Produto produto, double quantidade){
    print("=======================numeroItem $_numeroItem");
    ItemListaCompra item = ItemListaCompra(
        numeroItem : _numeroItem,
        produto: produto,
        quantidade : quantidade,
        selecionado : false
    );
    print("=======================numeroItem $_numeroItem");
    _itens[_numeroItem] = item;
    _numeroItem++;
  }

  void excluirItem(int numeroItem){
    _itens.remove(numeroItem);
  }

  List<ItemListaCompra> retornarItensPorTipo(int idTipoProduto){
    List< ItemListaCompra > entidades = [];
    print(entidades);
    _itens.values.forEach((item) {
      if ((idTipoProduto == 0) ||
          (item.produto.idTipoProduto == idTipoProduto)){
        entidades.add(item);
      }
    });
    return entidades;
  }

  List<Produto> retornarProdutosPorTipo(int idTipoProduto){

    List<Produto> entidades = [];
    _itens.values.forEach((item) {
      if ((idTipoProduto == 0) ||
          (item.produto.idTipoProduto == idTipoProduto)){
        Produto produto =  item.produto;
        produto.quantidade =  item.quantidade;
        entidades.add(item.produto);
      }
    });
    return entidades;
  }

  @override
  Map<String, dynamic> converterParaMapa(){

    Map<String, dynamic> valores;
    valores = {
      DicionarioDados.nome : nome,
    };
    //Se identificador é maior que zero, é alteração!
    if (identificador > 0){
      valores.addAll({DicionarioDados.idListaCompra :
      identificador});
    }
    return valores;
  }
}