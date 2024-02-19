import 'package:flutter/material.dart';

class FiltrosReport {
  FiltrosReport({
    required BuildContext context,
    required Function function,
  }) {
    context = context;
    function = function;
    filtros = IconButton(
      icon: const Icon(
        Icons.filter_alt_outlined,
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
