// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_chart_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReportChartController on ReportChartControllerBase, Store {
  late final _$chartNameSelectedAtom = Atom(
      name: 'ReportChartControllerBase.chartNameSelected', context: context);

  @override
  String get chartNameSelected {
    _$chartNameSelectedAtom.reportRead();
    return super.chartNameSelected;
  }

  @override
  set chartNameSelected(String value) {
    _$chartNameSelectedAtom.reportWrite(value, super.chartNameSelected, () {
      super.chartNameSelected = value;
    });
  }

  late final _$orderbyAtom =
      Atom(name: 'ReportChartControllerBase.orderby', context: context);

  @override
  String get orderby {
    _$orderbyAtom.reportRead();
    return super.orderby;
  }

  @override
  set orderby(String value) {
    _$orderbyAtom.reportWrite(value, super.orderby, () {
      super.orderby = value;
    });
  }

  late final _$chartSelectedAtom =
      Atom(name: 'ReportChartControllerBase.chartSelected', context: context);

  @override
  Widget get chartSelected {
    _$chartSelectedAtom.reportRead();
    return super.chartSelected;
  }

  @override
  set chartSelected(Widget value) {
    _$chartSelectedAtom.reportWrite(value, super.chartSelected, () {
      super.chartSelected = value;
    });
  }

  late final _$columnMetricSelectedAtom = Atom(
      name: 'ReportChartControllerBase.columnMetricSelected', context: context);

  @override
  Map<dynamic, dynamic> get columnMetricSelected {
    _$columnMetricSelectedAtom.reportRead();
    return super.columnMetricSelected;
  }

  @override
  set columnMetricSelected(Map<dynamic, dynamic> value) {
    _$columnMetricSelectedAtom.reportWrite(value, super.columnMetricSelected,
        () {
      super.columnMetricSelected = value;
    });
  }

  late final _$columnOrderBySelectedAtom = Atom(
      name: 'ReportChartControllerBase.columnOrderBySelected',
      context: context);

  @override
  Map<dynamic, dynamic> get columnOrderBySelected {
    _$columnOrderBySelectedAtom.reportRead();
    return super.columnOrderBySelected;
  }

  @override
  set columnOrderBySelected(Map<dynamic, dynamic> value) {
    _$columnOrderBySelectedAtom.reportWrite(value, super.columnOrderBySelected,
        () {
      super.columnOrderBySelected = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: 'ReportChartControllerBase.loading', context: context);

  @override
  bool get loading {
    _$loadingAtom.reportRead();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.reportWrite(value, super.loading, () {
      super.loading = value;
    });
  }

  late final _$metricaSelecionadaAtom = Atom(
      name: 'ReportChartControllerBase.metricaSelecionada', context: context);

  @override
  String get metricaSelecionada {
    _$metricaSelecionadaAtom.reportRead();
    return super.metricaSelecionada;
  }

  @override
  set metricaSelecionada(String value) {
    _$metricaSelecionadaAtom.reportWrite(value, super.metricaSelecionada, () {
      super.metricaSelecionada = value;
    });
  }

  late final _$ordenacaoSelecionadaAtom = Atom(
      name: 'ReportChartControllerBase.ordenacaoSelecionada', context: context);

  @override
  String get ordenacaoSelecionada {
    _$ordenacaoSelecionadaAtom.reportRead();
    return super.ordenacaoSelecionada;
  }

  @override
  set ordenacaoSelecionada(String value) {
    _$ordenacaoSelecionadaAtom.reportWrite(value, super.ordenacaoSelecionada,
        () {
      super.ordenacaoSelecionada = value;
    });
  }

  late final _$tipoOrdenacaoSelecionadaAtom = Atom(
      name: 'ReportChartControllerBase.tipoOrdenacaoSelecionada',
      context: context);

  @override
  String get tipoOrdenacaoSelecionada {
    _$tipoOrdenacaoSelecionadaAtom.reportRead();
    return super.tipoOrdenacaoSelecionada;
  }

  @override
  set tipoOrdenacaoSelecionada(String value) {
    _$tipoOrdenacaoSelecionadaAtom
        .reportWrite(value, super.tipoOrdenacaoSelecionada, () {
      super.tipoOrdenacaoSelecionada = value;
    });
  }

  late final _$getChartAsyncAction =
      AsyncAction('ReportChartControllerBase.getChart', context: context);

  @override
  Future getChart({required String chartNameSelected}) {
    return _$getChartAsyncAction
        .run(() => super.getChart(chartNameSelected: chartNameSelected));
  }

  @override
  String toString() {
    return '''
chartNameSelected: ${chartNameSelected},
orderby: ${orderby},
chartSelected: ${chartSelected},
columnMetricSelected: ${columnMetricSelected},
columnOrderBySelected: ${columnOrderBySelected},
loading: ${loading},
metricaSelecionada: ${metricaSelecionada},
ordenacaoSelecionada: ${ordenacaoSelecionada},
tipoOrdenacaoSelecionada: ${tipoOrdenacaoSelecionada}
    ''';
  }
}
