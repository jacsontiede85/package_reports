// ignore_for_file: must_be_immutable
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
          Visibility(
            visible: true,
            replacement: PopupMenuButton(
              tooltip: 'Graficos',
              itemBuilder: (context) {
                return widget.controller.getTodosOsTiposGraficos().map((value){
                  return PopupMenuItem(
                    onTap: value['funcao'],
                    child: Row(
                      children: [
                        Icon(
                          value['icone'],
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:5),
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
                return IconButton(
                  onPressed: e['funcao'], 
                  icon: Icon(e['icone'])
                );
              }).toList(),
            ),
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
                              ? (widget.controller.reportFromJSONController.dados.length * 150) < MediaQuery.sizeOf(context).width
                                  ? 500
                                  : widget.controller.reportFromJSONController.dados.length * 150
                              : MediaQuery.sizeOf(context).width,
                          height: 4000,
                          child: ListView(
                            controller: verticalScroll,
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width,
                                height: MediaQuery.sizeOf(context).height * 0.06,
                              ),
                              if (!widget.controller.loading)
                                Observer(
                                  builder: (_) => widget.controller.chartNameSelected == 'sfLineCartesianChartArea' || widget.controller.chartNameSelected == 'sfAreaCartesianChart'
                                      ? widget.controller.chartSelected //Graficos de area (lista)
                                      : SizedBox(
                                      width: MediaQuery.sizeOf(context).width,
                                      height: (widget.controller.reportFromJSONController.dados.length *30) > (MediaQuery.sizeOf(context).height * 0.83) ? widget.controller.reportFromJSONController.dados.length * 30 : MediaQuery.sizeOf(context).height * 0.83,
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
                        spacing: 30,
                        runSpacing: 10,
                        children: [
                          if (widget.controller.getColumnMetricsChart.length > 1 && widget.controller.chartNameSelected != 'sfLineCartesianChartArea' && widget.controller.chartNameSelected != 'sfAreaCartesianChart')
                            Observer(
                              builder: (_) => PopupMenuButton(
                                child: Text(
                                  'Selecione uma métrica: ${widget.controller.metricaSelecionada}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                itemBuilder:(context) => widget.controller.getColumnMetricsChart.map((value) {
                                  return PopupMenuItem(
                                    value: value,
                                    child: Text(
                                      Features.formatarTextoPrimeirasLetrasMaiusculas(value['nomeFormatado']),
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    onTap: () {
                                      widget.controller.metricaSelecionada = value['nomeFormatado'];
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          Observer(
                            builder: (_) => PopupMenuButton(
                              child: Text(
                                'Ordernar por: ${widget.controller.ordenacaoSelecionada}',
                                style: const TextStyle(fontSize: 14),
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
                                      widget.controller.ordenacaoSelecionada = value['nomeFormatado'];
                                    },
                                  );
                                }).toList();
                              },
                            ),
                          ),
                          Observer(
                            builder: (_) => PopupMenuButton(
                              child: Text(
                                'Tipo ordenação: ${widget.controller.tipoOrdenacaoSelecionada}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              itemBuilder: (context) => ['Crescente', 'Decrescente'].map((value) {
                                return PopupMenuItem(
                                  value: value,
                                  child: Text(
                                    Features.formatarTextoPrimeirasLetrasMaiusculas(value),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  onTap: () {
                                    widget.controller.tipoOrdenacaoSelecionada = value;
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
