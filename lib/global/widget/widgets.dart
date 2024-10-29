import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';
import 'package:package_reports/filtro_module/model/filtros_model.dart';
import 'package:package_reports/filtro_module/model/filtros_widget_model.dart';
import 'package:package_reports/filtro_module/page/itens_do_filtro.dart';
import 'package:package_reports/global/core/layout_controller.dart';
import 'package:package_reports/global/core/settings.dart';

class Widgets {
  Widget tituloCards({required String titulo, required BuildContext context}) {
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

  navigator({
    required dynamic pagina,
    required BuildContext context,
    bool isToShowFiltroNoMeio = false,
    required LayoutControllerPackage layout,
  }) async {
    if (layout.mobile || layout.tablet) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Material(
            color: Colors.transparent,
            child: pagina,
          ),
        ),
      );
    } else {
      switch (pagina.runtimeType) {
        case const (ItensFiltro):
          Widget widgetContrucao = Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Drawer(
                width: 500,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    topLeft: Radius.circular(15),
                  ),
                ),
                child: pagina,
              ),
            ],
          );
          await showDialog<void>(
            barrierColor: Colors.black54.withOpacity(0.4),
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => widgetContrucao,
          );
          break;
        default:
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Material(
                color: Colors.transparent,
                child: pagina,
              ),
            ),
          );
      }
    }
  }

  Widget selecaoDePeriodo({
    required FiltrosWidgetModel filtrosDados,
    required FiltroController controller,
    required BuildContext context,
    required String tipo,
  }) {
    return Builder(
      builder: (context) {
        if (tipo == 'datapickerfaturamento') {
          controller.validarSeDataSeraDeFaturamento();
        }
        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                tituloCards(
                  titulo: filtrosDados.titulo.toUpperCase(),
                  context: context,
                ),
                SizedBox(
                  width: 250,
                  child: Observer(
                    builder: (_) => Visibility(
                      visible: tipo == 'datapickerfaturamento',
                      child: CheckboxListTile(
                        value: controller.isDataFaturamento,
                        title: const Text('Data faturamento'),
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (c) {
                          controller.isDataFaturamento = !controller.isDataFaturamento;
                          controller.validarSeDataSeraDeFaturamento();
                        },
                      ),
                    ),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 10,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Observer(
                        builder: (_) => Text(
                          controller.dtinicio,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                      onPressed: () async {
                        controller.dtinicio = await SettingsReports().selectDate(
                          context: context,
                        );
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Observer(
                        builder: (_) => Text(
                          controller.dtfim,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                      onPressed: () async {
                        controller.dtfim = await SettingsReports().selectDate(
                          context: context,
                        );
                      },
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return controller.listaDePeriodos.map(
                          (valor) {
                            return PopupMenuItem(
                              value: valor.replaceAll(' ', ''),
                              child: Text(valor),
                            );
                          },
                        ).toList();
                      },
                      onSelected: (value) {
                        controller.selecaoDeDataPorPeriodo(periodo: value.toString(), isDataPadrao: true);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget selecaoDePeriodoMensal({
    required BuildContext context,
    required FiltrosWidgetModel filtrosDados,
    required FiltroController controller,
    required int index,
  }) {
    return Card(
      child: ListTile(
        title: tituloCards(titulo: filtrosDados.titulo.toUpperCase(), context: context),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Visibility(
              visible: filtrosDados.subtitulo.isNotEmpty,
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                alignment: Alignment.topLeft,
                child: Text(
                  filtrosDados.subtitulo,
                  style: const TextStyle(
                    fontSize: 11.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Observer(builder: (_) {
                return FutureBuilder(
                  future: controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index) == -1 ? 
                  controller.funcaoBuscarDadosDeCadaFiltro(
                    valor: controller.listaFiltrosParaConstruirTela[index].filtrosWidgetModel,
                    isBuscarDropDown: true,
                    index: index,
                    isDataMensal: true
                  ).then(
                    (value) {
                      controller.listaFiltrosCarregados[controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index)].valorSelecionadoParaDropDown = controller.listaFiltrosCarregados[controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index)].listaFiltros.first;
                    },
                  ) : null,
                  builder: (context, snapshot) {
                    return DropdownButton<FiltrosModel>(
                      value: controller.listaFiltrosCarregados[controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index)].valorSelecionadoParaDropDown,
                      isExpanded: true,
                      isDense: true,
                      onChanged: (value) {
                        controller.adicionarItensDropDown(index: index, valorSelecionado: value!);
                      },
                      hint: null,
                      items: controller.listaFiltrosCarregados[controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index)].listaFiltros.map((item) {
                        return DropdownMenuItem<FiltrosModel>(
                          value: item,
                          child: Text(
                            item.titulo,
                          ),
                        );
                      }).toList(),
                    );
                  }
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget selecaoDePeriodoNomeado({
    required FiltrosWidgetModel filtrosDados,
    required FiltroController controller,
    required BuildContext context,
    required String tipo,
  }) {
    return Builder(
      builder: (context) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                tituloCards(
                  titulo: filtrosDados.titulo.toUpperCase(),
                  context: context,
                ),
                SizedBox(
                  width: 250,
                  child: Observer(
                    builder: (_) => CheckboxListTile(
                      value: controller.mapaDatasNomeadas[filtrosDados.tipoFiltro]["isEnable"],
                      title: const Text('Desabilitar data'),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (c) {
                        controller.mapaDatasNomeadas.update(
                          filtrosDados.tipoFiltro, (value) {
                            return {
                              "dtinicio": value["dtinicio"],
                              "dtfim": value["dtfim"],
                              "isEnable": c
                            };
                          },);
                      },
                    ),
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 10,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Observer(
                        builder: (_) => Text(
                          controller.mapaDatasNomeadas[filtrosDados.tipoFiltro]["dtinicio"],
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                      onPressed: () async {
                        String data = await SettingsReports().selectDate(
                          context: context,
                        );
                        controller.mapaDatasNomeadas.update(
                          filtrosDados.tipoFiltro, (value) {
                            return {
                              "dtinicio": data,
                              "dtfim": value["dtfim"],
                              "isEnable": value["isEnable"]
                            };
                          },
                        );
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Observer(
                        builder: (_) => Text(
                          controller.mapaDatasNomeadas[filtrosDados.tipoFiltro]["dtfim"],
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                      onPressed: () async {
                        String data = await SettingsReports().selectDate(
                          context: context,
                        );
                        controller.mapaDatasNomeadas.update(
                          filtrosDados.tipoFiltro, (value) {
                            return {
                              "dtinicio": value["dtinicio"],
                              "dtfim": data,
                              "isEnable": value["isEnable"]
                            };
                          },
                        );
                      },
                    ),
                    PopupMenuButton(
                      itemBuilder: (context) {
                        return controller.listaDePeriodos.map(
                          (valor) {
                            return PopupMenuItem(
                              value: valor.replaceAll(' ', ''),
                              child: Text(valor),
                            );
                          },
                        ).toList();
                      },
                      onSelected: (value) {
                        Map res = controller.selecaoDeDataPorPeriodo(periodo: value.toString(), isDataPadrao: false);
                        controller.mapaDatasNomeadas.update(filtrosDados.tipoFiltro, (value) {
                          return {
                            "dtinicio": "${res["dtinicioFiltro"]}",
                            "dtfim": "${res["dtfimFiltro"]}",
                            "isEnable": value["isEnable"]
                          };
                        },);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget cardFiltroGeral({required BuildContext context, required FiltrosWidgetModel filtrosDados, required void Function()? onTap, required FiltroController controller, required int indexFiltro}) {
    return Card(
      child: ListTile(
        onTap: onTap,
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        title: tituloCards(titulo: filtrosDados.titulo.toUpperCase(), context: context),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Observer(
                  builder: (_) => Visibility(
                    visible: filtrosDados.tipoWidget == "checkboxrca",
                    child: Expanded(
                      child: CheckboxListTile(
                        splashRadius: 15,
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          "EXIBIR RCA SEM VENDAS",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: controller.isRCAsemVenda,
                        onChanged: (s) {
                          controller.isRCAsemVenda = !controller.isRCAsemVenda;
                          controller.validarCondicaoDebuscaRCA();
                        },
                      ),
                    ),
                  ),
                ),
                Observer(
                  builder: (_) => Visibility(
                    visible: filtrosDados.tipoWidget == "checkboxrca",
                    child: Expanded(
                      child: CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          "SOMENTE ATIVOS",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: controller.isRCAativo,
                        onChanged: (s) {
                          controller.isRCAativo = !controller.isRCAativo;
                          controller.validarCondicaoDebuscaRCA();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: filtrosDados.subtitulo.isNotEmpty,
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                alignment: Alignment.topLeft,
                child: Text(
                  filtrosDados.subtitulo,
                  style: const TextStyle(
                    fontSize: 11.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Observer(
                    builder: (_) => Wrap(
                      spacing: 2.0,
                      direction: Axis.horizontal,
                      children: [
                        Observer(
                          builder: (_) => Visibility(
                            visible: controller.listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.isEmpty,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[300],
                              ),
                              margin: const EdgeInsets.fromLTRB(1, 0, 0, 2),
                              padding: const EdgeInsets.fromLTRB(10, 2, 12, 2),
                              child: const Text(
                                "\u{2718} Sem filtro",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ),
                          ),
                        ),
                        for (FiltrosModel valores in controller.listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.take(20))
                          Observer(builder: (context) {
                            return Visibility(
                              visible: valores.selecionado,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[300],
                                ),
                                margin: const EdgeInsets.fromLTRB(1, 0, 0, 2),
                                padding: const EdgeInsets.fromLTRB(10, 2, 12, 2),
                                child: Text(
                                  "\u{2705} ${valores.codigo}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardSalvarFiltros ({required FiltrosWidgetModel filtrosDados, required BuildContext context, required void Function(bool)? onChanged}){
    return Card(
      margin: const EdgeInsets.only(top: 40, bottom: 10, left: 5, right: 5),
      elevation: 10,
      child: SwitchListTile(
        value: SettingsReports.isfiltrosSalvosApp,
        activeTrackColor: Colors.green,
        inactiveTrackColor: Colors.grey,
        title: tituloCards(
          titulo: "Salvar Filtros",
          context: context,
        ),
        subtitle: Text(
          filtrosDados.titulo,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        onChanged: onChanged
      )
    );
  }

  Widget cardFiltroDropDown({
    required BuildContext context,
    required FiltrosWidgetModel filtrosDados,
    required FiltroController controller,
    required int index,
  }) {
    return Card(
      child: ListTile(
        title: tituloCards(titulo: filtrosDados.titulo.toUpperCase(), context: context),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Visibility(
              visible: filtrosDados.subtitulo.isNotEmpty,
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                alignment: Alignment.topLeft,
                child: Text(
                  filtrosDados.subtitulo,
                  style: const TextStyle(
                    fontSize: 11.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: FutureBuilder(
                future: 
                controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index) == -1 ? 
                controller.funcaoBuscarDadosDeCadaFiltro(
                  valor: controller.listaFiltrosParaConstruirTela[index].filtrosWidgetModel,
                  isBuscarDropDown: true,
                  index: index,
                ).then(
                  (value) {
                    controller.listaFiltrosCarregados[controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index)].valorSelecionadoParaDropDown = controller.listaFiltrosCarregados[controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index)].listaFiltros.first;
                  },
                ) : null,
                builder: (context, snapshot) {
                  if (controller.listaFiltrosCarregados.where((element) => element.indexFiltros == index).toList().isNotEmpty) {
                    return DropdownButton<FiltrosModel>(
                      value: controller.listaFiltrosCarregados[controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index)].valorSelecionadoParaDropDown,
                      isExpanded: true,
                      isDense: true,
                      onChanged: (value) {
                        controller.listaFiltrosCarregados[controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index)].valorSelecionadoParaDropDown = value;
                        controller.adicionarItensDropDown(index: index, valorSelecionado: value!);
                    
                      },
                      hint: Text(controller.listaFiltrosCarregados[controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index)].valorSelecionadoParaDropDown!.titulo),
                      items: controller.listaFiltrosCarregados[controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index)].listaFiltros.map((item) {
                        return DropdownMenuItem<FiltrosModel>(
                          value: item,
                          child: Text(
                            item.titulo,
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return InkWell(
                      child: Container(
                        height: 25,
                        width: MediaQuery.sizeOf(context).width,
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.25))),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Text("NENHUM"),
                            ),
                            Icon(Icons.arrow_drop_down_sharp),
                          ],
                        ),
                      ),
                      onTap: () async {
                        await controller.funcaoBuscarDadosDeCadaFiltro(
                          valor: controller.listaFiltrosParaConstruirTela[index].filtrosWidgetModel,
                          isBuscarDropDown: true,
                          index: index,
                        );
                        controller.listaFiltrosCarregados[controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index)].valorSelecionadoParaDropDown = controller.listaFiltrosCarregados[controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index)].listaFiltros[0];
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardCampoDigitavel({
    required BuildContext context,
    required FiltrosWidgetModel filtrosDados,
    required FiltroController controller,
    required int index,
  }) {
    return Card(
      child: ListTile(
        title: tituloCards(titulo: filtrosDados.titulo, context: context),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Visibility(
              visible: filtrosDados.subtitulo.isNotEmpty,
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                alignment: Alignment.topLeft,
                child: Text(
                  filtrosDados.subtitulo,
                  style: const TextStyle(
                    fontSize: 11.0,
                  ),
                ),
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                filled: true,
                isDense: true,
                contentPadding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              onChanged: (value) {
                controller.filtrosSalvosParaAdicionarNoBody.addAll({
                  filtrosDados.tipoFiltro: value,
                });
                if (value.isEmpty) {
                  controller.filtrosSalvosParaAdicionarNoBody.remove(
                    filtrosDados.tipoFiltro,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget switchQualTipoDeFiltroExibir({
    required BuildContext context,
    required FiltrosWidgetModel filtrosDados,
    required void Function()? onTap,
    required FiltroController controller,
    required int index,
    required void Function(bool)? onChanged
  }) {
    Widget retornoFuncao = const SizedBox();

    switch (filtrosDados.tipoWidget) {
      case "checkbox" || "checkboxrca":
        retornoFuncao = cardFiltroGeral(
          context: context,
          filtrosDados: filtrosDados,
          onTap: onTap,
          controller: controller,
          indexFiltro: index,
        );
      break;

      case "datapicker" || "datapickerfaturamento":
        retornoFuncao = selecaoDePeriodo(
          filtrosDados: filtrosDados,
          context: context,
          controller: controller,
          tipo: filtrosDados.tipoWidget,
        );
      break;

      case "datapickernomeado":
        retornoFuncao = selecaoDePeriodoNomeado(
          filtrosDados: filtrosDados,
          context: context,
          controller: controller,
          tipo: filtrosDados.tipoWidget,
        );
      break;

      case "datapickermensal":
        retornoFuncao = selecaoDePeriodoMensal(
          context: context,
          filtrosDados: filtrosDados,
          controller: controller,
          index: index,
        );
      break;

      case "dropdown":
        retornoFuncao = cardFiltroDropDown(
          context: context,
          filtrosDados: filtrosDados,
          controller: controller,
          index: index,
        );
      break;

      case "textolivre":
        retornoFuncao = cardCampoDigitavel(
          context: context,
          filtrosDados: filtrosDados,
          controller: controller,
          index: index,
        );
      break;

      case "salvarFiltros" :
        retornoFuncao = cardSalvarFiltros(filtrosDados: filtrosDados, context: context, onChanged: onChanged);
      break;
    }
    return retornoFuncao;
  }
}
