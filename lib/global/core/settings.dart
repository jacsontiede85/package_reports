import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:package_reports/filtro_module/model/filtros_pagina_atual_model.dart';

mixin class SettingsReports{
  static String enderecoRepositorio = '';
  static int matricula = 0;
  static String bancoDeDados = '';

  static Map<String,dynamic> mapJsonFiltroBusca = {};
  static Map mapFiltroSalvo = {};

  static ObservableList<FiltrosPageAtual> listaFiltrosParaConstruirTelaTemp = ObservableList<FiltrosPageAtual>.of([]);

  setEnderecoApi({required String enderecoUrl}) => enderecoRepositorio = enderecoUrl;
  setMatricula({required int matriculaUsu}) => matricula = matriculaUsu;
  setBancoDeDados({required String banco}) => bancoDeDados = banco;

  static getDataPTBR() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(now);
  }
  
  static String formatarDataPadraoBR({required String data}) {
    List date = data.split(' ');
    date = date[0].toString().split('-');
    data = '${date[2]}/${date[1]}/${date[0]}';
    return data;
  }

  Future<String> selectDate({required BuildContext context}) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('pt_BR'),
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
      return formatarDataPadraoBR(data: "${selectedDate.toLocal()}");
    }
    return formatarDataPadraoBR(data: "${DateTime.now().toLocal()}");
  }

  static int qtdDiasDoMes(int mes, int ano) {
    switch (mes) {
      case 1:
        return 31;
      case 2:
        if (ano == 2000 || ano == 2004 || ano == 2008 || ano == 2012 || ano == 2016 || ano == 2020 || ano == 2024 || ano == 2028 || ano == 2032 || ano == 2036 || ano == 2040 || ano == 2044 || ano == 2048 || ano == 2052 || ano == 2056 || ano == 2060) {
          return 29;
        } else {
          return 28;
        }
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

  static int diaDaSemanaConverte({required String dia}) {
    switch (dia) {
      case 'dom.':
        return 0;
      case 'seg.':
        return 1;
      case 'ter.':
        return 2;
      case 'qua.':
        return 3;
      case 'qui.':
        return 4;
      case 'sex.':
        return 5;
      case 'sáb.':
        return 6;
      default:
        return 1;
    }
  }

}