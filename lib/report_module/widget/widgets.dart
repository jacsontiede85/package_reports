import 'package:flutter/material.dart';
import 'package:package_reports/filtro_module/model/filtros_widget_model.dart';
import 'package:package_reports/report_module/widget/texto.dart';

class Widgets{
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
    required dynamic theme
  }) async{
    if(layout.mobile || layout.tablet){
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
            barrierColor: theme.themeDarkAtivo ? Colors.white.withOpacity(0.2) : Colors.black54.withOpacity(0.4),
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
}