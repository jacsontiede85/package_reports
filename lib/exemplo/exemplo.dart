import 'package:flutter/material.dart';

class ExemploReportPage extends StatefulWidget {
  const ExemploReportPage({super.key});

  @override
  State<ExemploReportPage> createState() => _ExemploReportPageState();
}

class _ExemploReportPageState extends State<ExemploReportPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exemplo de uso package_report'),
      ),
      body: Container(
        color: Colors.transparent,
      ),
    );
  }
}
