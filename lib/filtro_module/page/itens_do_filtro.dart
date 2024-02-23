import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';

class ItensFiltro extends StatelessWidget {
  final FiltroController controller;
  final int indexDapagina;

  const ItensFiltro({
    super.key,
    required this.controller,
    required this.indexDapagina,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.listaFiltrosParaConstruirTela[0][0]!.nome),
        actions: const [
          SearchBar(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size(30,40), 
          child: CheckboxListTile(
            value: false, 
            title: const Text("Inverter seleção"),
            onChanged: (value){}
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: controller.listaFiltros[0][indexDapagina]!.length,
        itemBuilder: (context, index) {
          return Observer(
            builder: (_) => CheckboxListTile(
              value: controller.listaFiltros[0][indexDapagina]![index].selecionado,
              onChanged: (valor){
                controller.listaFiltros[0][indexDapagina]![index].selecionado = !controller.listaFiltros[0][indexDapagina]![index].selecionado;
              },
              title: Text(controller.listaFiltros[0][indexDapagina]![index].titulo),
              controlAffinity: ListTileControlAffinity.leading,
            ),
          );
        },
      ),
    );
  }
}