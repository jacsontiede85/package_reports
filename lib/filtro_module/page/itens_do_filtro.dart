import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';
import 'package:package_reports/filtro_module/model/filtros_model.dart';
import 'package:package_reports/filtro_module/model/filtros_pagina_atual_model.dart';

class ItensFiltro extends StatefulWidget {
  final FiltroController controller;
  final int indexDapagina;

  const ItensFiltro({
    super.key,
    required this.controller,
    required this.indexDapagina,
  });

  @override
  State<ItensFiltro> createState() => _ItensFiltroState();
}

class _ItensFiltroState extends State<ItensFiltro> {
 
  late FiltrosPageAtual filtroPaginaAtual = widget.controller.listaFiltrosParaConstruirTela[widget.controller.indexFiltro];

  @override
  void initState() {    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: filtroPaginaAtual.qualPaginaFiltroPertence == widget.indexDapagina,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: SelectionArea(
            child: Column(
              children: [
                Text(
                  filtroPaginaAtual.filtrosWidgetModel.titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),
                ),
                Observer(
                  builder: (_) => Visibility(
                    visible: widget.controller.getQtdeItensSelecionados > 0,
                    child: Observer(
                      builder: (_) => Text(
                        "Qtde. selecionado: ${widget.controller.getQtdeItensSelecionados} de ${widget.controller.getListFiltrosComputed.length}",
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color.fromRGBO(255, 255, 255, 1),
            onPressed: () async {
              Navigator.of(context).pop(true);
            }
          ),
          actions: [
            Observer(
              builder: (_) => AnimatedContainer(
                height: 40,
                width: widget.controller.exibirBarraPesquisa ? 300 : 60,
                margin: const EdgeInsets.only(right: 10),
                duration: const Duration(milliseconds: 300),
                child: SearchBar(
                  hintText: 'Pesquisar',
                  elevation: const MaterialStatePropertyAll(0),
                  side: const MaterialStatePropertyAll(BorderSide(color: Colors.white, width: 0.25),),
                  backgroundColor: const MaterialStatePropertyAll(Colors.black12),
                  leading: IconButton(
                    onPressed: (){
                      widget.controller.exibirBarraPesquisa = !widget.controller.exibirBarraPesquisa;
                    },
                    icon: Icon(
                      widget.controller.exibirBarraPesquisa ? Icons.search_off : Icons.search,
                    ),
                    color: Colors.white.withOpacity(0.7),
                  ),
                  textStyle: const MaterialStatePropertyAll(
                    TextStyle(
                      color: Colors.white
                    )
                  ),
                  hintStyle: MaterialStatePropertyAll(
                    TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  onChanged: (value) {
                    widget.controller.pesquisaItensDoFiltro = value;
                    if(widget.controller.getListFiltrosComputed.isEmpty){
                      widget.controller.bodyPesquisarFiltros.addAll({"pesquisa" : widget.controller.pesquisaItensDoFiltro});
                      widget.controller.funcaoBuscarDadosDeCadaFiltro(
                        valor: filtroPaginaAtual.filtrosWidgetModel,
                        isBuscarDropDown: false,
                        index: widget.controller.indexFiltro
                      );
                    }
                    else{
                      widget.controller.bodyPesquisarFiltros.remove('pesquisa');
                      widget.controller.funcaoBuscarDadosDeCadaFiltro(
                        valor: filtroPaginaAtual.filtrosWidgetModel,
                        isBuscarDropDown: false,
                        index: widget.controller.indexFiltro
                      );
                    }
                  },
                )
              ),
            ),
          ],
          // bottom: PreferredSize(
          //   preferredSize: const Size(30,40),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: Observer(
          //           builder: (_) => CheckboxListTile(
          //             value: widget.controller.verificaSeTodosEstaoSelecionados, 
          //             title: const Text(
          //               "Todos",
          //               style: TextStyle(
          //                 color: Colors.white
          //               ),
          //             ),
          //             hoverColor: Colors.grey.shade700,
          //             onChanged: (_){
          //               if(widget.controller.verificaSeTodosEstaoSelecionados){
          //                 widget.controller.limparSelecao();
          //               }else{
          //                 widget.controller.selecionarTodos();
          //               }
          //             },
          //             controlAffinity: ListTileControlAffinity.leading,
          //           ),
          //         ),
          //       ),
          //       Expanded(
          //         child: ListTile(
          //           leading: const Icon(
          //             Icons.change_circle_outlined,
          //             color: Colors.white60,
          //           ),
          //           title: const Text(
          //             "Inverter seleção",
          //             style: TextStyle(
          //               color: Colors.white
          //             ),
          //           ),
          //           dense: true,
          //           hoverColor: Colors.grey.shade700,
          //           onTap: (){
          //             widget.controller.inverterSelecao();
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
        body: Observer(
          builder: (_) => Visibility(
            visible: !widget.controller.loadingItensFiltros && widget.controller.getListFiltrosComputed.isNotEmpty,
            replacement: Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: const Color.fromARGB(255, 102, 78, 238),
                size: 40,
              ),
            ),
            child: widget.controller.novoIndexFiltro == -1 ? const Text("TESTE") : ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: widget.controller.getListFiltrosComputed.length,
              itemBuilder: (context, index) {
                FiltrosModel filtro = widget.controller.getListFiltrosComputed[index];
                return Observer(
                  builder: (_) => CheckboxListTile(
                    value: filtro.selecionado,
                    onChanged: (valor){
                      filtro.selecionado = !filtro.selecionado;
                      widget.controller.adicionarItensSelecionado(itens: filtro);
                    },
                    title: Text(
                      "${filtro.codigo} - ${filtro.titulo}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: filtro.subtitulo.isNotEmpty ? Text(
                      filtro.subtitulo,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.light ? Colors.orange[700] : Colors.orangeAccent[100], 
                      ),
                    ) : null,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}