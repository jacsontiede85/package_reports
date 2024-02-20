import 'package:mobx/mobx.dart';
part 'filtrar_colunas_model.g.dart';

class ColunasModel = ColunasModelBase with _$ColunasModel;

abstract class ColunasModelBase with Store{

  String coluna = "";
  String valor = "";

  @observable
  bool selecionado = false;

  ColunasModelBase({
    this.coluna = '',
    this.valor = '',
    this.selecionado = false,
  });

}