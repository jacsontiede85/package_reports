// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_reports/report_module/controller/layout_controller.dart';
import 'package:package_reports/report_module/controller/report_from_json_controller.dart';
import 'package:package_reports/report_module/controller/report_to_xlsx_controller.dart';
import 'package:package_reports/report_module/core/features.dart';
import 'package:package_reports/report_module/filtros_page.dart';
import 'package:package_reports/report_module/report_chart_page.dart';
import 'package:package_reports/report_module/widget/texto.dart';
import 'package:package_reports/report_module/widget/widgets.dart';

class ReportPage extends StatefulWidget {
  final String title;
  final String function;
  final bool? voltarComPop;
  final Color? corTitulo;
  const ReportPage({super.key, 
    required this.title,
    required this.function,
    this.voltarComPop = false,
    this.corTitulo = Colors.black,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with Rows {
  late ReportFromJSONController controller;
  final layout = GetIt.I.get<LayoutController>();
  FlyoutController menuController = FlyoutController();
  Widgets wp = Widgets();
  double _width = 0.0;

  @override
  void initState() {
    super.initState();
    controller = ReportFromJSONController(nomeFunction: widget.function, sizeWidth: _width);
  }

  @override
  void dispose() {
    super.dispose();
    controller.verticalScroll.dispose();
    controller.horizontalScroll.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = layout.width;
    controller.sizeWidth = _width;

    return Container(
      color: Colors.white,
      child: WillPopScope(
      onWillPop: controller.willPopCallback,
      child: ScaffoldPage(
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(widget.voltarComPop!)
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 5),
              child: IconButton(
                icon: const Icon(FluentIcons.back), 
                onPressed: (){
                  Navigator.of(context).pop(true);
                }
              ),
            ),
            if(layout.isDesktop)
              wp.wpHeader(
                titulo: widget.title,
                cor: widget.corTitulo ?? Colors.black,
              )
            else
              Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 15),
                child: Texto(
                  texto: widget.title,
                  cor: widget.corTitulo ?? Colors.black,
                  tipo: TipoTexto.corpoNegrito,
                ),
              ),
            Padding(
              padding: layout.isDesktop ? const EdgeInsets.only(left: 10, right: 10) : const EdgeInsets.only(left: 5, right: 10, bottom: 10),
              child: Wrap(
                children: [
                  Observer(
                    builder: (_) => Visibility(
                      visible: !controller.loading,
                      child: IconButton(
                        icon: Icon(
                          FluentIcons.graph_symbol,
                          color: widget.corTitulo ?? Colors.black,
                          size: layout.isDesktop ? 20 : 15,
                        ),
                        onPressed: () async => await Navigator.push(
                            context,
                            FluentPageRoute(
                              builder: (context) => ChartsReport(
                                reportFromJSONController: controller,
                                title: widget.title,
                              ),
                            ),
                          ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Observer(
                    builder: (_) => Visibility(
                      visible: (controller.dados.isNotEmpty && !controller.loading),
                      child: IconButton(
                        icon: Icon(
                          FluentIcons.excel_document, 
                          color: widget.corTitulo ?? Colors.black,
                          size: layout.isDesktop ? 20 : 15,
                        ),
                        onPressed: () {
                          ReportToXLSXController(title: widget.title, reportFromJSONController: controller);
                        },
                      ),
                    ),
                  ),
                  Observer(
                    builder: (_) => Visibility(
                      visible: !controller.loading,
                      child: FlyoutTarget(
                        controller: menuController,
                        child: IconButton(
                          icon: Icon(
                            FluentIcons.filter,
                            color: widget.corTitulo ?? Colors.black,
                            size: layout.isDesktop ? 20 : 15,
                          ),
                          onPressed: () => menuController.showFlyout(builder: (context) => FiltrosPage(functionAplicarFiltros: controller.getDados),)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Container(
          color: Colors.white,
          child: Observer(
            builder: (_) => Stack(
              children: [
                !controller.loading || controller.dados.isNotEmpty
                      ? 
                      ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        }),
                        child: AdaptiveScrollbar(
                          controller: controller.verticalScroll,
                          width: 8,
                          underColor: Colors.white.withOpacity(0.1),
                          sliderSpacing: const EdgeInsets.only(
                            right: 0,
                          ),
                          sliderDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.black.withOpacity(0.6),
                          ),
                          sliderActiveDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: AdaptiveScrollbar(
                            controller: controller.horizontalScroll,
                            width: _width < 600 ? 10 : 8,
                            position: ScrollbarPosition.bottom,
                            underSpacing: const EdgeInsets.only(bottom: 15),
                            underColor: Colors.white.withOpacity(0.1),
                            sliderSpacing: const EdgeInsets.only(
                              right: 0,
                            ),
                            sliderDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.black.withOpacity(0.5),
                            ),
                            sliderActiveDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: SingleChildScrollView(
                              controller: controller.horizontalScroll,
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                width: _width > controller.widthTable ? _width : controller.widthTable + 10,
                                alignment: Alignment.topLeft,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: controller.widthTable,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: controller.loading? Colors.transparent : Colors.purple.withOpacity(0.3),
                                          width: 0.1,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if(controller.dados.isEmpty)
                                            Text(
                                              'Não há dados para os filtros selecionados...',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: layout.isDesktop ? 16 : 12,
                                                fontWeight: FontWeight.w600
                                              ),
                                            ),
                                      
                                          // TITULO DE COLUNAS
                                          Container(
                                              height: controller.getHeightColunasCabecalho,
                                              color: Colors.grey[50],
                                              child: Stack(
                                                children: [
                                                  colunas(),
                                                  Observer(
                                                    builder: (_) => Visibility(
                                                      visible: controller.positionScroll > 200 && controller.visibleColElevated && controller.dados.length <= 500,
                                                      child: Positioned(
                                                        top: 0,
                                                        left: controller.positionScroll,
                                                        child: colunasElevated(),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          
                                          // ROWS [DADOS]
                                          if (controller.dados.isNotEmpty)
                                            controller.dados.length > 500
                                                ? Flexible(child: rowsBuilder())
                                                : Flexible(
                                                    child: ListView(
                                                      physics: const BouncingScrollPhysics(),
                                                      controller: controller.verticalScroll,
                                                      children: [
                                                        Stack(
                                                          children: [
                                                            rows(),
                                                            Observer(
                                                              builder: (_) => Visibility(
                                                                visible: controller.positionScroll > 200 && controller.visibleColElevated,
                                                                child: Positioned(
                                                                  top: 0,
                                                                  left: controller.positionScroll,
                                                                  child: rowsElevated(),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                          
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
                                                  visible: controller.positionScroll > 200 && controller.visibleColElevated && controller.dados.length <= 500,
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
                      ) :
                Center(
                  child: LoadingAnimationWidget.halfTriangleDot(
                    color: const Color(0xFFEE4E4E),
                    size: 50,
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

  Widget colunas() => Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          if (controller.colunas.where((element) => element['type'] != String).toList().isNotEmpty)
            ...controller.colunas
                .map(
                  (element) => HoverButton(
                    onPressed: () => controller.setOrderBy(key: element['key'], order: element['order']),
                    builder: (context, state) => rowTextFormatted(
                        width: controller.getWidthCol(
                          key: element['key'],
                        ),
                        height: controller.getHeightColunasCabecalho,
                        controller: controller,
                        key: element['key'],
                        type: element['type'],
                        value: Features.formatarTextoPrimeirasLetrasMaiusculas(element['nomeFormatado'].trim()),
                        isTitle: true,
                        isSelected: element['isSelected'],
                        order: element['order']),
                  ),
                )
                .toList(),
        ],
      );

  Widget colunasElevated() {
    var element = controller.getMapColuna(key: controller.keyFreeze);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        HoverButton(
          onPressed: () => controller.setOrderBy(key: controller.keyFreeze, order: element['order']),
          builder: (context, state) => rowTextFormatted(
              width: controller.getWidthCol(
                key: controller.keyFreeze,
              ),
              height: controller.getHeightColunasCabecalho,
              controller: controller,
              key: controller.keyFreeze,
              type: element['type'],
              value: Features.formatarTextoPrimeirasLetrasMaiusculas(element['nomeFormatado'].trim()),
              isTitle: true,
              isSelected: element['isSelected'],
              order: element['order']),
        ),
      ],
    );
  }

  Widget rowsBuilder() => ListView.builder(
        itemCount: controller.dados.length,
        physics: const BouncingScrollPhysics(),
        controller: controller.verticalScroll,
        itemBuilder: (BuildContext context, int index) {
          var val = controller.dados[index];
          List<Widget> row = [];
          val.forEach((key, value) {
            Type type = value.runtimeType;
            if (!key.toString().contains('__invisible'))
              row.add(
                rowTextFormatted(
                  width: controller.getWidthCol(
                    key: key,
                  ),
                  height: 35,
                  controller: controller,
                  key: key,
                  type: type,
                  value: value,
                  cor: controller.dados.indexOf(val) % 2 == 0 ? Colors.grey[20] : Colors.white,
                ),
              );
          });
          return Row(
            children: row,
          );
        },
      );

  Widget rows() => controller.dados.isEmpty
      ? const SizedBox()
      : Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ...controller.dados.map((val) {
              List<Widget> row = [];
              val.forEach((key, value) {
                Type type = value.runtimeType;
                if (!key.toString().contains('__invisible'))
                  row.add(
                    rowTextFormatted(
                      width: controller.getWidthCol(
                        key: key,
                      ),
                      height: 35,
                      controller: controller,
                      key: key,
                      type: type,
                      value: value,
                      cor: controller.dados.indexOf(val) % 2 == 0 ? Colors.grey[20] : Colors.white,
                    ),
                  );
              });
              return Row(
                children: row,
              );
            }).toList(),
          ],
        );

  Widget rowsElevated() => controller.dados.isEmpty
      ? const SizedBox()
      : Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (controller.keyFreeze.isNotEmpty)
              ...controller.dados.map((map) {
                int index = controller.dados.indexOf(map);
                List<Widget> row = [];
                row.add(
                  rowTextFormatted(
                    width: controller.getWidthCol(
                      key: controller.keyFreeze,
                    ),
                    height: 35,
                    controller: controller,
                    key: controller.keyFreeze,
                    type: String,
                    value: map[controller.keyFreeze],
                    cor: index % 2 == 0 ? Colors.grey[20] : Colors.white,
                  ),
                );
                return Row(
                  children: row,
                );
              }).toList(),
          ],
        );

  Widget rodape() => Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black,
            ),
          ],
        ),
        child: Row(
          children: [
            if (controller.colunas.isNotEmpty)
              ...controller.colunas
                  .map(
                    (element) => rowTextFormatted(
                      width: controller.getWidthCol(
                        key: element['key'],
                      ),
                      height: 40,
                      controller: controller,
                      key: element['key'],
                      type: element['key'].toString().toLowerCase().contains('__dontsum') ? String : element['type'],
                      value: controller.colunas.indexOf(element) == 0
                          ? '${controller.dados.length}'
                          : element['type'] == String
                              ? ''
                              : element['key'].toString().toLowerCase().contains('__dontsum')
                                  ? ''
                                  : element['vlrTotalDaColuna'],
                      isSelected: element['isSelected'],
                      isRodape: true,
                      order: element['order'],
                    ),
                  )
                  .toList(),
          ],
        ),
      );

  Widget rodapeElevated() {
    var element = controller.getMapColuna(key: controller.keyFreeze);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        rowTextFormatted(
          width: controller.getWidthCol(
            key: controller.keyFreeze,
          ),
          height: 40,
          controller: controller,
          key: controller.keyFreeze,
          type: controller.keyFreeze.toString().toLowerCase().contains('__dontsum') ? String : element['type'],
          value: '${controller.dados.length}',
          isSelected: element['isSelected'],
          isRodape: true,
          order: element['order'],
        ),
      ],
    );
  }
}

mixin Rows {
  rowTextFormatted({required ReportFromJSONController controller, required double width, double? height, required key, required Type type, required value, bool isTitle = false, bool isRodape = false, bool isSelected = false, String order = 'asc', Color? cor}) {
    double fontSize = 12;
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: cor ?? (isTitle
                      ? Colors.grey[40] 
                      : Colors.grey[10]),
              border: Border.all(color: Colors.black.withOpacity(0.3), width: 0.1)),
          padding: EdgeInsets.only(left: 10, right: 10, bottom: isRodape ? 5 : 0),
          alignment: (isTitle && isSelected && type != String)
              ? Alignment.center
              : (isTitle && type != String)
                  ? Alignment.centerRight
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
              color: Colors.black,
            ),
          ),
        ),
        if (isTitle && isSelected)
          Positioned(
            right: 0,
            bottom: 1,
            child: Icon(order == 'asc' ? FluentIcons.up : FluentIcons.down,
                size: 17, color: Colors.blue),
          ),
      ],
    );
  }
}
