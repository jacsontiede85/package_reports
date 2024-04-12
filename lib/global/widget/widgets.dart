import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:package_reports/filtro_module/controller/filtro_controller.dart';
import 'package:package_reports/filtro_module/model/filtros_model.dart';
import 'package:package_reports/filtro_module/model/filtros_widget_model.dart';
import 'package:package_reports/global/core/settings.dart';
import 'package:package_reports/global/widget/texto.dart';

class Widgets {

  Widget wpHeader({
    required String titulo,
    Color cor = Colors.white,
  }) {
    return Texto(
      texto: titulo,
      tipo: TipoTexto.titulo,
      cor: cor,
    );
  }

  navigator({
    required dynamic pagina, 
    required BuildContext context, 
    Function()? onTap, 
    bool isToShowFiltroNoMeio = false, 
    required dynamic layout,
  }) async{
    if(1==1){
      await Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => Material( color: Colors.transparent, child: pagina,) 
        )
      );
    }
    else{
      switch (pagina.runtimeType) {
        case const (FiltrosWidgetModel):
          Widget widgetContrucao = Container(
            color: Colors.transparent,
            child: Row(
              children: isToShowFiltroNoMeio ? 
              [
                GestureDetector(
                  onTap: onTap ?? () {
                    Navigator.of(context).pop();
                  },
                  child: Container(color: Colors.transparent, width: (layout.width - layout.larguraJanelaFiltrosPesquisa)/2,),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: pagina,
                  )
                ),
                GestureDetector(
                  onTap: onTap ?? () {
                    Navigator.of(context).pop();
                  },
                  child: Container(color: Colors.transparent, width: (layout.width - layout.larguraJanelaFiltrosPesquisa)/2,),
                ),
              ] 
              : 
              [
                GestureDetector(
                  onTap: onTap ?? () {
                    Navigator.of(context).pop();
                  },
                  child: Container(color: Colors.transparent, width: layout.width - layout.larguraJanelaFiltrosPesquisa,),
                ),
                Expanded(child: pagina),
              ],
            ),
          );
          await showDialog<void>(
            barrierColor: Colors.black54.withOpacity(0.4),
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context)=> widgetContrucao
          );
          break;
        default:
          await Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context) => Material( color: Colors.transparent, child: pagina,) 
            )
          );
      }
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
    required FiltroController controller,
    required BuildContext context,
    required String tipo,
  }){
    return Builder(
      builder: (context) {
        if(tipo == 'datapickerfaturamento'){
          controller.validarSeDataSeraDeFaturamento();          
        }
        return card(
          widgetList: [
            Text(
              filtrosDados.titulo.toUpperCase(),
              style: TextStyle(
                fontSize: 14.0, 
                color: Colors.green[700], 
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(
              width: 250,
              child: Observer(
                builder: (_) => Visibility(
                  visible: tipo == 'datapickerfaturamento',
                  child: CheckboxListTile(
                    value: controller.isDataFaturamento, 
                    title: const Text('Data faturamento'),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (c){
                      controller.isDataFaturamento = !controller.isDataFaturamento;
                      controller.validarSeDataSeraDeFaturamento();
                    },
                  ),
                ),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.start, 
              mainAxisSize: MainAxisSize.max,
              buttonPadding: const EdgeInsets.all(10),
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Observer(
                    builder: (_) => Text(
                      controller.dtinicio,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                  onPressed: () async {
                    controller.dtinicio = await SettingsReports().selectDate(context: context);
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: Observer(
                    builder: (_) => Text(
                      controller.dtfim,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                  onPressed: () async {
                    controller.dtfim = await SettingsReports().selectDate(context: context);
                  },
                ),
                PopupMenuButton(
                  itemBuilder: (context) {
                    return controller.listaDePeriodos.map((valor) {
                      return PopupMenuItem(
                        value: valor.replaceAll(' ', ''),
                        child: Text(valor),
                      );
                    },).toList();
                  },
                  onSelected: (value) {
                    controller.selecaoDeDataPorPeriodo(periodo: value);
                  },
                )
              ],
            ),
          ]
        );
      }
    );
  }

  Widget cardFiltroGeral({
    required BuildContext context, 
    required FiltrosWidgetModel filtrosDados,
    required void Function()? onTap,
    dynamic theme,
    bool isToShowFiltroNoMeio = false,
    required FiltroController controller,
    required int indexFiltro
  }) {
    return Card(
      child: ListTile(
        onTap: onTap,
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        title: Text(
          filtrosDados.titulo.toUpperCase(),
          style: TextStyle(
            fontSize: 14.0, 
            color: Colors.green[700], 
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.left,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start, 
          children: [
            Visibility(
              visible: filtrosDados.subtitulo.isNotEmpty,
              child: Container(
                margin: const EdgeInsets.only(top: 5, bottom: 5),
                alignment: Alignment.topLeft,
                child: Text(
                  filtrosDados.subtitulo,
                  style: const TextStyle(
                    fontSize: 11.0, 
                    // color: Colors.black,
                  ),
                ),
              ),
            ),
          
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Wrap(
                    spacing: 2.0, 
                    direction: Axis.horizontal,
                    children: [
                      Observer(
                        builder: (_) => Visibility(
                          visible: controller.listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados.isEmpty,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey[300],
                            ),
                            margin: const EdgeInsets.fromLTRB(1, 0, 0, 2),
                            padding: const EdgeInsets.fromLTRB(10, 2, 12, 2),
                            child: const Text(
                              "\u{2718} Sem filtro",
                              style: TextStyle(
                                fontWeight: FontWeight.w500, 
                                fontSize: 11, 
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                      for(FiltrosModel valores in controller.listaFiltrosParaConstruirTela[indexFiltro].filtrosWidgetModel.itensSelecionados.take(20))
                        Observer(
                          builder: (context) {
                            return Visibility(
                              visible: valores.selecionado,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.grey[300],
                                ),
                                margin: const EdgeInsets.fromLTRB(1, 0, 0, 2),
                                padding: const EdgeInsets.fromLTRB(10, 2, 12, 2),
                                child: Text(
                                  "\u{2705} ${valores.codigo}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500, 
                                    fontSize: 14, 
                                    color: Colors.blueGrey,
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget switchQualTipoDeFiltroExibir ({
    required BuildContext context,
    required FiltrosWidgetModel filtrosDados,
    required void Function()? onTap,
    required FiltroController controller,
    required int index,
  }){
    Widget retornoFuncao = const SizedBox();
    switch(filtrosDados.tipoWidget){

      case "checkbox" :
        retornoFuncao = cardFiltroGeral(
          context: context, 
          filtrosDados: filtrosDados, 
          onTap: onTap,
          controller: controller,
          indexFiltro: index
        );
      break;

      case "datapicker" || "datapickerfaturamento" : 
        retornoFuncao = selecaoDePeriodo(
          filtrosDados: filtrosDados, 
          context: context, 
          controller: controller,
          tipo: filtrosDados.tipoWidget,
        );
      break;

    }
    return retornoFuncao;
  }
}