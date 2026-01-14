import 'package:flutter/material.dart';

class TituloCards extends StatelessWidget {
  
  final String titulo;
  const TituloCards({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo.toUpperCase(),
      style: TextStyle(
        fontSize: 14.0,
        color: Theme.of(context).brightness == Brightness.light ? Colors.green[700] : Colors.greenAccent[200],
        fontWeight: FontWeight.w700,
      ),
      textAlign: TextAlign.left,
    );
  }
}