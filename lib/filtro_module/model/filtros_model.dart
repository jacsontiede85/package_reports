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
    codigo = json['CODIGO'];
    titulo = json['TITULO'];
    subtitulo = json['SUBTITULO'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['CODIGO'] = codigo;
    data['TITULO'] = titulo;
    data['SUBTITULO'] = subtitulo;
    return data;
  }

  @override
  bool operator == (other) => other is FiltrosModelBase && codigo == other.codigo;
  
  @override
  int get hashCode => codigo.hashCode;
}