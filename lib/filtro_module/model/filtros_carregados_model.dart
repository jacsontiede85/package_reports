import 'package:mobx/mobx.dart';
import 'package:package_reports/filtro_module/model/filtros_model.dart';
part "filtros_carregados_model.g.dart";

class FiltrosCarrregados = FiltrosCarrregadosBase with _$FiltrosCarrregados;

abstract class FiltrosCarrregadosBase with Store {
  
  @observable
  int indexFiltros = 0;
  @observable
  int indexPagina = 0;
  @observable
  bool pesquisaFeita = false;

  @observable
  List<FiltrosModel> listaFiltros = [];

  @observable
  FiltrosModel? valorSelecionadoParaDropDown;


  //Variavel adicionada para uso do dashboard
  @observable
  String tipoFiltro = "";

  FiltrosCarrregadosBase({
    this.indexFiltros = 0, 
    this.indexPagina = 0,
    required this.listaFiltros,
    this.valorSelecionadoParaDropDown,
    this.tipoFiltro = ""
  });

  FiltrosCarrregadosBase.fromJson(Map<String, dynamic> json){
    indexFiltros = json['indexFiltros'];
    indexPagina = json['indexPagina'];
    listaFiltros = (json['listaFiltros'] as List).map((item) {
      return FiltrosModel.fromJson(item);
    }).toList();
    valorSelecionadoParaDropDown = json['valorSelecionadoParaDropDown'];
    tipoFiltro = json['tipoFiltro'];
    pesquisaFeita = json['pesquisaFeita'];
  }

}