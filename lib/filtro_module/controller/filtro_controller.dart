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
  }) {
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
  ObservableMap<String, dynamic> mapaDatasNomeadas = ObservableMap.of({});

  @observable
  String dtinicio = SettingsReports.getDataPTBR(), dtfim = SettingsReports.getDataPTBR();

  @observable
  ObservableMap<String, dynamic> filtrosSalvosParaAdicionarNoBody = ObservableMap.of({});

  @observable
  bool exibirBarraPesquisa = false;

  @observable
  String pesquisaItensDoFiltro = '';

  Map<String, dynamic> bodyPesquisarFiltros = {};

  List<dynamic> listaDePeriodos = [];

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

  @observable
  bool erroBuscarItensFiltro = false;

  @observable
  String dataCampanhaInicial = "";

  @observable
  bool loadingMoreData = false;

  List<String> monthNames = [
    "janeiro", "fevereiro", "março", "abril", "maio", "junho", 
    "julho", "agosto", "setembro", "outubro", "novembro", "dezembro"
  ];

  List<FiltrosModel> getDataMensal({required String mesInicial}) {
    List<FiltrosModel> filtro = [];
    dataCampanhaInicial = ("${DateTime.now().month}/${DateFormat.y().format(DateTime.now())}").padLeft(7, "0");

    var data1 = DateTime(int.parse(mesInicial.split("/").last), int.parse(mesInicial.split("/").first), 01);
    var data2 = DateTime.now();
    int year = data2.year;
    int month = data2.month;
    int temp = ((data2.year - data1.year) * 12 + data2.month - data1.month) + 1;

    for(var i = 0; i<temp; i++){
      if(data2.month - i > 0){
        filtro.add(
          FiltrosModel(
            codigo: "${(month - i)}/$year",
            titulo: "${(monthNames[month - i - 1])}/$year"
          )
        );
      }
      else{
        if(month - i + ((data2.year - year) * 12) <= 0){
          year--;
          filtro.add(
            FiltrosModel(
              codigo: "${(month - i + ((data2.year - year) * 12))}/$year",
              titulo: "${monthNames[(month - i + ((data2.year - year) * 12)) -1]}/$year"
            )
          );
        }else {
          filtro.add(
            FiltrosModel(
              codigo: "${(month - i + ((data2.year - year) * 12))}/$year",
              titulo: "${monthNames[(month - i + ((data2.year - year) * 12))-1]}/$year"
            )
          );
        }
      }
    }

    return filtro;
  }

  // RETORNAR QTDE DE ITENS SELECIONADOS
  @computed
  int get getQtdeItensSelecionados => (listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.length);

  void getDadosCriarFiltros() async {
    mapaFiltrosWidget.forEach((key, value) {
      if(key == "cardPeriodoMensal"){
        key = "$key${value["mesInicial"]}";
      }
      if(value["tipo"] == "datapickernomeado" && !mapaDatasNomeadas.containsKey(key)){
        mapaDatasNomeadas.addAll(
          {
            key: {
              "dtinicio": SettingsReports.formatarDataPadraoBR(data: DateTime.now().toString()),
              "dtfim": SettingsReports.formatarDataPadraoBR(data: DateTime.now().toString()),
              "isEnable": false
            }
          }
        );
      }
      listaFiltrosParaConstruirTela.add(FiltrosPageAtual(qualPaginaFiltroPertence: indexPagina, filtrosWidgetModel: FiltrosWidgetModel.fromJson(value, key)));
    });
    await conjuntoDePeriodos();
  }

  Future<void> funcaoBuscarDadosDeCadaFiltro({
    required FiltrosWidgetModel valor,
    required bool isBuscarDropDown,
    required int index,
    bool pesquisa = false,
    bool isDataMensal = false,
  }) async {
    erroBuscarItensFiltro = false;
    if (isBuscarDropDown == false) validarListaParaDropDown = isBuscarDropDown;

    try {
      validarListaParaDropDown = isBuscarDropDown;

      loadingItensFiltros = true;
      novoIndexFiltro = retornarIndexListaFiltrosCarregados(index: index,);

      if (novoIndexFiltro == -1 || (!listaFiltrosCarregados[novoIndexFiltro].pesquisaFeita && !pesquisa)) {
        try {
          if(isDataMensal){
            String mesinit = "";
            mapaFiltrosWidget.forEach((key, value) {
              if(value["tipo"] == "datapickermensal"){
                mesinit = value["mesInicial"];
              }
            });

            if (novoIndexFiltro == -1 || listaFiltrosCarregados[novoIndexFiltro].pesquisaFeita) {
              listaFiltrosCarregados.add(
                FiltrosCarrregados(
                  tipoFiltro: listaFiltrosParaConstruirTela[index].filtrosWidgetModel.tipoFiltro,
                  indexFiltros: index,
                  indexPagina: indexPagina,
                  tipoWidget: listaFiltrosParaConstruirTela[index].filtrosWidgetModel.tipoWidget,
                  listaFiltros: getDataMensal(mesInicial: mesinit),
                ),
              );
            } else {
              listaFiltrosCarregados[novoIndexFiltro].listaFiltros = getDataMensal(mesInicial: mesinit);
            }
          }else{
            bodyPesquisarFiltros.addAll(
              {
                "function": valor.funcaoPrincipal,
                "database": valor.bancoBuscarFiltros,
                "matricula": SettingsReports.matricula,
              },
            );

            String response = await API().getDataReportApiJWT(dados: bodyPesquisarFiltros, url: "filtros/${valor.arquivoQuery}");

            List dados = jsonDecode(response);
            if (novoIndexFiltro == -1 || listaFiltrosCarregados[novoIndexFiltro].pesquisaFeita) {
              listaFiltrosCarregados.add(
                FiltrosCarrregados(
                  tipoFiltro: listaFiltrosParaConstruirTela[index].filtrosWidgetModel.tipoFiltro,
                  indexFiltros: index,
                  indexPagina: indexPagina,
                  tipoWidget: listaFiltrosParaConstruirTela[index].filtrosWidgetModel.tipoWidget,
                  listaFiltros: dados.map((e) => FiltrosModel.fromJson(e)).toList(),
                ),
              );
            } else {
              listaFiltrosCarregados[novoIndexFiltro].listaFiltros = dados.map((e) => FiltrosModel.fromJson(e)).toList();
            }
          }
          indexFiltro = index;
          novoIndexFiltro = retornarIndexListaFiltrosCarregados();
        } catch (e) {
          erroBuscarItensFiltro = true;
        } finally {
          listaFiltrosCarregados[novoIndexFiltro].pesquisaFeita = true;
        }
      } else if (pesquisa) {
        try {
          bodyPesquisarFiltros.addAll({
            "function": valor.funcaoPrincipal,
            "database": valor.bancoBuscarFiltros,
            "matricula": SettingsReports.matricula,
          });

          String response = await API().getDataReportApiJWT(dados: bodyPesquisarFiltros, url: "filtros/${valor.arquivoQuery}");

          bodyPesquisarFiltros.remove('pesquisa');
          List dados = jsonDecode(response);

          listaFiltrosCarregados[novoIndexFiltro].listaFiltros = dados.map((e) => FiltrosModel.fromJson(e)).toList();
        } catch (e) {
          erroBuscarItensFiltro = true;
          listaFiltrosCarregados[novoIndexFiltro].listaFiltros = [];
        } finally {
          listaFiltrosCarregados[novoIndexFiltro].pesquisaFeita = false;
        }
      }
      indexFiltro = index;
      for (FiltrosModel itens in getListFiltrosComputed) {
        if (listaFiltrosParaConstruirTela[indexFiltro].qualPaginaFiltroPertence == indexPagina) {
          for (FiltrosModel itensSelecionados in listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!) {
            if (itens.codigo == itensSelecionados.codigo) {
              itens = itensSelecionados;
              getListFiltrosComputed[listaFiltrosCarregados[novoIndexFiltro].listaFiltros.indexOf(itens)] = itens;
            }
          }
        }
      }
    } finally {
      loadingItensFiltros = false;
      if (isBuscarDropDown) validarListaParaDropDown = isBuscarDropDown;
    }
  }

  @computed
  List<FiltrosModel> get getListFiltrosComputed {
    List<FiltrosModel> list = [];

    try {
      // Obtem o index da lista de filtros carregados sem alterar diretamente o observável
      int index = retornarIndexListaFiltrosCarregados();
      list = listaFiltrosCarregados[index].listaFiltros;
    } catch (e) {
      list = [];
    }

    if (list.isEmpty) {
      return list;
    } else {
      return list.where((element) =>_verificarElementoContemPesquisa(element, pesquisaItensDoFiltro)).toList();
    }
  }

  // Função auxiliar para remoção de acentos e verificação de pesquisa
  bool _verificarElementoContemPesquisa(FiltrosModel element, String pesquisa) {
    String pesquisaNormalizada = Features.removerAcentos(string: pesquisa.toLowerCase());
    return Features.removerAcentos(string: element.codigo.toString().toLowerCase()).contains(pesquisaNormalizada) ||
        Features.removerAcentos(string: element.titulo.toString().toLowerCase()).contains(pesquisaNormalizada) ||
        Features.removerAcentos(string: element.subtitulo.toString().toLowerCase()).contains(pesquisaNormalizada);
  }


  @action
  void adicionarItensSelecionado({required FiltrosModel itens}) {
    if (itens.selecionado) {
      if (listaFiltrosParaConstruirTela[indexFiltro].qualPaginaFiltroPertence == indexPagina) {
        listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.add(itens);
      }
    } else {
      if (listaFiltrosParaConstruirTela[indexFiltro].qualPaginaFiltroPertence == indexPagina) {
        removerItensSelecionadosBody(
          itens: itens,
          index: listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.toList().indexWhere((element) => element == itens)
        );
        listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.remove(itens); 
      }
    }

    listaFiltrosParaConstruirTela = ObservableList.of([...listaFiltrosParaConstruirTela]);
  }

  @action
  void adicionarItemUnicoSelecionado({required FiltrosModel item}) {

    for (FiltrosModel demaisItens in getListFiltrosComputed){
      if(demaisItens != item){
        demaisItens.selecionado = false;
      }
    }

    if (item.selecionado) {
      if (listaFiltrosParaConstruirTela[indexFiltro].qualPaginaFiltroPertence == indexPagina) {
        listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.clear();
      }
      listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.add(item);
    } else {
      if (listaFiltrosParaConstruirTela[indexFiltro].qualPaginaFiltroPertence == indexPagina) {
        removerItensSelecionadosBody(
          itens: item,
          index: listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.toList().indexWhere((element) => element == item),
        );
        listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.remove(item);        
      }
    }

    listaFiltrosParaConstruirTela = ObservableList.of([...listaFiltrosParaConstruirTela]);
  }


  void removerItensSelecionadosBody ({required FiltrosModel itens, required int index}){
    Map<String, dynamic> bodyAtual = {};
    if(controllerReports.bodySecundario.isEmpty){
      bodyAtual = controllerReports.bodyPrimario;
    }else{
      bodyAtual = controllerReports.bodySecundario;
    }

    String tipoFiltro = listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.tipoFiltro;
    int indexItenMarcado = index;
    try{
      if(listaFiltrosParaConstruirTela[indexFiltro].qualPaginaFiltroPertence == indexPagina){
        if(bodyAtual.containsKey(tipoFiltro)){

          if(bodyAtual[tipoFiltro].length > indexItenMarcado) bodyAtual[tipoFiltro].removeAt(indexItenMarcado);      
          
          if(bodyAtual[tipoFiltro].length == 0){
            bodyAtual.removeWhere((key, value) => key == tipoFiltro);
            filtrosSalvosParaAdicionarNoBody.remove(tipoFiltro);
          }               
        }

      }
  
    }finally{
      if(controllerReports.bodySecundario.isEmpty){
        controllerReports.bodyPrimario = bodyAtual;
      }else{
        controllerReports.bodySecundario = bodyAtual;
      }      
    }
  }

  Future<void> criarNovoBody() async {
    
    for (FiltrosPageAtual valores in listaFiltrosParaConstruirTela) {
      if (valores.qualPaginaFiltroPertence == indexPagina) {
        filtrosSalvosParaAdicionarNoBody.addAll(
          valores.filtrosWidgetModel.toJsonItensSelecionados(),
        );
      }
    }

    filtrosSalvosParaAdicionarNoBody.forEach((key, value) {
      if(key.contains("cardPeriodoMensal")){
        dataCampanhaInicial = value.first["codigo"].toString().padLeft(7, "0");
      }
    },);

    if (controllerReports.bodySecundario.isEmpty) {
      controllerReports.bodyPrimario.update(
        'dtinicio',
        (value) => value = dtinicio,
      );
      controllerReports.bodyPrimario.update('dtfim', (value) => value = dtfim);
      controllerReports.bodyPrimario.addAll(filtrosSalvosParaAdicionarNoBody);

      //Data mensal das campanhas
      if(controllerReports.bodyPrimario.containsKey("dataMensal")) {
        controllerReports.bodyPrimario.update("dataMensal", (value) => value = dataCampanhaInicial,);
      } else {
        controllerReports.bodyPrimario.addAll(
          {"dataMensal": dataCampanhaInicial}
        );
      }
    } else {
      controllerReports.bodySecundario.update(
        'dtinicio',
        (value) => value = dtinicio,
      );
      controllerReports.bodySecundario.update('dtfim', (value) => value = dtfim);

      if(controllerReports.bodyPrimario.containsKey("dataMensal")) {
        controllerReports.bodyPrimario.update("dataMensal", (value) => value = dataCampanhaInicial,);
      } else {
        controllerReports.bodyPrimario.addAll(
          {"dataMensal": dataCampanhaInicial}
        );
      }

      controllerReports.bodySecundario.addAll(filtrosSalvosParaAdicionarNoBody);
    }
    //Data mensal das campanhas
    if(controllerReports.bodyPrimario.containsKey("dataMensal")) {
      controllerReports.bodyPrimario.update("dataMensal", (value) => value = dataCampanhaInicial,);
    } else {
      controllerReports.bodyPrimario.addAll(
        {"dataMensal": dataCampanhaInicial}
      );
    }

    mapaDatasNomeadas.forEach((key, value) {
      if(controllerReports.bodyPrimario.containsKey(key)){
        if(!value["isEnable"]){
          controllerReports.bodyPrimario.update(key, (value2) => value2 = value,);
        }else{
          controllerReports.bodyPrimario.removeWhere((key2, value2) => key == key2,);
        }
      }
      else{
        if(!value["isEnable"]){
          controllerReports.bodyPrimario.addAll({key: value});
        }
      }
    },);
    
    sincronizarFiltrosSalvos();
    //printO(controllerReports.bodyPrimario);
    await controllerReports.getDados();
  }

  // VERIFICAR SE TODOS OS ITENS ESTÃO SELECIONADOS
  @computed
  bool get verificaSeTodosEstaoSelecionados {
    return (listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.where(
      (element) => element.selecionado == true,
    ).length) == getListFiltrosComputed.length;
  }

  // LIMPAR SELEÇÃO DE TODOS OS ITENS
  @action
  void limparSelecao() {
    String tipoFiltro = listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.tipoFiltro;
    if (listaFiltrosParaConstruirTela[indexFiltro].qualPaginaFiltroPertence == indexPagina) {
      listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.clear();
      for (FiltrosModel value in getListFiltrosComputed) {
        value.selecionado = false;
        listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.removeAll({value});
        listaFiltrosParaConstruirTela = ObservableList.of([...listaFiltrosParaConstruirTela]);
      }
      controllerReports.bodyPrimario.removeWhere((key, value) => key == tipoFiltro);
      filtrosSalvosParaAdicionarNoBody.remove(tipoFiltro);
    }
  }

  // SELECIONAR TODOS OS ITENS
  @action
  void selecionarTodos() {
    for (FiltrosModel value in getListFiltrosComputed) {
      if (!value.selecionado) {
        value.selecionado = true;
        listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.addAll({value});
        listaFiltrosParaConstruirTela = ObservableList.of([...listaFiltrosParaConstruirTela]);
      }
    }
  }

  // INVERTER SELEÇÃO DOS ITENS
  @action
  void inverterSelecao() {
    for (FiltrosModel value in getListFiltrosComputed) {
      value.selecionado = !value.selecionado;
      adicionarItensSelecionado(itens: value);
    }
  }

  @action
  Future<void> conjuntoDePeriodos() async {

    bodyPesquisarFiltros.addAll(
      {
        "function": "getConjnuntoDePeriodos",
        "database": 'atacado',
        "matricula": SettingsReports.matricula,
      },
    );
    listaDePeriodos = jsonDecode(
      await API().getDataReportApiJWT(
        dados: bodyPesquisarFiltros,
        url: 'filtros/query_filtros.php'
      )
    );
  }

  // FUNÇÃO PARA DEFINIR DATAS PARA O DROPDOWN DE PERIODOS
  @action
  Map<String, dynamic> selecaoDeDataPorPeriodo({required String periodo, required bool isDataPadrao}) {
    var today = DateTime.now().toLocal();
    int mes, ano;

    mes = int.parse(today.toString().substring(5, 7));
    ano = int.parse(today.toString().substring(0, 4));

    initializeDateFormatting('pt_BR', null);

    String weekday = DateFormat.E('pt_BR').format(DateTime.now().toLocal());

    int diaDaSemana = SettingsReports.diaDaSemanaConverte(dia: weekday);

    String dtinicioFiltro = '';
    String dtfimFiltro = '';

    switch (periodo) {
      case 'Hoje':
        dtinicioFiltro = SettingsReports.formatarDataPadraoBR(data: "${DateTime.now().toLocal()}");
        dtfimFiltro = SettingsReports.formatarDataPadraoBR(data: "${DateTime.now().toLocal()}");
      break;

      case 'Ontem':
        dtinicioFiltro = SettingsReports.formatarDataPadraoBR(data: "${today.add(const Duration(days: -1))}");
        dtfimFiltro = SettingsReports.formatarDataPadraoBR(data: "${today.add(const Duration(days: -1))}");
      break;

      case 'Semanaatual':
        dtinicioFiltro = SettingsReports.formatarDataPadraoBR(data: "${today.add(Duration(days: -1 * diaDaSemana))}");
        dtfimFiltro = SettingsReports.formatarDataPadraoBR(data: "${today.add(Duration(days: (6 - diaDaSemana)))}");
      break;

      case 'Semanaanterior':
        dtinicioFiltro = SettingsReports.formatarDataPadraoBR(data: "${today.add(Duration(days: (6 - diaDaSemana) - 7 - 6))}");
        dtfimFiltro = SettingsReports.formatarDataPadraoBR(data: "${today.add(Duration(days: -1 * (diaDaSemana + 1)))}");
      break;

      case 'Últimos15dias':
        dtinicioFiltro = SettingsReports.formatarDataPadraoBR(data: "${today.add(const Duration(days: -15))}");
        dtfimFiltro = SettingsReports.formatarDataPadraoBR(data: "${today.add(const Duration(days: 0))}");
      break;

      case 'Mêsatual':
        dtinicioFiltro = '01/${today.toString().substring(5, 7)}/${today.toString().substring(0, 4)}';
        dtfimFiltro = '${SettingsReports.qtdDiasDoMes(mes, ano)}/${today.toString().substring(5, 7)}/${today.toString().substring(0, 4)}';
      break;

      case 'Mêsanterior':
        ano = (mes - 1 == 0 ? ano - 1 : ano);
        mes = (mes - 1 == 0 ? mes = 12 : mes - 1);
        if (mes < 10) {
          dtinicioFiltro = '01/0$mes/$ano';
          dtfimFiltro = '${SettingsReports.qtdDiasDoMes(mes, ano)}/${'0$mes'}/$ano';
        } else {
          dtinicioFiltro = '01/$mes/$ano';
          dtfimFiltro = '${SettingsReports.qtdDiasDoMes(mes, ano)}/$mes/$ano';
        }
      break;

      case 'Anoatual':
        dtinicioFiltro = '01/01/$ano';
        dtfimFiltro = '31/12/$ano';
      break;

      case 'Anoanterior':
        dtinicioFiltro = '01/01/${ano - 1}';
        dtfimFiltro = '31/12/${ano - 1}';
      break;

      default:
        dtinicioFiltro = '01/01/${periodo.toString().replaceAll('Ano', '')}';
        dtfimFiltro = '31/12/${periodo.toString().replaceAll('Ano', '')}';
      break;
    }

    if(isDataPadrao){
      dtinicio = dtinicioFiltro;
      dtfim = dtfimFiltro;
    }

    return {'dtinicioFiltro': dtinicioFiltro, 'dtfimFiltro': dtfimFiltro};
  }

  void validarSeDataSeraDeFaturamento() {
    if (isDataFaturamento) {
      controllerReports.bodyPrimario.addAll({"coluna_data": "pcpedc.dtfat"});
    } else {
      controllerReports.bodyPrimario.addAll({"coluna_data": "pcpedc.data"});
    }
  }

  void validarCondicaoDebuscaRCA() {
    if (isRCAativo) {
      controllerReports.bodyPrimario.addAll({'rcaativos': true});
      bodyPesquisarFiltros.addAll({'rcaativos': true});
      filtrosSalvosParaAdicionarNoBody.addAll({'rcaativos': true});
    } else {
      controllerReports.bodyPrimario.remove('rcaativos');
      bodyPesquisarFiltros.remove('rcaativos');
      filtrosSalvosParaAdicionarNoBody.remove('rcaativos');
    }

    if (isRCAsemVenda) {
      controllerReports.bodyPrimario.addAll({'rcasemvenda': true});
      filtrosSalvosParaAdicionarNoBody.addAll({'rcasemvenda': true});
    } else {
      controllerReports.bodyPrimario.remove('rcasemvenda');
      filtrosSalvosParaAdicionarNoBody.remove('rcasemvenda');
    }
  }

  void limparFiltros({required Map<String, dynamic> bodyParaSerLimpo}) {
    for (String chaves in filtrosSalvosParaAdicionarNoBody.keys) {
      bodyParaSerLimpo.remove(chaves);
    }
    for (FiltrosPageAtual filtros in listaFiltrosParaConstruirTela) {
      filtros.filtrosWidgetModel.itensSelecionados!.clear();

      // Voltar o valor do dropdown para o primeiro index
      if(filtros.filtrosWidgetModel.tipoWidget.contains("dropdown") || filtros.filtrosWidgetModel.tipoWidget.contains("datapickermensal")){
        for(var value in listaFiltrosCarregados){
          value.valorSelecionadoParaDropDown = value.listaFiltros.first;
          if(value.tipoFiltro.contains("cardPeriodoMensal")){
            dataCampanhaInicial = value.listaFiltros.first.codigo.padLeft(7, "0");
          }
        }
      }
    }
    for (FiltrosCarrregados filtros in listaFiltrosCarregados) {
      for (FiltrosModel itens in filtros.listaFiltros) {
        itens.selecionado = false;
      }
    }

    filtrosSalvosParaAdicionarNoBody.clear();
    isRCAativo = false;
    isRCAsemVenda = false;
    listaFiltrosParaConstruirTela = ObservableList.of([...listaFiltrosParaConstruirTela]);
  }

  int retornarIndexListaFiltrosCarregados({int? index,}) {
    int novoIndexFiltro = listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == (index ?? indexFiltro) && element.indexPagina == indexPagina);
    return novoIndexFiltro;
  }

  @action
  void adicionarItensDropDown({required int index, required FiltrosModel valorSelecionado}) {
    int indexFiltrosCarregados = listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index);
    listaFiltrosCarregados[indexFiltrosCarregados].valorSelecionadoParaDropDown = valorSelecionado;
    int indexFiltrosSelecionado = listaFiltrosCarregados[indexFiltrosCarregados].listaFiltros.indexWhere((element) => element == valorSelecionado);

    for (FiltrosModel itens in listaFiltrosCarregados[indexFiltrosCarregados].listaFiltros) {
      itens.selecionado = false;
      listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.remove(itens);
    }

    listaFiltrosCarregados[indexFiltrosCarregados].listaFiltros[indexFiltrosSelecionado].selecionado = true;
    indexFiltro = index;
    adicionarItensSelecionado(
      itens: listaFiltrosCarregados[indexFiltrosCarregados].listaFiltros[indexFiltrosSelecionado],
    );
  }

  void getItensSelecionadosSalvos(){
    // * CRIAÇÃO DE UMA LISTA TEMPORARIA, PARA GUARDAR TODOS OS FILTROS SELECIONADOS
    if(SettingsReports.listaFiltrosCarregadosSalvos.isEmpty) SettingsReports.listaFiltrosCarregadosSalvos = ObservableList<FiltrosCarrregados>.of([...listaFiltrosCarregados]);
    
    if(SettingsReports.listaFiltrosParaConstruirTelaTemp.isNotEmpty){
      for(var value in SettingsReports.listaFiltrosCarregadosSalvos){
        listaFiltrosCarregados.add(value);
      }
      //listaFiltrosCarregados = SettingsReports.listaFiltrosCarregadosSalvos;
      for(FiltrosPageAtual value in listaFiltrosParaConstruirTela){
        for(FiltrosPageAtual item in SettingsReports.listaFiltrosParaConstruirTelaTemp){
          if(item.filtrosWidgetModel.tipoFiltro == value.filtrosWidgetModel.tipoFiltro && item.filtrosWidgetModel.tipoWidget == value.filtrosWidgetModel.tipoWidget){
            value.filtrosWidgetModel.itensSelecionados = item.filtrosWidgetModel.itensSelecionados;
          }
        }
      }
    }
    else {
      SettingsReports.listaFiltrosParaConstruirTelaTemp = ObservableList<FiltrosPageAtual>.of([...listaFiltrosParaConstruirTela]);
    }
    
    
    listaFiltrosParaConstruirTela.clear();
    getDadosCriarFiltros();

    // * LOOP PARA VEREFICAR QUAIS FILTROS ESTÃO JA SELECIONADOS
    for(FiltrosPageAtual value in SettingsReports.listaFiltrosParaConstruirTelaTemp){
      for(FiltrosPageAtual item in listaFiltrosParaConstruirTela){
        if(value.filtrosWidgetModel.tipoFiltro == item.filtrosWidgetModel.tipoFiltro && value.filtrosWidgetModel.tipoWidget == item.filtrosWidgetModel.tipoWidget) {
          item.filtrosWidgetModel.itensSelecionados = value.filtrosWidgetModel.itensSelecionados;
          if(item.filtrosWidgetModel.itensSelecionados!.isEmpty && value.filtrosWidgetModel.tipoFiltro.contains("cardPeriodoMensal")){
            dataCampanhaInicial = ("${DateTime.now().month}/${DateFormat.y().format(DateTime.now())}").padLeft(7, "0");
          }
        }
      }
    }
      
    // * LOOP PARA VERIFICAR QUAIS ITENS DOS FILTROS ESTÃO SELECIONADOS QUANDO MUDAR DE TAB
    for(FiltrosPageAtual value in SettingsReports.listaFiltrosParaConstruirTelaTemp){
      for(FiltrosCarrregados item in listaFiltrosCarregados){
        if(value.filtrosWidgetModel.tipoFiltro == item.tipoFiltro && value.filtrosWidgetModel.tipoWidget == item.tipoWidget){
          item.indexFiltros = listaFiltrosParaConstruirTela.indexWhere((element) => element.filtrosWidgetModel.tipoWidget == value.filtrosWidgetModel.tipoWidget && element.filtrosWidgetModel.tipoFiltro == value.filtrosWidgetModel.tipoFiltro); 
        }
      }
    }
  }

  void sincronizarFiltrosSalvos() {
    for (FiltrosPageAtual filtroAtual in listaFiltrosParaConstruirTela) {
      for (FiltrosPageAtual filtroSalvo in SettingsReports.listaFiltrosParaConstruirTelaTemp) {
        if (filtroAtual.filtrosWidgetModel.tipoFiltro == filtroSalvo.filtrosWidgetModel.tipoFiltro &&
            filtroAtual.filtrosWidgetModel.tipoWidget == filtroSalvo.filtrosWidgetModel.tipoWidget) {
          filtroAtual.filtrosWidgetModel.itensSelecionados = filtroSalvo.filtrosWidgetModel.itensSelecionados;
        }
      }
    }
    listaFiltrosParaConstruirTela = ObservableList.of([...listaFiltrosParaConstruirTela]);
  }
}
