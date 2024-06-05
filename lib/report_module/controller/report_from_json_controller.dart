// ignore_for_file: curly_braces_in_flow_control_structures
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:package_reports/global/core/api_consumer.dart';
import 'package:package_reports/global/core/settings.dart';
import 'package:package_reports/report_module/model/filtrar_colunas_model.dart';
part 'report_from_json_controller.g.dart';

class ReportFromJSONController = ReportFromJSONControllerBase with _$ReportFromJSONController;

abstract class ReportFromJSONControllerBase with Store, ChangeNotifier {
  late String nomeFunction;
  late double sizeWidth;
  late bool isToGetDadosNaEntrada;
  late String database;
  Map<String, dynamic>? modificarbodyPrimario;

  ReportFromJSONControllerBase({
    required this.nomeFunction,
    required this.sizeWidth,
    required this.isToGetDadosNaEntrada,
    required this.database,
    this.modificarbodyPrimario,
  }) {
    bodyPrimario.update("database", (value) => database);

    if (isToGetDadosNaEntrada) {
      getConfig().whenComplete(() => getDados());
    }

    if (modificarbodyPrimario != null) {
      bodyPrimario.addAll(modificarbodyPrimario ?? {});
    }
  }

  Map<String, dynamic> bodyPrimario = {
    "matricula": SettingsReports.matricula,
    "database": "",
    "dtinicio": SettingsReports.formatarDataPadraoBR(data: DateTime.now().toString()),
    "dtfim": SettingsReports.formatarDataPadraoBR(data: DateTime.now().toString()),
  };

  @observable
  List dados = [];

  TextEditingController searchString = TextEditingController();

  List<Map<String, dynamic>> filtrosSelected = [];

  @observable
  Set<String> colunasFiltradas = {};

  @observable
  Map<String, dynamic> configPagina = {};

  String keyFreeze = ''; // chave da coluna que será congelada (elevated)

  @observable
  List<Map<String, dynamic>> colunas = [];

  @observable
  List<ColunasModel> listaFiltrarLinhas = [];

  List<Widget> row = [];

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

  bool habilitarNovoRelatorio = false;

  bool primeiraBusca = true;

  // ? VAREAVEIS E FUNÇÕES PARA PERMITIR A NAVEGAÇÃO ENTRE VARIOS RELATORIOS
  Map<String, dynamic> mapSelectedRow = {};
  Map<String, dynamic> configPageBuscaRecursiva = {};
  Map<String, dynamic> bodySecundario = {};

  setMapSelectedRowController({required Map<String, dynamic> mapSelectedRow, required Map<String, dynamic> configPageBuscaRecursiva, required Map<String, dynamic> bodySecundario}) {
    this.mapSelectedRow = mapSelectedRow;
    this.configPageBuscaRecursiva = configPageBuscaRecursiva;
    this.bodySecundario.addAll(bodySecundario);
    habilitarNovoRelatorio = true;
    primeiraBusca = false;
  }
  // ? FIM

  setPositionScroll(double position) async {
    visibleColElevated = false;
    if (_position != position) _position = position;
    updatePosition(pos: _position);
  }

  updatePosition({required double pos}) async {
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
      horizontalScroll.removeListener(() {});
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
  Future<void> getConfig() async {
    loading = true;
    var response = await API().getConfigApi(function: nomeFunction);
    configPagina = configPageBuscaRecursiva;
    if (habilitarNovoRelatorio && configPagina.isNotEmpty) {
      getSelectedRowParaNavegarParaNovaPage();
    } else {
      configPagina = response;
      bodyPrimario.addAll(
        {
          "indexPage": configPagina['indexPage'],
        },
      );
    }
  }

  void limparCamposVareaveis() {
    if (!habilitarNovoRelatorio && !primeiraBusca) {
      configPageBuscaRecursiva = {};
      getConfig();
    }

    dados = [];
    listaFiltrarLinhas = [];
    filtrosSelected = [];
    colunasFiltradas = {};

    loading = true;
    primeiraBusca = false;
    keyFreeze = "";

    if (_listenerStarted) _removeListener();

    // ! Necessario criar forma de limpar campos que estão indo fazer a busca de relatorios recursivos
  }

  getDados() async {
    limparCamposVareaveis();

    if (bodySecundario.isEmpty) {
      dados = jsonDecode(
        await API().getDataReportApiJWT(
          url: nomeFunction,
          dados: bodyPrimario,
        ),
      );
    } else {
      dados = jsonDecode(
        await API().getDataReportApiJWT(
          url: nomeFunction,
          dados: bodySecundario,
        ),
      );
    }

    List keys = [];
    for (var value in dados) {
      value['isFiltered'] = false;
      for (var key in value.keys) {
        if (key.toString().toUpperCase().contains('__LOCK')) {
          keys.add(key);
        }
      }
    }

    for (var value in keys) for (int i = 0; i < dados.length; i++) dados[i].remove(value);

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
      __ISRODAPE      => Usar para fazer um rodapé personalizado

      IMPORTANTE: coso o tipo de dado não seja informado, o tipo de formatação será identificado a partir dos dados recebidos
    */

    for (var value in dados) {
      for (var key in value.keys) {
        if (key.toString().toUpperCase().contains('__STRING') || key.toString().toUpperCase().contains('__INT_STRING')) continue;
        if (key.toString().toUpperCase().contains('__INT')) {
          try {
            var val = double.parse(value[key]).floor();
            value[key] = val;
          } catch (e) {
            value[key] = 0;
          }
          continue;
        }
        if (key.toString().toUpperCase().contains('__DOUBLE')) {
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
            value[key] = value[key].toString();
          }
        }
      }
    }

    /////////////////////////////// COLUNAS
    colunas.clear();
    colunasRodapePerson.clear();
    try {
      for (var key in dados[0].keys) {
        if (key.toString().toUpperCase().contains('__ISRODAPE')) {
          colunasRodapePerson.add(
            ObservableMap.of(
              {
                'key': key,
                'nomeFormatado': getNomeColunaFormatado(text: key),
                'type': key.toString().toUpperCase().toUpperCase().contains('__INT_STRING') ? String : getType(dados[0][key]),
                'order': 'asc',
                'isSelected': false,
                'vlrTotalDaColuna': 0.0,
                'widthCol': 0.0,
                'selecionado': colunaSelecionadaParaExportacao,
              },
            ),
          );
        } else if (!key.toString().toUpperCase().contains('__INVISIBLE') && !key.toString().contains('isFiltered')) {
          colunas.add(
            ObservableMap.of(
              {
                'key': key,
                'nomeFormatado': getNomeColunaFormatado(text: key),
                'type': key.toString().toUpperCase().contains('__INT_STRING') ? String : getType(dados[0][key]),
                'order': 'asc',
                'isSelected': false,
                'vlrTotalDaColuna': 0.0,
                'widthCol': 0.0,
                'selecionado': colunaSelecionadaParaExportacao,
                'isFiltered': false,
              },
            ),
          );
        }
      }

      //calcular totalizadores de rodape
      for (var col in colunas)
        for (var row in dados){
          for (var key in row.keys){
            if (key == col['key'] && row[key].toString().isNotEmpty) {
              if (col['type'] != String) {
                if(row[key].runtimeType == String) row[key] = double.parse(row[key]);
                col['vlrTotalDaColuna'] += row[key];
              }
            }
          }
        }

      //calcular max caractares para definir largura de colunas
      for (var col in colunas)
        for (var row in dados)
          for (var key in row.keys) {
            if (key == col['key']) {
              try {
                if (key.toString().toUpperCase().contains('__SIZEW')) {
                  var temp = key.toString().toUpperCase().split('__SIZEW');
                  col['widthCol'] = double.parse(temp[1]);
                } else {
                  if (col['type'] == String) {
                    if (col['widthCol'].floor() < row[key].toString().length) col['widthCol'] = double.parse('${row[key].toString().length}');
                  } else {
                    col['widthCol'] = double.parse('${'${col['vlrTotalDaColuna'].toStringAsFixed(2)}'.length}');
                  }
                }
              } catch (e) {
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
      if (kDebugMode) {
        print("Erro $e");
      }
    } finally {
      notify();
      _startListener();
    }
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
    text = text.toString().toUpperCase().replaceAll('__PERC', '_%');
    text = text.toString().toUpperCase().replaceAll('__INT_STRING', '');
    text = text.toString().toUpperCase().replaceAll('__STRING', '');
    text = text.toString().toUpperCase().replaceAll('__DOUBLE', '');
    text = text.toString().toUpperCase().replaceAll('__INT', '');
    text = text.toString().toUpperCase().replaceAll('__NO_METRICS', '');
    text = text.toString().toUpperCase().replaceAll('__NOCHARTAREA', '');
    text = text.toString().toUpperCase().replaceAll('__INVISIBLE', '');
    text = text.toString().toUpperCase().replaceAll('__DONTSUM', '');
    text = text.toString().toUpperCase().replaceAll('__FREEZE', '');
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

      if (a[key].toString().length == 10 && a[key].toString().toUpperCase().contains('/')) {
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
        if (order == 'asc') if (key.toString().toUpperCase().contains('__INT_STRING'))
          return int.parse(a[key]).compareTo(int.parse(b[key]));
        else
          return a[key].compareTo(b[key]);
        else if (key.toString().toUpperCase().contains('__INT_STRING'))
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
        if (key.toString().toUpperCase().contains('__FREEZE')) {
          keyFreeze = key;
          break;
        }
      }
      if (keyFreeze.isEmpty)
        for (var key in val.keys) {
          if ((val[key].runtimeType == String || key.toString().toUpperCase().contains('__NO_METRICS')) && '${val[key]}'.length > 5 && !key.toString().toUpperCase().contains('__INVISIBLE') && !key.toString().contains('isFiltered')) {
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
    widthTable = (w + 1) * 1.1; // +1 é referente a largura de cada linha de celula (1 pixel)
  }

  //exibir botão de grafico
  bool get isVisibleButtomCharts => (dados.isNotEmpty && !loading);

  //forçar atualização de tela
  notify() {
    loading = false;
    colunas = colunas;
    dados = dados;
  }

  List<ColunasModel> createlistaFiltrarLinhas({required String chave}) {
    for (Map<String, dynamic> valores in dados) {
      bool existe = listaFiltrarLinhas.any((mapa) => mapa.valor == valores[chave].toString() && mapa.coluna == chave);
      if (!existe) {
        listaFiltrarLinhas.add(ColunasModel(coluna: chave, valor: valores[chave].toString(), selecionado: false));
      }
    }

    List<ColunasModel> temp = listaFiltrarLinhas.where((mapa) => mapa.coluna == chave).toList();

    temp.sort((a, b) {
      try {
        return double.parse(a.valor).compareTo(double.parse(b.valor));
      } catch (e) {
        return a.valor.compareTo(b.valor);
      }
    });

    return temp.toList();
  }

  //inicio filtro de das colunas e da barra de pesquisa
  List dadosFiltered() {
    try {
      if (filtrosSelected.isNotEmpty || searchString.text.isNotEmpty)
        return dados.where((element) => element['isFiltered']).toList();
      else
        return dados;
    } catch (e) {
      return dados;
    }
  }

  filterListFromSearch() {
    if (searchString.text.isNotEmpty) if (filtrosSelected.isNotEmpty) {
      if (dados.any((element) => element['isFiltered']))
        for (var key in dados) {
          if (key['isFiltered']) {
            int count = 0;
            for (var value in key.values) {
              if (value.toString().toLowerCase().contains(searchString.text.toLowerCase())) {
                count++;
                break;
              }
            }
            if (count > 0)
              key["isFiltered"] = true;
            else
              key["isFiltered"] = false;
          }
        }
      else
        getTheSelectedFilteredRows();
    } else {
      for (var key in dados) {
        int count = 0;
        for (var value in key.values) {
          if (value.toString().toLowerCase().contains(searchString.text.toLowerCase())) {
            count++;
            break;
          }
        }
        if (count > 0)
          key["isFiltered"] = true;
        else
          key["isFiltered"] = false;
      }
    }
    else
      getTheSelectedFilteredRows();

    for (var col in colunas) {
      col['vlrTotalDaColuna'] = 0;
      for (var row in dados)
        for (var key in row.keys)
          if (key == col['key']) {
            if (col['type'] != String) col['vlrTotalDaColuna'] += row['isFiltered'] ? row[key] : 0;
          }

      for (var value in colunasFiltradas)
        if (col["key"] == value)
          col["isFiltered"] = true;
        else
          col["isFiltered"] = false;
    }
  }

  getTheSelectedFilteredRows() {
    Set temp = {};
    for (var element in filtrosSelected) {
      temp.add(
        element["coluna"],
      );
    }

    for (var key in dados) {
      int count = 0;
      for (var value in temp) {
        if (filtrosSelected.any((element) {
          if (element["coluna"] == value)
            return element["valor"].toString() == key[value].toString();
          else
            return false;
        })) count++;
      }

      if (count == temp.length)
        key["isFiltered"] = true;
      else
        key["isFiltered"] = false;

      if (searchString.text.isNotEmpty) filterListFromSearch();
    }

    for (var col in colunas) {
      col['vlrTotalDaColuna'] = 0;
      for (var row in dados)
        for (var key in row.keys)
          if (key == col['key']) {
            if (col['type'] != String) col['vlrTotalDaColuna'] += row['isFiltered'] ? row[key] : 0;
          }

      if (colunasFiltradas.any((element) => element == col["key"]))
        col["isFiltered"] = true;
      else
        col["isFiltered"] = false;
    }
  }

  clearFiltros() {
    searchString.clear();
    filtrosSelected = [];
    colunasFiltradas = {};

    for (var value in listaFiltrarLinhas) value.selecionado = false;
    for (var value in dados) value["isFiltered"] = false;
    for (var value in colunas)
      if (colunasFiltradas.any((element) => element == value["key"]))
        value["isFiltered"] = true;
      else
        value["isFiltered"] = false;

    for (var col in colunas) {
      col['vlrTotalDaColuna'] = 0;
      for (var row in dados)
        for (var key in row.keys)
          if (key == col['key']) {
            if (col['type'] != String) col['vlrTotalDaColuna'] += row[key];
          }
    }
  }

  getSelectedRowParaNavegarParaNovaPage() {
    if (configPagina['page'].isNotEmpty && configPagina['page'] != null) {
      configPagina['selectedRow'] = mapSelectedRow;
      bodySecundario.addAll(
        {
          'selectedRow': configPagina['selectedRow'],
        },
      );
      configPagina = configPagina['page'];
      if (bodySecundario['indexPage'].toString().isNotEmpty && bodySecundario['indexPage'] != null) {
        bodySecundario.update(
          'indexPage',
          (value) => value = configPagina['indexPage'],
        );
      } else {
        bodySecundario.addAll(
          {
            'indexPage': configPagina['indexPage'],
          },
        );
      }
    }
  }
}

/*
void printW(text) {
  if (kDebugMode) {
    print('\x1B[33m$text\x1B[0m');
  }
}

void printE(text) {
  if (kDebugMode) {
    print('\x1B[31m$text\x1B[0m');
  }
}

void printO(text) {
  if (kDebugMode) {
    print('\x1b[32m$text\x1B[0m');
  }
}

void limparPrint() {
  if (kDebugMode) {
    print("\x1B[2J\x1B[0;0H");
  }
}
*/