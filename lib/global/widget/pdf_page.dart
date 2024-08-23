import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_reports/report_module/controller/report_to_pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrintingPDFPage extends StatelessWidget {
  final ReportPDFController controller;
  const PrintingPDFPage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    //ENVIAR LOG DE ACESSO

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black87,
            surfaceTintColor: Colors.transparent,
            title: Text(
              controller.titulo,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            automaticallyImplyLeading: true,
            leading: IconButton(
              tooltip: 'Fechar',
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
          body: PdfPreview(
            loadingWidget: Center(
              child: LoadingAnimationWidget.halfTriangleDot(
                color: const Color.fromARGB(255, 102, 78, 238),
                size: 40,
              ),
            ),
            actionBarTheme: const PdfActionBarTheme(
              backgroundColor: Colors.black87,
              iconColor: Colors.white,
              elevation: 10
            ),
            canChangeOrientation: false,
            allowPrinting: true,
            allowSharing: true,
            canChangePageFormat: false,
            canDebug: false,
            pdfFileName: controller.pdfFileName,
            build: (format) => _generatePdf(format, context),
          ),
        ),
      ],
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, BuildContext context) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: false, pageMode: PdfPageMode.fullscreen);

    pdf.addPage(
      pw.MultiPage(
        maxPages: 20,
        pageFormat: controller.landscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4,
        margin: pw.EdgeInsets.only(
          top: controller.top,
          left: controller.left,
          right: controller.right,
          bottom: controller.bottom
        ),
        build: (context) => controller.table,
      ),
    );

    return pdf.save();
  }
}