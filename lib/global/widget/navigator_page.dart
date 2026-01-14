import 'package:flutter/material.dart';
import 'package:package_reports/filtro_module/page/itens_do_filtro.dart';
import 'package:package_reports/global/core/layout_controller.dart';

class NavigatorPage {

  Future<void> open({
    required BuildContext context,
    required Widget pagina,
    required LayoutControllerPackage layout
  }) async {
    if (layout.mobile || layout.tablet) {
      await _push(context, pagina);
      return;
    }
    switch (pagina.runtimeType) {
      case const (ItensFiltro):
        await _openDrawerDialog(context, pagina);
        return;

      default:
        await _push(context, pagina);
    }
  }

  Future<void> _push(BuildContext context, Widget pagina) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Material(
          color: Colors.transparent,
          child: pagina,
        ),
      ),
    );
  }

  Future<void> _openDrawerDialog(BuildContext context, Widget pagina) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54.withValues(alpha: 0.4),
      builder: (_) => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          Drawer(
            width: 500,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: pagina,
          ),
        ],
      ),
    );
  }
}
