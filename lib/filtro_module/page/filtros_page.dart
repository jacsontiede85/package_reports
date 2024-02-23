import 'package:flutter/material.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';
import 'package:package_reports/filtro_module/model/filtros_widget_model.dart';
import 'package:package_reports/filtro_module/page/itens_do_filtro.dart';
import 'package:package_reports/report_module/controller/layout_controller.dart';
import 'package:package_reports/report_module/widget/widgets.dart';

class FiltrosReportPage extends StatefulWidget {
  
  final BuildContext context;
  final Map<String, dynamic> mapaFiltros;
  final int indexPagina;
  
  const FiltrosReportPage({
    super.key,
    required this.context,
    required this.mapaFiltros,
    required this.indexPagina,
  });  

  @override
  State<FiltrosReportPage> createState() => _FiltrosReportPageState();
}

class _FiltrosReportPageState extends State<FiltrosReportPage> {
  
  late FiltroController controllerFiltro = FiltroController(
    mapaFiltrosWidget: widget.mapaFiltros,
    indexPagina: widget.indexPagina
  );

  Widgets wp = Widgets();
  LayoutController layout = LayoutController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ListView.builder(
          itemCount: controllerFiltro.listaFiltrosParaConstruirTela.length,
          itemBuilder: (context, index) {
            if(controllerFiltro.listaFiltrosParaConstruirTela[index].keys.first == widget.indexPagina){
              return Visibility(
                visible: controllerFiltro.listaFiltrosParaConstruirTela[index][widget.indexPagina]!.isVisivel,
                child: cardFiltroGeral(
                  context: context,
                  filtrosDados: controllerFiltro.listaFiltrosParaConstruirTela[index][widget.indexPagina]!,
                  onTap: () async {
                    controllerFiltro.funcaoBuscarDadosDeCadaFiltro(valor: controllerFiltro.listaFiltrosParaConstruirTela[index][widget.indexPagina]!);
                      wp.navigator(
                        context: context,
                        pagina: ItensFiltro(
                          controller: controllerFiltro,
                          indexDapagina: widget.indexPagina,
                          indexDOFiltro: index,
                        ),
                        isToShowFiltroNoMeio: true,
                        layout: layout
                      );
                  },
                ),
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
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: widgetList),
        ),
      ),
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

