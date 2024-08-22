import 'package:mobx/mobx.dart';
import 'package:package_reports/filtro_module/model/filtros_model.dart';
part 'filtros_widget_model.g.dart';

class FiltrosWidgetModel = FiltrosWidgetModelBase with _$FiltrosWidgetModel;

abstract class FiltrosWidgetModelBase with Store {

  String tipoFiltro = '';
  String titulo = '';
  String subtitulo = '';
  String arquivoQuery = '';
  String funcaoPrincipal = '';
  String bancoBuscarFiltros = '';
  String tipoWidget = '';

  @observable
  Set<FiltrosModel>? itensSelecionados = {};

  FiltrosWidgetModelBase({
    this.tipoFiltro = '',
    this.titulo = '',
    this.subtitulo = '',
    this.arquivoQuery = '',
    this.funcaoPrincipal = '',
    this.bancoBuscarFiltros = '',
    this.tipoWidget = '',
    this.itensSelecionados,
  });

  FiltrosWidgetModelBase.fromJson(Map<String, dynamic> json, String key){
    tipoFiltro = key;
    titulo = json['titulo'] ?? '';
    subtitulo = json['subtitulo'] ?? '';
    tipoWidget = json['tipo'];
    funcaoPrincipal = json['funcao'] ?? '';
    bancoBuscarFiltros = json['banco'] ?? '';
    arquivoQuery = json['arquivoquery'] ?? '';
  }

  Map<String, List<Map<String, dynamic>>> toJsonItensSelecionados() {
    Map<String, List<Map<String, dynamic>>> mapItensSelecionados = <String, List<Map<String, dynamic>>>{};
    List<Map<String, dynamic>> json = [];

    for(FiltrosModel item in itensSelecionados!){
      json.add(item.toJson());
      mapItensSelecionados.addAll({ tipoFiltro: json});
    }

    return mapItensSelecionados;
  }


}