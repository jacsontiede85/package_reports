// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Features{

  /// FORMATAÇÃO DE NUMEROS
  static var numberFormat = NumberFormat("#,##0.00", "pt_BR");

  static toDouble(String valor) {
    //1.001,01 -> 1001.01
    try {
      return double.parse(valor.replaceAll(".", "").replaceAll(",", "."));
    } catch (e) {
      return 0.0;
    }
  }

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

  static toFormatCalcPorcentagem({String? valorMenor, String? valorMaior}) {
    valorMenor = valorMenor!.replaceAll(",", ".");
    valorMaior = valorMaior!.replaceAll(",", ".");
    String porcentagem = '0,00';
    try {
      porcentagem = numberFormat.format((double.parse(valorMenor) / double.parse(valorMaior)) * 100);
    } catch (e) {
      porcentagem = '0,00';
    }
    if (porcentagem == 'NaN') return '0,00';
    return porcentagem;
  }

  static toFormatCalcMedia({String? valorMenor, String? valorMaior}) {
    valorMenor = valorMenor!.replaceAll(",", ".");
    valorMaior = valorMaior!.replaceAll(",", ".");
    String media = '0,00';
    try {
      media = numberFormat.format((double.parse(valorMaior) / double.parse(valorMenor)));
    } catch (e) {
      media = '0,00';
    }
    if (media == 'NaN') return '0,00';
    return media;
  }



  /// DATAS
  static getDataPTBR() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }

  static getDataUS() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  static getDataHoraPTBR() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    return formatter.format(now);
  }

  static getDataHoraNomeParaArquivo() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy-HH-mm-ss');
    return formatter.format(now);
  }

  static getAnoAtual() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy');
    return formatter.format(now);
  }

  static getAnoAnterior() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy');
    return "${(int.parse(formatter.format(now).toString())-1)}";
  }

  static getMesAtual() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MM');
    return formatter.format(now);
  }

  static formatarData(String dat) {
    List date = dat.split(' ');
    date = date[0].toString().split('-');
    dat = '${date[2]}/${date[1]}/${date[0]}';
    return dat;
  }

  static getQtdDiasDoMes(int mes, int ano) {
    switch (mes) {
      case 1:
        return 31;
      case 2:
        if (ano == 2000 || ano == 2004 || ano == 2008 || ano == 2012 || ano == 2016 || ano == 2020 || ano == 2024 || ano == 2028 || ano == 2032 || ano == 2036 || ano == 2040 || ano == 2044 || ano == 2048 || ano == 2052 || ano == 2056 || ano == 2060)
          return 29;
        else
          return 28;
      case 3:
        return 31;
      case 4:
        return 30;
      case 5:
        return 31;
      case 6:
        return 30;
      case 7:
        return 31;
      case 8:
        return 31;
      case 9:
        return 30;
      case 10:
        return 31;
      case 11:
        return 30;
      case 12:
        return 31;
      default:
        return 30;
    }
  }

  static getDiaDaSemanaConverte(var dia) {
    switch (dia) {
      case 'dom':
        return 0;
      case 'seg':
        return 1;
      case 'ter':
        return 2;
      case 'qua':
        return 3;
      case 'qui':
        return 4;
      case 'sex':
        return 5;
      case 'sáb':
        return 6;
    }
  }

  static getNomeMes(var mes) {
    switch (mes.toLowerCase()) {
      case 'janeiro':
        return 01;
      case 'fevereiro':
        return 2;
      case 'março':
        return 3;
      case 'abril':
        return 4;
      case 'maio':
        return 5;
      case 'junho':
        return 6;
      case 'julho':
        return 7;
      case 'agosto':
        return 8;
      case 'setembro':
        return 9;
      case 'outubro':
        return 10;
      case 'novembro':
        return 11;
      case 'dezembro':
        return 12;
    }
  }

  static Future<String> selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('pt'),
      initialDate: selectedDate,
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(2101),
      // builder: (BuildContext context, Widget child) {
      //   return Theme(
      //     data: ThemeData(primarySwatch: myColor),
      //     child: child,
      //   );
      // },
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      //print(selectedDate);
      return formatarData("${selectedDate.toLocal()}");
    }
    return formatarData("${DateTime.now().toLocal()}");
  }


  static formatarDataUS(String dat) {
    // saida 2023-07-03
    try {
      List date = dat.split(' ');
      date = date[0].toString().split('-');
      return '${date[0]}-${date[1]}-${date[2]}';
    } catch (e) {
      return dat;
    }
  }


  /// FORMATAÇÃO DE TEXTO
  static String formatarTextoSomentePrimeiraLetraMaiuscula(String txt) {
    try {
      return '${txt.substring(0, 1).toUpperCase()}${txt.substring(1, txt.length).toLowerCase()}';
    } catch (e) {
      return txt;
    }
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

  static String quebrarTextoParaBaixo({required String texto, int? tamanhoDoTexto}) {
    tamanhoDoTexto = tamanhoDoTexto??20;
    texto = texto;
    tamanhoDoTexto = tamanhoDoTexto;
    texto = texto.length > tamanhoDoTexto
        ? '${texto.substring(0, tamanhoDoTexto)}\n'
        '${texto.substring(tamanhoDoTexto, texto.length).length > tamanhoDoTexto ? "${texto.substring(tamanhoDoTexto, texto.length).substring(0, tamanhoDoTexto)}\n"
        "${texto.substring(tamanhoDoTexto, texto.length).substring(tamanhoDoTexto, texto.substring(tamanhoDoTexto, texto.length).length).length > tamanhoDoTexto ? texto.substring(tamanhoDoTexto, texto.length).substring(tamanhoDoTexto, texto.substring(tamanhoDoTexto, texto.length).length).substring(0, tamanhoDoTexto) : texto.substring(tamanhoDoTexto, texto.length).substring(tamanhoDoTexto, texto.substring(tamanhoDoTexto, texto.length).length)}" : texto.substring(tamanhoDoTexto, texto.length)}'
        : texto;
    return texto;
  }

  static String quebrarTextoParaBaixoPeloEspaco({required String texto}) {
    texto = texto.toString().replaceAll(" ", " \n");
    texto = "$texto ";
    return texto;
  }


  //Verificar se o e-mail é válido
  static bool isValidEmail({required String email}) {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9-.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(email);
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
