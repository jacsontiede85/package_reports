// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:package_reports/report_module/core/api_consumer.dart';
import 'package:package_reports/report_module/core/filtros.dart';
part 'report_from_json_controller.g.dart';

class ReportFromJSONController = ReportFromJSONControllerBase with _$ReportFromJSONController;

abstract class ReportFromJSONControllerBase with Store {

  late String nomeFunction;
  late double sizeWidth;
  ReportFromJSONControllerBase({required this.nomeFunction, required this.sizeWidth}) {
    getDados();
  }

  final Filtros filtro = Filtros();

  @observable
  List<dynamic> dados = [];

  String keyFreeze = ''; // chave da coluna que será congelada (elevated)

  @observable
  List<Map<String, dynamic>> colunas = [];

  @observable
  bool loading = false;

  @observable
  bool mostrarBarraPesquisar = false;

  @observable
  bool colunaSelecionadaParaExportacao = true;

  @observable
  List<ObservableMap<String, dynamic>> colunasRodapePerson = [];

  @observable
  double widthTable = 1000.0;

  ScrollController horizontalScroll = ScrollController();
  ScrollController verticalScroll = ScrollController();

  @observable
  double positionScroll = 0.0;
  double _position = 0.0;

  @observable
  bool visibleColElevated = false;

  setPositionScroll(double position) async {
    visibleColElevated = false;
    if (_position != position) _position = position;
    updatePosition(pos: _position);
  }

  updatePosition({required double pos}) async {
    //await Future.delayed(Duration(milliseconds: 500));
    if (pos == _position) positionScroll = _position;
    visibleColElevated = true;
  }

  bool _listenerStarted = false;
  Future<void> scrollListener() async {
    try {
      double position = double.parse(horizontalScroll.position.pixels.toString());
      if (!loading) setPositionScroll(position);
      _listenerStarted = true;
    } catch (e) {
      //printE('scrollListener : ERRO');
    }
  }

  void _startListener() async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      horizontalScroll.addListener(scrollListener);
    } catch (e) {
      //printE("_startListener");
    }
  }

  void _removeListener() {
    try {
      horizontalScroll.removeListener(() {
        //printE("Scrolled to: ${horizontalScroll.offset}");
      });
    } catch (e) {
      //printE("_startListener");
    }
    _listenerStarted = false;
  }

  //remover listener ao sair da page
  Future<bool> willPopCallback() async {
    _removeListener();
    return Future.value(true);
  }

  //BUSCAR DADOS PARA MONTAGEM DO RELATORIO
  getDados() async {
    keyFreeze = "";
    if (_listenerStarted) _removeListener();
    loading = true;
    dados = [];
    dados = await API().getDataReportApi(function: nomeFunction);

    List keys = [];
    for(var value in dados){
      for(var key in value.keys)
        if(key.toString().contains('__lock'))
          keys.add(key);
    }

    for(var value in keys)
      for(int i = 0; i<dados.length; i++)
        dados[i].remove(value);

    /////////////////////////////// TRATAR TIPOS DE DADOS [ ROWS ]
    /*
      Forma de realizar formatação de dados e alinhamento em tela.
      Deve-se enviar a seguinte informação no final de cada nome de coluna na query:

      __INT_STRING    => para forçar numero ser tratado e alinhado como string
      __STRING        => forçar o uso de String
      __DOUBLE        => forçar uso de double
      __INT           => forçar uso de int
      __NO_METRICS    => excluir da exibição de metricas dos graficos
      __NOCHARTAREA   => excluir do grafico de area e line
      __INVISIBLE     => não exibir campo no relatório
      __DONTSUM       => não somar na barra de totalizador
      __PERC          => colocar % (percentagem) junto ao texto da coluna
      __FREEZE        => congelar coluna ao deslizar barra de scroll horizontal
      __SIZEW         => passar largura fixa de coluna. Exemplo: __SIZEW300
      __LOCK          => Validar se o usuario tem acesso ao campo

      IMPORTANTE: coso o tipo de dado não seja informado, o tipo de formatação será identificado a partir dos dados recebidos
    */

    for (var value in dados) {
      for (var key in value.keys) {
        if (key.toString().contains('__string') || key.toString().contains('__int_string')) continue;
        if (key.toString().contains('__int')) {
          try {
            var val = double.parse(value[key]).floor();
            value[key] = val;
          } catch (e) {
            value[key] = 0;
          }
          continue;
        }
        if (key.toString().contains('__double')) {
          try {
            value[key] = double.parse(value[key]);
          } catch (e) {
            value[key] = 0.0;
          }
          continue;
        }

        //formatação padrão
        try {
          value[key] = double.parse(value[key]);
        } catch (e) {
          try {
            value[key] = int.parse(value[key]);
          } catch (e) {
            value[key] = 0;
          }
        }
      }
    }

    /////////////////////////////// COLUNAS
    colunas.clear();
    colunasRodapePerson.clear();
    try {

      for (var key in dados[0].keys) {
        if (key.toString().contains('__isrodape')){

          colunasRodapePerson.add(
            ObservableMap.of({
              'key': key,
              'nomeFormatado': getNomeColunaFormatado(text: key),
              'type': key.toString().contains('__int_string') ? String : getType(dados[0][key]),
              'order': 'asc',
              'isSelected': false,
              'vlrTotalDaColuna': 0.0,
              'widthCol': 0.0,
              'selecionado' : colunaSelecionadaParaExportacao,
            })
          );
          
        }
        else if (!key.toString().contains('__invisible')){

          colunas.add(
            ObservableMap.of({
              'key': key,
              'nomeFormatado': getNomeColunaFormatado(text: key),
              'type': key.toString().contains('__int_string') ? String : getType(dados[0][key]),
              'order': 'asc',
              'isSelected': false,
              'vlrTotalDaColuna': 0.0,
              'widthCol': 0.0,
              'selecionado' : colunaSelecionadaParaExportacao,
            })
          );
          
        }

      }

      //calcular totalizadores de rodape
      for (var col in colunas)
        for (var row in dados)
          for (var key in row.keys)
            if (key == col['key']) {
              if (col['type'] != String) col['vlrTotalDaColuna'] += row[key];
            }

      //calcular max caractares para definir largura de colunas
      for (var col in colunas)
        for (var row in dados)
          for (var key in row.keys) {
            if (key == col['key']) {
              try{
                if(key.toString().contains('__sizew')){
                  var temp = key.toString().split('__sizew');
                  col['widthCol'] = double.parse(temp[1]);
                } else {
                  if (col['type'] == String) {
                    if (col['widthCol'].floor() < row[key].toString().length) col['widthCol'] = double.parse('${row[key].toString().length}');
                  } else {
                    col['widthCol'] = double.parse('${'${col['vlrTotalDaColuna'].toStringAsFixed(2)}'.length}');
                  }
                }
              } catch (e){
                if (col['type'] == String) {
                  if (col['widthCol'].floor() < row[key].toString().length) col['widthCol'] = double.parse('${row[key].toString().length}');
                } else {
                  col['widthCol'] = double.parse('${'${col['vlrTotalDaColuna'].toStringAsFixed(2)}'.length}');
                }
              }
            }
          }
      getWidthTable();
      setOrderBy(key: colunas[0]['key'], order: 'asc');
      getColunaElevada();
    } catch (e) {
      // printE("Erro getDados");
    }

    notify();
    _startListener();
  }

  //retornar o tipo de dados
  getType(value) {
    try {
      value = int.parse(value);
    } catch (e) {
      try {
        value = double.parse(value);
      } catch (e) {
        return value.runtimeType;
      }
    }
    return value.runtimeType;
  }

  //retornar nome de coluna formatado
  getNomeColunaFormatado({required String text}) {
    text = text.toString().replaceAll('__perc', '_%');
    text = text.toString().replaceAll('__int_string', '');
    text = text.toString().replaceAll('__string', '');
    text = text.toString().replaceAll('__double', '');
    text = text.toString().replaceAll('__int', '');
    text = text.toString().replaceAll('__no_metrics', '');
    text = text.toString().replaceAll('__nochartarea', '');
    text = text.toString().replaceAll('__invisible', '');
    text = text.toString().replaceAll('__dontsum', '');
    text = text.toString().replaceAll('__freeze', '');
    var temp = text.split('__');
    text = temp[0];
    text = text.toString().replaceAll('_', ' ');
    return text.trim();
  }

  /////////////////////////////// ORDER BY
  @action
  setOrderBy({required key, required order}) {
    loading = true;
    dados.sort((a, b) {
      for (var value in colunas)
        if (value['key'] == key) {
          value['order'] = (order == 'asc') ? 'desc' : 'asc';
          value['isSelected'] = true;
        } else
          value['isSelected'] = false;

      if (a[key].toString().length == 10 && a[key].toString().contains('/')) {
        try {
          DateTime datea = DateFormat('dd/MM/yyyy').parse(a[key]);
          DateTime dateb = DateFormat('dd/MM/yyyy').parse(b[key]);
          var aa = int.parse('${datea.year}${datea.month.toString().padLeft(2, '0')}${datea.day.toString().padLeft(2, '0')}');
          var bb = int.parse('${dateb.year}${dateb.month.toString().padLeft(2, '0')}${dateb.day.toString().padLeft(2, '0')}');
          if (order == 'asc')
            return aa.compareTo(bb);
          else
            return bb.compareTo(aa);
        } catch (e) {
          return a[key].compareTo(b[key]);
        }
      } else {
        if (order == 'asc') if (key.toString().contains('__int_string'))
          return int.parse(a[key]).compareTo(int.parse(b[key]));
        else
          return a[key].compareTo(b[key]);
        else if (key.toString().contains('__int_string'))
          return int.parse(b[key]).compareTo(int.parse(a[key]));
        else
          return b[key].compareTo(a[key]);
      }
    });
    notify();
  }

  getColunaElevada() {
    for (var val in dados) {
      for (var key in val.keys) {
        if (key.toString().contains('__freeze')) {
          keyFreeze = key;
          break;
        }
      }
      if (keyFreeze.isEmpty)
        for (var key in val.keys) {
          if ((val[key].runtimeType == String || key.toString().contains('__no_metrics')) && '${val[key]}'.length > 5 && !key.toString().contains('__invisible')) {
            keyFreeze = key;
            break;
          }
        }
      if (keyFreeze.isEmpty)
        for (var key in val.keys) {
          keyFreeze = key;
          break;
        }
    }
  }

  double get getHeightColunasCabecalho {
    double t = 0.0;
    for (var col in colunas) {
      if (t.floor() < col['nomeFormatado'].toString().length) t += col['nomeFormatado'].toString().length;
    }
    return t * 1.9;
  }

  //retornar Map com dados de coluna
  Map getMapColuna({required key}) {
    for (var col in colunas) if (col['key'] == key) return col;
    return {};
  }

  //buscar largura de cada coluna
  double getWidthCol({
    required key,
  }) {
    var coluna = getMapColuna(key: key);
    return coluna['widthCol'];
  }

  //obter largura total da table
  getWidthTable() {
    double w = 0.0;
    bool isMobile = sizeWidth < 600;
    for (var coluna in colunas) {
      double widthCelula = 0.0;
      if (coluna['type'] == String) if (coluna['widthCol'] < 15)
        widthCelula = isMobile ? 100 : 110.0;
      else
        widthCelula = isMobile ? coluna['widthCol'] * 3.5 : coluna['widthCol'] * 6.0;
      else if (coluna['widthCol'] < 7)
        widthCelula = 100.0;
      else
        widthCelula = coluna['widthCol'] * 10.0;

      coluna['widthCol'] = widthCelula;
      w += widthCelula;
    }
    widthTable = w + 1; // +1 é referente a largura de cada linha de celula (1 pixel)
  }

  //exibir botão de grafico
  bool get isVisibleButtomCharts => /*(colunas.where((element) => element['type'] != String).toList().isNotEmpty) && */ (dados.isNotEmpty && !loading);

  //forçar atualização de tela
  notify() {
    loading = false;
    colunas = colunas;
    dados = dados;
  }
}
