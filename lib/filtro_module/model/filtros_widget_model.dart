import 'package:package_reports/filtro_module/model/filtros_model.dart';

class FiltrosWidgetModel {

  String tipoFiltro = '';
  String nome = '';  
  String arquivoQuery = '';  
  String funcaoPrincipal = '';
  String bancoBuscarFiltros = '';
  String tipoWidget = '';
  bool isVisivel = false;

  Set<FiltrosModel> itensSelecionados = {};

  FiltrosWidgetModel({
    this.tipoFiltro = '',
    this.nome = '',
    this.arquivoQuery = '',
    this.funcaoPrincipal = '',
    this.bancoBuscarFiltros = '',
    this.tipoWidget = '',
    this.isVisivel = false,
  });

  FiltrosWidgetModel.fromJson(Map<String, dynamic> json, String key){
    tipoFiltro = key;
    nome = json['nome'];
    isVisivel = json['exibir'];
    tipoWidget = json['tipo'];
    funcaoPrincipal = json['funcao'];
    bancoBuscarFiltros = json['banco'];
    arquivoQuery = json['arquivoquery'];
  }

  Map<String, dynamic> toJsonItensSelecionados() {
    Map<String, dynamic> mapItensSelecionados = <String, dynamic>{};
    for(FiltrosModel item in itensSelecionados){
      mapItensSelecionados.addAll( mapItensSelecionados[tipoFiltro] = item.toJson());
    }
    return mapItensSelecionados;
  }


}