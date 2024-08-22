import 'package:mobx/mobx.dart';
import 'package:package_reports/filtro_module/model/filtros_model.dart';
import 'package:package_reports/filtro_module/model/filtros_widget_model.dart';
part 'filtros_pagina_atual_model.g.dart';

class FiltrosPageAtual = FiltrosPageAtualBase with _$FiltrosPageAtual;

abstract class FiltrosPageAtualBase with Store {
  int qualPaginaFiltroPertence = 0;

  @observable
  late FiltrosWidgetModel filtrosWidgetModel;

  FiltrosPageAtualBase({
    required this.qualPaginaFiltroPertence,
    required this.filtrosWidgetModel,
  });  

  FiltrosPageAtualBase.fromJson(Map<String, dynamic> json){
    qualPaginaFiltroPertence = json['qualPaginaFiltroPertence'];
    filtrosWidgetModel = FiltrosWidgetModel(
      arquivoQuery : json['filtrosWidgetModel']['arquivoQuery'],
      bancoBuscarFiltros : json['filtrosWidgetModel']['bancoBuscarFiltros'],
      funcaoPrincipal : json['filtrosWidgetModel']['funcaoPrincipal'],
      subtitulo : json['filtrosWidgetModel']['subtitulo'],
      tipoFiltro : json['filtrosWidgetModel']['tipoFiltro'],
      tipoWidget : json['filtrosWidgetModel']['tipoWidget'],
      titulo : json['filtrosWidgetModel']['titulo'],
      itensSelecionados :  (json['filtrosWidgetModel']['itensSelecionados'] as List).map((e) {
        return FiltrosModel.fromJson(e);
      }).toSet(),
    );

  }

}