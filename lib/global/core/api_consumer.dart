import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';
import 'package:http/http.dart';
import 'package:package_reports/global/core/settings.dart';
import 'dart:convert';

class API with SettingsReports {
  Future<String> getDataReportApiJWT({String? banco, Map? dados, String? url}) async {
    //header
    Map<String, String> header = {
      "alg": "HS256",
      "typ": "JWT",
    };
    String header64 = base64Encode(jsonEncode(header).codeUnits);

    // print(dados);

    //payload
    var payload = dados;
    String payload64 = base64Encode(utf8.encode(jsonEncode(payload))); //utf8.encode para caracteres especiais
    //assinatura
    String secret = "tisa098*";
    Hmac hmac = Hmac(sha256, secret.codeUnits);
    Digest digest = hmac.convert("$header64.$payload64".codeUnits);
    String sign = base64Encode(digest.bytes);
    String token = "$header64.$payload64.$sign";
    // log(token);
    Response res = await http.post(
      Uri.parse("${SettingsReports.enderecoRepositorio}$url"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(
        {
          'connection': banco,
          'token': token,
        },
      ),
    );

    if (res.statusCode == 200) {
      return res.body.replaceAll("null", '""');
    } else {
      return "";
    }
  }

  Future<Map<String, dynamic>> getConfigApi({
    required String function,
  }) async {
    String matricula = base64Encode(utf8.encode('matricula=${SettingsReports.matricula}'));
    http.Response response = await http.get(
      Uri.parse('${SettingsReports.enderecoRepositorio}$function?hash=$matricula'),
    );
    try {
      return jsonDecode(
        response.body,
      );
    } catch (e) {
      return {
        'status_code': response.statusCode,
        'mensagem': 'Dados não encontrado! Verifique os filtros selecionados e tente novamente.\nCatch message nerd: $e',
      };
    }
  }
}
