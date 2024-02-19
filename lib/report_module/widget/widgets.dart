import 'package:flutter/material.dart';
import 'package:package_reports/report_module/widget/texto.dart';

class Widgets{
  Widget wpHeader({
    required String titulo,
    Color cor = Colors.white,
  }) {
    return Texto(
      texto: titulo,
      tipo: TipoTexto.titulo,
      cor: cor,
    );
  }
}