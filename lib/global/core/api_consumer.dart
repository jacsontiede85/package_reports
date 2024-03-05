import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:package_reports/global/core/settings.dart';
import 'dart:convert';

class API with Settings{


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
    var hmac = Hmac(sha256, 'tisa098*'.codeUnits);
    var digest = hmac.convert("$header64.$payload64".codeUnits);
    String sign = base64Encode(digest.bytes);
    String token = "$header64.$payload64.$sign";

    var res = await http.post(
      Uri.parse("${Settings.enderecoRepositorio}repository/"),
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
  
  Future<List> getDataReportApi({
    required String urlreports, 
    required Map<String, dynamic>? body, 
    bool isContentTypeApplicationJson = false
  }) async {

    if(isContentTypeApplicationJson){
      var response = await getDataReportApiJWT(dados: body, url: urlreports);
      return jsonDecode(response);
    } else {
      http.Response response = await http.post(
        Uri.parse('${Settings.enderecoRepositorio}$urlreports'),
        body: body,
      );

      try {
        return jsonDecode(response.body);
      } catch (e) {
        return [
          {
            'status_code': response.statusCode,
            'mensagem': 'Dados não encontrado! Verifique os filtros selecionados e tente novamente.\nCatch message nerd: $e',
          }
        ];
      }
    }
  }

  
  Future<String> getDataReportApiJWT({String? banco, Map? dados, String? url}) async {
    //header
    var header = {
      "alg": "HS256",
      "typ": "JWT",
    };
    String header64 = base64Encode(jsonEncode(header).codeUnits);

    //payload
    var payload = dados;
    String payload64 = base64Encode(utf8.encode(jsonEncode(payload))); //utf8.encode para caracteres especiais
    //assinatura
    String secret = "tisa098*";
    var hmac = Hmac(sha256, secret.codeUnits);
    var digest = hmac.convert("$header64.$payload64".codeUnits);
    String sign = base64Encode(digest.bytes);
    String token = "$header64.$payload64.$sign";
    
    // printW(dados);
    // printT(token);

    var res = await http.post(
      Uri.parse("${Settings.enderecoRepositorio}$url"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'connection': banco,
        'token': token
      })
    );

    if (res.statusCode == 200) {
      return res.body.replaceAll("null", '""');
    } else {
      // printE('Erro de API ${res.statusCode} (jwtSendJson)');
      // printE("LINK: ${Settings.enderecoRepositorio}");
      return "";
    }
  }

  Future<Map<String, dynamic>> getConfigApi({required String function,}) async {

    http.Response response = await http.get(
      Uri.parse('${Settings.enderecoRepositorio}$function'),
    );
    try {
      return jsonDecode(response.body);
    } catch (e) {
      return 
      {
        'status_code': response.statusCode,
        'mensagem': 'Dados não encontrado! Verifique os filtros selecionados e tente novamente.\nCatch message nerd: $e',
      };
    }
  }

}
