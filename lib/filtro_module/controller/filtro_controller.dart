import 'dart:convert';
import 'package:mobx/mobx.dart';
import 'package:package_reports/filtro_module/model/filtros_model.dart';
import 'package:package_reports/filtro_module/model/filtros_widget_model.dart';
import 'package:package_reports/report_module/controller/report_from_json_controller.dart';
import 'package:package_reports/global/core/api_consumer.dart';
import 'package:package_reports/global/core/settings.dart';
part 'filtro_controller.g.dart';

class FiltroController = FiltroControllerBase with _$FiltroController;

abstract class FiltroControllerBase with Store {

  Map<String, dynamic> mapaFiltrosWidget = {};
  int indexPagina = 0;
  late ReportFromJSONController controllerReports;

  FiltroControllerBase({
    required this.mapaFiltrosWidget,
    required this.indexPagina,
    required this.controllerReports,
  }){
    getDadosCriarFiltros();
  }

  @observable
  List<FiltrosModel> listaFiltros = [];

  @observable
  List<Map<int ,FiltrosWidgetModel>> listaFiltrosParaConstruirTela = [];

  @observable
  bool loadingItensFiltors = false;

  @observable
  String dtinicio = Settings.getDataPTBR(), dtfim = Settings.getDataPTBR();

  void getDadosCriarFiltros () async {
    mapaFiltrosWidget.forEach((key, value) {
      listaFiltrosParaConstruirTela.add({ indexPagina : FiltrosWidgetModel.fromJson(value, key)});
    });
  }

  void funcaoBuscarDadosDeCadaFiltro ({required FiltrosWidgetModel valor, required int indexFiltro}) async {
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

      for(FiltrosModel itens in listaFiltros){
        for(FiltrosModel itensSelecionados in listaFiltrosParaConstruirTela[indexFiltro][indexPagina]!.itensSelecionados){
          if(itens.codigo == itensSelecionados.codigo){
            itens = itensSelecionados;
            listaFiltros[listaFiltros.indexOf(itens)] = itens;
          }
        }
      }

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

  criarNovoBody() async {
    Map<String, dynamic> novoBody = {};

    for(Map<int, FiltrosWidgetModel> valores in listaFiltrosParaConstruirTela){
      novoBody.addAll(valores[indexPagina]!.toJsonItensSelecionados());
    }
    controllerReports.body.addAll(novoBody);
    await controllerReports.getDados();
  }


}