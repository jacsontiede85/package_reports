import 'package:flutter/material.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';
import 'package:package_reports/filtro_module/model/filtros_widget_model.dart';
import 'package:package_reports/filtro_module/page/itens_do_filtro.dart';
import 'package:package_reports/report_module/controller/layout_controller.dart';
import 'package:package_reports/report_module/controller/report_from_json_controller.dart';
import 'package:package_reports/report_module/widget/widgets.dart';

class FiltrosReportPage extends StatefulWidget {
  
  final BuildContext context;
  final Map<String, dynamic> mapaFiltros;
  final int indexPagina;
  final ReportFromJSONController reportController;
  
  const FiltrosReportPage({
    super.key,
    required this.context,
    required this.mapaFiltros,
    required this.indexPagina,
    required this.reportController,
  });  

  @override
  State<FiltrosReportPage> createState() => _FiltrosReportPageState();
}

class _FiltrosReportPageState extends State<FiltrosReportPage> {
  
  late FiltroController controllerFiltro = FiltroController(
    mapaFiltrosWidget: widget.mapaFiltros,
    indexPagina: widget.indexPagina,
    controllerReports: widget.reportController
  );
  
  Widgets wp = Widgets();
  LayoutController layout = LayoutController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: wp.wpHeader(titulo: 'Filtros'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color.fromRGBO(255, 255, 255, 1),
          onPressed: (){
            Navigator.of(context).pop(true);
          }
        ),
        actions: [
          ElevatedButton(
            child: const Text("Aplicar"),
            onPressed: () async {
              Navigator.of(context).pop(true);
              await controllerFiltro.criarNovoBody();
            },
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: controllerFiltro.listaFiltrosParaConstruirTela.length,
          itemBuilder: (context, index) {
            if(controllerFiltro.listaFiltrosParaConstruirTela[index].keys.first == widget.indexPagina){
              return switchQualTipoDeFiltroExibir(
                context: context,
                filtrosDados: controllerFiltro.listaFiltrosParaConstruirTela[index][widget.indexPagina]!,
                dataInicio: controllerFiltro.dtinicio,
                dataFim: controllerFiltro.dtfim,
                onTap: () async {
                  controllerFiltro.funcaoBuscarDadosDeCadaFiltro(
                    valor:controllerFiltro.listaFiltrosParaConstruirTela[index][widget.indexPagina]!,
                    indexFiltro: index
                  );
                    wp.navigator(
                      context: context,
                      pagina: ItensFiltro(
                        controller: controllerFiltro,
                        indexDapagina: widget.indexPagina,
                        indexDoFiltro: index,
                      ),
                      isToShowFiltroNoMeio: true,
                      layout: layout
                    );
                },
              );              
            }
            else{
              return Container();
            }
          },
        ),
      ),
    );
  }
}

  Widget card({required List<Widget> widgetList}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start, 
            children: widgetList,
          ),
        ),
      ),
    );
  }

  Widget selecaoDePeriodo ({
    required FiltrosWidgetModel filtrosDados,
    required BuildContext context,
    required String dataInicio,
    required String dataFim
  }){
    return card(
      widgetList: [
        Text(
          filtrosDados.nome.toUpperCase(),
          style: const TextStyle(
            fontSize: 14.0, 
            color: Colors.black, 
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.left,
        ),
        ButtonBar(
          alignment: MainAxisAlignment.start, 
          mainAxisSize: MainAxisSize.max,
          buttonPadding: const EdgeInsets.all(10),
          children: [
            TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                dataInicio,
                style: const TextStyle(fontSize: 17),
              ),
              onPressed: () {},
            ),
            TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                dataFim,
                style: const TextStyle(fontSize: 17),
              ),
              onPressed: () {},
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                return [const PopupMenuItem(child: Text("Datas"))];
              },
            )
          ],
        ),
      ]
    );
  }

  Widget cardFiltroGeral({
    required BuildContext context, 
    required FiltrosWidgetModel filtrosDados,
    required void Function()? onTap,
    // required Function functionGetDados, 
    // required Function functionAtuaizarCadSelecionados, 
    // required String codSelecionado, 
    // required Function functionGetDadosTotal, 
    // required List<Widget> selecWidgets,
    dynamic theme,
    bool isToShowFiltroNoMeio = false
  }) {
    return InkWell(
      onTap: onTap,
      child: card(
        widgetList: [
          Text(
            filtrosDados.nome.toUpperCase(),
            style: const TextStyle(
              fontSize: 14.0, 
              color: Colors.black, 
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.left,
          ),
          // subtitulo == null
          //     ? const SizedBox(height: 0)
          //     : Container(
          //         alignment: Alignment.topLeft,
          //         child: Row(
          //           children: [
          //             Expanded(
          //               flex: 2,
          //               child: Text(
          //                 subtitulo,
          //                 style: const TextStyle(
          //                   fontSize: 9.0, 
          //                   color: Colors.black,
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          const SizedBox(
            height: 5,
          ),
          Stack(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 5.0),
                child: const Column(
                  children: [
                    Wrap(
                      spacing: 2.0, 
                      direction: Axis.horizontal, 
                      children: [],
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }


  Widget switchQualTipoDeFiltroExibir ({
    required BuildContext context,
    required FiltrosWidgetModel filtrosDados,
    required void Function()? onTap,
    required String dataInicio,
    required String dataFim
  }){
    Widget retornoFuncao = const SizedBox();
    switch(filtrosDados.tipoWidget){
      case "checkbox" :
      retornoFuncao = cardFiltroGeral(context: context, filtrosDados: filtrosDados, onTap: onTap);
      break;

      case "datapicker" : 
      retornoFuncao = selecaoDePeriodo(filtrosDados: filtrosDados, context: context, dataFim: dataInicio, dataInicio: dataFim);
      break;

    }
    return retornoFuncao;
  }
