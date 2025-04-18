// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtro_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FiltroController on FiltroControllerBase, Store {
  Computed<int>? _$getQtdeItensSelecionadosComputed;

  @override
  int get getQtdeItensSelecionados => (_$getQtdeItensSelecionadosComputed ??=
          Computed<int>(() => super.getQtdeItensSelecionados,
              name: 'FiltroControllerBase.getQtdeItensSelecionados'))
      .value;
  Computed<List<FiltrosModel>>? _$getListFiltrosComputedComputed;

  @override
  List<FiltrosModel> get getListFiltrosComputed =>
      (_$getListFiltrosComputedComputed ??= Computed<List<FiltrosModel>>(
              () => super.getListFiltrosComputed,
              name: 'FiltroControllerBase.getListFiltrosComputed'))
          .value;
  Computed<bool>? _$verificaSeTodosEstaoSelecionadosComputed;

  @override
  bool get verificaSeTodosEstaoSelecionados =>
      (_$verificaSeTodosEstaoSelecionadosComputed ??= Computed<bool>(
              () => super.verificaSeTodosEstaoSelecionados,
              name: 'FiltroControllerBase.verificaSeTodosEstaoSelecionados'))
          .value;

  late final _$listaFiltrosCarregadosAtom = Atom(
      name: 'FiltroControllerBase.listaFiltrosCarregados', context: context);

  @override
  ObservableList<FiltrosCarrregados> get listaFiltrosCarregados {
    _$listaFiltrosCarregadosAtom.reportRead();
    return super.listaFiltrosCarregados;
  }

  @override
  set listaFiltrosCarregados(ObservableList<FiltrosCarrregados> value) {
    _$listaFiltrosCarregadosAtom
        .reportWrite(value, super.listaFiltrosCarregados, () {
      super.listaFiltrosCarregados = value;
    });
  }

  late final _$listaFiltrosParaConstruirTelaAtom = Atom(
      name: 'FiltroControllerBase.listaFiltrosParaConstruirTela',
      context: context);

  @override
  ObservableList<FiltrosPageAtual> get listaFiltrosParaConstruirTela {
    _$listaFiltrosParaConstruirTelaAtom.reportRead();
    return super.listaFiltrosParaConstruirTela;
  }

  @override
  set listaFiltrosParaConstruirTela(ObservableList<FiltrosPageAtual> value) {
    _$listaFiltrosParaConstruirTelaAtom
        .reportWrite(value, super.listaFiltrosParaConstruirTela, () {
      super.listaFiltrosParaConstruirTela = value;
    });
  }

  late final _$loadingItensFiltrosAtom =
      Atom(name: 'FiltroControllerBase.loadingItensFiltros', context: context);

  @override
  bool get loadingItensFiltros {
    _$loadingItensFiltrosAtom.reportRead();
    return super.loadingItensFiltros;
  }

  @override
  set loadingItensFiltros(bool value) {
    _$loadingItensFiltrosAtom.reportWrite(value, super.loadingItensFiltros, () {
      super.loadingItensFiltros = value;
    });
  }

  late final _$indexFiltroAtom =
      Atom(name: 'FiltroControllerBase.indexFiltro', context: context);

  @override
  int get indexFiltro {
    _$indexFiltroAtom.reportRead();
    return super.indexFiltro;
  }

  @override
  set indexFiltro(int value) {
    _$indexFiltroAtom.reportWrite(value, super.indexFiltro, () {
      super.indexFiltro = value;
    });
  }

  late final _$mapaDatasNomeadasAtom =
      Atom(name: 'FiltroControllerBase.mapaDatasNomeadas', context: context);

  @override
  ObservableMap<String, dynamic> get mapaDatasNomeadas {
    _$mapaDatasNomeadasAtom.reportRead();
    return super.mapaDatasNomeadas;
  }

  @override
  set mapaDatasNomeadas(ObservableMap<String, dynamic> value) {
    _$mapaDatasNomeadasAtom.reportWrite(value, super.mapaDatasNomeadas, () {
      super.mapaDatasNomeadas = value;
    });
  }

  late final _$dtinicioAtom =
      Atom(name: 'FiltroControllerBase.dtinicio', context: context);

  @override
  String get dtinicio {
    _$dtinicioAtom.reportRead();
    return super.dtinicio;
  }

  @override
  set dtinicio(String value) {
    _$dtinicioAtom.reportWrite(value, super.dtinicio, () {
      super.dtinicio = value;
    });
  }

  late final _$dtfimAtom =
      Atom(name: 'FiltroControllerBase.dtfim', context: context);

  @override
  String get dtfim {
    _$dtfimAtom.reportRead();
    return super.dtfim;
  }

  @override
  set dtfim(String value) {
    _$dtfimAtom.reportWrite(value, super.dtfim, () {
      super.dtfim = value;
    });
  }

  late final _$filtrosSalvosParaAdicionarNoBodyAtom = Atom(
      name: 'FiltroControllerBase.filtrosSalvosParaAdicionarNoBody',
      context: context);

  @override
  ObservableMap<String, dynamic> get filtrosSalvosParaAdicionarNoBody {
    _$filtrosSalvosParaAdicionarNoBodyAtom.reportRead();
    return super.filtrosSalvosParaAdicionarNoBody;
  }

  @override
  set filtrosSalvosParaAdicionarNoBody(ObservableMap<String, dynamic> value) {
    _$filtrosSalvosParaAdicionarNoBodyAtom
        .reportWrite(value, super.filtrosSalvosParaAdicionarNoBody, () {
      super.filtrosSalvosParaAdicionarNoBody = value;
    });
  }

  late final _$exibirBarraPesquisaAtom =
      Atom(name: 'FiltroControllerBase.exibirBarraPesquisa', context: context);

  @override
  bool get exibirBarraPesquisa {
    _$exibirBarraPesquisaAtom.reportRead();
    return super.exibirBarraPesquisa;
  }

  @override
  set exibirBarraPesquisa(bool value) {
    _$exibirBarraPesquisaAtom.reportWrite(value, super.exibirBarraPesquisa, () {
      super.exibirBarraPesquisa = value;
    });
  }

  late final _$pesquisaItensDoFiltroAtom = Atom(
      name: 'FiltroControllerBase.pesquisaItensDoFiltro', context: context);

  @override
  String get pesquisaItensDoFiltro {
    _$pesquisaItensDoFiltroAtom.reportRead();
    return super.pesquisaItensDoFiltro;
  }

  @override
  set pesquisaItensDoFiltro(String value) {
    _$pesquisaItensDoFiltroAtom.reportWrite(value, super.pesquisaItensDoFiltro,
        () {
      super.pesquisaItensDoFiltro = value;
    });
  }

  late final _$isDataFaturamentoAtom =
      Atom(name: 'FiltroControllerBase.isDataFaturamento', context: context);

  @override
  bool get isDataFaturamento {
    _$isDataFaturamentoAtom.reportRead();
    return super.isDataFaturamento;
  }

  @override
  set isDataFaturamento(bool value) {
    _$isDataFaturamentoAtom.reportWrite(value, super.isDataFaturamento, () {
      super.isDataFaturamento = value;
    });
  }

  late final _$isRCAsemVendaAtom =
      Atom(name: 'FiltroControllerBase.isRCAsemVenda', context: context);

  @override
  bool get isRCAsemVenda {
    _$isRCAsemVendaAtom.reportRead();
    return super.isRCAsemVenda;
  }

  @override
  set isRCAsemVenda(bool value) {
    _$isRCAsemVendaAtom.reportWrite(value, super.isRCAsemVenda, () {
      super.isRCAsemVenda = value;
    });
  }

  late final _$isRCAativoAtom =
      Atom(name: 'FiltroControllerBase.isRCAativo', context: context);

  @override
  bool get isRCAativo {
    _$isRCAativoAtom.reportRead();
    return super.isRCAativo;
  }

  @override
  set isRCAativo(bool value) {
    _$isRCAativoAtom.reportWrite(value, super.isRCAativo, () {
      super.isRCAativo = value;
    });
  }

  late final _$validarListaParaDropDownAtom = Atom(
      name: 'FiltroControllerBase.validarListaParaDropDown', context: context);

  @override
  bool get validarListaParaDropDown {
    _$validarListaParaDropDownAtom.reportRead();
    return super.validarListaParaDropDown;
  }

  @override
  set validarListaParaDropDown(bool value) {
    _$validarListaParaDropDownAtom
        .reportWrite(value, super.validarListaParaDropDown, () {
      super.validarListaParaDropDown = value;
    });
  }

  late final _$novoIndexFiltroAtom =
      Atom(name: 'FiltroControllerBase.novoIndexFiltro', context: context);

  @override
  int get novoIndexFiltro {
    _$novoIndexFiltroAtom.reportRead();
    return super.novoIndexFiltro;
  }

  @override
  set novoIndexFiltro(int value) {
    _$novoIndexFiltroAtom.reportWrite(value, super.novoIndexFiltro, () {
      super.novoIndexFiltro = value;
    });
  }

  late final _$valoresSelecionadorDropDownAtom = Atom(
      name: 'FiltroControllerBase.valoresSelecionadorDropDown',
      context: context);

  @override
  ObservableMap<int, FiltrosModel> get valoresSelecionadorDropDown {
    _$valoresSelecionadorDropDownAtom.reportRead();
    return super.valoresSelecionadorDropDown;
  }

  @override
  set valoresSelecionadorDropDown(ObservableMap<int, FiltrosModel> value) {
    _$valoresSelecionadorDropDownAtom
        .reportWrite(value, super.valoresSelecionadorDropDown, () {
      super.valoresSelecionadorDropDown = value;
    });
  }

  late final _$erroBuscarItensFiltroAtom = Atom(
      name: 'FiltroControllerBase.erroBuscarItensFiltro', context: context);

  @override
  bool get erroBuscarItensFiltro {
    _$erroBuscarItensFiltroAtom.reportRead();
    return super.erroBuscarItensFiltro;
  }

  @override
  set erroBuscarItensFiltro(bool value) {
    _$erroBuscarItensFiltroAtom.reportWrite(value, super.erroBuscarItensFiltro,
        () {
      super.erroBuscarItensFiltro = value;
    });
  }

  late final _$dataCampanhaInicialAtom =
      Atom(name: 'FiltroControllerBase.dataCampanhaInicial', context: context);

  @override
  String get dataCampanhaInicial {
    _$dataCampanhaInicialAtom.reportRead();
    return super.dataCampanhaInicial;
  }

  @override
  set dataCampanhaInicial(String value) {
    _$dataCampanhaInicialAtom.reportWrite(value, super.dataCampanhaInicial, () {
      super.dataCampanhaInicial = value;
    });
  }

  late final _$loadingMoreDataAtom =
      Atom(name: 'FiltroControllerBase.loadingMoreData', context: context);

  @override
  bool get loadingMoreData {
    _$loadingMoreDataAtom.reportRead();
    return super.loadingMoreData;
  }

  @override
  set loadingMoreData(bool value) {
    _$loadingMoreDataAtom.reportWrite(value, super.loadingMoreData, () {
      super.loadingMoreData = value;
    });
  }

  late final _$conjuntoDePeriodosAsyncAction =
      AsyncAction('FiltroControllerBase.conjuntoDePeriodos', context: context);

  @override
  Future<void> conjuntoDePeriodos() {
    return _$conjuntoDePeriodosAsyncAction
        .run(() => super.conjuntoDePeriodos());
  }

  late final _$FiltroControllerBaseActionController =
      ActionController(name: 'FiltroControllerBase', context: context);

  @override
  void adicionarItensSelecionado({required FiltrosModel itens}) {
    final _$actionInfo = _$FiltroControllerBaseActionController.startAction(
        name: 'FiltroControllerBase.adicionarItensSelecionado');
    try {
      return super.adicionarItensSelecionado(itens: itens);
    } finally {
      _$FiltroControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void limparSelecao() {
    final _$actionInfo = _$FiltroControllerBaseActionController.startAction(
        name: 'FiltroControllerBase.limparSelecao');
    try {
      return super.limparSelecao();
    } finally {
      _$FiltroControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selecionarTodos() {
    final _$actionInfo = _$FiltroControllerBaseActionController.startAction(
        name: 'FiltroControllerBase.selecionarTodos');
    try {
      return super.selecionarTodos();
    } finally {
      _$FiltroControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void inverterSelecao() {
    final _$actionInfo = _$FiltroControllerBaseActionController.startAction(
        name: 'FiltroControllerBase.inverterSelecao');
    try {
      return super.inverterSelecao();
    } finally {
      _$FiltroControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Map<String, dynamic> selecaoDeDataPorPeriodo(
      {required String periodo, required bool isDataPadrao}) {
    final _$actionInfo = _$FiltroControllerBaseActionController.startAction(
        name: 'FiltroControllerBase.selecaoDeDataPorPeriodo');
    try {
      return super.selecaoDeDataPorPeriodo(
          periodo: periodo, isDataPadrao: isDataPadrao);
    } finally {
      _$FiltroControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void adicionarItensDropDown(
      {required int index, required FiltrosModel valorSelecionado}) {
    final _$actionInfo = _$FiltroControllerBaseActionController.startAction(
        name: 'FiltroControllerBase.adicionarItensDropDown');
    try {
      return super.adicionarItensDropDown(
          index: index, valorSelecionado: valorSelecionado);
    } finally {
      _$FiltroControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listaFiltrosCarregados: ${listaFiltrosCarregados},
listaFiltrosParaConstruirTela: ${listaFiltrosParaConstruirTela},
loadingItensFiltros: ${loadingItensFiltros},
indexFiltro: ${indexFiltro},
mapaDatasNomeadas: ${mapaDatasNomeadas},
dtinicio: ${dtinicio},
dtfim: ${dtfim},
filtrosSalvosParaAdicionarNoBody: ${filtrosSalvosParaAdicionarNoBody},
exibirBarraPesquisa: ${exibirBarraPesquisa},
pesquisaItensDoFiltro: ${pesquisaItensDoFiltro},
isDataFaturamento: ${isDataFaturamento},
isRCAsemVenda: ${isRCAsemVenda},
isRCAativo: ${isRCAativo},
validarListaParaDropDown: ${validarListaParaDropDown},
novoIndexFiltro: ${novoIndexFiltro},
valoresSelecionadorDropDown: ${valoresSelecionadorDropDown},
erroBuscarItensFiltro: ${erroBuscarItensFiltro},
dataCampanhaInicial: ${dataCampanhaInicial},
loadingMoreData: ${loadingMoreData},
getQtdeItensSelecionados: ${getQtdeItensSelecionados},
getListFiltrosComputed: ${getListFiltrosComputed},
verificaSeTodosEstaoSelecionados: ${verificaSeTodosEstaoSelecionados}
    ''';
  }
}
