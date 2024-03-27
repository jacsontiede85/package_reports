// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';
import 'package:package_reports/filtro_module/model/filtros_pagina_atual_model.dart';
import 'package:package_reports/filtro_module/page/itens_do_filtro.dart';
import 'package:package_reports/report_module/controller/layout_controller.dart';
import 'package:package_reports/global/widget/widgets.dart';

class FiltrosReportPage extends StatefulWidget {
  
  final FiltroController controllerFiltro;
  Function(ObservableList<FiltrosPageAtual> listaFiltrosParaConstruirTela)? onAplicar;
  
  FiltrosReportPage({
    super.key,
    required this.controllerFiltro,
    this.onAplicar
  });

  @override
  State<FiltrosReportPage> createState() => _FiltrosReportPageState();
}

class _FiltrosReportPageState extends State<FiltrosReportPage>{
  
  late FiltroController controllerFiltro = widget.controllerFiltro;
  
  Widgets wp = Widgets();
  LayoutController layout = LayoutController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              child: const Text("Aplicar"),
              onPressed: () async {
                Navigator.of(context).pop(true);
                if(widget.onAplicar == null) {
                  await controllerFiltro.criarNovoBody();
                } else {
                  widget.onAplicar;
                }
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Observer(
          builder: (context) {
            return ListView.builder(
              itemCount: controllerFiltro.listaFiltrosParaConstruirTela.length,
              itemBuilder: (context, index) {
                if(controllerFiltro.listaFiltrosParaConstruirTela[index].qualPaginaFiltroPertence == controllerFiltro.indexPagina){
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
                          indexDapagina: controllerFiltro.indexPagina,
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
            );
          }
        ),
      ),
    );
  }
}
