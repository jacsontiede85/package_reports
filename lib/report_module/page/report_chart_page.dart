// ignore_for_file: must_be_immutable
import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:package_reports/report_module/charts/charts.dart';
import 'package:package_reports/report_module/controller/layout_controller.dart';
import 'package:package_reports/report_module/controller/report_from_json_controller.dart';
import 'package:package_reports/report_module/core/features.dart';
import '../controller/report_chart_controller.dart';

class ChartsReport extends StatelessWidget with Charts {
  late String title;
  late ReportFromJSONController reportFromJSONController;
  ChartsReport({super.key, required this.title, required this.reportFromJSONController}) {
    controller = ReportChartController(reportFromJSONController: reportFromJSONController);
  }
  
  final layout = GetIt.I.get<LayoutController>();
  late ReportChartController controller;
  ScrollController horizontalScroll = ScrollController();
  ScrollController verticalScroll = ScrollController();
    
  @override
  Widget build(BuildContext context) {
    // Mudou para layout em caso de erro mudar para MediaQuery
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    // width = width < 800 ? height : width;

    return ScaffoldPage(
      header: Row(
        children: [
          IconButton(
            icon: const Icon(FluentIcons.back),
            onPressed: () => Navigator.pop(context),
          ),
          Text(
            '$title [Gráficos]',
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
          const Expanded(child: SizedBox()),
          IconButton(
            onPressed: () => controller.getChart(chartNameSelected: 'barChartHorizontal'),
            icon:const  Icon(FluentIcons.bar_chart_vertical_fill),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () => controller.getChart(chartNameSelected: 'sfCircularChart'),
            icon: const Icon(FluentIcons.donut_chart),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () => controller.getChart(chartNameSelected: 'sfLineCartesianChart'),
            icon: const Icon(FluentIcons.bar_chart4),
          ),
          const SizedBox(
            width: 10,
          ),
          Observer(
            builder: (_) => Visibility(
              visible: controller.isVisibleChartsArea,
              child: IconButton(
                onPressed: () => controller.getChart(chartNameSelected: 'sfLineCartesianChartArea'),
                icon: const Icon(FluentIcons.bar_chart_horizontal),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Observer(
            builder: (_) => Visibility(
              visible: controller.isVisibleChartsArea,
              child: IconButton(
                onPressed: () => controller.getChart(chartNameSelected: 'sfAreaCartesianChart'),
                icon: const Icon(FluentIcons.charticulator_stack_radial),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      content:
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
                          width: controller.chartNameSelected == 'sfLineCartesianChart'
                              ? (controller.reportFromJSONController.dados.length * 150) < layout.width
                                  ? 500
                                  : controller.reportFromJSONController.dados.length * 150
                              : layout.width,
                          height: 4000,
                          child: ListView(
                            controller: verticalScroll,
                            children: [
                              SizedBox(
                                width: layout.width,
                                height: layout.height * 0.06,
                              ),
                              if (!controller.loading)
                                Observer(
                                  builder: (_) => controller.chartNameSelected == 'sfLineCartesianChartArea' || controller.chartNameSelected == 'sfAreaCartesianChart'
                                      ? controller.chartSelected //Graficos de area (lista)
                                      : SizedBox(
                                      width: layout.width,
                                      height: (controller.reportFromJSONController.dados.length *30) > (layout.height * 0.83) ? controller.reportFromJSONController.dados.length * 30 : layout.height * 0.83,
                                      child: controller.chartSelected,
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
                      visible: !controller.loading,
                      // && controller.getColumnMetricsChart.isNotEmpty
                      // && controller.chartNameSelected != 'sfLineCartesianChartArea'
                      // && controller.chartNameSelected != 'sfAreaCartesianChart',
                      child: Row(
                        children: [
                          if (controller.getColumnMetricsChart.length > 1 && controller.chartNameSelected != 'sfLineCartesianChartArea' && controller.chartNameSelected != 'sfAreaCartesianChart')
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selecione uma métrica:',
                                  style: TextStyle(fontSize: layout.isDesktop ? 14 : 10),
                                ),
                                Observer(
                                  builder: (_) => SizedBox(
                                    width: 150,//layout.mobile ? layout.width * 0.29 : 200,
                                    height: 40,
                                    child: 
                                    ComboBox<Map>(
                                      value: controller.columnMetricSelected,
                                      autofocus: false,
                                      isExpanded: true,
                                      //focusColor: Colors.transparent,
                                      items: controller.getColumnMetricsChart.map((value) {
                                        return ComboBoxItem<Map>(
                                          value: value,
                                          child: Text(
                                            Features.formatarTextoPrimeirasLetrasMaiusculas(value['nomeFormatado']),
                                            style: TextStyle(fontSize: layout.isDesktop ? 14 : 10, color: Colors.white),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (selected) {
                                        controller.columnMetricSelected = selected ?? {};
                                        controller.columnOrderBySelected = selected ?? {};
                                        controller.getChart(chartNameSelected: controller.chartNameSelected);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ordernar por:',
                                style: TextStyle(fontSize: layout.isDesktop ? 14 : 10),
                              ),
                              Observer(
                                builder: (_) => SizedBox(
                                  width: 150,//layout.mobile ? layout.width * 0.29 : 200,
                                  height: 40,
                                  child: ComboBox<Map>(
                                    value: controller.columnOrderBySelected,
                                    autofocus: false,
                                    isExpanded: true,
                                    focusColor: Colors.transparent,
                                    items: controller.getColumnOrderByChart.map((value) {
                                      return ComboBoxItem<Map>(
                                        value: value,
                                        child: Text(
                                          Features.formatarTextoPrimeirasLetrasMaiusculas(value['nomeFormatado']),
                                          style: TextStyle(fontSize: layout.isDesktop ? 14 : 10),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (selected) {
                                      controller.columnOrderBySelected = selected ?? {};
                                      controller.getChart(chartNameSelected: controller.chartNameSelected);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tipo ordenação:',
                                style: TextStyle(fontSize: layout.isDesktop ? 14 : 10),
                              ),
                              Observer(
                                builder: (_) => SizedBox(
                                  width: 150,//layout.mobile ? layout.width * 0.29 : 200,
                                  height: 40,
                                  child: ComboBox<String>(
                                    value: controller.orderby,
                                    autofocus: false,
                                    isExpanded: true,
                                    focusColor: Colors.transparent,
                                    items: ['', 'Crescente', 'Decrescente'].map((value) {
                                      return ComboBoxItem<String>(
                                        value: value,
                                        child: Text(
                                          Features.formatarTextoPrimeirasLetrasMaiusculas(value),
                                          style: TextStyle(fontSize: layout.isDesktop ? 14 : 10),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      controller.orderby = (value ?? '');
                                      controller.getChart(chartNameSelected: controller.chartNameSelected);
                                    },
                                  ),
                                ),
                              ),
                            ],
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
                visible: controller.loading,
                child: const Positioned(
                  bottom: 0,
                  child: ProgressBar(),
                ),
              ),
            ),
          ],
        ),
    );
  }
}
