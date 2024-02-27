
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

mixin class Settings{
  static String enderecoRepositorio = 'https://api.agnconsultoria.com.br/';

  static getDataPTBR() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }
  
  static formatarDataPadraoBR(String dat) {
    List date = dat.split(' ');
    date = date[0].toString().split('-');
    dat = '${date[2]}/${date[1]}/${date[0]}';
    return dat;
  }

  Future<String> selectDate({required BuildContext context}) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('pt'),
      initialDate: selectedDate,
      firstDate: DateTime(2000, 1),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return DatePickerDialog(      
          firstDate: DateTime(2000, 1),
          lastDate: DateTime(2101),
          cancelText: 'Cancelar',
          currentDate: selectedDate,
          
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      return formatarDataPadraoBR("${selectedDate.toLocal()}");
    }
    return formatarDataPadraoBR("${DateTime.now().toLocal()}");
  }

}

void printW(text) {
  print('\x1B[33m$text\x1B[0m');
}

void printE(text) {
  print('\x1B[31m$text\x1B[0m');
}

void printO(text) {
  print('\x1b[32m$text\x1B[0m');
}