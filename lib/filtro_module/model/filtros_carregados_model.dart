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
  List<FiltrosModel> listaFiltros = [];

  FiltrosCarrregadosBase({
    this.indexFiltros = 0, 
    this.indexPagina = 0,
    required this.listaFiltros,
  });


}