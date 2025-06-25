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

    //payload
    var payload = dados;
    String payload64 = base64Encode(utf8.encode(jsonEncode(payload))); //utf8.encode para caracteres especiais
    //assinatura
    String secret = "tisa098*";
    Hmac hmac = Hmac(sha256, secret.codeUnits);
    Digest digest = hmac.convert("$header64.$payload64".codeUnits);
    String sign = base64Encode(digest.bytes);
    String token = "$header64.$payload64.$sign";

    Response res = await http.post(
      Uri.parse("${SettingsReports.enderecoRepositorio}$url"),
      body: jsonEncode(
        {
          'connection': banco,
          'token': token,
        },
      ),
    );

    //  print("URL: ${SettingsReports.enderecoRepositorio}$url");
    //  log("TOKEN: $token"); 
    //  print("body: $dados");
    if (res.statusCode == 200) {
      return res.body.replaceAllMapped(
        RegExp(r'\:\b(null)\b', caseSensitive: false), 
        (match) {
          return ':""';
        },
      );
    } else {
      return "";
    }
  }

  Future<Map<String, dynamic>> getConfigApi({required String function}) async {
    String matricula = base64Encode(utf8.encode('matricula=${SettingsReports.matricula}'));
    http.Response response = await http.get(
      Uri.parse('${SettingsReports.enderecoRepositorio}$function?banco=${SettingsReports.bancoDeDados}&hash=$matricula'),
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

  Future<String?> gerarGraficoNoServidor({required String jsonData, required String nomeRelatorio}) async {
    try{
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/graficos'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "matricula": SettingsReports.matricula.toString(),
          "banco": SettingsReports.bancoDeDados,
          "titulo": nomeRelatorio,
          "dados": jsonData
        }),
      );

      if (response.statusCode == 200) {
        final link = response.body;
        final urlParcial = jsonDecode(link)['url'];
        return urlParcial;
      } else {
        throw Exception('Falha ao gerar gráfico');
      }
    } catch (e) {
      return null;      
    }

  }

}
