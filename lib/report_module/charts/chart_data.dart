import 'package:flutter/material.dart';

class ChartData{
  String nome;
  double valor;
  String? valorDeLabel;
  double? perc;
  Color? color;
  late Type type; //controlar o tipo de dados da variavel valor para formatação
  String? title; //para graficos com titulo
  ChartData({required this.nome, required this.valor, this.perc, this.color, this.type=double, this.title='', this.valorDeLabel});
}

abstract class ColorData{
  static List<Color> cores =[
    Colors.red.shade900,
    Colors.pink.shade900,
    Colors.purple.shade900,
    Colors.deepPurple.shade900,
    Colors.indigo.shade900,
    Colors.blue.shade900,
    Colors.lightBlue.shade900,
    Colors.cyan.shade900,
    Colors.teal.shade900,
    Colors.green.shade900,
    Colors.lightGreen.shade900,
    Colors.lime.shade900,
    Colors.yellow.shade900,
    Colors.amber.shade900,
    Colors.orange.shade900,
    Colors.deepOrange.shade900,
    Colors.brown.shade900,
    Colors.blueGrey.shade900,
    Colors.red.shade800,
    Colors.pink.shade800,
    Colors.purple.shade800,
    Colors.deepPurple.shade800,
    Colors.indigo.shade800,
    Colors.blue.shade800,
    Colors.lightBlue.shade800,
    Colors.cyan.shade800,
    Colors.teal.shade800,
    Colors.green.shade800,
    Colors.lightGreen.shade800,
    Colors.lime.shade800,
    Colors.yellow.shade800,
    Colors.amber.shade800,
    Colors.orange.shade800,
    Colors.deepOrange.shade800,
    Colors.brown.shade800,
    Colors.blueGrey.shade800,
    Colors.red.shade700,
    Colors.pink.shade700,
    Colors.purple.shade700,
    Colors.deepPurple.shade700,
    Colors.indigo.shade700,
    Colors.blue.shade700,
    Colors.lightBlue.shade700,
    Colors.cyan.shade700,
    Colors.teal.shade700,
    Colors.green.shade700,
    Colors.lightGreen.shade700,
    Colors.lime.shade700,
    Colors.yellow.shade700,
    Colors.amber.shade700,
    Colors.orange.shade700,
    Colors.deepOrange.shade700,
    Colors.brown.shade700,
    Colors.blueGrey.shade700,
    Colors.redAccent.shade700,
    Colors.pinkAccent.shade700,
    Colors.purpleAccent.shade700,
    Colors.deepPurpleAccent.shade700,
    Colors.indigoAccent.shade700,
    Colors.blueAccent.shade700,
    Colors.lightBlueAccent.shade700,
    Colors.cyanAccent.shade700,
    Colors.tealAccent.shade700,
    Colors.greenAccent.shade700,
    Colors.lightGreenAccent.shade700,
    Colors.limeAccent.shade700,
    Colors.yellowAccent.shade700,
    Colors.amberAccent.shade700,
    Colors.orangeAccent.shade700,
    Colors.deepOrangeAccent.shade700,
    Colors.red.shade600,
    Colors.pink.shade600,
    Colors.purple.shade600,
    Colors.deepPurple.shade600,
    Colors.indigo.shade600,
    Colors.blue.shade600,
    Colors.lightBlue.shade600,
    Colors.cyan.shade600,
    Colors.teal.shade600,
    Colors.green.shade600,
    Colors.lightGreen.shade600,
    Colors.lime.shade600,
    Colors.yellow.shade600,
    Colors.amber.shade600,
    Colors.orange.shade600,
    Colors.deepOrange.shade600,
    Colors.brown.shade600,
    Colors.blueGrey.shade600,
    Colors.red.shade500,
    Colors.pink.shade500,
    Colors.purple.shade500,
    Colors.deepPurple.shade500,
    Colors.indigo.shade500,
    Colors.blue.shade500,
    Colors.lightBlue.shade500,
    Colors.cyan.shade500,
    Colors.teal.shade500,
    Colors.green.shade500,
    Colors.lightGreen.shade500,
    Colors.lime.shade500,
    Colors.yellow.shade500,
    Colors.amber.shade500,
    Colors.orange.shade500,
    Colors.deepOrange.shade500,
    Colors.brown.shade500,
    Colors.blueGrey.shade500,
    Colors.red.shade400,
    Colors.pink.shade400,
    Colors.purple.shade400,
    Colors.deepPurple.shade400,
    Colors.indigo.shade400,
    Colors.blue.shade400,
    Colors.lightBlue.shade400,
    Colors.cyan.shade400,
    Colors.teal.shade400,
    Colors.green.shade400,
    Colors.lightGreen.shade400,
    Colors.lime.shade400,
    Colors.yellow.shade400,
    Colors.amber.shade400,
    Colors.orange.shade400,
    Colors.deepOrange.shade400,
    Colors.brown.shade400,
    Colors.blueGrey.shade400,
    Colors.redAccent.shade400,
    Colors.pinkAccent.shade400,
    Colors.purpleAccent.shade400,
    Colors.deepPurpleAccent.shade400,
    Colors.indigoAccent.shade400,
    Colors.blueAccent.shade400,
    Colors.lightBlueAccent.shade400,
    Colors.cyanAccent.shade400,
    Colors.tealAccent.shade400,
    Colors.greenAccent.shade400,
    Colors.lightGreenAccent.shade400,
    Colors.limeAccent.shade400,
    Colors.yellowAccent.shade400,
    Colors.amberAccent.shade400,
    Colors.orangeAccent.shade400,
    Colors.deepOrangeAccent.shade400,
    Colors.red.shade300,
    Colors.pink.shade300,
    Colors.purple.shade300,
    Colors.deepPurple.shade300,
    Colors.indigo.shade300,
    Colors.blue.shade300,
    Colors.lightBlue.shade300,
    Colors.cyan.shade300,
    Colors.teal.shade300,
    Colors.green.shade300,
    Colors.lightGreen.shade300,
    Colors.lime.shade300,
    Colors.yellow.shade300,
    Colors.amber.shade300,
    Colors.orange.shade300,
    Colors.deepOrange.shade300,
    Colors.brown.shade300,
    Colors.blueGrey.shade300,
    Colors.red.shade200,
    Colors.pink.shade200,
    Colors.purple.shade200,
    Colors.deepPurple.shade200,
    Colors.indigo.shade200,
    Colors.blue.shade200,
    Colors.lightBlue.shade200,
    Colors.cyan.shade200,
    Colors.teal.shade200,
    Colors.green.shade200,
    Colors.lightGreen.shade200,
    Colors.lime.shade200,
    Colors.yellow.shade200,
    Colors.amber.shade200,
    Colors.orange.shade200,
    Colors.deepOrange.shade200,
    Colors.brown.shade200,
    Colors.blueGrey.shade200,
    Colors.redAccent.shade200,
    Colors.pinkAccent.shade200,
    Colors.purpleAccent.shade200,
    Colors.deepPurpleAccent.shade200,
    Colors.indigoAccent.shade200,
    Colors.blueAccent.shade200,
    Colors.lightBlueAccent.shade200,
    Colors.cyanAccent.shade200,
    Colors.tealAccent.shade200,
    Colors.greenAccent.shade200,
    Colors.lightGreenAccent.shade200,
    Colors.limeAccent.shade200,
    Colors.yellowAccent.shade200,
    Colors.amberAccent.shade200,
    Colors.orangeAccent.shade200,
    Colors.deepOrangeAccent.shade200,
  ];
}