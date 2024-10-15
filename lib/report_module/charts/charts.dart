import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:package_reports/global/core/features.dart';
import 'package:package_reports/report_module/charts/chart_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

mixin Charts {
  Widget barChartHorizontal({required List<ChartData> dados, Color? color, bool? isTransposed, String? numberFormatSymbol}) {
    return SfCartesianChart(
      margin: const EdgeInsets.all(20),
      plotAreaBorderWidth: 0.5,
      enableAxisAnimation: true,
      isTransposed: isTransposed ?? false,
      primaryXAxis: const CategoryAxis(
        labelStyle: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
        labelsExtent: 120,
        majorGridLines: MajorGridLines(width: 1),
        isInversed: true,
      ),
      primaryYAxis: NumericAxis(
        majorGridLines: const MajorGridLines(width: 1),
        numberFormat: NumberFormat.compactCurrency(symbol: numberFormatSymbol ?? ''),
        minimum: 0,
        rangePadding: ChartRangePadding.auto,
      ),
      series: [
        BarSeries<ChartData, String>(
          dataSource: dados,
          xValueMapper: (ChartData data, _) => Features.formatarTextoPrimeirasLetrasMaiusculas(data.nome),
          yValueMapper: (ChartData data, _) => data.valor,
          pointColorMapper: (ChartData data, _) => data.color ?? color,
          width: 1,
          spacing: 0.5,
          borderWidth: 1,
          borderColor: Colors.black,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          enableTooltip: true,
          dataLabelMapper: (ChartData data, _) {
            if (data.type == int) {
              return '${numberFormatSymbol ?? ''}${Features.toFormatNumber(data.valor.toString(), qtCasasDecimais: 0)}';
            } else {
              return '${numberFormatSymbol ?? 'R\$ '}${Features.toFormatNumber(data.valor.toString())}';
            }
          },
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            alignment: ChartAlignment.center,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 11,
            ),
            labelAlignment: ChartDataLabelAlignment.auto,
            angle: isTransposed ?? false ? 0 : 0,
          ),
        ),
      ],
    );
  }

  Widget sfLineCartesianChart({List<ChartData>? dados, List<List<ChartData>>? dadosList}) => dados == null && dadosList == null
      ? const SizedBox()
      : SfCartesianChart(
        title: ChartTitle(
          text: dados![0].title!.replaceRange(dados[0].title!.length - 2, dados[0].title!.length, ''),
          alignment: ChartAlignment.near,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          )
        ),
        primaryXAxis: const CategoryAxis(),
        margin: const EdgeInsets.all(10),
        series: [
          if (dados.isNotEmpty && dadosList == null)
            LineSeries<ChartData, String>(
              dataSource: dados,
              xValueMapper: (ChartData data, _) => data.nome,
              yValueMapper: (ChartData data, _) => data.valor,
              dataLabelMapper: (ChartData data, _) => data.type == int ? '${Features.toFormatNumber(data.valor.toString(), qtCasasDecimais: 0)}' : 'R\$ ${Features.toFormatNumber(data.valor.toString())}',
              pointColorMapper: (ChartData data, _) => data.color,
              width: 3,
              markerSettings: const MarkerSettings(
                isVisible: true,
                height: 4,
                width: 4,
                shape: DataMarkerType.circle,
                borderWidth: 3,
                borderColor: Colors.red,
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
              ),
            ),
          if (dados.isEmpty && dadosList != null)
            for (var value in dadosList)
              LineSeries<ChartData, String>(
                dataSource: value,
                xValueMapper: (ChartData data, _) => data.nome,
                yValueMapper: (ChartData data, _) => data.valor * 100,
                dataLabelMapper: (ChartData data, _) => '${Features.toFormatNumber((data.valor).toString().replaceAll('_', ' '), qtCasasDecimais: 1)}',
                pointColorMapper: (ChartData data, _) => data.color,
                enableTooltip: true,
                width: 3,
                markerSettings: const MarkerSettings(
                  isVisible: true,
                  height: 4,
                  width: 4,
                  shape: DataMarkerType.circle,
                  borderWidth: 3,
                  borderColor: Colors.red,
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
                ),
              ),
        ],
      );

  Widget sfAreaCartesianChart({List<ChartData>? dados, List<List<ChartData>>? dadosList}) {
    return (dados == null && dadosList == null)
        ? const SizedBox()
        : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (dados != null)
                if ((dados[0].title ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 0),
                    child: Text('${dados[0].title}'),
                  ),
              if (dadosList != null)
                if ((dadosList[1][0].title ?? '').isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 30, top: 0),
                    child: Text('${dadosList[1][0].title}'),
                  ),
              SfCartesianChart(
                primaryXAxis: const CategoryAxis(),
                margin: const EdgeInsets.only(left: 0, top: 15, right: 0, bottom: 0),
                series: <CartesianSeries>[
                  if (dados != null && dadosList == null)
                    AreaSeries<ChartData, String>(
                      dataSource: dados,
                      xValueMapper: (ChartData data, _) => data.nome,
                      yValueMapper: (ChartData data, _) => data.valor,
                      dataLabelMapper: (ChartData data, _) {
                        if (data.type == int) {
                          return '${Features.toFormatNumber(data.valor.toString(), qtCasasDecimais: 0)}';
                        } else {
                          return 'R\$ ${Features.toFormatNumber(data.valor.toString())}';
                        }
                      },
                      pointColorMapper: (ChartData data, _) => data.color,
                      color: dados[0].color,
                      enableTooltip: true,
                      markerSettings: const MarkerSettings(
                        isVisible: true,
                        height: 4,
                        width: 4,
                        shape: DataMarkerType.circle,
                        borderWidth: 3,
                        borderColor: Colors.red,
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
                      ),
                    ),
                  if (dados == null && dadosList != null)
                    for (var dados in dadosList)
                      AreaSeries<ChartData, String>(
                        dataSource: dados,
                        xValueMapper: (ChartData data, _) => data.nome,
                        yValueMapper: (ChartData data, _) => data.valor,
                        dataLabelMapper: (ChartData data, _) {
                          if (data.type == int) {
                            return '${Features.toFormatNumber(data.valor.toString(), qtCasasDecimais: 0)}';
                          } else {
                            return 'R\$ ${Features.toFormatNumber(data.valor.toString())}';
                          }
                        },
                        pointColorMapper: (ChartData data, _) => data.color,
                        color: dados[0].color,
                        enableTooltip: true,
                        markerSettings: const MarkerSettings(
                          isVisible: true,
                          height: 4,
                          width: 4,
                          shape: DataMarkerType.circle,
                          borderWidth: 3,
                          borderColor: Colors.red,
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
                        ),
                      ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          );
  }

  Widget sfCircularChart({required List<ChartData> dados}) {
    return SfCircularChart(
      series: <CircularSeries>[
        PieSeries<ChartData, String>(
          dataSource: dados,
          xValueMapper: (ChartData data, _) => data.nome,
          yValueMapper: (ChartData data, _) => data.perc,
          dataLabelMapper: (ChartData data, _) {
            return '${Features.formatarTextoPrimeirasLetrasMaiusculas(data.nome)}\n${Features.toFormatNumber((data.perc).toString().replaceAll('_', ' '), qtCasasDecimais: 0)}% ';
          },
          pointColorMapper: (ChartData data, _) => data.color,
          radius: '70%',
          legendIconType: LegendIconType.diamond,
          enableTooltip: true,
          groupTo: 40,
          groupMode: CircularChartGroupMode.point,
          dataLabelSettings: const DataLabelSettings(
            useSeriesColor: true,
            labelAlignment: ChartDataLabelAlignment.auto,
            textStyle: TextStyle(fontSize: 11),
            showZeroValue: false,
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            showCumulativeValues: true,
            borderRadius: 5,
            connectorLineSettings: ConnectorLineSettings(
              width: 2,
              type: ConnectorType.curve,
              length: '30%',
            ),
          ),
        )
      ],
    );
  }
}
