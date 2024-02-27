// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:adaptive_scrollbar/adaptive_scrollbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_reports/filtro_module/page/filtros_page.dart';
import 'package:package_reports/report_module/controller/layout_controller.dart';
import 'package:package_reports/report_module/controller/report_from_json_controller.dart';
import 'package:package_reports/report_module/controller/report_to_xlsx_controller.dart';
import 'package:package_reports/global/core/features.dart';
import 'package:package_reports/report_module/page/report_chart_page.dart';
import 'package:package_reports/global/widget/widgets.dart';

class ReportPage extends StatefulWidget {
  final String function;
  final bool? voltarComPop;
  final Color? corTitulo;
  final Map<String, dynamic> body;
  const ReportPage({
    super.key,
    required this.function,
    this.voltarComPop = false,
    this.corTitulo = Colors.white,
    required this.body
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with Rows {
  late ReportFromJSONController controller;
  final LayoutController layout = LayoutController();
  Widgets wp = Widgets();
  double _width = 0.0;

  setStatee(Function fn){setState(() {fn();});}

  @override
  void initState() {
    super.initState();
    controller = ReportFromJSONController(
      nomeFunction: widget.function, 
      sizeWidth: _width,
      isToGetDadosNaEntrada: true,
      body: widget.body,
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.verticalScroll.dispose();
    controller.horizontalScroll.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _width = layout.width;
    controller.sizeWidth = _width;

    return PopScope(
      onPopInvoked: (value) => controller.willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Observer(
            builder: (_) => Visibility(
              visible: controller.configPagina.isNotEmpty,
              child: wp.wpHeader(
                titulo: controller.configPagina['name'].toString(),
                cor: widget.corTitulo ?? Colors.white,
              ),
            ),
          ),
          leading: Visibility(
            visible: widget.voltarComPop!,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: const Color.fromRGBO(255, 255, 255, 1),
              onPressed: (){
                Navigator.of(context).pop(true);
              }
            ),
          ),
          actions: [
            Visibility(
              visible: controller.colunasFiltradas.isNotEmpty || controller.searchString.text.isNotEmpty,
              child: InkWell(
                onTap: () {
                  controller.clearFiltros();
                  setState(() {});
                },
                child: const Row(
                  children: [
                    Icon(Icons.close, color: Colors.red,),
                    Text("Limpar Filtros", style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
            ),
            const SizedBox(width: 30,),
            Observer(
              builder: (_) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: AnimatedContainer(
                  height: 40,
                  width: controller.mostrarBarraPesquisar ? 250 : 60,
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.all(5),
                  child: SearchBar(
                    controller: controller.searchString,
                    hintText: 'Pesquisar',
                    elevation: const MaterialStatePropertyAll(0),
                    side: const MaterialStatePropertyAll(BorderSide(color: Colors.white, width: 0.25),),
                    backgroundColor: const MaterialStatePropertyAll(Colors.black12),
                    textStyle: MaterialStatePropertyAll(
                      TextStyle(
                        color: widget.corTitulo
                      )
                    ),
                    hintStyle: MaterialStatePropertyAll(
                      TextStyle(
                        color: widget.corTitulo?.withOpacity(0.7),
                        fontWeight: FontWeight.normal
                      ),
                    ),
                    leading: IconButton(
                      onPressed: (){
                        controller.mostrarBarraPesquisar = !controller.mostrarBarraPesquisar;
                      },
                      icon: Icon(
                        controller.mostrarBarraPesquisar ? Icons.search_off : Icons.search,
                        color: controller.mostrarBarraPesquisar ? widget.corTitulo?.withOpacity(0.7) : widget.corTitulo,
                      )
                    ),
                    onChanged: (value) {
                      controller.filterListFromSearch();
                      setState(() {});
                    },
                  ),
                ),
              ),
            ),
            Wrap(
              spacing: 10,
              children: [
                Observer(
                  builder: (_) => Visibility(
                    visible: !controller.loading,
                    child: IconButton.outlined(
                      icon: Icon(
                        Icons.bar_chart,
                        size: layout.isDesktop ? 20 : 15,
                      ),
                      color: widget.corTitulo ?? Colors.white,
                      onPressed: () async => await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChartsReport(
                              reportFromJSONController: controller,
                              title: controller.configPagina['name'],
                            ),
                          ),
                        ),
                    ),
                  ),
                ),
                Observer(
                  builder: (_) => Visibility(
                    visible: (controller.dadosFiltered().isNotEmpty && !controller.loading),
                    child: IconButton.outlined(
                      icon: Icon(
                        Icons.grid_on_outlined, 
                        size: layout.isDesktop ? 20 : 15,
                      ),
                      color: widget.corTitulo ?? Colors.white,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => exibirSelecaoDeColunasParaExporta(
                            onPressed: (){
                              ReportToXLSXController(title: controller.configPagina['name'], reportFromJSONController: controller);
                              Navigator.pop(context);
                            },
                            titulo: 'Exportar para Excel'
                          )             
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right:5),
                  child: Observer(
                    builder: (_) => Visibility(
                      visible: (controller.dadosFiltered().isNotEmpty && !controller.loading),
                      child: IconButton.outlined(
                        icon: Icon(
                          Icons.filter_alt_outlined, 
                          size: layout.isDesktop ? 20 : 15,
                        ),
                        color: widget.corTitulo ?? Colors.white,
                        onPressed: () {
                          wp.navigator(
                            pagina: FiltrosReportPage(
                              context: context,
                              mapaFiltros: controller.configPagina['filtros'],
                              indexPagina: controller.configPagina['indexPage'],
                              reportController: controller,
                            ), 
                            context: context, 
                            layout: layout,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: Observer(
            builder: (_) => Stack(
              children: [
                !controller.loading || controller.dadosFiltered().isNotEmpty
                      ? 
                      ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                          PointerDeviceKind.touch,
                          PointerDeviceKind.mouse,
                        }),
                        child: AdaptiveScrollbar(
                          controller: controller.verticalScroll,
                          width: 8,
                          underColor: Colors.white.withOpacity(0.1),
                          sliderSpacing: const EdgeInsets.only(
                            right: 0,
                          ),
                          sliderDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.black.withOpacity(0.6),
                          ),
                          sliderActiveDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.black.withOpacity(0.5),
                          ),
                          child: AdaptiveScrollbar(
                            controller: controller.horizontalScroll,
                            width: _width < 600 ? 10 : 8,
                            position: ScrollbarPosition.bottom,
                            underSpacing: const EdgeInsets.only(bottom: 15),
                            underColor: Colors.white.withOpacity(0.1),
                            sliderSpacing: const EdgeInsets.only(
                              right: 0,
                            ),
                            sliderDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.black.withOpacity(0.5),
                            ),
                            sliderActiveDecoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: SingleChildScrollView(
                              controller: controller.horizontalScroll,
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                width: _width > controller.widthTable ? _width : controller.widthTable + 10,
                                alignment: Alignment.topLeft,
                                child: Stack(
                                  children: [
                                    Container(
                                      width: controller.widthTable,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: controller.loading? Colors.transparent : Colors.purple.withOpacity(0.3),
                                          width: 0.1,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                      
                                          // TITULO DE COLUNAS
                                          Container(
                                            height: controller.getHeightColunasCabecalho,
                                            color: Colors.grey[50],
                                            child: Stack(
                                              children: [
                                                colunas(),
                                                Observer(
                                                  builder: (_) => Visibility(
                                                    visible: controller.positionScroll > 200 && controller.visibleColElevated && controller.dadosFiltered().length <= 500,
                                                    child: Positioned(
                                                      top: 0,
                                                      left: controller.positionScroll,
                                                      child: colunasElevated(),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          if(controller.dadosFiltered().isEmpty)
                                            Text(
                                              'Não há dados para os filtros selecionados...',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: layout.isDesktop ? 16 : 12,
                                                fontWeight: FontWeight.w600
                                              ),
                                          ),
                                          
                                          // ROWS [DADOS]
                                          if (controller.dadosFiltered().isNotEmpty)
                                            Flexible(child: rowsBuilder()),

                                          if(controller.dadosFiltered().isEmpty)
                                            const Expanded(child: SizedBox()),
                                          
                                          //deixar espaço para rodape
                                          if (controller.colunas.where((element) => element['type'] != String).toList().isNotEmpty)
                                          const SizedBox(
                                              height: 39,
                                            ),
                                        ],
                                      ),
                                    ),
                                    Observer(
                                      builder: (_) => Visibility(
                                        visible: controller.colunas.where((element) => element['type'] != String).toList().isNotEmpty,
                                        child: Positioned(
                                          bottom: 0,
                                          right: 0,
                                          left: 0,
                                          child: Stack(
                                            children: [
                                              rodape(),
                                              Observer(
                                                builder: (_) => Visibility(
                                                  visible: controller.positionScroll > 200 && controller.visibleColElevated && controller.dadosFiltered().length <= 500,
                                                  child: Positioned(
                                                    top: 0,
                                                    left: controller.positionScroll,
                                                    child: rodapeElevated(),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ) :
                Center(
                  child: LoadingAnimationWidget.halfTriangleDot(
                    color: const Color(0xFFEE4E4E),
                    size: 40,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget colunas() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (controller.colunas.where((element) => element['type'] != String).toList().isNotEmpty)
          ...controller.colunas.map(
            (element) => InkWell(
              onTap: () => controller.setOrderBy(key: element['key'], order: element['order']),
              child: rowTextFormatted(
                width: controller.getWidthCol(
                  key: element['key'],
                ),
                height: controller.getHeightColunasCabecalho,
                controller: controller,
                key: element['key'],
                type: element['type'],
                value: Features.formatarTextoPrimeirasLetrasMaiusculas(element['nomeFormatado'].trim()),
                isTitle: true,
                isSelected: element['isSelected'],
                order: element['order'],
                setStateRows: setStatee,
                isFiltered: element['isFiltered'],
              ),
            )
          ),
      ],
    );
  }

  Widget colunasElevated() {
    var element = controller.getMapColuna(key: controller.keyFreeze);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          onTap: () => controller.setOrderBy(key: controller.keyFreeze, order: element['order']),
          child: rowTextFormatted(
            width: controller.getWidthCol(
              key: controller.keyFreeze,
            ),
            cor: Colors.white,
            height: controller.getHeightColunasCabecalho,
            controller: controller,
            key: controller.keyFreeze,
            type: element['type'],
            value: Features.formatarTextoPrimeirasLetrasMaiusculas(element['nomeFormatado'].trim()),
            isTitle: true,
            isSelected: element['isSelected'],
            order: element['order'],
            setStateRows: setStatee
          ),
        ),
      ],
    );
  }

  Widget rowsBuilder() => ListView.builder(
        itemCount: controller.dadosFiltered().length,
        physics: const BouncingScrollPhysics(),
        controller: controller.verticalScroll,
        itemBuilder: (BuildContext context, int index) {
          var val = controller.dadosFiltered()[index];
          controller.row = [];
          val.forEach((key, value) {
            Type type = value.runtimeType;
            if(!key.toString().contains('__INVISIBLE') && !key.toString().contains('__ISRODAPE') && !key.toString().contains('isFiltered'))
              controller.row.add(
                rowTextFormatted(
                  width: controller.getWidthCol(
                    key: key,
                  ),
                  height: 35,
                  controller: controller,
                  key: key,
                  type: type,
                  value: value,
                  cor: controller.dadosFiltered().indexOf(val) % 2 == 0 ? Colors.grey[20] : Colors.white,
                  setStateRows: setStatee
                )
              );
          });
          return Stack(
            children: [
              InkWell(
                onDoubleTap: (){
                  controller.getNovaPage(mapaGetNovaPage:controller.configPagina);
                },
                child: Row(
                  children: controller.row,
                ),
              ),
              
               Observer(
                builder: (_) => Visibility(
                  visible: controller.positionScroll > 200 && controller.visibleColElevated,
                  child: Positioned(
                    top: 0,
                    left: controller.positionScroll,
                    child: rowTextFormatted(
                      width: controller.getWidthCol(
                        key: controller.keyFreeze,
                      ),
                      height: 35,
                      controller: controller,
                      key: controller.keyFreeze,
                      type: String,
                      value: val[controller.keyFreeze],
                      cor: index % 2 == 0 ? Colors.grey[20] : Colors.white,
                      setStateRows: setStatee
                    ),
                  ),
                ),
              ),

            ],
          );
        },
      );


  // Widget rows() => controller.dadosFiltered().isEmpty
  //     ? const SizedBox()
  //     : Column(
  //         mainAxisSize: MainAxisSize.max,
  //         children: [
  //           ...controller.dadosFiltered().map((val) {
  //             controller.row = [];
  //             val.forEach((key, value) {
  //               Type type = value.runtimeType;
  //               if(!key.toString().contains('__INVISIBLE') && !key.toString().contains('__ISRODAPE') && !key.toString().contains('isFiltered'))
  //                 controller.row.add(
  //                   rowTextFormatted(
  //                     width: controller.getWidthCol(key: key,),
  //                     height: 35,
  //                     controller: controller,
  //                     key: key,
  //                     type: type,
  //                     value: value,
  //                     cor: controller.dadosFiltered().indexOf(val) % 2 == 0 ? Colors.grey[20] : Colors.white,
  //                     setStateRows: setStatee
  //                   ),
  //                 );
  //             });
  //             return InkWell(
  //               onDoubleTap: (){
  //                 printW('dsajkflsd');
  //                 // controller.getNovaPage(mapaGetNovaPage:controller.configPagina);
  //               },
  //               child: Row(
  //                 children: controller.row,
  //               ),
  //             );
  //           }),
  //         ],
  //       );

  Widget rowsElevated() => controller.dadosFiltered().isEmpty
      ? const SizedBox()
      : Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (controller.keyFreeze.isNotEmpty)
              ...controller.dadosFiltered().map((map) {
                int index = controller.dadosFiltered().indexOf(map);
                controller.row = [];
                controller.row.add(
                  rowTextFormatted(
                    width: controller.getWidthCol(
                      key: controller.keyFreeze,
                    ),
                    height: 35,
                    controller: controller,
                    key: controller.keyFreeze,
                    type: String,
                    value: map[controller.keyFreeze],
                    cor: index % 2 == 0 ? Colors.grey[20] : Colors.white,
                    setStateRows: setStatee
                  ),
                );
                return Row(
                  children: controller.row,
                );
              }),
          ],
        );

  Widget rodape() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black38,
        border: Border(top: BorderSide(color: Colors.blue, width: 1))
      ),
      
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(controller.colunas.isNotEmpty && controller.colunasRodapePerson.isEmpty)
            ...controller.colunas.map((element)=>
              rowTextFormatted(
                width: controller.getWidthCol(key: element['key'],),
                height: 40,
                controller: controller,
                key: element['key'],
                type: element['key'].toString().contains('__DONTSUM') ? String : element['type'],
                value: controller.colunas.indexOf(element)==0
                    ? '${controller.dadosFiltered().length}'
                    : element['type']==String ? ''
                    : element['key'].toString().contains('__DONTSUM') ? ''
                    : element['vlrTotalDaColuna'],
                isSelected: element['isSelected'],
                isRodape: true,
                order: element['order'],
                setStateRows: setStatee
              ),
            )
          else
            ...controller.colunasRodapePerson.map((element) {
              for(var value in controller.dadosFiltered()){
                if(element['key'].toString().contains('__ISRODAPE')){
                  return rowTextComLable(
                    width:controller.widthTable / controller.colunasRodapePerson.where((element) => element['key'].toString().contains('__ISRODAPE')).length,
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
        ]
      ),
    );
  }

  Widget rodapeElevated(){
    var element = controller.getMapColuna(key: controller.keyFreeze);
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        rowTextFormatted(
          width: controller.getWidthCol(key: controller.keyFreeze,),
          height: 40,
          cor: const Color.fromARGB(255, 65, 63, 63),
          controller: controller,
          key: controller.keyFreeze,
          type: controller.keyFreeze.toString().contains('__DONTSUM') ? String : element['type'],
          value: '${controller.dadosFiltered().length}',
          isSelected: element['isSelected'],
          isRodape: true,
          order: element['order'],
          setStateRows: setStatee
        ),
      ],
    );
  }

  Widget exibirSelecaoDeColunasParaExporta ({required void Function()? onPressed, required String titulo}){
    return AlertDialog(
      elevation: 0,
      title: Text(
        titulo,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500
        ),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: onPressed,
          icon:  Icon(
            Icons.sim_card_download_rounded,
            color: Colors.green[500],
          ),
          label: Text(
            "Exportar",
            style: TextStyle(
              fontSize: 19,
              color: Colors.green[500],
            ),
          )
        ),
      ],
      content: SizedBox(
        width: 300,
        height: 500,
        child: ListView.builder(
          itemCount: controller.colunas.length,
          itemBuilder:(context, index) {
            return Observer(
              builder: (_) => Card(
                child: CheckboxListTile(
                  value: controller.colunas[index]['selecionado'],
                  onChanged: (value){
                    setState(() {
                      controller.colunas[index]['selecionado'] = !controller.colunas[index]['selecionado'];
                    });
                  },
                  title: Text(
                    Features.formatarTextoPrimeirasLetrasMaiusculas(controller.colunas[index].entries.first.value.toString().split('__')[0].replaceAll('_', ' ')),
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

}

mixin Rows {
  rowTextFormatted({
    required ReportFromJSONController controller, 
    required double width, 
    double? height, 
    required key, 
    required Type type, 
    required value, 
    bool isTitle = false,
    bool isRodape = false, 
    bool isSelected = false, 
    String order = 'asc', 
    Color? cor,
    bool isFiltered = false,
    required Function setStateRows
  }) {
    double fontSize = 12;
    return Stack(
      children: [
        Container(
          width: width * 1.10,
          height: height,
          decoration: BoxDecoration(
            color: cor ?? (
              isTitle ? Colors.grey[40] 
              : isRodape ? Colors.black54
              : Colors.grey[300]
            ),
            border: Border.all(color: Colors.purple.withOpacity(0.3), width: 0.25),
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
    
        if(isTitle && isSelected)
          Positioned(
            left: 0,
            bottom: -10,
            child: IconButton(
              icon:Icon(
                order=='asc' ? Icons.arrow_upward : Icons.arrow_downward,
                size: 17,
                color: Colors.blueAccent,
              ),
              onPressed: null,
            ),
          ),
    
        if(isTitle)
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
                color: isFiltered ? Colors.blue : Colors.grey,
              ),
              itemBuilder: (context) {
                return controller.createlistaFiltrarLinhas(chave: key).map((e){
                  return PopupMenuItem(
                    padding: EdgeInsets.zero,
                    child: Observer(
                      builder: (_) => CheckboxListTile(
                        value: e.selecionado,
                        title: Text(e.valor.toString()),
                        onChanged: (v) {
                          e.selecionado = !e.selecionado;
                          if(e.selecionado) controller.colunasFiltradas.add(e.coluna);
                          else controller.colunasFiltradas.removeWhere((element) => element == e.coluna);
                          setStateRows((){
                            if(e.selecionado)
                              controller.filtrosSelected.add(
                                {
                                  "coluna": e.coluna,
                                  "valor": e.valor
                                }
                              );
                            else controller.filtrosSelected.removeWhere((element) => element['coluna'] == e.coluna && element['valor'] == e.valor);
                            controller.getTheSelectedFilteredRows();
                            controller.dadosFiltered();
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    )
                  );
                }).toList();
              },
            ),
          )
      ],
    );
  }

  Widget rowTextComLable ({
    required ReportFromJSONController controller,
    required double width,
    double? height,
    required key,
    required Type type,
    required value,
  }){
    return Stack(
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(color: Colors.purple.withOpacity(0.5), width: 0.25),
          ),
          padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              bottom: 5 
          ),
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
                  type == DateTime ? value.toString()
                  : type == String ? Features.formatarTextoPrimeirasLetrasMaiusculas(value.toString().replaceAll('_', ' '))
                  : type == double ? Features.toFormatNumber(value.toString().replaceAll('_', ' '))
                  : type == int ? Features.toFormatInteger(value.toString().replaceAll('_', ' '),)
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
