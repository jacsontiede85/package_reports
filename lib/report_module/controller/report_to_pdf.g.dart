// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_to_pdf.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ReportPDFController on ReportPDFControllerBase, Store {
  late final _$loadingExportPdfAtom =
      Atom(name: 'ReportPDFControllerBase.loadingExportPdf', context: context);

  @override
  bool get loadingExportPdf {
    _$loadingExportPdfAtom.reportRead();
    return super.loadingExportPdf;
  }

  @override
  set loadingExportPdf(bool value) {
    _$loadingExportPdfAtom.reportWrite(value, super.loadingExportPdf, () {
      super.loadingExportPdf = value;
    });
  }

  late final _$tableAtom =
      Atom(name: 'ReportPDFControllerBase.table', context: context);

  @override
  List<Widget> get table {
    _$tableAtom.reportRead();
    return super.table;
  }

  @override
  set table(List<Widget> value) {
    _$tableAtom.reportWrite(value, super.table, () {
      super.table = value;
    });
  }

  late final _$getDadosAsyncAction =
      AsyncAction('ReportPDFControllerBase.getDados', context: context);

  @override
  Future getDados(
      {required ReportFromJSONController controller, required String titulo}) {
    return _$getDadosAsyncAction
        .run(() => super.getDados(controller: controller, titulo: titulo));
  }

  late final _$ReportPDFControllerBaseActionController =
      ActionController(name: 'ReportPDFControllerBase', context: context);

  @override
  void getColumns() {
    final _$actionInfo = _$ReportPDFControllerBaseActionController.startAction(
        name: 'ReportPDFControllerBase.getColumns');
    try {
      return super.getColumns();
    } finally {
      _$ReportPDFControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getRows() {
    final _$actionInfo = _$ReportPDFControllerBaseActionController.startAction(
        name: 'ReportPDFControllerBase.getRows');
    try {
      return super.getRows();
    } finally {
      _$ReportPDFControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getTable() {
    final _$actionInfo = _$ReportPDFControllerBaseActionController.startAction(
        name: 'ReportPDFControllerBase.getTable');
    try {
      return super.getTable();
    } finally {
      _$ReportPDFControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
loadingExportPdf: ${loadingExportPdf},
table: ${table}
    ''';
  }
}
