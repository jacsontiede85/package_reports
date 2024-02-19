import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:open_filex/open_filex.dart';
import 'package:package_reports/report_module/core/features.dart';
import 'package:path_provider/path_provider.dart';
import 'report_from_json_controller.dart';
import '../widget/xlsx_widget.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:universal_html/html.dart' show AnchorElement;

class ReportToXLSXController extends WidgetReportXLSX {
  String xlsxFileName = "";

  //CONSTRUCTOR
  ReportToXLSXController({required String title, required ReportFromJSONController reportFromJSONController}) {
    createExcel(title: title, reportFromJSONController: reportFromJSONController);
  }

  Future<void> createExcel({required String title, required ReportFromJSONController reportFromJSONController}) async {
    reportFromJSONController.loading = true;
    xlsxFileName = 'Rel-${Features.getDataHoraNomeParaArquivo()}';

    // Create a new Excel Document.
    final Workbook workbook = Workbook();

    // Accessing sheet via index.
    Worksheet sheet = workbook.worksheets[0];

    sheet.name = xlsxFileName;

    // formatação de celulas
    Style cabecalhoStyle = styleCabecalho(workbook: workbook);
    Style colunasStyle = styleColunas(workbook: workbook);
    Style celulaCinzaStyle = styleCelulaCinza(workbook: workbook);
    Style celulaBrancoStyle = styleCelulaBranco(workbook: workbook);

    /////////////////////////////////////////////////// CABEÇALHO
    int linha = 1;
    int coluna = 1;

    tilulo(
      sheet: sheet, 
      titulo: title, 
      linha: linha, 
      coluna: coluna, 
      cabecalhoStyle: cabecalhoStyle, 
      totalColunas: reportFromJSONController.colunas.where((element) => element['selecionado'] == true).length,
    );

    ///////////////////////////////////////////////////  COLUNAS
    linha = linha + 1;
    coluna = 1;

    colunas(
      sheet: sheet, 
      linha: linha, 
      coluna: coluna, 
      colunasStyle: colunasStyle, 
      colunasList: reportFromJSONController.colunas.where((element) => element['selecionado'] == true), 
      rowHeight: reportFromJSONController.getHeightColunasCabecalho * 0.5,
    );

    /////////////////////////////////////////////////// LINHAS
    linha = linha + 1;
        for (Map<String,dynamic> map in reportFromJSONController.dados) {

      coluna=1;
      for (var colunas in reportFromJSONController.colunas){
        if(colunas['selecionado']){
          map.forEach((key, value) {

            Style style = linha%2==0 ? celulaCinzaStyle : celulaBrancoStyle;
          
            if(!key.toString().contains('__INVISIBLE') && colunas['key'] == key.toString()){
              celulaText(
                sheet: sheet, 
                linha: linha, 
                coluna: coluna, 
                style: style, 
                text: value,
              );              
            }

          });  
          coluna++;            
        }
      }

      linha++;
    }

    /////////////////////////////////////////////////// OPEN FILE
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    if (kIsWeb) {
      AnchorElement( href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')..setAttribute('download', '$xlsxFileName.xlsx')..click();
    } else {
      final String path = (await getApplicationSupportDirectory()).path;
      final String fileName = Platform.isWindows ? '$path\\$xlsxFileName.xlsx' : '$path/$xlsxFileName.xlsx';
      final File file = File(fileName);
      await file.writeAsBytes(bytes, flush: true);
      var res = await OpenFilex.open(fileName);
      if (res.message != 'done') {
        // printW("Nenhum APP encontrado para abrir este arquivo。${res.message}");
      }
    }

    reportFromJSONController.loading = false;
  }
}

class WidgetReportXLSX extends WidgetXLSX {
  var list = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'AA', 'AB', 'AC', 'AD', 'AE', 'AF', 'AG', 'AH', 'AI', 'AJ', 'AK', 'AL', 'AM', 'AN', 'AO', 'AP', 'AQ', 'AR', 'AS', 'AT', 'AU', 'AV', 'AW', 'AX', 'AY', 'AZ'];
  @override
  Worksheet tilulo({required Worksheet sheet, required int linha, required int coluna, required Style cabecalhoStyle, required String titulo, int totalColunas = 1}) {
    sheet.getRangeByName('A$linha:${list[totalColunas - 1]}$linha').merge();
    sheet.getRangeByIndex(linha, coluna).cellStyle = cabecalhoStyle;
    Range range = sheet.getRangeByIndex(linha, coluna);
    range.setText(titulo);
    range.autoFitColumns();
    return sheet;
  }

  @override
  colunas({required Worksheet sheet, required linha, required coluna, required Style colunasStyle, required colunasList, double rowHeight = 30}) {
    for (var value in colunasList) {
      if (value['type'] == double || value['type'] == int) colunasStyle.hAlign = HAlignType.right;
      sheet.setRowHeightInPixels(linha, rowHeight);
      sheet.getRangeByIndex(linha, coluna).cellStyle = colunasStyle;
      sheet.getRangeByIndex(linha, coluna).setText(Features.formatarTextoPrimeirasLetrasMaiusculas(value['nomeFormatado']));
      Range range = sheet.getRangeByIndex(linha, coluna);
      range.cellStyle.wrapText = true;
      coluna++;
    }
  }

  @override
  celulaText({
    required Worksheet sheet, 
    required int linha, 
    required int coluna, 
    required Style style, 
    required text, 
    bool? autoFitColumns, 
    bool? laguraFixa, 
    bool? larguraTitulo,
  }) {
    sheet.getRangeByIndex(linha, coluna).cellStyle = style;
    Range range = sheet.getRangeByIndex(linha, coluna);

    if (text == 'NaN') text = 0.0;

    //FLUTUANTE
    if (text.runtimeType == double) {
      range.setNumber(99999999999.999); //forçar uma largura fixa
      range.autoFitColumns();
      range.setNumber(text);
      range.numberFormat = '#,##0.00'; // valor formatado com duas casas decimais

      //INTEIRO
    } else if (text.runtimeType == int) {
      range.setNumber(999999999); //forçar uma largura fixa
      range.autoFitColumns();
      range.setNumber(double.parse(text.toString()));
      range.numberFormat = '#,##0'; // valor formatado sem casas decimais

      //STRING
    } else {
      range.setText(text.toString());
      range.autoFitColumns();
    }
  }
}
