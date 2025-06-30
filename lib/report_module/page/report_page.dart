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
import 'package:package_reports/global/widget/widgets.dart';
import 'package:package_reports/report_module/page/rows.dart';
import 'package:package_reports/report_module/page/widgets_reports.dart';

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
  late WidgetsReports wdreports;
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
    wdreports= WidgetsReports(
      context: context,
      controller: controller,
      database: widget.database,
      setStatee: setStatee
    );

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
                          wdreports.pageSelecaoGraficos();
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
                            builder: (context) => wdreports.exibirSelecaoDeColunasParaExporta(
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
                            builder: (context) => wdreports.exibirSelecaoDeColunasParaExporta(
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
                                              wdreports.colunasWidget(),
                                              Observer(
                                                builder: (_) => Visibility(
                                                  visible: controller.positionScroll > 200 && controller.visibleColElevated,
                                                  child: Positioned(
                                                    top: 0,
                                                    left: controller.positionScroll,
                                                    child: wdreports.colunasElevated(),
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
                                        if (controller.dadosFiltered().isNotEmpty) Flexible(flex: 2, child: wdreports.rowsBuilder()),
            
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
                                            wdreports.rodape(),
                                            Observer(
                                              builder: (_) => Visibility(
                                                visible: controller.positionScroll > 200 && controller.visibleColElevated,
                                                child: Positioned(
                                                  top: 0,
                                                  left: controller.positionScroll,
                                                  child: wdreports.rodapeElevated(),
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
                  if (controller.isLoadingGraficos || controller.errorGraficosMessage.isNotEmpty)
                    Positioned.fill(
                      child: wdreports.messagemGraficosDialogs(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
