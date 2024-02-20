// ignore_for_file: must_be_immutable
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:package_reports/report_module/charts/charts.dart';
import 'package:package_reports/report_module/controller/layout_controller.dart';
import 'package:package_reports/report_module/controller/report_from_json_controller.dart';
import 'package:package_reports/report_module/core/features.dart';
import 'package:package_reports/report_module/widget/widgets.dart';
import '../controller/report_chart_controller.dart';

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
  final LayoutController layout = LayoutController();

  ScrollController horizontalScroll = ScrollController();

  ScrollController verticalScroll = ScrollController();

  Widgets wp = Widgets();

  @override
  Widget build(BuildContext context) {
    // Mudou para layout em caso de erro mudar para MediaQuery
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    // width = width < 800 ? height : width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: wp.wpHeader(
          titulo: '${widget.title} Gráficos',
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
          IconButton(
            onPressed: () => widget.controller.getChart(chartNameSelected: 'barChartHorizontal'),
            icon:const  Icon(Icons.bar_chart_sharp),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () => widget.controller.getChart(chartNameSelected: 'sfCircularChart'),
            icon: const Icon(Icons.pie_chart_rounded),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () => widget.controller.getChart(chartNameSelected: 'sfLineCartesianChart'),
            icon: const Icon(Icons.ssid_chart),
          ),
          const SizedBox(
            width: 10,
          ),
          Observer(
            builder: (_) => Visibility(
              visible: widget.controller.isVisibleChartsArea,
              child: IconButton(
                onPressed: () => widget.controller.getChart(chartNameSelected: 'sfLineCartesianChartArea'),
                icon: const Icon(Icons.stacked_line_chart_outlined),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Observer(
            builder: (_) => Visibility(
              visible: widget.controller.isVisibleChartsArea,
              child: IconButton(
                onPressed: () => widget.controller.getChart(chartNameSelected: 'sfAreaCartesianChart'),
                icon: const Icon(Icons.area_chart),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body:
        Stack(
          children: [
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              }),
              child: AdaptiveScrollbar(
                controller: verticalScroll,
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
                  child: SingleChildScrollView(
                    controller: horizontalScroll,
                    scrollDirection: Axis.horizontal,
                    child: Observer(
                      builder: (_) => SizedBox(
                          width: widget.controller.chartNameSelected == 'sfLineCartesianChart'
                              ? (widget.controller.reportFromJSONController.dados.length * 150) < layout.width
                                  ? 500
                                  : widget.controller.reportFromJSONController.dados.length * 150
                              : layout.width,
                          height: 4000,
                          child: ListView(
                            controller: verticalScroll,
                            children: [
                              SizedBox(
                                width: layout.width,
                                height: layout.height * 0.06,
                              ),
                              if (!widget.controller.loading)
                                Observer(
                                  builder: (_) => widget.controller.chartNameSelected == 'sfLineCartesianChartArea' || widget.controller.chartNameSelected == 'sfAreaCartesianChart'
                                      ? widget.controller.chartSelected //Graficos de area (lista)
                                      : SizedBox(
                                      width: layout.width,
                                      height: (widget.controller.reportFromJSONController.dados.length *30) > (layout.height * 0.83) ? widget.controller.reportFromJSONController.dados.length * 30 : layout.height * 0.83,
                                      child: widget.controller.chartSelected,
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
            Container(
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
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          if (widget.controller.getColumnMetricsChart.length > 1 && widget.controller.chartNameSelected != 'sfLineCartesianChartArea' && widget.controller.chartNameSelected != 'sfAreaCartesianChart')
                            Observer(
                              builder: (_) => PopupMenuButton(
                                child: Text(
                                  'Selecione uma métrica:',
                                  style: TextStyle(fontSize: layout.isDesktop ? 14 : 10),
                                ),
                                itemBuilder:(context) => widget.controller.getColumnMetricsChart.map((value) {
                                  return PopupMenuItem(
                                    value: value,
                                    child: Text(
                                      Features.formatarTextoPrimeirasLetrasMaiusculas(value['nomeFormatado']),
                                      style: TextStyle(
                                        fontSize: layout.isDesktop ? 14 : 10,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          const SizedBox(
                            width: 20,
                          ),
                          Observer(
                            builder: (_) => PopupMenuButton(
                              child: Text(
                                'Ordernar por:',
                                style: TextStyle(fontSize: layout.isDesktop ? 14 : 10),
                              ),
                              itemBuilder: (context) {
                                return widget.controller.getColumnOrderByChart.map((value) {
                                  return PopupMenuItem<Map>(
                                    value: value,
                                    child: Text(
                                      Features.formatarTextoPrimeirasLetrasMaiusculas(value['nomeFormatado']),
                                      style: TextStyle(fontSize: layout.isDesktop ? 14 : 10),
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Observer(
                            builder: (_) => PopupMenuButton(
                              child: Text(
                                'Tipo ordenação:',
                                style: TextStyle(fontSize: layout.isDesktop ? 14 : 10),
                              ),
                              itemBuilder: (context) => ['', 'Crescente', 'Decrescente'].map((value) {
                                return PopupMenuItem(
                                  value: value,
                                  child: Text(
                                    Features.formatarTextoPrimeirasLetrasMaiusculas(value),
                                    style: TextStyle(fontSize: layout.isDesktop ? 14 : 10),
                                  ),
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
            Observer(
              builder: (_) => Visibility(
                visible: widget.controller.loading,
                child: const Positioned(
                  bottom: 0,
                  child: LinearProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
