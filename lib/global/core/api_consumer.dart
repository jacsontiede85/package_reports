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

  Future<List> getDataReportApi({required String function,}) async {

    http.Response response = await http.post(
      Uri.parse('${Settings.enderecoRepositorio}/$function'),
      body: {
        "url-reports" : function,
        "banco": "atacado",
        "dtinicio": "19/02/2024",
        "dtfim": "20/02/2024",
        "exibirCardDataFaturamento": "",
        "exibirOpcaoRCASemVendas" :"",
        "rcaAtivosInativos" :"",
        "filial": "1,7,8",
        "supervisor": "15",
        "matricula": "3312",
        "posicao": "",
        "pcpedi_numped": "",
        "pcclient_codcli": "",
        "pcclient_codcliprinc": "",
        "pcusuari_codusur": "",
        "pcplpag_codplpag": "",
        "pcpraca_codpraca": "",
        "pcregiao_numregiao": "",
        "pccob_codcob": "",
        "pcprodut_codprod": "",
        "pcprodut_codprodprinc": "",
        "pcpraca_rota": "",
        "pcsecao_codsec": "",
        "pcdepto_codepto": "",
        "pcativi_codativ": "",
        "pccidade_codcidade": "",
        "pcfornec_codfornec": "",
        "pcclient_estcob": "",
        "pcpedc_origemped": "",
        "pcmarca_codmarca": "",
        "pcpedido_tipobonific": "",
        "rankingRuptura": "",
        "pcprodut_classe":"",
        "mes_campanha": "",
        "comprador": "",
      },
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

  Future<Map<String, dynamic>> getConfigApi({required String function,}) async {

    http.Response response = await http.get(
      Uri.parse('${Settings.enderecoRepositorio}/$function'),
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
