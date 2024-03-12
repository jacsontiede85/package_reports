import 'package:flutter/material.dart';

class ChartData{
  String nome;
  double valor;
  String? valorDeLabel;
  double? perc;
  Color? color;
  late Type type; //controlar o tipo de dados da variavel valor para formatação
  String? title; //para graficos com titulo
  ChartData({
    required this.nome, 
    required this.valor, 
    this.perc, 
    this.color, 
    this.type=double, 
    this.title = '', 
    this.valorDeLabel
  });
}