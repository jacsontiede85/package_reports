// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtros_pagina_atual.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FiltrosPageAtual on FiltrosPageAtualBase, Store {
  late final _$filtrosWidgetModelAtom =
      Atom(name: 'FiltrosPageAtualBase.filtrosWidgetModel', context: context);

  @override
  FiltrosWidgetModel get filtrosWidgetModel {
    _$filtrosWidgetModelAtom.reportRead();
    return super.filtrosWidgetModel;
  }

  bool _filtrosWidgetModelIsInitialized = false;

  @override
  set filtrosWidgetModel(FiltrosWidgetModel value) {
    _$filtrosWidgetModelAtom.reportWrite(value,
        _filtrosWidgetModelIsInitialized ? super.filtrosWidgetModel : null, () {
      super.filtrosWidgetModel = value;
      _filtrosWidgetModelIsInitialized = true;
    });
  }

  @override
  String toString() {
    return '''
filtrosWidgetModel: ${filtrosWidgetModel}
    ''';
  }
}
