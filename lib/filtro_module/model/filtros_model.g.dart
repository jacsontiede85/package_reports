// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtros_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FiltrosModel on FiltrosModelBase, Store {
  late final _$tituloAtom =
      Atom(name: 'FiltrosModelBase.titulo', context: context);

  @override
  String get titulo {
    _$tituloAtom.reportRead();
    return super.titulo;
  }

  @override
  set titulo(String value) {
    _$tituloAtom.reportWrite(value, super.titulo, () {
      super.titulo = value;
    });
  }

  late final _$selecionadoAtom =
      Atom(name: 'FiltrosModelBase.selecionado', context: context);

  @override
  bool get selecionado {
    _$selecionadoAtom.reportRead();
    return super.selecionado;
  }

  @override
  set selecionado(bool value) {
    _$selecionadoAtom.reportWrite(value, super.selecionado, () {
      super.selecionado = value;
    });
  }

  @override
  String toString() {
    return '''
titulo: ${titulo},
selecionado: ${selecionado}
    ''';
  }
}
