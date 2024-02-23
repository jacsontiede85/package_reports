import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';

class ItensFiltro extends StatelessWidget {
  final FiltroController controller;
  final int indexDapagina;
  final int indexDOFiltro;

  const ItensFiltro({
    super.key,
    required this.controller,
    required this.indexDapagina,
    required this.indexDOFiltro,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          controller.listaFiltrosParaConstruirTela[indexDOFiltro][indexDapagina]!.nome,
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
              SizedBox(
                width: 200,
                child: CheckboxListTile(
                  value: false, 
                  title: const Text(
                    "Todos",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  onChanged: (value){},
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              SizedBox(
                width: 210,
                child: CheckboxListTile(
                  value: false, 
                  title: const Text(
                    "Inverter seleção",
                    style: TextStyle(
                      color: Colors.white
                    ),
                  ),
                  onChanged: (value){},
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Observer(
        builder: (_) => Visibility(
          visible: !controller.loadingItensFiltors,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: ListView.builder(
            itemCount: controller.listaFiltros.length,
            itemBuilder: (context, index) {
              return Observer(
                builder: (_) => CheckboxListTile(
                  value: controller.listaFiltros[index].selecionado,
                  onChanged: (valor){
                    controller.listaFiltros[index].selecionado = !controller.listaFiltros[index].selecionado;
                    controller.adicionarItensSelecionado(indexFiltro: indexDOFiltro, itens: controller.listaFiltros[index]);
                  },
                  title: Text(controller.listaFiltros[index].titulo),
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