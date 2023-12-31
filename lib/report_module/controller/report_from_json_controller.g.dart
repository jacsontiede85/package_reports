// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_from_json_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReportFromJSONController on ReportFromJSONControllerBase, Store {
  late final _$dadosAtom =
      Atom(name: 'ReportFromJSONControllerBase.dados', context: context);

  @override
  List<dynamic> get dados {
    _$dadosAtom.reportRead();
    return super.dados;
  }

  @override
  set dados(List<dynamic> value) {
    _$dadosAtom.reportWrite(value, super.dados, () {
      super.dados = value;
    });
  }

  late final _$colunasAtom =
      Atom(name: 'ReportFromJSONControllerBase.colunas', context: context);

  @override
  List<Map<String, dynamic>> get colunas {
    _$colunasAtom.reportRead();
    return super.colunas;
  }

  @override
  set colunas(List<Map<String, dynamic>> value) {
    _$colunasAtom.reportWrite(value, super.colunas, () {
      super.colunas = value;
    });
  }

  late final _$loadingAtom =
      Atom(name: 'ReportFromJSONControllerBase.loading', context: context);

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

  late final _$widthTableAtom =
      Atom(name: 'ReportFromJSONControllerBase.widthTable', context: context);

  @override
  double get widthTable {
    _$widthTableAtom.reportRead();
    return super.widthTable;
  }

  @override
  set widthTable(double value) {
    _$widthTableAtom.reportWrite(value, super.widthTable, () {
      super.widthTable = value;
    });
  }

  late final _$positionScrollAtom = Atom(
      name: 'ReportFromJSONControllerBase.positionScroll', context: context);

  @override
  double get positionScroll {
    _$positionScrollAtom.reportRead();
    return super.positionScroll;
  }

  @override
  set positionScroll(double value) {
    _$positionScrollAtom.reportWrite(value, super.positionScroll, () {
      super.positionScroll = value;
    });
  }

  late final _$visibleColElevatedAtom = Atom(
      name: 'ReportFromJSONControllerBase.visibleColElevated',
      context: context);

  @override
  bool get visibleColElevated {
    _$visibleColElevatedAtom.reportRead();
    return super.visibleColElevated;
  }

  @override
  set visibleColElevated(bool value) {
    _$visibleColElevatedAtom.reportWrite(value, super.visibleColElevated, () {
      super.visibleColElevated = value;
    });
  }

  late final _$ReportFromJSONControllerBaseActionController =
      ActionController(name: 'ReportFromJSONControllerBase', context: context);

  @override
  dynamic setOrderBy({required dynamic key, required dynamic order}) {
    final _$actionInfo = _$ReportFromJSONControllerBaseActionController
        .startAction(name: 'ReportFromJSONControllerBase.setOrderBy');
    try {
      return super.setOrderBy(key: key, order: order);
    } finally {
      _$ReportFromJSONControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
dados: ${dados},
colunas: ${colunas},
loading: ${loading},
widthTable: ${widthTable},
positionScroll: ${positionScroll},
visibleColElevated: ${visibleColElevated}
    ''';
  }
}
