import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:package_reports/filtro_module/model/filtros_model.dart';
import 'package:package_reports/filtro_module/model/filtros_widget_model.dart';
import 'package:package_reports/report_module/core/api_consumer.dart';
part 'filtro_controller.g.dart';

class FiltroController = FiltroControllerBase with _$FiltroController;

abstract class FiltroControllerBase with Store {

  FiltroControllerBase({
    required this.mapaFiltrosWidget,
    required this.indexPagina,
  }){
    getDadosCriarFiltros();
  }

  late Map<String, dynamic> mapaFiltrosWidget = {};

  late int indexPagina = 0;

  @observable
  List<FiltrosModel> listaFiltros = [];

  @observable
  List<Map<int ,FiltrosWidgetModel>> listaFiltrosParaConstruirTela = [];

  @observable
  bool loadingItensFiltors = false;

  void getDadosCriarFiltros () async {
    mapaFiltrosWidget.forEach((key, value) {
      listaFiltrosParaConstruirTela.add({ indexPagina : FiltrosWidgetModel.fromJson(value)});
    }); 
  }

  funcaoBuscarDadosDeCadaFiltro ({required FiltrosWidgetModel valor}) async {
    try{
      loadingItensFiltors = true;
      var response = await API().jwtSendJson(
        banco: valor.bancoBuscarFiltros,
        dados: {
          "arquivo" : valor.arquivoQuery,
          "function" : valor.funcaoPrincipal,
          "matricula" : "3312",
        }
      );
      List dados = jsonDecode(response);
      
      listaFiltros = dados.map((e) => FiltrosModel.fromJson(e)).toList();      
    }finally{
      loadingItensFiltors = false;
    }
  }

  adicionarItensSelecionado ({required int indexFiltro, required FiltrosModel itens}){
    if(itens.selecionado){
      listaFiltrosParaConstruirTela[indexFiltro][indexPagina]!.itensSelecionados.add(itens);
    }else{
      listaFiltrosParaConstruirTela[indexFiltro][indexPagina]!.itensSelecionados.remove(itens);
    }
  }

}