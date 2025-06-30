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

  Future<String?> gerarGraficoNoServidor({required String jsonData, required String nomeRelatorio, required List<Map<String,dynamic>> agrupamentos}) async {
    try{
      String chave = "grafic_criation@2025";
      String dados = jsonEncode({
        "matricula": SettingsReports.matricula.toString(),
        "banco": SettingsReports.bancoDeDados,
        "titulo": nomeRelatorio,
        "dados": jsonData,
        "agrupamentos" : agrupamentos
      });

      final List<int> bodyBytes = utf8.encode(dados);

      final hmacSha256 = Hmac(sha256, utf8.encode(chave));
      final assinatura = hmacSha256.convert(bodyBytes);

      // ✅ Aqui está a assinatura em Base64
      final assinaturaBase64 = base64.encode(assinatura.bytes);

      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/graficos'),
        headers: {
          'Content-Type': 'application/json',
          'X-HMAC-SIGNATURE': assinaturaBase64
        },
        body: dados,
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
