class FiltrosWidgetModel {

  String nome = '';  
  String arquivoQuery = '';  
  String funcaoPrincipal = '';
  String bancoBuscarFiltros = '';
  String tipoWidget = '';
  bool isVisivel = false;

  FiltrosWidgetModel({
    this.nome = '',
    this.arquivoQuery = '',
    this.funcaoPrincipal = '',
    this.bancoBuscarFiltros = '',
    this.tipoWidget = '',
    this.isVisivel = false,
  });

  FiltrosWidgetModel.fromJson(Map<String, dynamic> json){
    nome = json['NOME'];
    isVisivel = json['EXIBIR'];
  }

}