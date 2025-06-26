import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:package_reports/global/core/features.dart';
import 'package:package_reports/report_module/controller/report_from_json_controller.dart';
import 'package:package_reports/report_module/page/report_page.dart';
import 'package:package_reports/report_module/page/rows.dart';

class WidgetsReports {

  late final ReportFromJSONController controller;
  late final Function setStatee;
  late final BuildContext context;
  late final String database;

  WidgetsReports({
    required this.controller,
    required this.setStatee,
    required this.context,
    required this.database,
  });

  Widget colunasWidget() {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.colunas.where((element) => element['type'] != String).toList().isNotEmpty)
              ...controller.colunas.map(
                (element) {
                  if(element['colunasFiltradas'] == true) {
                    return InkWell(
                      onTap: () => controller.setOrderBy(key: element['key'], order: element['order']),
                      child: Rows.rowTextFormatted(
                        context: context,
                        width: controller.getWidthCol(
                          key: element['key'],
                        ),
                        height: controller.getHeightColunasCabecalho,
                        controller: controller,
                        key: element['key'],
                        type: element['type'],
                        value: Features.formatarTextoPrimeirasLetrasMaiusculas(
                          element['nomeFormatado'].trim(),
                        ),
                        isTitle: true,
                        isSelected: element['isSelected'],
                        order: element['order'],
                        setStateRows: setStatee,
                        isFiltered: element['isFiltered'],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
          ],
        ),
      
        Tooltip(
          message: 'Clique para exibir/ocultar colunas',
          child: InkWell(
            child: const Icon(
              Icons.more_horiz,
              size: 20,
              color: Colors.black,
            ),
            onTap: (){
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Selecione as colunas para exibir/ocultar'),
                    content: SingleChildScrollView(
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.colunas.map((e) {
                          return Observer(
                            builder: (_) => FilterChip(
                              label: Text(Features.formatarTextoPrimeirasLetrasMaiusculas(e['nomeFormatado'])),
                              selected: e['colunasFiltradas'],
                              onSelected: (bool selected) {
                                e['colunasFiltradas'] = !e['colunasFiltradas'];
                                if(!e['colunasFiltradas']){
                                  controller.widthTable = controller.widthTable - e['widthCol'];
                                }else{
                                  controller.widthTable = controller.widthTable + e['widthCol'];
                                }
                                // Ajustar largura da tabela para evitar overflow
                                if (controller.colunas.every((col) => !col['colunasFiltradas'])) {
                                  controller.widthTable = 0.0;
                                }
                                setStatee;
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Fechar'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),      
      ],
    );
  }
  

  Widget colunasElevated() {
    Map<String,dynamic> element = controller.getMapColuna(key: controller.keyFreeze);
    if(element['colunasFiltradas'] == true) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
            onTap: () => controller.setOrderBy(key: controller.keyFreeze, order: element['order']),
            child: Rows.rowTextFormatted(
              context: context,
              width: controller.getWidthCol(
                key: controller.keyFreeze,
              ),
              cor: Colors.white,
              height: controller.getHeightColunasCabecalho,
              controller: controller,
              key: controller.keyFreeze,
              type: element['type'],
              value: Features.formatarTextoPrimeirasLetrasMaiusculas(
                element['nomeFormatado'].trim(),
              ),
              isTitle: true,
              isSelected: element['isSelected'],
              order: element['order'],
              setStateRows: setStatee,
            ),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget rowsBuilder() {
    return ListView.builder(
      itemCount: controller.dadosFiltered().length,
      physics: const BouncingScrollPhysics(),
      controller: ScrollController(),
      itemBuilder: (BuildContext context, int index) {
        Map<String,dynamic> val = controller.dadosFiltered()[index];
        controller.row = [];
        val.forEach((key, value) {
          Type type = value.runtimeType;
          if (!key.toString().toUpperCase().contains('__INVISIBLE') && !key.toString().toUpperCase().contains('__ISRODAPE') && !key.toString().contains('isFiltered')) {
            controller.row.add(
              Rows.rowTextFormatted(
                context: context,
                width: controller.getWidthCol(
                  key: key,
                ),
                height: 35,
                controller: controller,
                key: key,
                type: type,
                value: value,
                cor: controller.dadosFiltered().indexOf(val) % 2 == 0 ? Colors.grey[20] : Colors.white,
                setStateRows: setStatee,
              ),
            );
          }
        });
        return Stack(
          children: [
            InkWell(
              onDoubleTap: controller.configPagina['page'] != null && controller.configPagina['page'].isNotEmpty
                  ? () {
                      if (controller.configPagina['page'] != null && controller.configPagina['page'].isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              if(controller.bodySecundario.isEmpty){
                                return ReportPage(
                                  database: database,
                                  buscarDadosNaEntrada: true,
                                  function: controller.configPagina['urlapi'],
                                )..setMapSelectedRowPage(
                                  mapSelectedRow: val,
                                  bodyConfigBuscaRecursiva: controller.configPagina,
                                  getbodyPrimario: controller.bodyPrimario,
                                );                                
                              }else{
                                return ReportPage(
                                  database: database,
                                  buscarDadosNaEntrada: true,
                                  function: controller.configPagina['urlapi'],
                                )..setMapSelectedRowPage(
                                  mapSelectedRow: val,
                                  bodyConfigBuscaRecursiva: controller.configPagina,
                                  getbodyPrimario: controller.bodySecundario,
                                );
                              }
    
                            },
                          ),
                        );
                      }
                    }
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: controller.row,
              ),
            ),
            Observer(
              builder: (_) => Visibility(
                visible: controller.positionScroll > 200 && controller.visibleColElevated,
                child: Positioned(
                  top: 0,
                  left: controller.positionScroll,
                  child: Rows.rowTextFormatted(
                    context: context,
                    width: controller.getWidthCol(
                      key: controller.keyFreeze,
                    ),
                    height: 35,
                    controller: controller,
                    key: controller.keyFreeze,
                    type: String,
                    value: val[controller.keyFreeze],
                    cor: index % 2 == 0 ? Colors.grey[20] : Colors.white,
                    setStateRows: setStatee,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget rodape() {
    return Container(
      decoration: const BoxDecoration(color: Colors.black38, border: Border(top: BorderSide(color: Colors.blue, width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (controller.colunas.isNotEmpty && controller.colunasRodapePerson.isEmpty)
            ...controller.colunas.map(
              (element) {
                if(element['colunasFiltradas'] == true) {
                  return Rows.rowTextFormatted(
                    context: context,
                    width: controller.getWidthCol(
                      key: element['key'],
                    ),
                    height: 40,
                    controller: controller,
                    key: element['key'],
                    type: element['key'].toString().toUpperCase().contains('__DONTSUM') ? String : element['type'],
                    value: controller.valoresRodape(element: element),
                    element: element,
                    isSelected: element['isSelected'],
                    isRodape: true,
                    order: element['order'],
                    setStateRows: setStatee,
                  );
                } else {
                  return const SizedBox();
                }
              },
            )
          else
            ...controller.colunasRodapePerson.map((element) {
              for (var value in controller.dadosFiltered()) {
                if (element['key'].toString().toUpperCase().contains('__ISRODAPE') && element['colunasFiltradas'] == true) {
                  return Rows.rowTextComLable(
                    width: controller.widthTable / controller.colunasRodapePerson.where((element) => element['key'].toString().toUpperCase().contains('__ISRODAPE')).length,
                    height: 40,
                    controller: controller,
                    key: Features.formatarTextoPrimeirasLetrasMaiusculas(element['nomeFormatado']),
                    type: element['type'],
                    value: value[element['key']],
                  );
                }
              }
              return const SizedBox();
            }),
        ],
      ),
    );
  }

  Widget rodapeElevated() {
    var element = controller.getMapColuna(key: controller.keyFreeze);
    if(element['colunasFiltradas'] == true) {
      return Rows.rowTextFormatted(
        context: context,
        width: controller.getWidthCol(
          key: controller.keyFreeze,
        ),
        height: 40,
        cor: const Color.fromARGB(255, 65, 63, 63),
        controller: controller,
        key: controller.keyFreeze,
        type: controller.keyFreeze.toString().toUpperCase().contains('__DONTSUM') ? String : element['type'],
        value: '${controller.dadosFiltered().length}',
        isSelected: element['isSelected'],
        isRodape: true,
        order: element['order'],
        setStateRows: setStatee,
      );
    } else {
      return const SizedBox();
    }
  }

  Widget exibirSelecaoDeColunasParaExporta({required void Function()? onPressedFiltrado, required void Function()? onPressedTudo, required String titulo}) {
    return AlertDialog(
      elevation: 0,
      title: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Observer(
            builder: (_) => FilterChip.elevated(
              onSelected: (d){
                if(controller.colunas.every((element) => element['selecionado'] == true,)){
                  for(Map<String,dynamic> valor in controller.colunas){
                    valor['selecionado'] = false;
                  }
                }
                else{
                  for(Map<String,dynamic> valor in controller.colunas){
                    valor['selecionado'] = true;
                  }
                }
              },
              selected: controller.colunas.every((element) => element['selecionado'] == true,),
              label: Text(controller.colunas.every((element) => element['selecionado'] == true,) ? 'Desmarcar todas' : 'Marcar todos'),
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        Observer(
          builder: (_) => Visibility(
            visible: controller.colunasFiltradas.isNotEmpty,
            child: TextButton.icon(
              onPressed: onPressedFiltrado,
              icon: Icon(
                Icons.downloading_sharp,
                color: Colors.blue[500],
              ),
              style: ButtonStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.teal,
                    ),
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                overlayColor: const WidgetStatePropertyAll(
                  Color.fromARGB(106, 133, 138, 141),
                ),
              ),
              label: Text(
                "Linhas filtradas",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.blue[500],
                ),
              ),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onPressedTudo,
          icon: Icon(
            Icons.downloading_sharp,
              color: Colors.green[500],
          ),
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.teal,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            overlayColor: const WidgetStatePropertyAll(
              Color.fromARGB(106, 133, 138, 141),
            ),
          ),
          label: Text(
            "Exportar tudo",
            style: TextStyle(
              fontSize: 15,
              color: Colors.green[500],
            ),
          ),
        ),
      ],
      content: SizedBox(
        width: 500,
        height: 300,
        child: ListView.builder(
          itemCount: controller.colunas.length,
          itemBuilder: (context, index) {
            return Observer(
              builder: (_) => Card(
                child: CheckboxListTile(
                  dense: true,
                  value: controller.colunas[index]['selecionado'],
                  selected: !controller.colunas[index]['selecionado'],
                  selectedTileColor: Colors.grey.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onChanged: (value) {
                    setStatee(() {
                      controller.colunas[index]['selecionado'] = !controller.colunas[index]['selecionado'];
                    });
                  },
                  title: Text(
                    Features.formatarTextoPrimeirasLetrasMaiusculas(
                      controller.colunas[index].entries.first.value.toString().split('__')[0].replaceAll('_', ' '),
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildGraficosDialogs() {
    return Container(
      color: Colors.black.withValues(alpha:0.6),
      child: AlertDialog(
        alignment: Alignment.center,
        title: Visibility(
          visible: controller.isLoadingGraficos && controller.errorGraficosMessage.isEmpty,
          replacement: Column(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 40),
              const SizedBox(height: 16),
              Text(
                controller.errorGraficosMessage,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,                
              ),
            ],
          ),
          child: const Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Gerando gráficos...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,                
              ),
            ],
          ),
        ),
      ),
    );
  }


}