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

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['codigo'] = codigo;
    data['titulo'] = titulo;
    data['subtitulo'] = subtitulo;
    return data;
  }

  @override
  bool operator == (other) => other is FiltrosModelBase && codigo == other.codigo;
  
  @override
  int get hashCode => codigo.hashCode;
}