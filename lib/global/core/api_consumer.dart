import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:package_reports/global/core/settings.dart';
import 'dart:convert';

class API with SettingsReports {
  Map<String, String> _cabecalhos() => {
    'Content-Type': 'application/json; charset=UTF-8',
    'Authorization': 'Bearer ${SettingsReports.obterToken()}',
  };

  Future<void> _tratarNaoAutenticado(int statusCode) async {
    if (statusCode == 401) await SettingsReports.aoNaoAutenticado?.call();
  }

  Future<String> getDataReportApiJWT({String? banco, Map? dados, String? url}) async {
    final corpo = Map.of(dados ?? {});
    if (banco != null && (corpo['database'] ?? '').toString().isEmpty) corpo['database'] = banco;

    Response res = await http.post(
      Uri.parse("${SettingsReports.enderecoRepositorio}$url"),
      headers: _cabecalhos(),
      body: jsonEncode(corpo),
    );

    if (res.statusCode == 200) {
      return res.body.replaceAllMapped(
        RegExp(r'\:\b(null)\b', caseSensitive: false), 
        (match) {
          return ':""';
        },
      );
    } else {
      await _tratarNaoAutenticado(res.statusCode);
      return "";
    }
  }

  Future<Map<String, dynamic>> getConfigApi({required String function}) async {
    http.Response response = await http.get(
      Uri.parse('${SettingsReports.enderecoRepositorio}$function?banco=${SettingsReports.bancoDeDados}'),
      headers: _cabecalhos(),
    );
    await _tratarNaoAutenticado(response.statusCode);
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
