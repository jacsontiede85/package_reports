import 'package:flutter/material.dart';

class TipoTexto {
  static const String grande = 'grandes';
  static const String titulo = 'titulo';
  static const String legenda = 'legenda';
  static const String corpoGrande = 'corpo_grande';
  static const String corpoNegrito = 'corpo_negrito';
  static const String corpo = 'corpo';
  static const String rubrica = 'rubrica';
}

class Texto extends StatelessWidget {
  final dynamic texto;
  final String tipo;
  final Color cor;
  const Texto({super.key, required this.texto, this.tipo = TipoTexto.corpo, this.cor = Colors.white});

  @override
  Widget build(BuildContext context) {
    double scale = 1.0;
    Typography typography = Theme.of(context).typography;
    // typography = typography.black.bodyLarge?.apply(backgroundColor: cor);

    switch (tipo) {
      case 'grande':
        return SelectableText(
          texto, 
          style: typography.black.bodyLarge?.apply(fontSizeFactor: scale),
        );
      case 'titulo':
        return SelectableText(
          texto, 
          style: typography.black.titleMedium?.apply(fontSizeFactor: scale),
        );
      case 'legenda':
        return SelectableText(
          texto, 
          style: typography.black.labelMedium?.apply(fontSizeFactor: scale),
        );
      case 'corpo_grande':
        return SelectableText(
          texto, 
          style: typography.black.bodyLarge?.apply(fontSizeFactor: scale),
        );
      case 'corpo_negrito':
        return SelectableText(
          texto, 
          style: const TextStyle(
            fontFamily: 'typography.black.bodyMedium',
            fontWeight: FontWeight.bold,
          ),
        );
      case 'corpo':
        return SelectableText(
          texto, 
          style: typography.black.bodyMedium?.apply(fontSizeFactor: scale),
        );
      case 'rubrica':
        return SelectableText(
          texto, 
          style: const TextStyle(
            fontFamily: 'typography.black.bodyMedium',
            fontStyle: FontStyle.italic,
          ),
        );
      default:
        return const Text("");
    }
  }
}
