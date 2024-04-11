// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:intl/intl.dart';

class Features{

  /// FORMATAÇÃO DE NUMEROS
  static var numberFormat = NumberFormat("#,##0.00", "pt_BR");

  static toFormatNumber(String valor, {int? qtCasasDecimais}) {
    if (valor == 'NaN') return '0,00';
    if (valor == 'null') return '0,00';
    valor = valor.replaceAll(",", ".");
    try {
      var numberFormat = NumberFormat("#,##0.00", "pt_BR");
      if(qtCasasDecimais!=null)
        numberFormat = NumberFormat("#,##${double.parse('0.0').toStringAsFixed(qtCasasDecimais)}", "pt_BR");
      valor = numberFormat.format(double.parse(valor));
    } catch (e) {
      valor = '0,00';
    }
    //valor = valor.replaceAll(".", "0,");
    //if (valor == 'NaN') return '0,00';
    return valor;
  }

  static toFormatInteger(String? valor) {
    valor = valor!.replaceAll(",", ".");
    try {
      valor = NumberFormat("#,##0", "pt_BR").format(double.parse(valor));
      // valor = (double.parse(valor ?? 0.0)).toStringAsFixed(0).toString();
    } catch (e) {
      valor = '0';
    }
    if (valor == 'NaN') return '0';
    return valor;
  }

  /// DATAS

  static getDataHoraNomeParaArquivo() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy-HH-mm-ss');
    return formatter.format(now);
  }

  static formatarData(String dat) {
    List date = dat.split(' ');
    date = date[0].toString().split('-');
    dat = '${date[2]}/${date[1]}/${date[0]}';
    return dat;
  }

  static String formatarTextoPrimeirasLetrasMaiusculas(String txt) {
    try {
      List texto = txt.split(' ');
      txt = '';
      int i=0;
      for (var value in texto) {
        if(i>0 && (value=='DA'||value=='DE'||value=='DI'||value=='DO'||value=='DU'||value=='A'||value=='E'||value=='I'||value=='O'||value=='U'||value=='DOS'||value=='DAS'))
          txt = '$txt ${value.toString().toLowerCase()}';
        else
          txt = '$txt ${value.toString().substring(0, 1).toUpperCase()}${value.toString().substring(1, value.toString().length).toLowerCase()}';
        i++;
      }
      return txt.substring(1, txt.length).trim();
    } catch (e) {
      //--
    }
    return txt;
  }

  static String removerAcentos({required String string}){
    if(string.isEmpty)
      return '';
    var comAcento = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž()[]"\'!@#\$%&*+={}ªº,.;?/°|\\';
    var semAcento = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz()[]"\'!@#\$%&*+={}ªº,.;?/°|\\';
    for (int i = 0; i < comAcento.length; i++) {
      string = string.replaceAll(comAcento[i], semAcento[i]);
    }
    return string.replaceAll(' ', '-').toLowerCase();
  }

}
