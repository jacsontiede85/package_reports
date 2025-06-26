
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:package_reports/global/core/features.dart';
import 'package:package_reports/report_module/controller/report_from_json_controller.dart';

mixin Rows {
  static rowTextFormatted({
    required ReportFromJSONController controller,
    required double width,
    required String key,
    required Type type,
    required dynamic value,
    required Function setStateRows,
    required BuildContext context,
    bool isTitle = false,
    bool isRodape = false,
    bool isSelected = false,
    bool isFiltered = false,
    Map<String,dynamic>? element,
    String order = 'asc',
    Color? cor,
    double? height,
  }) {
    double fontSize = 12;
    return GestureDetector(
      onLongPressStart: !isRodape ? null : (LongPressStartDetails details) {
        _showContextMenu(context, details.globalPosition, controller: controller, setStateRows: setStateRows, element: element!);
      },
      child: Listener(
        onPointerDown: !isRodape ? null : (PointerDownEvent event) {
          if (event.kind == PointerDeviceKind.mouse && event.buttons == kSecondaryMouseButton) {
            _showContextMenu(context, event.position, controller: controller, setStateRows: setStateRows, element: element!);
          }
        },
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                color: cor ??
                    (isTitle
                        ? Colors.grey[40]
                        : isRodape
                            ? Colors.black54
                            : Colors.grey[300]),
                border: Border.all(
                  color: Colors.purple.withValues(alpha: 0.35),
                  width: 0.25,
                ),
              ),
              padding: EdgeInsets.only(left: 5, right: 5, bottom: isRodape ? 5 : 0),
              alignment: (isTitle)
                  ? Alignment.centerLeft
                  : type != String
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
              child: Text(
                type == DateTime
                    ? value.toString()
                    : type == String || isTitle
                        ? Features.formatarTextoPrimeirasLetrasMaiusculas(value.toString().replaceAll('_', ' '))
                        : type == double
                            ? Features.toFormatNumber(value.toString().replaceAll('_', ' '))
                            : type == int
                                ? Features.toFormatInteger(
                                    value.toString().replaceAll('_', ' '),
                                  )
                                : value.toString(),
                style: TextStyle(
                  fontWeight: isRodape || isTitle ? FontWeight.bold : FontWeight.normal,
                  fontSize: fontSize,
                  color: isRodape ? Colors.white : Colors.black,
                ),
              ),
            ),
            if (isTitle && isSelected)
              Positioned(
                left: 0,
                bottom: -10,
                child: IconButton(
                  icon: Icon(
                    order == 'asc' ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 17,
                    color: Colors.blueAccent,
                  ),
                  onPressed: null,
                ),
              ),
            if (isTitle)
              Positioned(
                right: 0,
                bottom: -10,
                child: PopupMenuButton(
                  tooltip: "",
                  splashRadius: 1,
                  position: PopupMenuPosition.under,
                  constraints: const BoxConstraints(
                    maxHeight: 400,
                    minWidth: 90,
                  ),
                  icon: Icon(
                    isFiltered ? Icons.filter_alt_outlined : Icons.arrow_drop_down_outlined,
                    size: 22,
                    color: Colors.blue,
                  ),
                  itemBuilder: (context) {
                    return controller.createlistaFiltrarLinhas(chave: key).map((e) {
                      return PopupMenuItem(
                        padding: EdgeInsets.zero,
                        child: Observer(
                          builder: (_) => CheckboxListTile(
                            value: e.selecionado,
                            title: Text(e.valor.toString()),
                            onChanged: (v) {
                              e.selecionado = !e.selecionado;
                              if (e.selecionado) {
                                controller.colunasFiltradas.add(e.coluna);
                              } else {
                                controller.colunasFiltradas.removeWhere((element) => element == e.coluna);
                              }
                              setStateRows(() {
                                if (e.selecionado) {
                                  controller.filtrosSelected.add(
                                    {"coluna": e.coluna, "valor": e.valor},
                                  );
                                } else {
                                  controller.filtrosSelected.removeWhere((element) => element['coluna'] == e.coluna && element['valor'] == e.valor);
                                }
                                controller.getTheSelectedFilteredRows();
                                controller.dadosFiltered();
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              )
          ],
        ),
      ),
    );
  }

  static void _showContextMenu(BuildContext context, Offset position, {required ReportFromJSONController controller, required Function setStateRows,required Map<String,dynamic> element}) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        overlay.size.width - position.dx,
        overlay.size.height - position.dy,
      ),
      items: const [
        PopupMenuItem<bool>(
          value: false,
          child: Text('Soma'),
        ),
        PopupMenuItem<bool>(
          value: true,
          child: Text('Media'),
        ),
      ],
    ).then((valor) {
      setStateRows ((){
        if(valor != null){
          for (var value in controller.colunas) {
            if (value['key'] == element['key']) {
              value['isMedia'] = valor;
            }
          } 
        }        
      });

    });
  }

  static Widget rowTextComLable({
    required ReportFromJSONController controller,
    required double width,
    double? height,
    required key,
    required Type type,
    required value,
  }) {
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(
              color: Colors.purple.withValues(alpha: 0.5),
              width: 0.25,
            ),
          ),
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
          alignment: Alignment.center,
          child: Column(
            children: [
              Text(
                key,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                  color: Colors.black,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  type == DateTime
                      ? value.toString()
                      : type == String
                          ? Features.formatarTextoPrimeirasLetrasMaiusculas(value.toString().replaceAll('_', ' '))
                          : type == double
                              ? Features.toFormatNumber(value.toString().replaceAll('_', ' '))
                              : type == int
                                  ? Features.toFormatInteger(
                                      value.toString().replaceAll('_', ' '),
                                    )
                                  : value.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
