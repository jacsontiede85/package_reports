import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_reports/global/core/settings.dart';
import 'package:package_reports/report_module/page/report_page.dart';

void main() {
  SettingsReports().setEnderecoApi(enderecoUrl: 'https://analytics.agnconsultoria.com.br/api/');
  // SettingsReports().setEnderecoApi(enderecoUrl: 'https://api.agnconsultoria.com.br/');
  SettingsReports().setMatricula(matriculaUsu: 3312);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste Report Package',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Teste de Reports Pages'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              icon: const Icon(CupertinoIcons.doc),
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (context) => ReportPage(
                      database: "atacado",
                      buscarDadosNaEntrada: false,
                      function: 'vendas/venda-por-rca/index.php',
                      // function: 'comercial/clientes-sem-vendas/index.php',
                    ),
                  )
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
