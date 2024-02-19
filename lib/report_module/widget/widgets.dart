import 'package:fluent_ui/fluent_ui.dart';
import 'package:package_reports/report_module/widget/texto.dart';

class Widgets{
  Widget wpHeader({
    required String titulo,
    Color cor = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 24),
      child: Texto(
        texto: titulo,
        tipo: TipoTexto.titulo,
        cor: cor,
      ),
    );
  }
}