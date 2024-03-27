import 'dart:convert';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
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
  List<FiltrosModel> listaFiltros = [];

  @observable
  ObservableList<FiltrosPageAtual> listaFiltrosParaConstruirTela = ObservableList<FiltrosPageAtual>.of([]);

  @observable
  bool loadingItensFiltors = false;

  @observable
  int indexFiltro = 0;

  @observable
  String dtinicio = Settings.getDataPTBR(), dtfim = Settings.getDataPTBR();

  @observable
  Map<String, dynamic> filtrosSalvosParaAdicionarNoBody = {};

  @observable
  bool exibirBarraPesquisa  = false;

  @observable
  String pesquisaItensDoFiltro = '';

  Map<String, dynamic> bodyPesquisarFiltros =  {};
  
  List<String> listaDePeriodos = [];

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

  Future<void> funcaoBuscarDadosDeCadaFiltro ({required FiltrosWidgetModel valor,}) async {
    try{
      loadingItensFiltors = true;
      bodyPesquisarFiltros.addAll({
        "arquivo" : valor.arquivoQuery,
        "function" : valor.funcaoPrincipal,
        "matricula" : "3312",
      });

      var response = await API().jwtSendJson(
        banco: valor.bancoBuscarFiltros,
        dados: bodyPesquisarFiltros
      );

      List dados = jsonDecode(response);
      
      listaFiltros = dados.map((e) => FiltrosModel.fromJson(e)).toList();

      for(FiltrosModel itens in getListFiltrosComputed){
        if(listaFiltrosParaConstruirTela[indexFiltro].qualPaginaFiltroPertence == indexPagina){
          for(FiltrosModel itensSelecionados in listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados){
            if(itens.codigo == itensSelecionados.codigo){
              itens = itensSelecionados;
              getListFiltrosComputed[listaFiltros.indexOf(itens)] = itens;
            }
          }          
        }
      }

    }finally{
      loadingItensFiltors = false;
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

    int diaDaSemana = Settings.diaDaSemanaConverte(weekday);

    String dtinicioFiltro= '';
    String dtfimFiltro= '';

    switch(periodo){
      case 'Hoje':
        dtinicioFiltro = Settings.formatarDataPadraoBR("${DateTime.now().toLocal()}");
        dtfimFiltro = Settings.formatarDataPadraoBR("${DateTime.now().toLocal()}");
      break;

      case 'Ontem':
        dtinicioFiltro = Settings.formatarDataPadraoBR("${today.add(const Duration( days: -1 ))}");
        dtfimFiltro = Settings.formatarDataPadraoBR("${today.add(const Duration( days: -1 ))}");
      break;

      case 'Semanaatual':
        dtinicioFiltro = Settings.formatarDataPadraoBR("${ today.add( Duration(   days: -1 *  diaDaSemana    )) }");
        dtfimFiltro = Settings.formatarDataPadraoBR("${ today.add( Duration(   days: (  6 - diaDaSemana )    )) }");
      break;

      case 'Semanaanterior':
        dtinicioFiltro = Settings.formatarDataPadraoBR("${ today.add( Duration(   days: (  6 - diaDaSemana )-7-6    )) }");
        dtfimFiltro = Settings.formatarDataPadraoBR("${ today.add( Duration(   days: -1 * (  diaDaSemana+1 )    )) }");
      break;

      case 'Últimos15dias':
        dtinicioFiltro = Settings.formatarDataPadraoBR("${ today.add(const Duration(   days: -15    )) }");
        dtfimFiltro = Settings.formatarDataPadraoBR("${ today.add(const Duration(   days: 0    )) }");
      break;

      case 'Mêsatual':
        dtinicioFiltro = '01/${today.toString().substring(5,7)}/${today.toString().substring(0,4)}';
        dtfimFiltro = '${Settings.qtdDiasDoMes(mes, ano)}/${today.toString().substring(5,7)}/${today.toString().substring(0,4)}';
      break;

      case 'Mêsanterior':
        ano = ( mes-1 ==0? ano-1 : ano );
        mes = ( mes-1 ==0? mes =12 : mes-1 );
        if(mes < 10){
          dtinicioFiltro = '01/0$mes/$ano';
          dtfimFiltro = '${Settings.qtdDiasDoMes(mes, ano)}/${'0$mes'}/$ano';
        }else{
          dtinicioFiltro = '01/$mes/$ano';
          dtfimFiltro = '${Settings.qtdDiasDoMes(mes, ano)}/$mes/$ano';
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
  List<FiltrosModel> get getListFiltrosComputed {
    List<FiltrosModel> list = listaFiltros;
    if(list.isEmpty) {
      return list;
    } else {
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

}