import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';
import 'package:package_reports/filtro_module/model/filtros_carregados_model.dart';
import 'package:package_reports/filtro_module/model/filtros_model.dart';
import 'package:package_reports/filtro_module/model/filtros_pagina_atual_model.dart';

class ItensFiltro extends StatefulWidget {
  final FiltroController controller;
  final int indexDapagina;
  final int indexDofiltro;
  final FiltrosPageAtual filtroPaginaAtual;

  ItensFiltro({super.key, required this.controller, required this.indexDapagina, required this.indexDofiltro, required this.filtroPaginaAtual}) {
    controller.indexFiltro = indexDofiltro;
  }

  @override
  State<ItensFiltro> createState() => _ItensFiltroState();
}

class _ItensFiltroState extends State<ItensFiltro> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Visibility(
        visible: widget.filtroPaginaAtual.qualPaginaFiltroPertence == widget.indexDapagina,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            elevation: 0,
            scrolledUnderElevation: 0.0,
            backgroundColor: Colors.black,
            title: ListTile(
              dense: true,
              isThreeLine: true,
              title: Text(
                widget.filtroPaginaAtual.filtrosWidgetModel.titulo,
                style: const TextStyle( 
                  fontSize: 16, 
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),
              subtitle: Observer(
                builder: (_) => Visibility(
                  visible: widget.controller.getQtdeItensSelecionados > 0,
                  child: Observer(
                    builder: (_) => Text(
                      "Qtde. selecionado: ${widget.controller.getQtdeItensSelecionados} de ${widget.controller.getListFiltrosComputed.length}",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              trailing: Observer(
                builder: (_) => Visibility(
                  visible: widget.filtroPaginaAtual.filtrosWidgetModel.itensSelecionados!.isNotEmpty,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: TextButton.icon(
                      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.redAccent.shade400)),
                      onPressed: () {
                        //Limpando as variaveis
                        widget.filtroPaginaAtual.filtrosWidgetModel.itensSelecionados!.clear();  
                        for(FiltrosCarrregados  value in widget.controller.listaFiltrosCarregados){
                          if(value.indexFiltros == widget.indexDofiltro){
                            for(FiltrosModel item in value.listaFiltros){
                              item.selecionado = false;
                            }
                          }
                        }
                        
                        for (FiltrosModel value in widget.controller.getListFiltrosComputed) {
                          value.selecionado = false;
                        }

                        widget.controller.filtrosSalvosParaAdicionarNoBody.removeWhere((key, value) => key == widget.filtroPaginaAtual.filtrosWidgetModel.tipoFiltro,);
                        
                        //Limpando o body de pesquisa
                        if (widget.controller.controllerReports.bodySecundario.isEmpty) {
                          widget.controller.controllerReports.bodyPrimario.removeWhere((key, value) {
                            return key == widget.filtroPaginaAtual.filtrosWidgetModel.tipoFiltro;
                          },);
                        } else {
                          widget.controller.controllerReports.bodySecundario.removeWhere((key, value) {
                            return key == widget.filtroPaginaAtual.filtrosWidgetModel.tipoFiltro;
                          },);
                        }
                      },
                      icon: const Icon(
                        Icons.clear_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Limpar Itens",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            actions: [
              IconButton(
                onPressed: (){
                  widget.controller.exibirBarraPesquisa = !widget.controller.exibirBarraPesquisa;
                },
                icon: Icon(
                  widget.controller.exibirBarraPesquisa ? Icons.search_off : Icons.search,
                  color: Colors.white,
                ),
              )
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(
                widget.controller.exibirBarraPesquisa && (!widget.controller.loadingItensFiltros && widget.controller.getListFiltrosComputed.isNotEmpty) 
                ? 90 
                : !widget.controller.exibirBarraPesquisa && (!widget.controller.loadingItensFiltros && widget.controller.getListFiltrosComputed.isNotEmpty) 
                ?
                40
                :
                widget.controller.exibirBarraPesquisa && (!widget.controller.loadingItensFiltros && widget.controller.getListFiltrosComputed.isEmpty)
                ?
                40
                :
                widget.controller.exibirBarraPesquisa && widget.controller.loadingItensFiltros
                ?
                40
                :
                0
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Observer(
                    builder: (_) => Visibility(
                      visible: widget.controller.exibirBarraPesquisa,
                      child: Container(
                        height: 40,
                        margin: const EdgeInsets.all(10),
                        child: SearchBar(
                          hintText: 'Pesquisar',
                          elevation: const WidgetStatePropertyAll(0),
                          side: const WidgetStatePropertyAll(
                            BorderSide(color: Colors.white, width: 0.25),
                          ),
                          backgroundColor: const WidgetStatePropertyAll(Colors.black12),
                          leading: IconButton(
                            onPressed: () {
                              widget.controller.exibirBarraPesquisa = !widget.controller.exibirBarraPesquisa;
                            },
                            icon: Icon(
                              widget.controller.exibirBarraPesquisa ? Icons.search_off : Icons.search,
                              color: Colors.white,
                            ),
                          ),
                          textStyle: const WidgetStatePropertyAll(TextStyle(color: Colors.white)),
                          hintStyle: WidgetStatePropertyAll(
                            TextStyle(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.normal),
                          ),
                          onSubmitted: (value) {
                            widget.controller.pesquisaItensDoFiltro = value;
                            widget.controller.bodyPesquisarFiltros.addAll({"pesquisa": widget.controller.pesquisaItensDoFiltro});
                            if (widget.controller.getListFiltrosComputed.isEmpty) {
                              widget.controller.funcaoBuscarDadosDeCadaFiltro(
                                valor: widget.filtroPaginaAtual.filtrosWidgetModel,
                                isBuscarDropDown: false,
                                index: widget.controller.indexFiltro,
                                pesquisa: true,
                              );
                            } else {
                              if (widget.controller.pesquisaItensDoFiltro.isEmpty) {
                                widget.controller.funcaoBuscarDadosDeCadaFiltro(
                                  valor: widget.filtroPaginaAtual.filtrosWidgetModel,
                                  isBuscarDropDown: false,
                                  index: widget.controller.indexFiltro,
                                  pesquisa: true,
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Observer(
                    builder: (_) => Visibility(
                      visible: !widget.controller.loadingItensFiltros && widget.controller.getListFiltrosComputed.isNotEmpty,
                      child: Row(
                        children: [
                          Expanded(
                            child: Observer(
                              builder: (_) => CheckboxListTile(
                                value: widget.controller.verificaSeTodosEstaoSelecionados,
                                title: const Text(
                                  "Todos",
                                  style: TextStyle(
                                    color: Colors.white
                                  ),
                                ),
                                hoverColor: Colors.grey.shade700,
                                onChanged: (_) {
                                  if (widget.controller.verificaSeTodosEstaoSelecionados) {
                                    widget.controller.limparSelecao();
                                  } else {
                                    widget.controller.selecionarTodos();
                                  }
                                },
                                controlAffinity: ListTileControlAffinity.leading,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              leading: const Icon(
                                Icons.compare_arrows,
                                color: Colors.white,
                              ),
                              title: const Text(
                                "Inverter seleção",
                                style: TextStyle(
                                  color: Colors.white
                                ),
                              ),
                              dense: true,
                              onTap: () {
                                widget.controller.inverterSelecao();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Observer(
            builder: (_) => Visibility(
              visible: !widget.controller.loadingItensFiltros && widget.controller.getListFiltrosComputed.isNotEmpty,
              replacement: Visibility(
                visible: !widget.controller.erroBuscarItensFiltro,
                replacement: const Center(
                  child: Text(
                    "Não foi possivel encontrar o item pesquisado !",
                  ),
                ),
                child: Center(
                  child: LoadingAnimationWidget.halfTriangleDot(
                    color: const Color.fromARGB(255, 102, 78, 238),
                    size: 40,
                  ),
                ),
              ),
              child: widget.controller.novoIndexFiltro == -1
                  ? const SizedBox()
                  : Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return const Divider();
                            },
                            itemCount: widget.controller.getListFiltrosComputed.length,
                            itemBuilder: (context, index) {
                              FiltrosModel filtro = widget.controller.getListFiltrosComputed[index];
                              return Observer(
                                builder: (_) => CheckboxListTile(
                                  value: filtro.selecionado,
                                  onChanged: (valor) {
                                    filtro.selecionado = !filtro.selecionado;
                                    if ( widget.filtroPaginaAtual.filtrosWidgetModel.tipoWidget == "singleCheckbox"){
                                      widget.controller.adicionarItemUnicoSelecionado(item: filtro);
                                    }else{
                                      widget.controller.adicionarItensSelecionado(itens: filtro);
                                    }
                                  },
                                  title: Text(
                                    "${filtro.codigo} - ${filtro.titulo}".toUpperCase(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  subtitle: filtro.subtitulo.isNotEmpty
                                      ? Text(
                                          filtro.subtitulo.toUpperCase(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: Theme.of(context).brightness == Brightness.light ? Colors.orange[700] : Colors.orangeAccent[100],
                                          ),
                                        )
                                      : null,
                                  controlAffinity: ListTileControlAffinity.leading,
                                ),
                              );
                            },
                          ),
                      ),
                      Observer(
                        builder: (_) => Visibility(
                          visible: widget.controller.loadingMoreData,
                          child: const LinearProgressIndicator(),
                        ),
                      ),
                    ],
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
