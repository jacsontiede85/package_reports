import 'package:mobx/mobx.dart';
import 'package:package_reports/filtro_module/model/filtros_widget_model.dart';
part 'filtros_pagina_atual.g.dart';

class FiltrosPageAtual = FiltrosPageAtualBase with _$FiltrosPageAtual;

abstract class FiltrosPageAtualBase with Store {
  int qualPaginaFiltroPertence = 0;

  @observable
  late FiltrosWidgetModel filtrosWidgetModel;

  FiltrosPageAtualBase({
    required this.qualPaginaFiltroPertence,
    required this.filtrosWidgetModel,
  });  

}