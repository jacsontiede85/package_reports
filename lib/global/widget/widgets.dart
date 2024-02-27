import 'package:flutter/material.dart';
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
    required BuildContext context,
    required String dataInicio,
    required String dataFim
  }){
    return card(
      widgetList: [
        Text(
          filtrosDados.nome.toUpperCase(),
          style: TextStyle(
            fontSize: 14.0, 
            color: Colors.green[700], 
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.left,
        ),
        SizedBox(
          width: 250,
          child: CheckboxListTile(
            value: false, 
            title: const Text('Data faturamento'),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (c){},
          ),
        ),
        ButtonBar(
          alignment: MainAxisAlignment.start, 
          mainAxisSize: MainAxisSize.max,
          buttonPadding: const EdgeInsets.all(10),
          children: [
            TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                dataInicio,
                style: const TextStyle(fontSize: 17),
              ),
              onPressed: () async {
                dataInicio = await Settings().selectDate(context: context);
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                dataFim,
                style: const TextStyle(fontSize: 17),
              ),
              onPressed: () async {
                dataFim = await Settings().selectDate(context: context);
              },
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                return [const PopupMenuItem(child: Text("Datas"))];
              },
            )
          ],
        ),
      ]
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
            style: TextStyle(
              fontSize: 14.0, 
              color: Colors.green[700], 
              fontWeight: FontWeight.w800,
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


  Widget switchQualTipoDeFiltroExibir ({
    required BuildContext context,
    required FiltrosWidgetModel filtrosDados,
    required void Function()? onTap,
    required String dataInicio,
    required String dataFim
  }){
    Widget retornoFuncao = const SizedBox();
    switch(filtrosDados.tipoWidget){
      case "checkbox" :
      retornoFuncao = cardFiltroGeral(context: context, filtrosDados: filtrosDados, onTap: onTap);
      break;

      case "datapicker" : 
      retornoFuncao = selecaoDePeriodo(filtrosDados: filtrosDados, context: context, dataFim: dataInicio, dataInicio: dataFim);
      break;

    }
    return retornoFuncao;
  }
}