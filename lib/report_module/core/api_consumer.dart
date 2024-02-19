import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:package_reports/report_module/core/features.dart';
import 'package:package_reports/report_module/core/settings.dart';
import 'dart:convert';

class API {

  Future<String> jwtSendJson({required String banco, required Map dados,}) async {
    //header
    var header = {
      "alg": "HS256",
      "typ": "JWT",
    };
    String header64 = base64Encode(jsonEncode(header).codeUnits);

    //payload
    var payload = dados;
    String payload64 = base64Encode(utf8.encode(jsonEncode(payload)));

    //assinatura
    var hmac = Hmac(sha256, 'Settings.secret'.codeUnits);
    var digest = hmac.convert("$header64.$payload64".codeUnits);
    String sign = base64Encode(digest.bytes);
    String token = "$header64.$payload64.$sign";

    var res = await http.post(
      Uri.parse(Settings.enderecoRepositorio),
      body: {
        'connection': banco,
        'token': token,
      },
    );
    if (res.statusCode == 200) {
      return res.body;
    } else {
      return "";
    }
  }

  Future<List> getDataReportApi({required String function}) async {
    // final filtro = GetIt.I.get<Filtros>();
    try{
      var response = await jwtSendJson(
        dados: {
          "function" : function,
          "datainicio" : "${Features.formatarDataUS('filtro.dataInicioFiltro.toString()')}",
          "datafim" : "${Features.formatarDataUS('filtro.dataFimFiltro.toString()')}",
          "filial": 'filtro.selectedFiliaisFiltro',
          "transportadora": 'filtro.selectedTransportadoraFiltro'
        },
        banco: "sgt_mysql",
      );
      return jsonDecode(response);
    }catch(e){
      return [];
    }
  }

}
