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
  List<ObservableMap<int ,FiltrosWidgetModel>> listaFiltrosParaConstruirTela = [];

  @observable
  bool loadingItensFiltors = false;

  @observable
  int indexFiltro = 0;

  @observable
  String dtinicio = Settings.getDataPTBR(), dtfim = Settings.getDataPTBR();

  void getDadosCriarFiltros () async {
    mapaFiltrosWidget.forEach((key, value) {
      listaFiltrosParaConstruirTela.add(ObservableMap<int ,FiltrosWidgetModel>.of({ indexPagina : FiltrosWidgetModel.fromJson(value, key)}));
    });
  }

  void funcaoBuscarDadosDeCadaFiltro ({required FiltrosWidgetModel valor}) async {
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

  @action
  adicionarItensSelecionado ({required FiltrosModel itens}){
    if(itens.selecionado){
      listaFiltrosParaConstruirTela[indexFiltro][indexPagina]!.itensSelecionados.add(itens);
    }else{
      listaFiltrosParaConstruirTela[indexFiltro][indexPagina]!.itensSelecionados.remove(itens);
    }
  }

  criarNovoBody() async {
    Map<String, dynamic> novoBody = {};

    for(Map<int, FiltrosWidgetModel> valores in listaFiltrosParaConstruirTela){
      novoBody.addAll(valores[indexPagina]!.toJsonItensSelecionados(), );
    }

    controllerReports.body.update('dtinicio', (value) => value = dtinicio,);
    controllerReports.body.update('dtfim', (value) => value = dtfim);

    controllerReports.body.addAll(novoBody);
    await controllerReports.getDados();
  }


  // VERIFICAR SE TODOS OS ITENS ESTÃO SELECIONADOS
  @computed
  bool get verificaSeTodosEstaoSelecionados {
    return (listaFiltros.where((element) {
      return element.selecionado;
    }).length) == listaFiltros.length;
  }

  // LIMPAR SELEÇÃO DE TODOS OS ITENS
  @action
  limparSelecao() {
    for( FiltrosModel value in listaFiltrosParaConstruirTela[indexFiltro][indexPagina]!.itensSelecionados ){
      if(value.selecionado){
        value.selecionado = false;
      }
    }
  }

  // SELECIONAR TODOS OS ITENS
  @action
  selecionarTodos() {
    for( FiltrosModel value in listaFiltros){
      if(!value.selecionado){
        value.selecionado = true;
        adicionarItensSelecionado(itens: value);
      }
    }
  }

  // INVERTER SELEÇÃO DOS ITENS
  @action
  inverterSelecao() {
    for( FiltrosModel value in listaFiltros ){
      value.selecionado = !value.selecionado;
      adicionarItensSelecionado(itens: value);
    }
  }


}