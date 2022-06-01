abstract class Entidade{
  int identificador = 0;

  Entidade(this.identificador);

  Entidade.criarDeMapa(Map<String, dynamic> mapaEntidade);
  
  Map<String, dynamic> converterParaMapa();

  Entidade criarEntidade(Map<String, dynamic> mapaEntidade);

  Entidade criarCopia() {
    Map<String, dynamic> mapa = converterParaMapa();
    return criarEntidade(mapa);
  }
}