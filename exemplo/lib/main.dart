import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_reports/global/core/settings.dart';
import 'package:package_reports/report_module/page/report_page.dart';

void main() {
  SettingsReports().setEnderecoApi(enderecoUrl: 'https://analytics.agnconsultoria.com.br/api/');
  // SettingsReports().setEnderecoApi(enderecoUrl: 'https://api.agnconsultoria.com.br/');
  SettingsReports().setMatricula(matriculaUsu: 3374);
  SettingsReports().setBancoDeDados(banco: 'atacado');
  SettingsReports.getFiltrosSalvos();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Teste Report Package',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Teste de Reports Pages",
        ),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              icon: const Icon(
                CupertinoIcons.doc,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportPage(
                      database: SettingsReports.bancoDeDados,
                      buscarDadosNaEntrada: false,
                      // function: 'vendas/venda-por-rca/index.php',
                      // function: 'compras/pedido-de-compra-saldo/index.php',
                      // function: 'comercial/ultima-data-pedido-rca/index.php',
                      // function: 'comercial/consultar-clientes/index.php',
                      // function: 'quadro_kanban/index.php',
                      // function: 'compras/leadtime-compras/index.php',
                      // function: 'compras/pedido-de-compra-saldo/index.php',
                      // function: 'campanha_milionaria/campanha-milionaria-dca-sintetico-por-supervisor/index.php',
                      // function: 'dashboard/query_vendas/leadtime_analitico/index.php',
                      // function: 'campanha/campanha-amakha-paris/index.php',
                      // function: 'campanha_milionaria/campanha-milionaria-dca-por-rca/index.php',
                      // function: 'vendas/venda-por-cliente/index.php',
                      // function: 'comercial/evolucao-venda-anual-por-rca/index.php',
                      // function: 'compras/ruptura-estoque-fornecedor/index.php',
                      function: 'financeiro/inadimplencia-por-cliente/index.php',
                      //function: 'compras/assistente-compras/assistente_compras_report.php',
                    ),
                  ),
                );
              },
            ),
            IconButton.filledTonal(
              icon: const Icon(
                CupertinoIcons.settings,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReportPage(
                      database: SettingsReports.bancoDeDados,
                      buscarDadosNaEntrada: false,
                      function: 'vendas/venda-por-rca/index.php',
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
