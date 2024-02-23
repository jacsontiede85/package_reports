// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtro_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FiltroController on FiltroControllerBase, Store {
  late final _$listaFiltrosAtom =
      Atom(name: 'FiltroControllerBase.listaFiltros', context: context);

  @override
  List<FiltrosModel> get listaFiltros {
    _$listaFiltrosAtom.reportRead();
    return super.listaFiltros;
  }

  @override
  set listaFiltros(List<FiltrosModel> value) {
    _$listaFiltrosAtom.reportWrite(value, super.listaFiltros, () {
      super.listaFiltros = value;
    });
  }

  late final _$listaFiltrosParaConstruirTelaAtom = Atom(
      name: 'FiltroControllerBase.listaFiltrosParaConstruirTela',
      context: context);

  @override
  List<Map<int, FiltrosWidgetModel>> get listaFiltrosParaConstruirTela {
    _$listaFiltrosParaConstruirTelaAtom.reportRead();
    return super.listaFiltrosParaConstruirTela;
  }

  @override
  set listaFiltrosParaConstruirTela(List<Map<int, FiltrosWidgetModel>> value) {
    _$listaFiltrosParaConstruirTelaAtom
        .reportWrite(value, super.listaFiltrosParaConstruirTela, () {
      super.listaFiltrosParaConstruirTela = value;
    });
  }

  late final _$loadingItensFiltorsAtom =
      Atom(name: 'FiltroControllerBase.loadingItensFiltors', context: context);

  @override
  bool get loadingItensFiltors {
    _$loadingItensFiltorsAtom.reportRead();
    return super.loadingItensFiltors;
  }

  @override
  set loadingItensFiltors(bool value) {
    _$loadingItensFiltorsAtom.reportWrite(value, super.loadingItensFiltors, () {
      super.loadingItensFiltors = value;
    });
  }

  @override
  String toString() {
    return '''
listaFiltros: ${listaFiltros},
listaFiltrosParaConstruirTela: ${listaFiltrosParaConstruirTela},
loadingItensFiltors: ${loadingItensFiltors}
    ''';
  }
}
