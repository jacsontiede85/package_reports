import 'package:mobx/mobx.dart';
import 'package:package_reports/filtro_module/model/filtros_model.dart';
part "filtros_carregados_model.g.dart";

class FiltrosCarrregados = FiltrosCarrregadosBase with _$FiltrosCarrregados;

abstract class FiltrosCarrregadosBase with Store {
  
  @observable
  late int indexFiltros;
  @observable
  late int indexPagina;
  @observable
  late bool pesquisaFeita;
  @observable
  late String tipoFiltro;
  @observable
  late String tipoWidget;
  @observable
  late List<FiltrosModel> listaFiltros;
  
  @observable
  FiltrosModel? valorSelecionadoParaDropDown;

  FiltrosCarrregadosBase({
    required this.indexFiltros, 
    required this.indexPagina,
    required this.listaFiltros,
    this.valorSelecionadoParaDropDown,
    required this.tipoFiltro,
    required this.tipoWidget,
  });

  FiltrosCarrregadosBase.fromJson(Map<String, dynamic> json){
    indexFiltros = json['indexFiltros'];
    indexPagina = json['indexPagina'];
    listaFiltros = (json['listaFiltros'] as List).map((item) {
      return FiltrosModel.fromJson(item);
    }).toList();
    if(json['valorSelecionadoParaDropDown'] != null){
      valorSelecionadoParaDropDown = FiltrosModel.fromJson(json['valorSelecionadoParaDropDown']);
    }
    tipoFiltro = json['tipoFiltro'];
    tipoWidget = json['tipoWidget'];
    pesquisaFeita = json['pesquisaFeita'];
  }

}