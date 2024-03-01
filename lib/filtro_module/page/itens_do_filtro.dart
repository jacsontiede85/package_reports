import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';

class ItensFiltro extends StatefulWidget {
  final FiltroController controller;
  final int indexDapagina;
  final int indexDoFiltro;

  const ItensFiltro({
    super.key,
    required this.controller,
    required this.indexDapagina,
    required this.indexDoFiltro,
  });

  @override
  State<ItensFiltro> createState() => _ItensFiltroState();
}

class _ItensFiltroState extends State<ItensFiltro> {

  @override
  void initState() {
    widget.controller.indexFiltro = widget.indexDoFiltro;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          widget.controller.listaFiltrosParaConstruirTela[widget.indexDoFiltro][widget.indexDapagina]!.titulo,
          style: const TextStyle(
            color: Colors.white
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color.fromRGBO(255, 255, 255, 1),
          onPressed: (){
            Navigator.of(context).pop(true);
          }
        ),
        actions: [
          AnimatedContainer(
            height: 40,
            width: 400,
            duration: const Duration(seconds: 1),
            child: SearchBar(
              hintText: 'Pesquisar',
              elevation: const MaterialStatePropertyAll(0),
              side: const MaterialStatePropertyAll(BorderSide(color: Colors.white, width: 0.25),),
              backgroundColor: const MaterialStatePropertyAll(Colors.black12),
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
            )
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(30,40),
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
                    onChanged: (_){
                      if(widget.controller.verificaSeTodosEstaoSelecionados){
                        widget.controller.limparSelecao();
                      }else{
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
                    Icons.change_circle_outlined,
                    color: Colors.white60,
                  ),
                  title: const Text(
                    "Inverter seleção",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  dense: true,
                  hoverColor: Colors.grey.shade700,
                  onTap: (){
                    widget.controller.inverterSelecao();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Observer(
        builder: (_) => Visibility(
          visible: !widget.controller.loadingItensFiltors,
          replacement: Center(
            child: LoadingAnimationWidget.halfTriangleDot(
              color: const Color(0xFFEE4E4E),
              size: 40,
            ),
          ),
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return const Divider();
            },
            itemCount: widget.controller.listaFiltros.length,
            itemBuilder: (context, index) {
              return Observer(
                builder: (_) => CheckboxListTile(
                  value: widget.controller.listaFiltros[index].selecionado,
                  onChanged: (valor){
                    widget.controller.listaFiltros[index].selecionado = !widget.controller.listaFiltros[index].selecionado;
                    widget.controller.adicionarItensSelecionado(itens: widget.controller.listaFiltros[index]);
                  },
                  title: Text(widget.controller.listaFiltros[index].titulo),
                  subtitle: Text(
                    widget.controller.listaFiltros[index].subtitulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color.fromARGB(197, 209, 158, 5),
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}