// ignore_for_file: depend_on_referenced_packages

import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:package_reports/report_module/core/features.dart';
import '../charts/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:fl_chart/fl_chart.dart';

mixin Charts{
  Widget pieChart({required List<ChartData> dados, double? radius, double? centerSpaceRadius, double? fontSize})=>
      AspectRatio(
        aspectRatio: 1,
        child: PieChart(
          PieChartData(
              borderData: FlBorderData(show: false,),
              sectionsSpace: 0,
              centerSpaceRadius: centerSpaceRadius,
              sections: dados.map((e) =>
                  PieChartSectionData(
                    color: e.color,
                    value: e.perc,
                    title: '${Features.toFormatNumber((e.perc).toString().replaceAll('_', ' '), qtCasasDecimais: 0)}%',
                    radius: radius,
                    titleStyle: TextStyle(
                        fontSize: fontSize??10.0,
                        fontWeight: FontWeight.normal,
                        color: Colors.white
                    ),
                  )
              ).toList()
          ),
          swapAnimationDuration: const Duration(milliseconds: 1500), // Optional
          swapAnimationCurve: Curves.linear, // Optional
        ),
      );

  Widget barChartHorizontal({required List<ChartData> dados, Color? color, bool? isTransposed, String? numberFormatSymbol})=>
      SfCartesianChart(
          margin: const EdgeInsets.only(top: 20, right: 20),
          plotAreaBorderWidth: 0.5,
          enableAxisAnimation: true,
          legend: const Legend(isVisible: false),
          isTransposed: isTransposed??false,
          primaryXAxis: const CategoryAxis(
            labelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
            majorGridLines: MajorGridLines(width: 0),
            isInversed: true,
          ),
          primaryYAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 1),
            numberFormat: NumberFormat.compactCurrency(symbol: numberFormatSymbol??''),
            minimum: 0,
            rangePadding: ChartRangePadding.auto,
          ),
          // tooltipBehavior: TooltipBehavior(enable: false),
          series: [
            BarSeries<ChartData, String>(
              dataSource: dados,
              xValueMapper: (ChartData data, _) => data.nome,
              yValueMapper: (ChartData data, _) => data.valor,
              pointColorMapper: (ChartData data, _) => data.color??color,
              // Width of the bars
              width: 0.5,
              // Spacing between the bars
              spacing: 0.2,
              borderRadius: const BorderRadius.all(Radius.circular(11)),
              enableTooltip: true,
              dataLabelMapper: (ChartData data, _) =>
                  data.type == int
                  ? '${numberFormatSymbol??''}${Features.toFormatNumber(data.valor.toString(), qtCasasDecimais: 0)}'
                  : '${numberFormatSymbol??'R\$ '}${Features.toFormatNumber(data.valor.toString())}',
              dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  alignment: ChartAlignment.center,
                  textStyle: const TextStyle(fontWeight: FontWeight.w400, fontSize: 11),
                  labelAlignment: ChartDataLabelAlignment.auto,
                  angle: isTransposed??false ? 0 : 0
              ),
            )
          ]
      );

  Widget sfLineCartesianChart({List<ChartData>? dados, List<List<ChartData>>? dadosList})=>
      dados==null && dadosList==null
      ? const SizedBox()
      : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(dados!=null)
              if((dados[0].title??'').isNotEmpty) Padding(padding: const EdgeInsets.only(left: 30, top: 20), child: Text('${dados[0].title}'),),
            SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                margin: const EdgeInsets.only(left: 0, top: 15, right: 0, bottom: 0),
                series: [
                  if(dados!=null && dadosList==null)
                    LineSeries<ChartData, String>(
                        dataSource: dados,
                        xValueMapper: (ChartData data, _) => data.nome,
                        yValueMapper: (ChartData data, _) => data.valor,
                        dataLabelMapper: (ChartData data, _) => data.type == int
                            ? '${Features.toFormatNumber(data.valor.toString(), qtCasasDecimais: 0)}'
                            : 'R\$ ${Features.toFormatNumber(data.valor.toString())}',
                        pointColorMapper: (ChartData data, _) => data.color,
                        enableTooltip: true,
                        width: 3,
                        animationDuration: 2,
                        markerSettings: MarkerSettings(
                            isVisible: true,
                            height: 4,
                            width: 4,
                            shape: DataMarkerType.circle,
                            borderWidth: 3,
                            borderColor: Colors.red
                        ),
                        dataLabelSettings: const DataLabelSettings(
                          useSeriesColor: true,
                          labelAlignment: ChartDataLabelAlignment.auto,
                          textStyle: TextStyle(fontSize: 10),
                          showZeroValue: false,
                          isVisible: true,
                          labelPosition: ChartDataLabelPosition.outside,
                          showCumulativeValues: true,
                          borderRadius: 7,
                        )
                    ),

                  if(dados==null && dadosList!=null)
                    for(var value in dadosList)
                      LineSeries<ChartData, String>(
                          dataSource: value,
                          xValueMapper: (ChartData data, _) => data.nome,
                          yValueMapper: (ChartData data, _) => data.valor*100,
                          dataLabelMapper: (ChartData data, _) => '${Features.toFormatNumber((data.valor).toString().replaceAll('_', ' '), qtCasasDecimais: 1)}',
                          pointColorMapper: (ChartData data, _) => data.color,
                          enableTooltip: true,
                          width: 3,
                          animationDuration: 2,
                          markerSettings: MarkerSettings(
                              isVisible: true,
                              height: 4,
                              width: 4,
                              shape: DataMarkerType.circle,
                              borderWidth: 3,
                              borderColor: Colors.red
                          ),
                          dataLabelSettings: const DataLabelSettings(
                            useSeriesColor: true,
                            labelAlignment: ChartDataLabelAlignment.auto,
                            textStyle: TextStyle(fontSize: 10),
                            showZeroValue: false,
                            isVisible: true,
                            labelPosition: ChartDataLabelPosition.outside,
                            showCumulativeValues: true,
                            borderRadius: 7,
                          )
                      ),
                ]
            ),
            const SizedBox(height: 30,),
          ],
        );

  Widget sfAreaCartesianChart({List<ChartData>? dados, List<List<ChartData>>? dadosList})=>
      dados==null && dadosList==null
          ? const SizedBox()
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(dados!=null)
                  if((dados[0].title??'').isNotEmpty)
                    Padding(padding: const EdgeInsets.only(left: 30, top: 0), child: Text('${dados[0].title}'),),
                if(dadosList!=null)
                  if((dadosList[1][0].title??'').isNotEmpty)
                    Padding(padding: const EdgeInsets.only(left: 30, top: 0), child: Text('${dadosList[1][0].title}'),),
                SfCartesianChart(
                    primaryXAxis: const CategoryAxis(),
                    margin: const EdgeInsets.only(left: 0, top: 15, right: 0, bottom: 0),
                    series: <CartesianSeries>[
                      if(dados!=null && dadosList==null)
                        AreaSeries<ChartData, String>(
                            dataSource: dados,
                            xValueMapper: (ChartData data, _) => data.nome,
                            yValueMapper: (ChartData data, _) => data.valor,
                            dataLabelMapper: (ChartData data, _) => data.type == int
                                ? '${Features.toFormatNumber(data.valor.toString(), qtCasasDecimais: 0)}'
                                : 'R\$ ${Features.toFormatNumber(data.valor.toString())}',
                            pointColorMapper: (ChartData data, _) => data.color,
                            color: dados[0].color,
                            enableTooltip: true,
                            animationDuration: 2,
                            markerSettings: MarkerSettings(
                                isVisible: true,
                                height: 4,
                                width: 4,
                                shape: DataMarkerType.circle,
                                borderWidth: 3,
                                borderColor: Colors.red
                            ),
                            dataLabelSettings: const DataLabelSettings(
                              useSeriesColor: true,
                              labelAlignment: ChartDataLabelAlignment.auto,
                              textStyle: TextStyle(fontSize: 10),
                              showZeroValue: false,
                              isVisible: true,
                              labelPosition: ChartDataLabelPosition.outside,
                              showCumulativeValues: true,
                              borderRadius: 7,
                            )
                        ),

                      if(dados==null && dadosList!=null)
                        for(var dados in dadosList)
                          AreaSeries<ChartData, String>(
                              dataSource: dados,
                              xValueMapper: (ChartData data, _) => data.nome,
                              yValueMapper: (ChartData data, _) => data.valor,
                              dataLabelMapper: (ChartData data, _) => data.type == int
                                  ? '${Features.toFormatNumber(data.valor.toString(), qtCasasDecimais: 0)}'
                                  : 'R\$ ${Features.toFormatNumber(data.valor.toString())}',
                              pointColorMapper: (ChartData data, _) => data.color,
                              color: dados[0].color,
                              enableTooltip: true,
                              animationDuration: 2,
                              markerSettings: MarkerSettings(
                                  isVisible: true,
                                  height: 4,
                                  width: 4,
                                  shape: DataMarkerType.circle,
                                  borderWidth: 3,
                                  borderColor: Colors.red
                              ),
                              dataLabelSettings: const DataLabelSettings(
                                useSeriesColor: true,
                                labelAlignment: ChartDataLabelAlignment.auto,
                                textStyle: TextStyle(fontSize: 10),
                                showZeroValue: false,
                                isVisible: true,
                                labelPosition: ChartDataLabelPosition.outside,
                                showCumulativeValues: true,
                                borderRadius: 7,
                              )
                          ),
                    ]
                ),
                const SizedBox(height: 30,),
              ],
            );


  Widget sfCircularChart({required List<ChartData> dados})=>
      SfCircularChart(
          series: <CircularSeries>[
            PieSeries<ChartData, String>(
                dataSource: dados,
                xValueMapper: (ChartData data, _) => data.nome,
                yValueMapper: (ChartData data, _) => data.perc,
                dataLabelMapper: (ChartData data, _) => '${Features.formatarTextoPrimeirasLetrasMaiusculas(data.nome)}\n${Features.toFormatNumber((data.perc).toString().replaceAll('_', ' '), qtCasasDecimais: 0)}% ',
                pointColorMapper: (ChartData data, _) => data.color,
                radius: '60%',
                legendIconType: LegendIconType.diamond,
                enableTooltip: true,
                groupTo: 40,
                groupMode: CircularChartGroupMode.point,
                dataLabelSettings: const DataLabelSettings(
                  useSeriesColor: true,
                  labelAlignment: ChartDataLabelAlignment.auto,
                  textStyle: TextStyle(fontSize: 12),
                  showZeroValue: false,
                  margin: EdgeInsets.only(left: 3, right: 2),
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                  showCumulativeValues: true,
                  borderRadius: 7,
                  connectorLineSettings: ConnectorLineSettings(
                    width: 2,
                    type: ConnectorType.curve,
                    length: '25%',
                  ),
                  // labelIntersectAction: 'shift'
                )
            )
          ]
      );
}