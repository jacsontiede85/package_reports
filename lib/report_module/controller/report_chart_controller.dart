// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:package_reports/report_module/charts/chart_data.dart';
import 'package:package_reports/report_module/charts/charts.dart';
import 'report_from_json_controller.dart';
part 'report_chart_controller.g.dart';

class ReportChartController = ReportChartControllerBase with _$ReportChartController;

abstract class ReportChartControllerBase with Store, Charts {
  late ReportFromJSONController reportFromJSONController;
  ReportChartControllerBase({required this.reportFromJSONController}) {
    load();
  }

  @observable
  String chartNameSelected = 'barChartHorizontal';

  @observable
  String orderby = 'Decrescente';

  @observable
  Widget chartSelected = const SizedBox();

  @observable
  Map columnMetricSelected = {};

  @observable
  Map columnOrderBySelected = {};

  @observable
  bool loading = false;

  @observable
  String metricaSelecionada = '';

  @observable
  String ordenacaoSelecionada = '';

  //selecionar uma coluna de metrica e exbir o grafico padrao ao carregar tela
  Future<void> load() async {
    loading = true;
    columnMetricSelected = getColumnMetricsChart[0];
    columnOrderBySelected = getColumnMetricsChart[0];
    getChart(chartNameSelected: chartNameSelected);
    loading = false;
  }

  //retornar colunas de metricas para dropdown
  List<Map> get getColumnMetricsChart => reportFromJSONController.colunas.where((element) => element['type'] != String && !element['key'].toString().toUpperCase().contains('__NO_METRICS')).toList();

  //retornar colunas de metricas para dropdown de ordenação
  List<Map> get getColumnOrderByChart => [...reportFromJSONController.colunas].toList();

  //ativar ou desativar graficos de ared
  bool get isVisibleChartsArea => getColumnMetricsChart.where((value) => value['type'] != String && !value['key'].toString().toUpperCase().contains('__NOCHARTAREA')).toList().length > 1;

  @action
  getChart({required String chartNameSelected}) async {
    loading = true;
    this.chartNameSelected = chartNameSelected;
    await Future.delayed(const Duration(seconds: 1));

    // ? Analise de dados de linhas
    if (chartNameSelected == 'sfLineCartesianChart')
      chartSelected = sfLineCartesianChart(dados: _getListChartData());

    // ? Analise de dados de colunas (horizontal)
    else if (chartNameSelected == 'barChartHorizontal')
      chartSelected = barChartHorizontal(dados: _getListChartData());

    // ? Analise de dados de pizza
    else if (chartNameSelected == 'sfCircularChart')
      chartSelected = sfCircularChart(
        dados: _getListChartData(),
      );
    else if (chartNameSelected == 'sfLineCartesianChartArea') {
      // ? Analise de dados na horizontal (ex.: mes 1, mes2, ... total)
      List<Widget> charts = [];
      for (var listChartdata in _getListChartData()) charts.add(sfLineCartesianChart(dados: listChartdata));
      chartSelected = Column(
        children: charts,
      );
    } else if (chartNameSelected == 'sfAreaCartesianChart') {
      // ? Analise de dados na horizontal (ex.: mes 1, mes2, ... total)
      List<Widget> charts = [];
      List<ChartData> listTotal = [];
      listTotal = _getListChartData(listaDeTotaisDeRodape: true);
      for (var listChartdata in _getListChartData()) {
        List<List<ChartData>> list = [];
        list.add(listTotal);
        list.add(listChartdata);
        charts.add(sfAreaCartesianChart(dadosList: list));
      }
      chartSelected = Column(
        children: charts,
      );
    }
    loading = false;
  }

  _getListChartData({bool listaDeTotaisDeRodape = false}) {
    var keySelected = columnMetricSelected['key'];

    if (orderby.isNotEmpty) setOrderBy(key: columnOrderBySelected['key'], order: orderby == 'Decrescente' ? 'desc' : 'asc');

    if (listaDeTotaisDeRodape) {
      List<ChartData> temp = [];

      for (Map<String, dynamic> col in reportFromJSONController.colunas) {
        String nome = '';

        if ((col['type'] == String || col['key'].toString().toUpperCase().contains('__NO_METRICS')) && col['key'] != 'isFiltered') nome += '${col['key']}'.length > 20 ? '${'${col['key']}'.substring(0, 20)}...' : '${col['key']}';

        if (col['type'] != String && !col['key'].toString().toUpperCase().contains('__NO_METRICS') && !col['key'].toString().toUpperCase().contains('__NOCHARTAREA'))
          temp.add(
            ChartData(
              title: nome,
              nome: col['nomeFormatado'],
              valor: col['vlrTotalDaColuna'],
              type: col['type'],
              perc: 100,
              color: const Color.fromARGB(255, 29, 27, 27),
            ),
          );
      }
      return temp;
    } else if (chartNameSelected == 'sfLineCartesianChartArea' || chartNameSelected == 'sfAreaCartesianChart') {
      List<List<ChartData>> list = [];

      for (Map<String, dynamic> value in reportFromJSONController.dados) {
        List<ChartData> temp = [];
        String nome = '';

        for (String key in value.keys) if ((value[key].runtimeType == String || key.toString().toUpperCase().contains('__NO_METRICS')) && key != 'isFiltered') nome += '${value[key]}';

        for (var col in getColumnMetricsChart) {
          if (value['type'] != String && !col['key'].toString().toUpperCase().contains('__NOCHARTAREA')) {
            temp.add(ChartData(
              title: nome,
              nome: reportFromJSONController.getNomeColunaFormatado(text: col['key']),
              valor: value[col['key']].runtimeType == int ? double.parse(value[col['key']].toString()) : value[col['key']],
              type: value[col['key']].runtimeType,
              perc: 0,
              color: gerarCoresPorPosicao(index: reportFromJSONController.dados.indexOf(value)),
            ));
          }
        }

        list.add(temp);
      }
      return list;
    } else {
      List<ChartData> temp = [];
      for (Map<String, dynamic> value in reportFromJSONController.dados) {
        String nome = '';
        double vlrTotalDaColuna = 0.0;

        for (String key in value.keys) if ((value[key].runtimeType == String || key.toString().toUpperCase().contains('__NO_METRICS')) && key != 'isFiltered') nome += '${value[key]}';

        for (Map<String, dynamic> col in reportFromJSONController.colunas) if (col['key'] == keySelected) vlrTotalDaColuna = col['vlrTotalDaColuna'];

        temp.add(
          ChartData(
            title: nome,
            nome: nome,
            valor: value[keySelected].runtimeType == int ? double.parse(value[keySelected].toString()) : value[keySelected],
            type: value[keySelected].runtimeType,
            perc: (value[keySelected] / vlrTotalDaColuna) * 100,
            color: gerarCoresPorPosicao(index: reportFromJSONController.dados.indexOf(value)),
          ),
        );
      }
      return temp;
    }
  }

  //ordenar
  setOrderBy({required key, required order}) => reportFromJSONController.setOrderBy(key: key, order: order);

  List<Map<String, dynamic>> getTodosOsTiposGraficos() {
    List<Map<String, dynamic>> opcoesDeGraficos = [];

    for (String grafico in reportFromJSONController.configPagina['graficosDisponiveis']) {
      switch (grafico.toLowerCase()) {
        case 'barras':
          opcoesDeGraficos.add(
            {
              "nome": "Barras",
              "icone": Icons.bar_chart_sharp,
              "funcao": () => getChart(chartNameSelected: 'barChartHorizontal'),
            },
          );

        case 'circular':
          opcoesDeGraficos.add(
            {
              "nome": "Circular",
              "icone": Icons.pie_chart_rounded,
              "funcao": () => getChart(chartNameSelected: 'sfCircularChart'),
            },
          );

        case 'linhas':
          opcoesDeGraficos.add(
            {
              "nome": "Linhas",
              "icone": Icons.ssid_chart,
              "funcao": () => getChart(chartNameSelected: 'sfLineCartesianChart'),
            },
          );

        case 'linhas duplas':
          opcoesDeGraficos.add(
            {
              "nome": "Linhas duplas",
              "icone": Icons.stacked_line_chart_outlined,
              "funcao": () => getChart(chartNameSelected: 'sfLineCartesianChartArea'),
            },
          );

        case 'area':
          opcoesDeGraficos.add(
            {
              "nome": "Area",
              "icone": Icons.area_chart,
              "funcao": () => getChart(chartNameSelected: 'sfAreaCartesianChart'),
            },
          );
      }
    }

    return opcoesDeGraficos;
  }

  Color gerarCoresPorPosicao({required int index}) {
    Color corPrincipal = Colors.grey;

    int red = index * 80;
    int green = index * 90;
    int blue = index * 95;

    corPrincipal = Color.fromARGB(255, red, green, blue);

    return corPrincipal;
  }
}
