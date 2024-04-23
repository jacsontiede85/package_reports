import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:package_reports/filtro_module/model/filtros_carregados_model.dart';
import 'package:package_reports/filtro_module/model/filtros_model.dart';
import 'package:package_reports/filtro_module/model/filtros_pagina_atual_model.dart';
import 'package:package_reports/filtro_module/model/filtros_widget_model.dart';
import 'package:package_reports/global/core/features.dart';
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
    //this.onAplicar,
  }){
    getDadosCriarFiltros();
  }

  @observable
  ObservableList<FiltrosCarrregados> listaFiltrosCarregados = ObservableList<FiltrosCarrregados>.of([]);

  @observable
  ObservableList<FiltrosPageAtual> listaFiltrosParaConstruirTela = ObservableList<FiltrosPageAtual>.of([]);

  @observable
  bool loadingItensFiltros = false;

  @observable
  int indexFiltro = 0;

  @observable
  String dtinicio = SettingsReports.getDataPTBR(), dtfim = SettingsReports.getDataPTBR();

  @observable
  Map<String, dynamic> filtrosSalvosParaAdicionarNoBody = {};

  @observable
  bool exibirBarraPesquisa  = false;

  @observable
  String pesquisaItensDoFiltro = '';

  Map<String, dynamic> bodyPesquisarFiltros =  {};
  
  List<String> listaDePeriodos = [];

  @observable
  bool isDataFaturamento = false;

  @observable
  bool isRCAsemVenda = false;

  @observable
  bool isRCAativo = false;

  @observable
  bool validarListaParaDropDown = false;
  
  @observable
  int novoIndexFiltro = -1;

  @observable
  ObservableMap<int, FiltrosModel> valoresSelecionadorDropDown = ObservableMap<int, FiltrosModel>.of({});

  // RETORNAR QTDE DE ITENS SELECIONADOS
  @computed
  int get getQtdeItensSelecionados => (listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados.length);

  void getDadosCriarFiltros () async {
    mapaFiltrosWidget.forEach((key, value) {
      listaFiltrosParaConstruirTela.add(
        FiltrosPageAtual(
          qualPaginaFiltroPertence: indexPagina,
          filtrosWidgetModel: FiltrosWidgetModel.fromJson(value, key)
        )
      );
    });
    conjuntoDePeriodos();
  }

  Future<void> funcaoBuscarDadosDeCadaFiltro ({required FiltrosWidgetModel valor, required bool isBuscarDropDown, required int index, bool pesquisa = false}) async {

    if(isBuscarDropDown == false) validarListaParaDropDown = isBuscarDropDown;

    try{        
      validarListaParaDropDown = isBuscarDropDown;

      loadingItensFiltros = true;

      novoIndexFiltro = retornarIndexListaFiltrosCarregados(index: index); 

      if(novoIndexFiltro == -1 || (!listaFiltrosCarregados[novoIndexFiltro].pesquisaFeita && !pesquisa)){
        bodyPesquisarFiltros.addAll({
          "function" : valor.funcaoPrincipal,
          "database" : valor.bancoBuscarFiltros,
          "matricula" : SettingsReports.matricula,
        });

        var response = await API().getDataReportApiJWT(
          dados: bodyPesquisarFiltros,
          url: "filtros/${valor.arquivoQuery}"
        );

        List dados = jsonDecode(response);
        
        if(novoIndexFiltro == -1 || listaFiltrosCarregados[novoIndexFiltro].pesquisaFeita){
          listaFiltrosCarregados.add(
            FiltrosCarrregados(
              indexFiltros: index,
              indexPagina: indexPagina,
              listaFiltros: dados.map((e) => FiltrosModel.fromJson(e)).toList(),
            ),
          );          
        }else{
          listaFiltrosCarregados[novoIndexFiltro].listaFiltros = dados.map((e) => FiltrosModel.fromJson(e)).toList();
        }

        indexFiltro = index;
        novoIndexFiltro = retornarIndexListaFiltrosCarregados();
        listaFiltrosCarregados[novoIndexFiltro].pesquisaFeita = true;
      }
      else if(pesquisa){

        bodyPesquisarFiltros.addAll({
          "function" : valor.funcaoPrincipal,
          "database" : valor.bancoBuscarFiltros,
          "matricula" : SettingsReports.matricula,
        });

        var response = await API().getDataReportApiJWT(
          dados: bodyPesquisarFiltros,
          url: "filtros/${valor.arquivoQuery}"
        );
        bodyPesquisarFiltros.remove('pesquisa');
        List dados = jsonDecode(response);

        listaFiltrosCarregados[novoIndexFiltro].pesquisaFeita = false;
        listaFiltrosCarregados[novoIndexFiltro].listaFiltros = dados.map((e) => FiltrosModel.fromJson(e)).toList();
        
      }
      
      indexFiltro = index;
      for(FiltrosModel itens in getListFiltrosComputed){
        if(listaFiltrosParaConstruirTela[indexFiltro].qualPaginaFiltroPertence == indexPagina){
          for(FiltrosModel itensSelecionados in listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados){
            if(itens.codigo == itensSelecionados.codigo){
              itens = itensSelecionados;
              getListFiltrosComputed[listaFiltrosCarregados[novoIndexFiltro].listaFiltros.indexOf(itens)] = itens;
            }
          }          
        }
      }

    }
    finally{
      loadingItensFiltros = false;
      if(isBuscarDropDown) validarListaParaDropDown = isBuscarDropDown;
    }
  }

  @action
  void adicionarItensSelecionado ({required FiltrosModel itens}){
    if(itens.selecionado){
      if(listaFiltrosParaConstruirTela[indexFiltro].qualPaginaFiltroPertence == indexPagina){
        listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados.add(itens);
      }
    }else{
      if(listaFiltrosParaConstruirTela[indexFiltro].qualPaginaFiltroPertence == indexPagina){
        listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados.remove(itens);
      }
    }

    listaFiltrosParaConstruirTela = ObservableList.of([...listaFiltrosParaConstruirTela]);
  }

  Future<void> criarNovoBody() async {
    for(FiltrosPageAtual valores in listaFiltrosParaConstruirTela){
      if(valores.qualPaginaFiltroPertence == indexPagina){
        filtrosSalvosParaAdicionarNoBody.addAll(valores.filtrosWidgetModel.toJsonItensSelecionados(),);
      }
    }
    if(controllerReports.bodySecundario.isEmpty){
      controllerReports.bodyPrimario.update('dtinicio', (value) => value = dtinicio,);
      controllerReports.bodyPrimario.update('dtfim', (value) => value = dtfim);

      controllerReports.bodyPrimario.addAll(filtrosSalvosParaAdicionarNoBody);
    }else{
      controllerReports.bodySecundario.update('dtinicio', (value) => value = dtinicio,);
      controllerReports.bodySecundario.update('dtfim', (value) => value = dtfim);

      controllerReports.bodySecundario.addAll(filtrosSalvosParaAdicionarNoBody);
    }
    await controllerReports.getDados();
  }


  // VERIFICAR SE TODOS OS ITENS ESTÃO SELECIONADOS
  @computed
  bool get verificaSeTodosEstaoSelecionados {
    return (listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados.where((element) {
      return element.selecionado;
    }).length) == getListFiltrosComputed.length;
  }

  // LIMPAR SELEÇÃO DE TODOS OS ITENS
  @action
  void limparSelecao() {
    if(listaFiltrosParaConstruirTela[indexFiltro].qualPaginaFiltroPertence == indexPagina){
      listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados.clear();
      for( FiltrosModel value in getListFiltrosComputed){
        value.selecionado = false;
      }
    }
  }

  // SELECIONAR TODOS OS ITENS
  @action
  void selecionarTodos() {
    for( FiltrosModel value in getListFiltrosComputed){
      if(!value.selecionado){
        value.selecionado = true;
        listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados.addAll({value});
        listaFiltrosParaConstruirTela = ObservableList.of([...listaFiltrosParaConstruirTela]);
      }
    }
  }

  // INVERTER SELEÇÃO DOS ITENS
  @action
  void inverterSelecao() {
    for( FiltrosModel value in getListFiltrosComputed ){
      value.selecionado = !value.selecionado;
      adicionarItensSelecionado(itens: value);
    }  
  }

  @action
  void conjuntoDePeriodos() {
    listaDePeriodos=[];
    // List<AnosModel> anosmodel = await TotalizadorDados().getAnosDeVenda(order: 'desc');
    listaDePeriodos.add('Hoje');
    listaDePeriodos.add('Ontem');
    listaDePeriodos.add('Semana atual');
    listaDePeriodos.add('Semana anterior');
    listaDePeriodos.add('Últimos 15 dias');
    listaDePeriodos.add('Mês atual');
    listaDePeriodos.add('Mês anterior');
    // for (var element in anosmodel) {
    //   listaDePeriodos.add('Ano ${element.aNO}');
    // }
  }

  // FUNÇÃO PARA DEFINIR DATAS PARA O DROPDOWN DE PERIODOS
  @action
  Map<String, dynamic> selecaoDeDataPorPeriodo({required String periodo}) {
    var today =  DateTime.now().toLocal();
    int mes, ano;

    mes = int.parse(today.toString().substring(5,7));
    ano = int.parse(today.toString().substring(0,4));

    initializeDateFormatting('pt_BR', null);

    String weekday = DateFormat.E('pt_BR').format(DateTime.now().toLocal());

    int diaDaSemana = SettingsReports.diaDaSemanaConverte(weekday);

    String dtinicioFiltro= '';
    String dtfimFiltro= '';

    switch(periodo){
      case 'Hoje':
        dtinicioFiltro = SettingsReports.formatarDataPadraoBR("${DateTime.now().toLocal()}");
        dtfimFiltro = SettingsReports.formatarDataPadraoBR("${DateTime.now().toLocal()}");
      break;

      case 'Ontem':
        dtinicioFiltro = SettingsReports.formatarDataPadraoBR("${today.add(const Duration( days: -1 ))}");
        dtfimFiltro = SettingsReports.formatarDataPadraoBR("${today.add(const Duration( days: -1 ))}");
      break;

      case 'Semanaatual':
        dtinicioFiltro = SettingsReports.formatarDataPadraoBR("${ today.add( Duration(   days: -1 *  diaDaSemana    )) }");
        dtfimFiltro = SettingsReports.formatarDataPadraoBR("${ today.add( Duration(   days: (  6 - diaDaSemana )    )) }");
      break;

      case 'Semanaanterior':
        dtinicioFiltro = SettingsReports.formatarDataPadraoBR("${ today.add( Duration(   days: (  6 - diaDaSemana )-7-6    )) }");
        dtfimFiltro = SettingsReports.formatarDataPadraoBR("${ today.add( Duration(   days: -1 * (  diaDaSemana+1 )    )) }");
      break;

      case 'Últimos15dias':
        dtinicioFiltro = SettingsReports.formatarDataPadraoBR("${ today.add(const Duration(   days: -15    )) }");
        dtfimFiltro = SettingsReports.formatarDataPadraoBR("${ today.add(const Duration(   days: 0    )) }");
      break;

      case 'Mêsatual':
        dtinicioFiltro = '01/${today.toString().substring(5,7)}/${today.toString().substring(0,4)}';
        dtfimFiltro = '${SettingsReports.qtdDiasDoMes(mes, ano)}/${today.toString().substring(5,7)}/${today.toString().substring(0,4)}';
      break;

      case 'Mêsanterior':
        ano = ( mes-1 ==0? ano-1 : ano );
        mes = ( mes-1 ==0? mes =12 : mes-1 );
        if(mes < 10){
          dtinicioFiltro = '01/0$mes/$ano';
          dtfimFiltro = '${SettingsReports.qtdDiasDoMes(mes, ano)}/${'0$mes'}/$ano';
        }else{
          dtinicioFiltro = '01/$mes/$ano';
          dtfimFiltro = '${SettingsReports.qtdDiasDoMes(mes, ano)}/$mes/$ano';
        }
      break;

      case 'Anoatual':
        dtinicioFiltro = '01/01/$ano';
        dtfimFiltro = '31/12/$ano';
      break;

      case 'Anoanterior':
        dtinicioFiltro = '01/01/${ano-1}';
        dtfimFiltro = '31/12/${ano-1}';
      break;


      default:
        dtinicioFiltro = '01/01/${periodo.toString().replaceAll('Ano', '')}';
        dtfimFiltro = '31/12/${periodo.toString().replaceAll('Ano', '')}';
      break;

    }

    dtinicio = dtinicioFiltro;
    dtfim = dtfimFiltro;

    return {
      'dtinicioFiltro': dtinicioFiltro,
      'dtfimFiltro': dtfimFiltro
    };
  }


  @computed
  List<FiltrosModel> get getListFiltrosComputed  {
    novoIndexFiltro = retornarIndexListaFiltrosCarregados();

    List<FiltrosModel> list = [];
    list = listaFiltrosCarregados[novoIndexFiltro].listaFiltros;

    if(list.isEmpty) {
      return list;
    }
    else {
      return list.where((element) =>(
      Features.removerAcentos(
        string: element.codigo.toString().toLowerCase(),
      ).contains(
        Features.removerAcentos(
          string: pesquisaItensDoFiltro.toLowerCase(),
        ),
      ) 
      ||
      Features.removerAcentos(
        string: element.titulo.toString().toLowerCase(),
      ).contains(
        Features.removerAcentos(
          string: pesquisaItensDoFiltro.toLowerCase(),
        ),
      ) 
      ||
      Features.removerAcentos(
        string: element.subtitulo.toString().toLowerCase(),
      ).contains(
        Features.removerAcentos(
          string: pesquisaItensDoFiltro.toLowerCase(),
        ),
      ) 
    )).toList();
    }
    
  }

  void validarSeDataSeraDeFaturamento (){
    if(isDataFaturamento){
      controllerReports.bodyPrimario.addAll({
        "coluna_data" : "pcpedc.dtfat"
      });                
    }else{
      controllerReports.bodyPrimario.addAll({
        "coluna_data" : "pcpedc.data"
      });      
    }
  }

  void validarCondicaoDebuscaRCA (){
    if(isRCAativo){
      controllerReports.bodyPrimario.addAll({'rcaativos' : true});
      bodyPesquisarFiltros.addAll({'rcaativos' : true});
      filtrosSalvosParaAdicionarNoBody.addAll({'rcaativos' : true});
    }else{
      controllerReports.bodyPrimario.remove('rcaativos');
      bodyPesquisarFiltros.remove('rcaativos');
      filtrosSalvosParaAdicionarNoBody.remove('rcaativos');
    }

    if(isRCAsemVenda){
      controllerReports.bodyPrimario.addAll({'rcasemvenda' : true});
      filtrosSalvosParaAdicionarNoBody.addAll({'rcasemvenda' : true});
    }else{
      controllerReports.bodyPrimario.remove('rcasemvenda');
      filtrosSalvosParaAdicionarNoBody.remove('rcasemvenda');
    }
  }

  void limparFiltros ({required Map<String, dynamic> bodyParaSerLimpo}){
    for(String chaves in filtrosSalvosParaAdicionarNoBody.keys){
      bodyParaSerLimpo.remove(chaves);
    }
    for(FiltrosPageAtual filtros in listaFiltrosParaConstruirTela){
      filtros.filtrosWidgetModel.itensSelecionados.clear();
    }
    for(FiltrosCarrregados filtros in listaFiltrosCarregados){
      for(FiltrosModel itens in filtros.listaFiltros){
        itens.selecionado = false;
      }
    }
    filtrosSalvosParaAdicionarNoBody.clear();
    isRCAativo = false;
    isRCAsemVenda = false;
    listaFiltrosParaConstruirTela = ObservableList.of([...listaFiltrosParaConstruirTela]);
  }

  int retornarIndexListaFiltrosCarregados ({int? index}) {
    int novoIndexFiltro = listaFiltrosCarregados.indexWhere((element) => element.indexFiltros ==(index ?? indexFiltro) && element.indexPagina == indexPagina);
    return novoIndexFiltro;
  }

  void adicionarItensDropDown ({required int index, required FiltrosModel valorSelecionado}){
    int indexFiltrosCarregados = listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index);
    listaFiltrosCarregados[indexFiltrosCarregados].valorSelecionadoParaDropDown = valorSelecionado;
    int indexFiltrosSelecionado = listaFiltrosCarregados[indexFiltrosCarregados].listaFiltros.indexWhere((element) => element == valorSelecionado);

    for(FiltrosModel itens in listaFiltrosCarregados[indexFiltrosCarregados].listaFiltros){
      itens.selecionado = false;
      listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados.remove(itens);
    }

    listaFiltrosCarregados[indexFiltrosCarregados].listaFiltros[indexFiltrosSelecionado].selecionado = true;
    indexFiltro  = index;
    adicionarItensSelecionado(itens: listaFiltrosCarregados[indexFiltrosCarregados].listaFiltros[indexFiltrosSelecionado]);

  }

}