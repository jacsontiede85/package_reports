import 'package:mobx/mobx.dart';
import 'package:package_reports/global/core/features.dart';
import 'package:package_reports/report_module/controller/report_from_json_controller.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
part 'report_to_pdf.g.dart';

class ReportPDFController = ReportPDFControllerBase with _$ReportPDFController;

abstract class ReportPDFControllerBase with Store {
  
  String titulo ='';
  late ReportFromJSONController reportController;

  ReportPDFControllerBase({
    required this.titulo,
    required this.reportController,
  });


  @observable
  bool loadingExportPdf = false;

  int qtdeclientes=0;

  @observable
  List<Widget> table =[];

  String pdfFileName = 'document.pdf';
  bool landscape = true;

  //margens da pagina
  double top = 0.0;
  double left = 0.0;
  double right = 0.0;
  double bottom = 0.0;

  @action
  getDados({required ReportFromJSONController controller, required String titulo}) async {
    reportController = controller;
    this.titulo = titulo;
    loadingExportPdf = true;
    try{
      getTable();
    }catch(e){
      print('Erro Gerar Pdf report: $e');
    }
    loadingExportPdf = false;
  }

  void cabecalho(){
    table=[];
    table.clear();
  }


  @action
  void getColumns(){      
    table.add(
      Container(
        padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
        color: PdfColors.black,
        child: Row(
          children: cabecalhoColunasPdf(),
        ),
      ),
    );
  }

  List<Widget> cabecalhoColunasPdf(){
    List<Widget> colunasDados = [];
    for(var colunas in reportController.colunas){
      if(colunas['selecionado']){
        colunasDados.add(
          Expanded( 
            flex: 2, 
            child: Text(
              Features.formatarTextoPrimeirasLetrasMaiusculas(colunas['key'].toString().split('__')[0].replaceAll('_', ' ')),
              style: TextStyle(
                color: PdfColors.white,
                fontWeight: FontWeight.bold,
                fontSize: 8,
              ),
              textAlign: TextAlign.left,
            )
          ),
        );
      }
    }
    return colunasDados;
  }

  @action
  void getRows(){
    qtdeclientes =0;
    int index=0;

    for( Map<String, dynamic> model in reportController.dados ){
      List<Widget> row = [];

      model.forEach((key, value) {
        if(!key.toString().contains('__INVISIBLE') && reportController.colunas.where((element) => element['key'].toString() == key.toString() && element['selecionado']).toList().isNotEmpty ) {
          row.add(
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: Text(
                  Features.formatarTextoPrimeirasLetrasMaiusculas(value.toString()),
                  style: TextStyle(
                    color: PdfColors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          );
        }
      });

      table.add(
        Container(
          padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
          color: index%2!=0 ? PdfColors.grey50 : PdfColors.white,
          child: Row(
            children: row,
          ),
        ),
      );

      index++;
      qtdeclientes++;
    }

  }


  @action
  void getTable(){
    cabecalho();
    getColumns();
    getRows();
  }

}