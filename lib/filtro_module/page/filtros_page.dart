import 'package:flutter/material.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';
import 'package:package_reports/filtro_module/page/itens_do_filtro.dart';
import 'package:package_reports/report_module/controller/layout_controller.dart';
import 'package:package_reports/report_module/controller/report_from_json_controller.dart';
import 'package:package_reports/global/widget/widgets.dart';

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
            if(controllerFiltro.listaFiltrosParaConstruirTela[index].qualPaginaFiltroPertence == widget.indexPagina){
              return wp.switchQualTipoDeFiltroExibir(
                context: context,
                filtrosDados: controllerFiltro.listaFiltrosParaConstruirTela[index].filtrosWidgetModel,
                controller: controllerFiltro,
                index: index,
                onTap: () async {
                  controllerFiltro.funcaoBuscarDadosDeCadaFiltro(
                    valor:controllerFiltro.listaFiltrosParaConstruirTela[index].filtrosWidgetModel,
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
