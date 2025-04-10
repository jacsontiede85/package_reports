// ignore_for_file: curly_braces_in_flow_control_structures, must_be_immutable
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';
import 'package:package_reports/filtro_module/page/filtros_page.dart';
import 'package:package_reports/global/core/layout_controller.dart';
import 'package:package_reports/global/widget/pdf_page.dart';
import 'package:package_reports/report_module/controller/report_from_json_controller.dart';
import 'package:package_reports/report_module/controller/report_to_pdf.dart';
import 'package:package_reports/report_module/controller/report_to_xlsx_controller.dart';
import 'package:package_reports/global/core/features.dart';
import 'package:package_reports/report_module/page/report_chart_page.dart';
import 'package:package_reports/global/widget/widgets.dart';

class ReportPage extends StatefulWidget {
  Map<String, dynamic> mapSelectedRow = {};
  Map<String, dynamic> bodyConfigBuscaRecursiva = {};
  Map<String, dynamic> getbodyPrimario = {};
  bool buscarDadosNaEntrada = false;
  late String database;
  Map<String, dynamic>? conteudoParaModificarBodyInicial;
  final String function;

  ReportPage({
    super.key,
    required this.function,
    required this.buscarDadosNaEntrada,
    required this.database,
    this.conteudoParaModificarBodyInicial,
  });

  setMapSelectedRowPage({
    required Map<String, dynamic> mapSelectedRow,
    required Map<String, dynamic> bodyConfigBuscaRecursiva,
    required Map<String, dynamic> getbodyPrimario,
  }) {
    this.mapSelectedRow = mapSelectedRow;
    this.bodyConfigBuscaRecursiva = bodyConfigBuscaRecursiva;
    this.getbodyPrimario = getbodyPrimario;
  }

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with Rows {
  double _width = 0.0;

  LayoutControllerPackage layout = LayoutControllerPackage();
  Widgets wp = Widgets();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  late ReportFromJSONController controller = ReportFromJSONController(
    nomeFunction: widget.function,
    sizeWidth: _width,
    isToGetDadosNaEntrada: widget.buscarDadosNaEntrada,
    database: widget.database,
    modificarbodyPrimario: widget.conteudoParaModificarBodyInicial,
  );

  late FiltroController controllerFiltro = FiltroController(
    mapaFiltrosWidget: (controller.configPagina['filtros']?.isEmpty ?? true) ? {} : controller.configPagina['filtros'],
    indexPagina: controller.configPagina['indexPage'],
    controllerReports: controller,
  );

  setStatee(Function fn) {
    setState(() {
      fn();
    });
  }

  @override
  void initState() {
    super.initState();
    if (controller.configPagina.isEmpty)
      controller.getConfig().whenComplete(
        () {
          bool buscarDados = controller.configPagina['buscarDadosEntrada'] ?? false;
          if(buscarDados){
            controllerFiltro.criarNovoBody();
            controller.getDados();
          }else{
            if (!widget.buscarDadosNaEntrada && controller.configPagina.isNotEmpty &&(controller.configPagina['filtros']?.isNotEmpty ?? false)) {
              controller.loading = false;
              scaffoldKey.currentState!.openEndDrawer();
            }            
          }
        },
      );

    if (widget.mapSelectedRow.isNotEmpty) {
      controller.setMapSelectedRowController(
        mapSelectedRow: widget.mapSelectedRow,
        configPageBuscaRecursiva: widget.bodyConfigBuscaRecursiva,
        bodySecundario: widget.getbodyPrimario,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.horizontalScroll.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    controller.sizeWidth = _width;

    return PopScope(
      onPopInvokedWithResult: (value,_) => controller.willPopCallback,
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          surfaceTintColor: Colors.transparent,
          title: Observer(
            builder: (_) => ListTile(
              isThreeLine: true,
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: SelectableText(
                controller.configPagina['name'] ?? "",
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              subtitle: Visibility(
                visible: controller.configPagina['page'] != null && controller.configPagina['page'].isNotEmpty,
                child: SelectableText(
                  "Relatório com linhas interativas. Clique duas vezes na linha para mais detalhes.Prox rel. ${controller.configPagina['page']?['name']}",
                  style: const TextStyle(
                    color: Colors.lime,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w500,
                    fontSize: 10
                  ),
                )
              ),
            ),
          ),
          leadingWidth: 20,
          leading: IconButton(
            tooltip: 'Voltar',
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
            ),color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(controller.mostrarBarraPesquisar && controller.configPagina.isNotEmpty && !controller.loading && controller.dados.isNotEmpty ? kToolbarHeight : 0),
            child: Observer(
              builder: (_) => Visibility(
                visible: controller.mostrarBarraPesquisar && controller.configPagina.isNotEmpty && !controller.loading && controller.dados.isNotEmpty,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    height: controller.mostrarBarraPesquisar ? 40 : 0,
                    margin: const EdgeInsets.all(15),
                    child: SearchBar(
                      controller: controller.searchString,
                      hintText: 'Pesquisar',
                      elevation: const WidgetStatePropertyAll(10),
                      backgroundColor: const WidgetStatePropertyAll(
                        Color.fromARGB(117, 124, 120, 120),
                      ),
                      textStyle: const WidgetStatePropertyAll(
                        TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      leading: Visibility(
                        visible: controller.mostrarBarraPesquisar,
                        child: IconButton(
                          onPressed: () {
                            controller.mostrarBarraPesquisar = !controller.mostrarBarraPesquisar;
                            if(!controller.mostrarBarraPesquisar){
                              controller.clearFiltros();
                            }
                            setState(() {});
                          },
                          icon: Icon(
                            controller.mostrarBarraPesquisar ? Icons.search_off : Icons.search,
                            color:Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        controller.filterListFromSearch();
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            Observer(
              builder: (_) => Visibility(
                visible: (controller.dadosFiltered().isNotEmpty && !controller.loading),
                child: PopupMenuButton(
                  tooltip: 'Opções',
                  position: PopupMenuPosition.under,
                  iconColor: Colors.white,
                  color: Colors.black87,
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.search, color: Colors.white,),
                            ),
                            Text(
                              "Pesquisar",
                              style: TextStyle(
                                color: Colors.white,
                              ),                              
                            ),
                          ],
                        ),
                        onTap: () {
                          controller.mostrarBarraPesquisar = !controller.mostrarBarraPesquisar;
                          if(!controller.mostrarBarraPesquisar){
                            controller.clearFiltros();
                          }
                          setState(() {});
                        },
                      ),

                      if( !controller.loading && controller.dados.isNotEmpty && (controller.configPagina['graficosDisponiveis'] != null && controller.configPagina['graficosDisponiveis'].isNotEmpty))
                      PopupMenuItem(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.bar_chart, color: Colors.white,),
                            ),
                            Text(
                              "Graficos",
                              style: TextStyle(
                                color: Colors.white,
                              ),                              
                            ),
                          ],
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChartsReport(
                                reportFromJSONController: controller,
                                title: controller.configPagina['name'],
                              ),
                            ),
                          );
                        },
                      ),

                      PopupMenuItem(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.analytics, color: Colors.white,),
                            ),
                            Text(
                              "Excel",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => exibirSelecaoDeColunasParaExporta(
                              onPressedTudo: () {
                                ReportToXLSXController(title: controller.configPagina['name'], reportFromJSONController: controller, filtraTudo: true);
                                Navigator.pop(context);
                              },
                              onPressedFiltrado: () {
                                ReportToXLSXController(title: controller.configPagina['name'], reportFromJSONController: controller, filtraTudo: false);
                                Navigator.pop(context);
                              },
                              titulo: 'Exportar para Excel',
                            ),
                          );
                        },
                      ),

                      PopupMenuItem(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(Icons.paste, color: Colors.white,),
                            ),
                            Text(
                              "PDF",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {

                          showDialog(
                            context: context, 
                            builder: (context) => exibirSelecaoDeColunasParaExporta(
                              onPressedFiltrado: (){
                                ReportPDFController controllerPDF = ReportPDFController(
                                  titulo: controller.configPagina['name'],
                                  reportController: controller,
                                  filtraTudo: false,
                                );
                                controllerPDF.getDados(controller: controller, titulo: controller.configPagina['name']);
                                showDialog(
                                  context: context,
                                  builder: (context) => PrintingPDFPage(controller: controllerPDF),
                                );                      
                              },
                              onPressedTudo: () {
                                ReportPDFController controllerPDF = ReportPDFController(
                                  titulo: controller.configPagina['name'],
                                  reportController: controller,
                                  filtraTudo: true,
                                );
                                controllerPDF.getDados(controller: controller, titulo: controller.configPagina['name']);
                                showDialog(
                                  context: context,
                                  builder: (context) => PrintingPDFPage(controller: controllerPDF),
                                );                                    
                              },
                              titulo: 'Selecione as colunas para exportar para PDF'
                            ),
                          );
                        },
                      ),
                    ];
                  },
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Observer(
                builder: (_) => Visibility(
                  visible: (controller.configPagina.isNotEmpty && !controller.loading && (controller.configPagina['filtros']?.isNotEmpty ?? false)),
                  replacement: Visibility(
                    visible: controller.configPagina['indexPage'] == 0 && !controller.loadingConfigFiltros && (controller.configPagina['filtros']?.isEmpty ?? true),
                    child: TextButton(
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.green),
                      ),
                      onPressed: () async {
                        await controllerFiltro.criarNovoBody();
                      },
                      child: const Text(
                        "Buscar",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.filter_alt_outlined,
                      size: 18,
                    ),
                    color: Colors.white,
                    onPressed: () {
                      scaffoldKey.currentState!.openEndDrawer();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: Visibility(
          visible: controller.filtrosSelected.isNotEmpty || controller.searchString.text.isNotEmpty,
          child: ElevatedButton.icon(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Colors.white,
              ),
            ),
            onPressed: () {
              controller.clearFiltros();
              setState(() {});
            },
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
            label: const Text(
              "Limpar Filtros",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ),
        endDrawer: Builder(
          builder: (context) {
            if (controller.configPagina.isNotEmpty) {
              if (controller.bodySecundario.isNotEmpty) {
                return Drawer(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                  ),
                  width: 500,
                  child: FiltrosReportPage(
                    controllerFiltro: controllerFiltro,
                    bodypesquisaAtual: controller.bodySecundario,
                  ),
                );
              } else {
                return Drawer(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topLeft: Radius.circular(15),
                    ),
                  ),
                  width: 500,
                  child: FiltrosReportPage(
                    controllerFiltro: controllerFiltro,
                    bodypesquisaAtual: controller.bodyPrimario,
                  ),
                );
              }
            } else {
              return const Drawer(
                child: Center(
                  child: Text(
                    "Não ha filtros para esse relatorio",
                  ),
                ),
              );
            }
          },
        ),
        body: Observer(
          builder: (_) => Visibility(
            visible: (!controller.loading || controller.dadosFiltered().isEmpty) && !controller.primeiraBusca,
            replacement: Center(
              child: Text(
                controller.configPagina['name'] != null ? "Por favor selecione algum filtro!" : "Relatório indisponível no momento",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            child: Observer(
              builder: (_) => Stack(
                children: [
                  Visibility(
                    visible: !controller.loading || controller.dadosFiltered().isNotEmpty,
                    replacement: Center(
                      child: LoadingAnimationWidget.halfTriangleDot(
                        color: const Color.fromARGB(255, 102, 78, 238),
                        size: 40,
                      ),
                    ),
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(
                        dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        },
                      ),
                      child: AdaptiveScrollbar(
                        controller: ScrollController(),
                        width: 8,
                        underColor: Colors.white.withValues(alpha: 0.1),
                        sliderSpacing: const EdgeInsets.only(
                          right: 0,
                        ),
                        sliderDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.black.withValues(alpha: 0.6),
                        ),
                        sliderActiveDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.black.withValues(alpha: 0.5),
                        ),
                        child: AdaptiveScrollbar(
                          controller: controller.horizontalScroll,
                          width: _width < 600 ? 10 : 8,
                          position: ScrollbarPosition.bottom,
                          underSpacing: const EdgeInsets.only(bottom: 15),
                          underColor: Colors.white.withValues(alpha: 0.1),
                          sliderSpacing: const EdgeInsets.only(
                            right: 0,
                          ),
                          sliderDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                          sliderActiveDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.black.withValues(alpha: 0.5),
                          ),
                          child: SingleChildScrollView(
                            controller: controller.horizontalScroll,
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              width: _width > controller.widthTable ? _width : controller.widthTable,
                              alignment: _width > controller.widthTable ? Alignment.center : Alignment.topLeft,
                              child: Stack(
                                children: [
                                  Container(
                                    width: controller.widthTable,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: controller.loading ? Colors.transparent : Colors.purple.withValues(alpha: 0.3),
                                        width: 0.1,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // TITULO DE COLUNAS
                                        Container(
                                          height: controller.getHeightColunasCabecalho,
                                          color: Colors.grey[50],
                                          child: Stack(
                                            children: [
                                              colunasWidget(),
                                              Observer(
                                                builder: (_) => Visibility(
                                                  visible: controller.positionScroll > 200 && controller.visibleColElevated,
                                                  child: Positioned(
                                                    top: 0,
                                                    left: controller.positionScroll,
                                                    child: colunasElevated(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
            
                                        if (controller.dadosFiltered().isEmpty)
                                          Text(
                                            'Não há dados para os filtros selecionados...',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: layout.desktop ? 16 : 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
            
                                        // ROWS [DADOS]
                                        if (controller.dadosFiltered().isNotEmpty) Flexible(flex: 2, child: rowsBuilder()),
            
                                        if (controller.dadosFiltered().isEmpty) const Expanded(child: SizedBox()),
            
                                        //deixar espaço para rodape
                                        if (controller.colunas.where((element) => element['type'] != String).toList().isNotEmpty)
                                          const SizedBox(
                                            height: 39,
                                          ),
                                      ],
                                    ),
                                  ),
                                  Observer(
                                    builder: (_) => Visibility(
                                      visible: controller.colunas.where((element) => element['type'] != String).toList().isNotEmpty,
                                      child: Positioned(
                                        bottom: 0,
                                        right: 0,
                                        left: 0,
                                        child: Stack(
                                          children: [
                                            rodape(),
                                            Observer(
                                              builder: (_) => Visibility(
                                                visible: controller.positionScroll > 200 && controller.visibleColElevated,
                                                child: Positioned(
                                                  top: 0,
                                                  left: controller.positionScroll,
                                                  child: rodapeElevated(),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget colunasWidget() {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.colunas.where((element) => element['type'] != String).toList().isNotEmpty)
              ...controller.colunas.map(
                (element) {
                  if(element['colunasFiltradas'] == true)
                    return InkWell(
                      onTap: () => controller.setOrderBy(key: element['key'], order: element['order']),
                      child: rowTextFormatted(
                        context: context,
                        width: controller.getWidthCol(
                          key: element['key'],
                        ),
                        height: controller.getHeightColunasCabecalho,
                        controller: controller,
                        key: element['key'],
                        type: element['type'],
                        value: Features.formatarTextoPrimeirasLetrasMaiusculas(
                          element['nomeFormatado'].trim(),
                        ),
                        isTitle: true,
                        isSelected: element['isSelected'],
                        order: element['order'],
                        setStateRows: setStatee,
                        isFiltered: element['isFiltered'],
                      ),
                    );
                  else
                    return const SizedBox();
                },
              ),
          ],
        ),
      
        Tooltip(
          message: 'Clique para exibir/ocultar colunas',
          child: InkWell(
            child: const Icon(
              Icons.more_horiz,
              size: 20,
              color: Colors.black,
            ),
            onTap: (){
              showMenu(
                context: context,
                constraints: const BoxConstraints(
                  maxHeight: 500,
                  minWidth: 1000,
                ),
                position: const RelativeRect.fromLTRB(0, 80, 0, 0), 
                elevation: 10,
                menuPadding: EdgeInsets.zero,
                items: [
                  PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: Wrap(
                      children:  controller.colunas.map((e) {
                        return Observer(
                          builder: (_) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 200,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.25
                                )
                              ),
                              child: CheckboxListTile(
                                value: e['colunasFiltradas'], 
                                onChanged: (value) {
                                  e['colunasFiltradas'] = !e['colunasFiltradas'];
                                  
                                  if(!e['colunasFiltradas']){
                                    controller.widthTable = controller.widthTable - e['widthCol'];
                                  }else{
                                    controller.widthTable = controller.widthTable + e['widthCol'];
                                  }
                                },
                                title: Center(
                                  child: Text(Features.formatarTextoPrimeirasLetrasMaiusculas(e['nomeFormatado'])),
                                ),
                              ),
                            ),
                          ),
                        );           
                      },).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),      
      ],
    );
  }

  Widget colunasElevated() {
    Map<String,dynamic> element = controller.getMapColuna(key: controller.keyFreeze);
    if(element['colunasFiltradas'] == true)
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            onTap: () => controller.setOrderBy(key: controller.keyFreeze, order: element['order']),
            child: rowTextFormatted(
              context: context,
              width: controller.getWidthCol(
                key: controller.keyFreeze,
              ),
              cor: Colors.white,
              height: controller.getHeightColunasCabecalho,
              controller: controller,
              key: controller.keyFreeze,
              type: element['type'],
              value: Features.formatarTextoPrimeirasLetrasMaiusculas(
                element['nomeFormatado'].trim(),
              ),
              isTitle: true,
              isSelected: element['isSelected'],
              order: element['order'],
              setStateRows: setStatee,
            ),
          ),
        ],
      );
    else
      return const SizedBox();
  }

  Widget rowsBuilder() {
    return ListView.builder(
      itemCount: controller.dadosFiltered().length,
      physics: const BouncingScrollPhysics(),
      controller: ScrollController(),
      itemBuilder: (BuildContext context, int index) {
        Map<String,dynamic> val = controller.dadosFiltered()[index];
        controller.row = [];
        val.forEach((key, value) {
          Type type = value.runtimeType;
          if (!key.toString().toUpperCase().contains('__INVISIBLE') && !key.toString().toUpperCase().contains('__ISRODAPE') && !key.toString().contains('isFiltered'))
            controller.row.add(
              rowTextFormatted(
                context: context,
                width: controller.getWidthCol(
                  key: key,
                ),
                height: 35,
                controller: controller,
                key: key,
                type: type,
                value: value,
                cor: controller.dadosFiltered().indexOf(val) % 2 == 0 ? Colors.grey[20] : Colors.white,
                setStateRows: setStatee,
              ),
            );
        });
        return Stack(
          children: [
            InkWell(
              onDoubleTap: controller.configPagina['page'] != null && controller.configPagina['page'].isNotEmpty
                  ? () {
                      if (controller.configPagina['page'] != null && controller.configPagina['page'].isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              if(controller.bodySecundario.isEmpty){
                                return ReportPage(
                                  database: widget.database,
                                  buscarDadosNaEntrada: true,
                                  function: controller.configPagina['urlapi'],
                                )..setMapSelectedRowPage(
                                  mapSelectedRow: val,
                                  bodyConfigBuscaRecursiva: controller.configPagina,
                                  getbodyPrimario: controller.bodyPrimario,
                                );                                
                              }else{
                                return ReportPage(
                                  database: widget.database,
                                  buscarDadosNaEntrada: true,
                                  function: controller.configPagina['urlapi'],
                                )..setMapSelectedRowPage(
                                  mapSelectedRow: val,
                                  bodyConfigBuscaRecursiva: controller.configPagina,
                                  getbodyPrimario: controller.bodySecundario,
                                );
                              }
    
                            },
                          ),
                        );
                      }
                    }
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.row,
              ),
            ),
            Observer(
              builder: (_) => Visibility(
                visible: controller.positionScroll > 200 && controller.visibleColElevated,
                child: Positioned(
                  top: 0,
                  left: controller.positionScroll,
                  child: rowTextFormatted(
                    context: context,
                    width: controller.getWidthCol(
                      key: controller.keyFreeze,
                    ),
                    height: 35,
                    controller: controller,
                    key: controller.keyFreeze,
                    type: String,
                    value: val[controller.keyFreeze],
                    cor: index % 2 == 0 ? Colors.grey[20] : Colors.white,
                    setStateRows: setStatee,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget rodape() {
    return Container(
      decoration: const BoxDecoration(color: Colors.black38, border: Border(top: BorderSide(color: Colors.blue, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (controller.colunas.isNotEmpty && controller.colunasRodapePerson.isEmpty)
            ...controller.colunas.map(
              (element) {
                if(element['colunasFiltradas'] == true)
                  return rowTextFormatted(
                    context: context,
                    width: controller.getWidthCol(
                      key: element['key'],
                    ),
                    height: 40,
                    controller: controller,
                    key: element['key'],
                    type: element['key'].toString().toUpperCase().contains('__DONTSUM') ? String : element['type'],
                    value: controller.valoresRodape(element: element),
                    element: element,
                    isSelected: element['isSelected'],
                    isRodape: true,
                    order: element['order'],
                    setStateRows: setStatee,
                  );
                else
                  return const SizedBox();
              },
            )
          else
            ...controller.colunasRodapePerson.map((element) {
              for (var value in controller.dadosFiltered()) {
                if (element['key'].toString().toUpperCase().contains('__ISRODAPE') && element['colunasFiltradas'] == true) {
                  return rowTextComLable(
                    width: controller.widthTable / controller.colunasRodapePerson.where((element) => element['key'].toString().toUpperCase().contains('__ISRODAPE')).length,
                    height: 40,
                    controller: controller,
                    key: Features.formatarTextoPrimeirasLetrasMaiusculas(element['nomeFormatado']),
                    type: element['type'],
                    value: value[element['key']],
                  );
                }
              }
              return const SizedBox();
            }),
        ],
      ),
    );
  }

  Widget rodapeElevated() {
    var element = controller.getMapColuna(key: controller.keyFreeze);
    if(element['colunasFiltradas'] == true)
      return rowTextFormatted(
        context: context,
        width: controller.getWidthCol(
          key: controller.keyFreeze,
        ),
        height: 40,
        cor: const Color.fromARGB(255, 65, 63, 63),
        controller: controller,
        key: controller.keyFreeze,
        type: controller.keyFreeze.toString().toUpperCase().contains('__DONTSUM') ? String : element['type'],
        value: '${controller.dadosFiltered().length}',
        isSelected: element['isSelected'],
        isRodape: true,
        order: element['order'],
        setStateRows: setStatee,
      );
    else
      return const SizedBox();
  }

  Widget exibirSelecaoDeColunasParaExporta({required void Function()? onPressedFiltrado, required void Function()? onPressedTudo, required String titulo}) {
    return AlertDialog(
      elevation: 0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Observer(
              builder: (_) => TextButton(
                onPressed: (){
                  if(controller.colunas.every((element) => element['selecionado'] == true,)){
                    for(Map<String,dynamic> valor in controller.colunas){
                      valor['selecionado'] = false;
                    }
                  }
                  else{
                    for(Map<String,dynamic> valor in controller.colunas){
                      valor['selecionado'] = true;
                    }
                  }
                }, 
                child: Text(controller.colunas.every((element) => element['selecionado'] == true,) ? 'Desmarcar todas' : 'Marcar todos'),
              ),
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Observer(
          builder: (_) => Visibility(
            visible: controller.colunasFiltradas.isNotEmpty,
            child: TextButton.icon(
              onPressed: onPressedFiltrado,
              icon: Icon(
                Icons.downloading_sharp,
                color: Colors.blue[500],
              ),
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.teal,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                overlayColor: const WidgetStatePropertyAll(
                  Color.fromARGB(106, 133, 138, 141),
                ),
              ),
              label: Text(
                "Linhas filtradas",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blue[500],
                ),
              ),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onPressedTudo,
          icon: Icon(
            Icons.downloading_sharp,
              color: Colors.green[500],
          ),
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.teal,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            overlayColor: const WidgetStatePropertyAll(
              Color.fromARGB(106, 133, 138, 141),
            ),
          ),
          label: Text(
            "Exportar tudo",
            style: TextStyle(
              fontSize: 15,
              color: Colors.green[500],
            ),
          ),
        ),
      ],
      content: SizedBox(
        width: 300,
        height: 500,
        child: ListView.builder(
          itemCount: controller.colunas.length,
          itemBuilder: (context, index) {
            return Observer(
              builder: (_) => Card(
                child: CheckboxListTile(
                  value: controller.colunas[index]['selecionado'],
                  onChanged: (value) {
                    setState(() {
                      controller.colunas[index]['selecionado'] = !controller.colunas[index]['selecionado'];
                    });
                  },
                  title: Text(
                    Features.formatarTextoPrimeirasLetrasMaiusculas(
                      controller.colunas[index].entries.first.value.toString().split('__')[0].replaceAll('_', ' '),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

mixin Rows {
  rowTextFormatted({
    required ReportFromJSONController controller,
    required double width,
    required String key,
    required Type type,
    required dynamic value,
    required Function setStateRows,
    required BuildContext context,
    bool isTitle = false,
    bool isRodape = false,
    bool isSelected = false,
    bool isFiltered = false,
    Map<String,dynamic>? element,
    String order = 'asc',
    Color? cor,
    double? height,
  }) {
    double fontSize = 12;
    return GestureDetector(
      onLongPressStart: !isRodape ? null : (LongPressStartDetails details) {
        _showContextMenu(context, details.globalPosition, controller: controller, setStateRows: setStateRows, element: element!);
      },
      child: Listener(
        onPointerDown: !isRodape ? null : (PointerDownEvent event) {
          if (event.kind == PointerDeviceKind.mouse && event.buttons == kSecondaryMouseButton) {
            _showContextMenu(context, event.position, controller: controller, setStateRows: setStateRows, element: element!);
          }
        },
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: cor ??
                    (isTitle
                        ? Colors.grey[40]
                        : isRodape
                            ? Colors.black54
                            : Colors.grey[300]),
                border: Border.all(
                  color: Colors.purple.withValues(alpha: 0.35),
                  width: 0.25,
                ),
              ),
              padding: EdgeInsets.only(left: 5, right: 5, bottom: isRodape ? 5 : 0),
              alignment: (isTitle)
                  ? Alignment.centerLeft
                  : type != String
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
              child: Text(
                type == DateTime
                    ? value.toString()
                    : type == String || isTitle
                        ? Features.formatarTextoPrimeirasLetrasMaiusculas(value.toString().replaceAll('_', ' '))
                        : type == double
                            ? Features.toFormatNumber(value.toString().replaceAll('_', ' '))
                            : type == int
                                ? Features.toFormatInteger(
                                    value.toString().replaceAll('_', ' '),
                                  )
                                : value.toString(),
                style: TextStyle(
                  fontWeight: isRodape || isTitle ? FontWeight.bold : FontWeight.normal,
                  fontSize: fontSize,
                  color: isRodape ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (isTitle && isSelected)
              Positioned(
                left: 0,
                bottom: -10,
                child: IconButton(
                  icon: Icon(
                    order == 'asc' ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 17,
                    color: Colors.blueAccent,
                  ),
                  onPressed: null,
                ),
              ),
            if (isTitle)
              Positioned(
                right: 0,
                bottom: -10,
                child: PopupMenuButton(
                  tooltip: "",
                  splashRadius: 1,
                  position: PopupMenuPosition.under,
                  constraints: const BoxConstraints(
                    maxHeight: 400,
                    minWidth: 90,
                  ),
                  icon: Icon(
                    isFiltered ? Icons.filter_alt_outlined : Icons.arrow_drop_down_outlined,
                    size: 22,
                    color: Colors.blue,
                  ),
                  itemBuilder: (context) {
                    return controller.createlistaFiltrarLinhas(chave: key).map((e) {
                      return PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: Observer(
                          builder: (_) => CheckboxListTile(
                            value: e.selecionado,
                            title: Text(e.valor.toString()),
                            onChanged: (v) {
                              e.selecionado = !e.selecionado;
                              if (e.selecionado)
                                controller.colunasFiltradas.add(e.coluna);
                              else
                                controller.colunasFiltradas.removeWhere((element) => element == e.coluna);
                              setStateRows(() {
                                if (e.selecionado)
                                  controller.filtrosSelected.add(
                                    {"coluna": e.coluna, "valor": e.valor},
                                  );
                                else
                                  controller.filtrosSelected.removeWhere((element) => element['coluna'] == e.coluna && element['valor'] == e.valor);
                                controller.getTheSelectedFilteredRows();
                                controller.dadosFiltered();
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              )
          ],
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, Offset position, {required ReportFromJSONController controller, required Function setStateRows,required Map<String,dynamic> element}) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        overlay.size.width - position.dx,
        overlay.size.height - position.dy,
      ),
      items: const [
        PopupMenuItem<bool>(
          value: false,
          child: Text('Soma'),
        ),
        PopupMenuItem<bool>(
          value: true,
          child: Text('Media'),
        ),
      ],
    ).then((valor) {
      setStateRows ((){
        if(valor != null){
          for (var value in controller.colunas)
            if (value['key'] == element['key']) {
              value['isMedia'] = valor;
            } 
        }        
      });

    });
  }

  Widget rowTextComLable({
    required ReportFromJSONController controller,
    required double width,
    double? height,
    required key,
    required Type type,
    required value,
  }) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(
              color: Colors.purple.withValues(alpha: 0.5),
              width: 0.25,
            ),
          ),
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                key,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  type == DateTime
                      ? value.toString()
                      : type == String
                          ? Features.formatarTextoPrimeirasLetrasMaiusculas(value.toString().replaceAll('_', ' '))
                          : type == double
                              ? Features.toFormatNumber(value.toString().replaceAll('_', ' '))
                              : type == int
                                  ? Features.toFormatInteger(
                                      value.toString().replaceAll('_', ' '),
                                    )
                                  : value.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
