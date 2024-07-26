// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';
import 'package:package_reports/filtro_module/model/filtros_pagina_atual_model.dart';
import 'package:package_reports/filtro_module/page/itens_do_filtro.dart';
import 'package:package_reports/global/core/layout_controller.dart';
import 'package:package_reports/global/widget/widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';

class FiltrosReportPage extends StatefulWidget {
  final FiltroController controllerFiltro;
  Function(ObservableList<FiltrosPageAtual> listaFiltrosParaConstruirTela, String dtinicio, String dtfim)? onAplicar;
  Map<String, dynamic> bodypesquisaAtual;

  FiltrosReportPage({super.key, required this.controllerFiltro, required this.bodypesquisaAtual, this.onAplicar});

  @override
  State<FiltrosReportPage> createState() => _FiltrosReportPageState();
}

class _FiltrosReportPageState extends State<FiltrosReportPage> {
  late FiltroController controllerFiltro = widget.controllerFiltro;

  Widgets wp = Widgets();
  LayoutControllerPackage layout = LayoutControllerPackage();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        // CONFIGURAÇÃO DE LAYOUT (CONTROLLER)
        layout.setSizeScreen(
          altura: MediaQuery.of(context).size.height,
          largura: MediaQuery.of(context).size.width,
          sizingInformation: sizingInformation,
          context: context,
        );

        // ------------------------------ FORÇAR MUDANÇA DE LAYOUT
        layout.menuDrawerDesktopVisible = false;
        if (layout.width < 800) {
          layout.desktop = false;
          layout.tablet = false;
          layout.mobile = true;
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              "Filtros",
              style: TextStyle(
                fontSize: 18, 
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
            automaticallyImplyLeading: true,
            elevation: 0,
            scrolledUnderElevation: 0.0,
            actions: [
              Observer(
                builder: (_) => Visibility(
                  visible: (controllerFiltro.isRCAativo || controllerFiltro.isRCAsemVenda) || controllerFiltro.filtrosSalvosParaAdicionarNoBody.isNotEmpty || controllerFiltro.listaFiltrosParaConstruirTela.any((element) => element.filtrosWidgetModel.itensSelecionados.isNotEmpty),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextButton.icon(
                      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.redAccent.shade400)),
                      onPressed: () {
                        controllerFiltro.limparFiltros(bodyParaSerLimpo: widget.bodypesquisaAtual);                     
                      },
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Limpar Filtros",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                    if (widget.onAplicar == null) {
                      await controllerFiltro.criarNovoBody();
                    } else {
                      widget.onAplicar!(controllerFiltro.listaFiltrosParaConstruirTela, controllerFiltro.dtinicio, controllerFiltro.dtfim);
                    }
                  },
                  child: const Text(
                    "Aplicar",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Center(
            child: Observer(builder: (context) {
              return ListView.builder(
                itemCount: controllerFiltro.listaFiltrosParaConstruirTela.length,
                itemBuilder: (context, index) {
                  if (controllerFiltro.listaFiltrosParaConstruirTela[index].qualPaginaFiltroPertence == controllerFiltro.indexPagina) {
                    return wp.switchQualTipoDeFiltroExibir(
                      context: context,
                      filtrosDados: controllerFiltro.listaFiltrosParaConstruirTela[index].filtrosWidgetModel,
                      controller: controllerFiltro,
                      index: index,
                      onTap: () async {
                        if(controllerFiltro.bodyPesquisarFiltros.containsKey("pesquisa")){
                          controllerFiltro.bodyPesquisarFiltros.update("pesquisa", (value) => "",);
                        }
                        
                        controllerFiltro.pesquisaItensDoFiltro = "";
                        controllerFiltro.funcaoBuscarDadosDeCadaFiltro(
                          valor: controllerFiltro.listaFiltrosParaConstruirTela[index].filtrosWidgetModel,
                          isBuscarDropDown: false,
                          index: index,
                        );
                        wp.navigator(
                          context: context,
                          pagina: ItensFiltro(
                            controller: controllerFiltro,
                            indexDapagina: controllerFiltro.indexPagina,
                            filtroPaginaAtual: controllerFiltro.listaFiltrosParaConstruirTela[index],
                            indexDofiltro: index,
                          ),
                          isToShowFiltroNoMeio: true,
                          layout: layout,
                        );
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              );
            }),
          ),
        );
      },
    );
  }
}
