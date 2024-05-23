// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

class WidgetXLSX {
  String? titulo;

  Style styleCabecalho({required workbook}) {
    //------------- FORMATAÇÃO CABEÇALHO
    //Defining a global style with all properties.
    Style style = workbook.styles.add('cabecalho');
    //set back color by hexa decimal.
    style.backColor = '#1B4F72';
    //set font color by hexa decimal.
    style.fontColor = '#FFFFFF';
    //set font italic.
    style.italic = true;
    //set font bold.
    style.bold = true;
    style.fontSize = 12.0;
    return style;
  }

  Style styleColunas({required workbook}) {
    //------------- FORMATAÇÃO COLUNAS
    //Defining a global style with all properties.
    Style style = workbook.styles.add('colunas');
    //set back color by hexa decimal.
    style.backColor = '#1B4F72';
    //set font color by hexa decimal.
    style.fontColor = '#FFFFFF';
    //set font italic.
    style.italic = true;
    //set font bold.
    style.bold = true;
    style.fontSize = 9.0;
    return style;
  }

  Style styleCelulaCinza({required workbook}) {
    //-------------FORMATAÇÃO LINHA CINZA
    //Defining a global style with all properties.
    Style style = workbook.styles.add('linha');
    //set back color by hexa decimal.
    style.backColor = '#EAE7E6';
    //set font color by hexa decimal.
    style.fontColor = '#000000';
    //set font italic.
    style.italic = true;
    //set font bold.
    style.bold = false;
    return style;
  }

  Style styleCelulaBranco({required workbook}) {
    //-------------FORMATAÇÃO LINHA BRANCO
    //Defining a global style with all properties.
    Style style = workbook.styles.add('linha1');
    //set back color by hexa decimal.
    style.backColor = '#FFFFFF';
    //set font color by hexa decimal.
    style.fontColor = '#000000';
    //set font italic.
    style.italic = true;
    //set font bold.
    style.bold = false;
    return style;
  }

  Worksheet tilulo({required Worksheet sheet, required int linha, required int coluna, required Style cabecalhoStyle, required String titulo}) {
    this.titulo = titulo;
    sheet.getRangeByName('A$linha:E$linha').merge();
    sheet.getRangeByIndex(linha, coluna).cellStyle = cabecalhoStyle;
    Range range = sheet.getRangeByIndex(linha, coluna);
    range.setText(titulo);
    range.autoFitColumns();
    return sheet;
  }

  colunas({required Worksheet sheet, required int linha, required int coluna, required Style colunasStyle, required colunasList}) {
    for (int index = 0; index < colunasList.length; index++) {
      sheet.getRangeByIndex(linha, coluna).cellStyle = colunasStyle;
      sheet.getRangeByIndex(linha, coluna).setText(colunasList[index]);
      Range range = sheet.getRangeByIndex(linha, coluna);
      range.cellStyle.wrapText = true;
      coluna++;
    }
  }

  celulaText({required Worksheet sheet, required int linha, required int coluna, required Style style, required text, bool? autoFitColumns, bool? laguraFixa, bool? larguraTitulo}) {
    sheet.getRangeByIndex(linha, coluna).cellStyle = style;
    Range range = sheet.getRangeByIndex(linha, coluna);
    if (larguraTitulo ?? false) {
      range.setText('$titulo$titulo------------'); //forçar primeira celula ficar com a largura do titulo
      range.autoFitColumns();
      range.setText(text);
    }

    if (laguraFixa ?? false) {
      range.setText('-------------'); //forçar uma largura fixa
      range.autoFitColumns();
      range.setText(text);
    } else {
      range.setText(text);
    }

    if (!(larguraTitulo ?? false)) if (!(laguraFixa ?? false)) if (autoFitColumns ?? true) range.autoFitColumns();
  }

  celulaNumber({required sheet, required linha, required coluna, required style, required number, bool? laguraFixa}) {
    sheet.getRangeByIndex(linha, coluna).cellStyle = style;
    Range range = sheet.getRangeByIndex(linha, coluna);
    double num;

    if (number == 'NaN') {
      number = 0.0;
    }

    if (number.runtimeType.toString() == 'double')
      num = number;
    else
      num = double.parse(number ?? '0.0');
    if (laguraFixa != null)
      range.setNumber(99999999999.999); //forçar uma largura fixa
    else
      range.setNumber(num);
    range.autoFitColumns();
    range.setNumber(num);
    range.numberFormat = '#,##0.00'; // valor formatado
  }
}
