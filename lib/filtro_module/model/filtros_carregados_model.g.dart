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

  bool _indexFiltrosIsInitialized = false;

  @override
  set indexFiltros(int value) {
    _$indexFiltrosAtom.reportWrite(
        value, _indexFiltrosIsInitialized ? super.indexFiltros : null, () {
      super.indexFiltros = value;
      _indexFiltrosIsInitialized = true;
    });
  }

  late final _$indexPaginaAtom =
      Atom(name: 'FiltrosCarrregadosBase.indexPagina', context: context);

  @override
  int get indexPagina {
    _$indexPaginaAtom.reportRead();
    return super.indexPagina;
  }

  bool _indexPaginaIsInitialized = false;

  @override
  set indexPagina(int value) {
    _$indexPaginaAtom.reportWrite(
        value, _indexPaginaIsInitialized ? super.indexPagina : null, () {
      super.indexPagina = value;
      _indexPaginaIsInitialized = true;
    });
  }

  late final _$pesquisaFeitaAtom =
      Atom(name: 'FiltrosCarrregadosBase.pesquisaFeita', context: context);

  @override
  bool get pesquisaFeita {
    _$pesquisaFeitaAtom.reportRead();
    return super.pesquisaFeita;
  }

  bool _pesquisaFeitaIsInitialized = false;

  @override
  set pesquisaFeita(bool value) {
    _$pesquisaFeitaAtom.reportWrite(
        value, _pesquisaFeitaIsInitialized ? super.pesquisaFeita : null, () {
      super.pesquisaFeita = value;
      _pesquisaFeitaIsInitialized = true;
    });
  }

  late final _$tipoFiltroAtom =
      Atom(name: 'FiltrosCarrregadosBase.tipoFiltro', context: context);

  @override
  String get tipoFiltro {
    _$tipoFiltroAtom.reportRead();
    return super.tipoFiltro;
  }

  bool _tipoFiltroIsInitialized = false;

  @override
  set tipoFiltro(String value) {
    _$tipoFiltroAtom.reportWrite(
        value, _tipoFiltroIsInitialized ? super.tipoFiltro : null, () {
      super.tipoFiltro = value;
      _tipoFiltroIsInitialized = true;
    });
  }

  late final _$tipoWidgetAtom =
      Atom(name: 'FiltrosCarrregadosBase.tipoWidget', context: context);

  @override
  String get tipoWidget {
    _$tipoWidgetAtom.reportRead();
    return super.tipoWidget;
  }

  bool _tipoWidgetIsInitialized = false;

  @override
  set tipoWidget(String value) {
    _$tipoWidgetAtom.reportWrite(
        value, _tipoWidgetIsInitialized ? super.tipoWidget : null, () {
      super.tipoWidget = value;
      _tipoWidgetIsInitialized = true;
    });
  }

  late final _$listaFiltrosAtom =
      Atom(name: 'FiltrosCarrregadosBase.listaFiltros', context: context);

  @override
  List<FiltrosModel> get listaFiltros {
    _$listaFiltrosAtom.reportRead();
    return super.listaFiltros;
  }

  bool _listaFiltrosIsInitialized = false;

  @override
  set listaFiltros(List<FiltrosModel> value) {
    _$listaFiltrosAtom.reportWrite(
        value, _listaFiltrosIsInitialized ? super.listaFiltros : null, () {
      super.listaFiltros = value;
      _listaFiltrosIsInitialized = true;
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

  @override
  String toString() {
    return '''
indexFiltros: ${indexFiltros},
indexPagina: ${indexPagina},
pesquisaFeita: ${pesquisaFeita},
tipoFiltro: ${tipoFiltro},
tipoWidget: ${tipoWidget},
listaFiltros: ${listaFiltros},
valorSelecionadoParaDropDown: ${valorSelecionadoParaDropDown}
    ''';
  }
}
