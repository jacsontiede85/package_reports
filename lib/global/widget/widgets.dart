import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';
import 'package:package_reports/filtro_module/model/filtros_model.dart';
import 'package:package_reports/filtro_module/model/filtros_widget_model.dart';
import 'package:package_reports/global/core/settings.dart';
import 'package:package_reports/global/widget/card_person.dart';
import 'package:package_reports/global/widget/titulo_cards.dart';

class Widgets {

  Widget selecaoSinglePeriodo({
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
        return CardPerson(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TituloCards(
                titulo: filtrosDados.titulo.toUpperCase(),
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
          
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Observer(
                      builder: (_) => Expanded(
                        child: SegmentedButton(
                          selectedIcon: const Icon(Icons.calendar_today),
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          segments: [
                            ButtonSegment(
                              value: 0,
                              label: Text(controller.dtunico),
                            ),
                          ],
                          multiSelectionEnabled: true,
                          selected: const {0,1},
                          onSelectionChanged: (Set<int> newSelection) async {
                            controller.dtunico = await SettingsReports().selectDate(
                              context: context,
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
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
        return CardPerson(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TituloCards(
                titulo: filtrosDados.titulo.toUpperCase(),
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
          
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Observer(
                      builder: (_) => Expanded(
                        child: SegmentedButton(
                          selectedIcon: const Icon(Icons.calendar_today),
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          segments: [
                            ButtonSegment(
                              value: 0,
                              label: Text(controller.dtinicio),
                            ),
                            ButtonSegment(
                              value: 1,
                              label: Text(controller.dtfim),
                            ),
                          ],
                          multiSelectionEnabled: true,
                          selected: const {0,1},
                          onSelectionChanged: (Set<int> newSelection) async {
                            if (newSelection.first == 1) {
                              controller.dtinicio = await SettingsReports().selectDate(
                                context: context,
                              );
                            } else {
                              controller.dtfim = await SettingsReports().selectDate(
                                context: context,
                              );
                            }
                          },
                        ),
                      ),
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
              ),
            ],
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
    
    int posicaoValidada = controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index);

    return CardPerson(
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TituloCards(titulo: filtrosDados.titulo.toUpperCase()),
          
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
              future: posicaoValidada == -1 ? 
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
            ),
          ),
        ],
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
        return CardPerson(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TituloCards(titulo: filtrosDados.titulo.toUpperCase()),
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
            
              Row(
                children: [
                  Expanded(
                    child: Observer(
                      builder: (_) => SegmentedButton(
                        selectedIcon: const Icon(Icons.calendar_today),
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),             
                        multiSelectionEnabled: true,
                        selected: const {0,1},
                        segments: [
                          ButtonSegment(
                            enabled: !controller.mapaDatasNomeadas[filtrosDados.tipoFiltro]["isEnable"],
                            value: 0,
                            label: Observer(
                              builder: (_) => Text(
                                controller.mapaDatasNomeadas[filtrosDados.tipoFiltro]["dtinicio"],
                                style: const TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          ButtonSegment(
                            enabled: !controller.mapaDatasNomeadas[filtrosDados.tipoFiltro]["isEnable"],                          
                            value: 1,
                            label: Observer(
                              builder: (_) => Text(
                                controller.mapaDatasNomeadas[filtrosDados.tipoFiltro]["dtfim"],
                                style: const TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                        ],  
                        onSelectionChanged: (Set<int> newSelection) async {
                          if(newSelection.first == 1){
                            String dataInicio = await SettingsReports().selectDate(
                              context: context,
                            );
                            controller.mapaDatasNomeadas.update(
                              filtrosDados.tipoFiltro, (value) {
                                return {
                                  "dtinicio": dataInicio,
                                  "dtfim": value["dtfim"],
                                  "isEnable": value["isEnable"]
                                };
                              },
                            );
                          }else{
                            String dataFim = await SettingsReports().selectDate(
                              context: context,
                            );
                            controller.mapaDatasNomeadas.update(
                              filtrosDados.tipoFiltro, (value) {
                                return {
                                  "dtinicio": value["dtinicio"],
                                  "dtfim": dataFim,
                                  "isEnable": value["isEnable"]
                                };
                              },
                            );
                          }
                        }               
                      ),
                    ),
                  ),
                  Observer(
                    builder: (_) => PopupMenuButton(
                      enabled: !controller.mapaDatasNomeadas[filtrosDados.tipoFiltro]["isEnable"],                    
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
                    ),
                  ),
                ],
              )             
            ],
          ),
        );
      },
    );
  }

  Widget cardFiltroGeral({required BuildContext context, required FiltrosWidgetModel filtrosDados, required void Function()? onTap, required FiltroController controller, required int indexFiltro}) {
    return CardPerson(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TituloCards(titulo: filtrosDados.titulo.toUpperCase()),

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
                        filtrosDados.itensSelecionados!.clear();
                        controller.listaFiltrosCarregados.removeWhere((element) => element.tipoFiltro == filtrosDados.tipoFiltro && element.tipoWidget == filtrosDados.tipoWidget,);
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
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
              
          Observer(
            builder: (_) => Visibility(
              visible: controller.listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.isNotEmpty,
              replacement: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: FilterChip(
                  onSelected: null,
                  selected: false,
                  label: const Text(
                    "\u{2718} Sem filtro",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),                
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Wrap(
                  spacing: 5.0,
                  runSpacing: 5,
                  direction: Axis.horizontal,
                  children: [
                    for (FiltrosModel valores in controller.listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados!.take(20))
                      Observer(builder: (context) {
                        return Visibility(
                          visible: valores.selecionado,
                          child: FilterChip(
                            onSelected: null,
                            padding: EdgeInsets.zero,
                            showCheckmark: false,
                            selected: true,
                            labelStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            label: Text("\u{2705} ${valores.codigo}",),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardSalvarFiltros ({required FiltrosWidgetModel filtrosDados, required BuildContext context, required void Function(bool)? onChanged}){
    return CardPerson(
      child: SwitchListTile(
        value: SettingsReports.isfiltrosSalvosApp,
        activeTrackColor: Colors.green,
        inactiveTrackColor: Colors.grey,
        title: TituloCards(titulo: "Salvar Filtros"),
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

    int valorProcurado = controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index);

    if (valorProcurado == -1){
      controller.funcaoBuscarDadosDeCadaFiltro(
        valor: controller.listaFiltrosParaConstruirTela[index].filtrosWidgetModel,
        isBuscarDropDown: true,
        index: index,
      ).then(
        (value) {
          controller.listaFiltrosCarregados[controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index)].valorSelecionadoParaDropDown = controller.listaFiltrosCarregados[controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index)].listaFiltros.first;
        },
      );

      valorProcurado = controller.listaFiltrosCarregados.indexWhere((element) => element.indexFiltros == index);
    }

    return CardPerson(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TituloCards(titulo: filtrosDados.titulo.toUpperCase()),
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
            child: Builder(
              builder: (context) {
                  return DropdownButton<FiltrosModel>(
                    value: controller.listaFiltrosCarregados[valorProcurado].valorSelecionadoParaDropDown,
                    hint: const Text("Selecione um valor"),
                    isExpanded: true,
                    isDense: true,
                    onChanged: (value) {
                      controller.listaFiltrosCarregados[valorProcurado].valorSelecionadoParaDropDown = value;
                      controller.adicionarItensDropDown(index: index, valorSelecionado: value!);
                    },
                    items: controller.listaFiltrosCarregados[valorProcurado].listaFiltros.map((item) {
                      return DropdownMenuItem<FiltrosModel>(
                        value: item,
                        child: Text(
                          item.titulo,
                        ),
                      );
                    }).toList(),
                  );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget cardCampoDigitavel({
    required BuildContext context,
    required FiltrosWidgetModel filtrosDados,
    required FiltroController controller,
    required int index,
  }) {
    return CardPerson(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TituloCards(titulo: filtrosDados.titulo),
          
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
      case "checkbox" || "checkboxrca" || "singleCheckbox":
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

      case "datapickersingle":
        retornoFuncao = selecaoSinglePeriodo(
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
