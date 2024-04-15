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
  Computed<bool>? _$verificaSeTodosEstaoSelecionadosComputed;

  @override
  bool get verificaSeTodosEstaoSelecionados =>
      (_$verificaSeTodosEstaoSelecionadosComputed ??= Computed<bool>(
              () => super.verificaSeTodosEstaoSelecionados,
              name: 'FiltroControllerBase.verificaSeTodosEstaoSelecionados'))
          .value;
  Computed<List<FiltrosModel>>? _$getListFiltrosComputedComputed;

  @override
  List<FiltrosModel> get getListFiltrosComputed =>
      (_$getListFiltrosComputedComputed ??= Computed<List<FiltrosModel>>(
              () => super.getListFiltrosComputed,
              name: 'FiltroControllerBase.getListFiltrosComputed'))
          .value;

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
  Map<String, dynamic> get filtrosSalvosParaAdicionarNoBody {
    _$filtrosSalvosParaAdicionarNoBodyAtom.reportRead();
    return super.filtrosSalvosParaAdicionarNoBody;
  }

  @override
  set filtrosSalvosParaAdicionarNoBody(Map<String, dynamic> value) {
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

  late final _$valorSelecionadoDropDownAtom = Atom(
      name: 'FiltroControllerBase.valorSelecionadoDropDown', context: context);

  @override
  String get valorSelecionadoDropDown {
    _$valorSelecionadoDropDownAtom.reportRead();
    return super.valorSelecionadoDropDown;
  }

  @override
  set valorSelecionadoDropDown(String value) {
    _$valorSelecionadoDropDownAtom
        .reportWrite(value, super.valorSelecionadoDropDown, () {
      super.valorSelecionadoDropDown = value;
    });
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
  void conjuntoDePeriodos() {
    final _$actionInfo = _$FiltroControllerBaseActionController.startAction(
        name: 'FiltroControllerBase.conjuntoDePeriodos');
    try {
      return super.conjuntoDePeriodos();
    } finally {
      _$FiltroControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Map<String, dynamic> selecaoDeDataPorPeriodo({required String periodo}) {
    final _$actionInfo = _$FiltroControllerBaseActionController.startAction(
        name: 'FiltroControllerBase.selecaoDeDataPorPeriodo');
    try {
      return super.selecaoDeDataPorPeriodo(periodo: periodo);
    } finally {
      _$FiltroControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listaFiltros: ${listaFiltros},
listaFiltrosParaConstruirTela: ${listaFiltrosParaConstruirTela},
loadingItensFiltros: ${loadingItensFiltros},
indexFiltro: ${indexFiltro},
dtinicio: ${dtinicio},
dtfim: ${dtfim},
filtrosSalvosParaAdicionarNoBody: ${filtrosSalvosParaAdicionarNoBody},
exibirBarraPesquisa: ${exibirBarraPesquisa},
pesquisaItensDoFiltro: ${pesquisaItensDoFiltro},
isDataFaturamento: ${isDataFaturamento},
valorSelecionadoDropDown: ${valorSelecionadoDropDown},
getQtdeItensSelecionados: ${getQtdeItensSelecionados},
verificaSeTodosEstaoSelecionados: ${verificaSeTodosEstaoSelecionados},
getListFiltrosComputed: ${getListFiltrosComputed}
    ''';
  }
}
