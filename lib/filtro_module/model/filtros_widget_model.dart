import 'package:package_reports/filtro_module/model/filtros_model.dart';

class FiltrosWidgetModel {

  String nome = '';  
  String arquivoQuery = '';  
  String funcaoPrincipal = '';
  String bancoBuscarFiltros = '';
  String tipoWidget = '';
  bool isVisivel = false;

  List<FiltrosModel> itensSelecionados = [];

  FiltrosWidgetModel({
    this.nome = '',
    this.arquivoQuery = '',
    this.funcaoPrincipal = '',
    this.bancoBuscarFiltros = '',
    this.tipoWidget = '',
    this.isVisivel = false,
  });

  FiltrosWidgetModel.fromJson(Map<String, dynamic> json){
    nome = json['nome'];
    isVisivel = json['exibir'];
    tipoWidget = json['tipo'];
    funcaoPrincipal = json['funcao'];
    bancoBuscarFiltros = json['banco'];
    arquivoQuery = json['arquivoquery'];
  }

}