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

  Map<String, List<Map<String, dynamic>>> toJsonItensSelecionados() {
    Map<String, List<Map<String, dynamic>>> mapItensSelecionados = <String, List<Map<String, dynamic>>>{};
    List<Map<String, dynamic>> json = [];

    for(FiltrosModel item in itensSelecionados){
      json.add(item.toJson());
      mapItensSelecionados.addAll({ tipoFiltro: json});
    }
    
    return mapItensSelecionados;
  }


}