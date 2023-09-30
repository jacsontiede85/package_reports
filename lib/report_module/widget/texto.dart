import 'package:fluent_ui/fluent_ui.dart';

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
    assert(debugCheckHasFluentTheme(context));
    double scale = 1.0;
    Typography typography = FluentTheme.of(context).typography;
    typography = typography.apply(displayColor: cor);

    switch (tipo) {
      case 'grande':
        return Text(texto, style: typography.titleLarge?.apply(fontSizeFactor: scale));
      case 'titulo':
        return Text(texto, style: typography.title?.apply(fontSizeFactor: scale));
      case 'legenda':
        return Text(texto, style: typography.subtitle?.apply(fontSizeFactor: scale));
      case 'corpo_grande':
        return Text(texto, style: typography.bodyLarge?.apply(fontSizeFactor: scale));
      case 'corpo_negrito':
        return Text(texto, style: typography.bodyStrong?.apply(fontSizeFactor: scale));
      case 'corpo':
        return Text(texto, style: typography.body?.apply(fontSizeFactor: scale));
      case 'rubrica':
        return Text(texto, style: typography.caption?.apply(fontSizeFactor: scale));
      default:
        return const Text("");
    }
  }
}
