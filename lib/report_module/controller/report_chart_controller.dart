// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../charts/chart_data.dart';
import '../charts/charts.dart';
import 'report_from_json_controller.dart';
part 'report_chart_controller.g.dart';

class ReportChartController = ReportChartControllerBase with _$ReportChartController;

abstract class ReportChartControllerBase with Store, Charts{
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

  //selecionar uma coluna de metrica e exbir o grafico padrao ao carregar tela
  Future<void> load() async {
    loading = true;
    columnMetricSelected = getColumnMetricsChart[0];
    columnOrderBySelected = getColumnMetricsChart[0];
    getChart(chartNameSelected: chartNameSelected);
    loading = false;
  }

  //retornar colunas de metricas para dropdown
  List<Map> get getColumnMetricsChart => reportFromJSONController.colunas.where((element) => element['type'] != String && !element['key'].toString().contains('__no_metrics')).toList();

  //retornar colunas de metricas para dropdown de ordenação
  List<Map> get getColumnOrderByChart => [...reportFromJSONController.colunas].toList();
  // reportFromJSONController.colunas.where((element) =>
  //   element['type'] == String && element['key'].toString().contains('__no_metrics')
  // ).toList();

  //ativar ou desativar graficos de ared
  bool get isVisibleChartsArea => getColumnMetricsChart.where((value) => value['type'] != String && !value['key'].contains('__nochartarea')).toList().length > 1;

  @action
  getChart({required String chartNameSelected}) async {
    loading = true;
    this.chartNameSelected = chartNameSelected;
    await Future.delayed(const Duration(seconds: 1));
    if (chartNameSelected == 'sfLineCartesianChart') //Analise de dados de colunas (vertical)
      chartSelected = sfLineCartesianChart(dados: _getListChartData());
    else if (chartNameSelected == 'barChartHorizontal') //Analise de dados de colunas (vertical)
      chartSelected = barChartHorizontal(dados: _getListChartData());
    else if (chartNameSelected == 'sfCircularChart') //Analise de dados de colunas (vertical)
      chartSelected = sfCircularChart(
        dados: _getListChartData(),
      );
    else if (chartNameSelected == 'pieChart') //Analise de dados de colunas (vertical)
      chartSelected = pieChart(dados: _getListChartData(), centerSpaceRadius: 50, radius: 200);
    else if (chartNameSelected == 'sfLineCartesianChartArea') {
      //Analise de dados na horizontal (ex.: mes 1, mes2, ... total)
      List<Widget> charts = [];
      for (var listChartdata in _getListChartData()) charts.add(sfLineCartesianChart(dados: listChartdata));
      chartSelected = Column(
        children: charts,
      );
    } else if (chartNameSelected == 'sfAreaCartesianChart') {
      //Analise de dados na horizontal (ex.: mes 1, mes2, ... total)
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

    List<Color> cores = _randonColors(length: reportFromJSONController.dados.length);

    if (listaDeTotaisDeRodape) {
      List<ChartData> temp = [];
      for (var col in reportFromJSONController.colunas) {
        String nome = '';
        if (col['type'] == String || col['key'].contains('__no_metrics')) nome += '${col['key']}'.length > 20 ? '${'${col['key']}'.substring(0, 20)}... ' : '${col['key']} ';
        if (col['type'] != String && !col['key'].contains('__no_metrics') && !col['key'].contains('__nochartarea')) temp.add(ChartData(title: nome, nome: col['nomeFormatado'], valor: col['vlrTotalDaColuna'], type: col['type'], perc: 100, color: const Color.fromARGB(255, 29, 27, 27)));
      }
      return temp;
    } else if (chartNameSelected == 'sfLineCartesianChartArea' || chartNameSelected == 'sfAreaCartesianChart') {
      List<List<ChartData>> list = [];
      for (var value in reportFromJSONController.dados) {
        List<ChartData> temp = [];
        String nome = '';
        for (var key in value.keys) if (value[key].runtimeType == String || key.toString().contains('__no_metrics')) nome += '${value[key]}'.length > 20 ? '${'${value[key]}'.substring(0, 20)}... ' : '${value[key]} ';

        var cor = cores.isEmpty ? null : cores[reportFromJSONController.dados.indexOf(value)];
        for (var col in getColumnMetricsChart) {
          if (value['type'] != String && !col['key'].contains('__nochartarea')) {
            temp.add(ChartData(title: nome, nome: reportFromJSONController.getNomeColunaFormatado(text: col['key']), valor: value[col['key']].runtimeType == int ? double.parse(value[col['key']].toString()) : value[col['key']], type: value[col['key']].runtimeType, perc: 0, color: cor));
          }
        }

        list.add(temp);
      }
      return list;
    } else {
      List<ChartData> temp = [];
      for (var value in reportFromJSONController.dados) {
        String nome = '';
        for (var key in value.keys) if (value[key].runtimeType == String || key.toString().contains('__no_metrics')) nome += '${value[key]}'.length > 12 ? '${'${value[key]}'.substring(0, 12)}... ' : '${value[key]} ';

        double vlrTotalDaColuna = 0.0;
        for (var col in reportFromJSONController.colunas) if (col['key'] == keySelected) vlrTotalDaColuna = col['vlrTotalDaColuna'];

        temp.add(ChartData(title: nome, nome: nome, valor: value[keySelected].runtimeType == int ? double.parse(value[keySelected].toString()) : value[keySelected], type: value[keySelected].runtimeType, perc: (value[keySelected] / vlrTotalDaColuna) * 100, color: cores.isEmpty ? null : cores[reportFromJSONController.dados.indexOf(value)]));
      }
      return temp;
    }
  }

  //ordenar
  setOrderBy({required key, required order}) => reportFromJSONController.setOrderBy(key: key, order: order);

  //gerar lista de cores rândomica
  //length = total de itens que precisam de cores no grafico
  List<Color> _randonColors({required int length}) {
    if (ColorData.cores.length < length) return [];
    var rng = Random();
    List<Color> cores = [];
    List<int> listIndex = [];
    for (var i = 0; i < length; i++) {
      int index = rng.nextInt(ColorData.cores.length - 1);
      // ignore: prefer_is_empty
      if (i < ColorData.cores.length) while (listIndex.where((element) => element == index).toList().length > 0) index = rng.nextInt(ColorData.cores.length - 1);
      listIndex.add(index);
      cores.add(ColorData.cores[index]);
    }
    return cores;
  }
}
