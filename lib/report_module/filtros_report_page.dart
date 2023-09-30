import 'package:fluent_ui/fluent_ui.dart';

class FiltrosReport {
  FiltrosReport({
    required BuildContext context,
    required Function function,
  }) {
    context = context;
    function = function;
    filtros = IconButton(
      icon: const Icon(
        FluentIcons.filter,
        color: Colors.white,
      ),
      onPressed: () {},
    );
  }
  late BuildContext context;
  late Function function;
  late Widget filtros;

  Widget get getFiltros => filtros;
}
