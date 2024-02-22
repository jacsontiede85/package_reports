import 'package:flutter/material.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';

class FiltrosReport {
  FiltrosReport({
    required BuildContext context,
    required Function function,
  }) {
    context = context;
    function = function;
  }
  late BuildContext context;
  late Function function;
  FiltroController controlerFiltro = FiltroController(
    mapaFiltrosWidget: {},
  );

}
