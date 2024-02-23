import 'package:mobx/mobx.dart';
part 'filtros_model.g.dart';

class FiltrosModel = FiltrosModelBase with _$FiltrosModel;

abstract class FiltrosModelBase with Store {

  String codigo = '';
  String titulo = '';
  String subtitulo = '';

  @observable
  bool selecionado = false;

  FiltrosModelBase.fromJson(Map<String, dynamic> json){
    codigo = json['codigo'];
    titulo = json['titulo'];
    subtitulo = json['subtitulo'];
  }

  @override
  bool operator == (other) => other is FiltrosModelBase && codigo == other.codigo;
  
  @override
  int get hashCode => codigo.hashCode;
}