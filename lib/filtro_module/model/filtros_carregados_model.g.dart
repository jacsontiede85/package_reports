// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtros_carregados_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FiltrosCarrregados on FiltrosCarrregadosBase, Store {
  late final _$indexFiltrosAtom =
      Atom(name: 'FiltrosCarrregadosBase.indexFiltros', context: context);

  @override
  int get indexFiltros {
    _$indexFiltrosAtom.reportRead();
    return super.indexFiltros;
  }

  @override
  set indexFiltros(int value) {
    _$indexFiltrosAtom.reportWrite(value, super.indexFiltros, () {
      super.indexFiltros = value;
    });
  }

  late final _$indexPaginaAtom =
      Atom(name: 'FiltrosCarrregadosBase.indexPagina', context: context);

  @override
  int get indexPagina {
    _$indexPaginaAtom.reportRead();
    return super.indexPagina;
  }

  @override
  set indexPagina(int value) {
    _$indexPaginaAtom.reportWrite(value, super.indexPagina, () {
      super.indexPagina = value;
    });
  }

  late final _$pesquisaFeitaAtom =
      Atom(name: 'FiltrosCarrregadosBase.pesquisaFeita', context: context);

  @override
  bool get pesquisaFeita {
    _$pesquisaFeitaAtom.reportRead();
    return super.pesquisaFeita;
  }

  @override
  set pesquisaFeita(bool value) {
    _$pesquisaFeitaAtom.reportWrite(value, super.pesquisaFeita, () {
      super.pesquisaFeita = value;
    });
  }

  late final _$listaFiltrosAtom =
      Atom(name: 'FiltrosCarrregadosBase.listaFiltros', context: context);

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

  late final _$valorSelecionadoParaDropDownAtom = Atom(
      name: 'FiltrosCarrregadosBase.valorSelecionadoParaDropDown',
      context: context);

  @override
  FiltrosModel? get valorSelecionadoParaDropDown {
    _$valorSelecionadoParaDropDownAtom.reportRead();
    return super.valorSelecionadoParaDropDown;
  }

  @override
  set valorSelecionadoParaDropDown(FiltrosModel? value) {
    _$valorSelecionadoParaDropDownAtom
        .reportWrite(value, super.valorSelecionadoParaDropDown, () {
      super.valorSelecionadoParaDropDown = value;
    });
  }

  late final _$tipoFiltroAtom =
      Atom(name: 'FiltrosCarrregadosBase.tipoFiltro', context: context);

  @override
  String get tipoFiltro {
    _$tipoFiltroAtom.reportRead();
    return super.tipoFiltro;
  }

  @override
  set tipoFiltro(String value) {
    _$tipoFiltroAtom.reportWrite(value, super.tipoFiltro, () {
      super.tipoFiltro = value;
    });
  }

  @override
  String toString() {
    return '''
indexFiltros: ${indexFiltros},
indexPagina: ${indexPagina},
pesquisaFeita: ${pesquisaFeita},
listaFiltros: ${listaFiltros},
valorSelecionadoParaDropDown: ${valorSelecionadoParaDropDown},
tipoFiltro: ${tipoFiltro}
    ''';
  }
}
