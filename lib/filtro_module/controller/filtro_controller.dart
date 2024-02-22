import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:package_reports/filtro_module/model/filtros_model.dart';
import 'package:package_reports/filtro_module/model/filtros_widget_model.dart';
part 'filtro_controller.g.dart';

class FiltroController = FiltroControllerBase with _$FiltroController;

abstract class FiltroControllerBase with Store {

  FiltroControllerBase({
    required this.mapaFiltrosWidget
  }){
    getDadosCriarFiltros();
  }

  late Map<String, dynamic> mapaFiltrosWidget = {};

  @observable
  List<FiltrosModel> listaFiltros = [];

  List<FiltrosWidgetModel> listaFiltrosParaConstruirTela = [];

  void getDadosCriarFiltros () async {
    List dados = await jsonDecode(mapaFiltrosWidget['filtro']);
    listaFiltrosParaConstruirTela = dados.map((e) => FiltrosWidgetModel.fromJson(e)).toList();
  }

}