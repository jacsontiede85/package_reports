// ignore_for_file: must_be_immutable
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_reports/report_module/charts/charts.dart';
import 'package:package_reports/report_module/controller/report_from_json_controller.dart';
import 'package:package_reports/global/core/features.dart';
import 'package:package_reports/global/widget/widgets.dart';
import 'package:package_reports/report_module/controller/report_chart_controller.dart';

class ChartsReport extends StatefulWidget with Charts {
  late String title;
  late ReportFromJSONController reportFromJSONController;
  ChartsReport({super.key, required this.title, required this.reportFromJSONController}) {
    controller = ReportChartController(reportFromJSONController: reportFromJSONController);
  }

  late ReportChartController controller;

  @override
  State<ChartsReport> createState() => _ChartsReportState();
}

class _ChartsReportState extends State<ChartsReport> {
  ScrollController horizontalScroll = ScrollController();

  ScrollController verticalScroll = ScrollController();

  Widgets wp = Widgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        title: Text(
          "${widget.title} - Graficos",
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Visibility(
            visible: true,
            replacement: PopupMenuButton(
              tooltip: 'Graficos',
              itemBuilder: (context) {
                return widget.controller.getTodosOsTiposGraficos().map((value) {
                  return PopupMenuItem(
                    onTap: value['funcao'],
                    child: Row(
                      children: [
                        Icon(
                          value['icone'],
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(value['nome']),
                        )
                      ],
                    ),
                  );
                }).toList();
              },
            ),
            child: Wrap(
              spacing: 15,
              children: widget.controller.getTodosOsTiposGraficos().map((e) {
                return IconButton(onPressed: e['funcao'], icon: Icon(e['icone']));
              }).toList(),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            }),
            child: AdaptiveScrollbar(
              controller: horizontalScroll,
              width: 8,
              position: ScrollbarPosition.bottom,
              underSpacing: const EdgeInsets.only(bottom: 15), //largura do srcroll
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
              child: Observer(
                builder: (_) => Container(
                  width: MediaQuery.sizeOf(context).width,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Visibility(
                    visible: !widget.controller.loading,
                    replacement: Center(
                      child: LoadingAnimationWidget.halfTriangleDot(
                        color: const Color.fromARGB(255, 102, 78, 238),
                        size: 40,
                      ),
                    ),
                    child: Visibility(
                      visible: !(widget.controller.chartNameSelected == 'sfLineCartesianChart' || widget.controller.chartNameSelected == 'sfAreaCartesianChart'),
                      replacement: widget.controller.chartSelected,
                      child: ListView(
                        controller: verticalScroll,
                        children: [
                          Observer(
                            builder: (_) {
                              return SizedBox(
                              width: MediaQuery.sizeOf(context).width,
                              height: (widget.controller.reportFromJSONController.dados.length * 30) > (MediaQuery.sizeOf(context).height * 0.83) ? widget.controller.reportFromJSONController.dados.length * 30 : MediaQuery.sizeOf(context).height * 0.83,
                              child: widget.controller.chartSelected,
                            );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Observer(
            builder: (_) => Visibility(
              visible: (widget.controller.getColumnMetricsChart.length > 1 && widget.controller.chartNameSelected != 'sfLineCartesianChartArea' && widget.controller.chartNameSelected != 'sfAreaCartesianChart'),
              child: Container(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
                alignment: Alignment.topRight,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  }),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Observer(
                      builder: (_) => Visibility(
                        visible: !widget.controller.loading,
                        child: Wrap(
                          spacing: 30,
                          runSpacing: 10,
                          children: [
                            Observer(
                              builder: (_) => PopupMenuButton(
                                child: Text(
                                  'Selecione uma métrica: ${widget.controller.metricaSelecionada}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                itemBuilder: (context) => widget.controller.getColumnMetricsChart.map((value) {
                                  return PopupMenuItem(
                                    value: value,
                                    child: Text(
                                      Features.formatarTextoPrimeirasLetrasMaiusculas(value['nomeFormatado']),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    onTap: () {
                                      widget.controller.columnMetricSelected = value;
                                      widget.controller.metricaSelecionada = value['nomeFormatado'];
                                      widget.controller.getChart(chartNameSelected: widget.controller.chartNameSelected);
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                            Observer(
                              builder: (_) => PopupMenuButton(
                                child: Text(
                                  'Ordernar por: ${widget.controller.ordenacaoSelecionada}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                itemBuilder: (context) {
                                  return widget.controller.getColumnOrderByChart.map((value) {
                                    return PopupMenuItem<Map>(
                                      value: value,
                                      child: Text(
                                        Features.formatarTextoPrimeirasLetrasMaiusculas(value['nomeFormatado']),
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      onTap: () {
                                        widget.controller.columnOrderBySelected = value;
                                        widget.controller.ordenacaoSelecionada = value['nomeFormatado'];
                                        widget.controller.getChart(chartNameSelected: widget.controller.chartNameSelected);
                                      },
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                            Observer(
                              builder: (_) => PopupMenuButton(
                                child: Text(
                                  'Tipo ordenação: ${widget.controller.orderby}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                                itemBuilder: (context) => ['Crescente', 'Decrescente'].map((value) {
                                  return PopupMenuItem(
                                    value: value,
                                    child: Text(
                                      Features.formatarTextoPrimeirasLetrasMaiusculas(value),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    onTap: () {
                                      widget.controller.orderby = value;
                                      widget.controller.getChart(chartNameSelected: widget.controller.chartNameSelected);
                                    },
                                  );
                                }).toList(),
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
          ),
        ],
      ),
    );
  }
}
