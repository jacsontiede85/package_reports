# Package Reports
Package de criação de relatórios automaticamente a partir de uma entrada de JSON
- Principais funções:
  - Relatório com totalizadores e ordenação
  - Gráficos (Barras, pizza, ...)
  - Exportação para excel

## Getting Started

- Entre no arquivo pubspec.yaml
- Adicione isto ao arquivo pubspec.yaml do seu pacote:
``` Dart
dependencies:
     package_reports: ^0.0.2
```
- Get dependencies

``` shell
flutter pub get
``` 

## package_reports struct
``` shell
lib-|
    |-- package_reports.dart 
    |       - Contém todos os exports permitidos para uso nos projetos que irão consumir o package
    |
    |-- report_module
    |   |
    |   |-- charts
    |   |   |-- chart_data.dart
    |   |   |       - ChartData (class de dados padrão que todos os graficos vão consumir)
    |   |   |       - ColorData (class com todas as cores para consumo randômico nos gráficos)
    |   |   '-- charts.dart
    |   |           - Widget de gráficos
    |   |
    |   |-- controller
    |   |   |-- layout_controller.dart
    |   |   |       - Controlador de largura, altura e tipo de tela (mobile, desktop)
    |   |   |-- report_chart_controller.dart
    |   |   |       - Controlador para construção de gráficos do relatório, keys com valores do tipo String será identificado com métricas e tipo int, double, será definido como valores dos gráficos
    |   |   |-- report_from_json_controller.dart
    |   |   |       - CONTROLADOR PRINCIPAL que irá receber o JSON de entrada para construção do relatório, todas as keys do JSON será interpretado como nome de coluna e todos os values das respectivas keys como rows de dados 
    |   |   '-- report_to_xlsx_controller.dart
    |   |   |       - Controlador para exportar dados para Excel
    |   |   '-- filtros_controller.dart
    |   |           - Controlador de filtros
    |   |
    |   |-- core
    |   |   |-- api_consumer.dart
    |   |   |       - Arquivo responsável pelo consumo de API que irá fornecer os dados em formato JSON para construção do relatório
    |   |   |-- features.dart
    |   |   |       - rercusos de uso privado no package (funções de formatação, etc)
    |   |   '-- settings.dart
    |   |           - variveis static global como link de api, etc
    |   |
    |   |-- model
    |   |   '-- my_icon_data.dart (442 KB)
    |   |
    |   |-- page
    |   |   |-- filtros_report_page.dart
    |   |   |       - Tela de filtros
    |   |   |-- report_chart_page.dart
    |   |   |       - Tela de gráficos
    |   |   |-- report_page.dart
    |   |   |       - Página de relatórios 
    |   |   '-- filtros_page.dart
    |   |           - class de conversão do filtro antigo do sistema analytics para atual
    |   |
    |   '-- widget
    |       |-- texto.dart
    |       |-- widgets.dart
    |       '-- xlsx_widget.dart
    |
    '-- version.dart
           - Versão do package
```



## Exemplo de formatação das colunas através da key do JSON de entrada

- Exemplo que como escrever uma query na API no back-end:
```roomsql
    select 
          pcpedc.codsupervisor as cod__INT__NO_METRICS
        , pcsuperv.nome
        , count(*) qtde_pedidos__INT
        , sum(pcpedc.vlatend) as total
    from pcpedc, pcsuperv
    where pcpedc.codsupervisor = pcsuperv.codsupervisor
    and data between to_date('01/10/2023', 'DD/MM/YYYY') and to_date('02/10/2023', 'DD/MM/YYYY')
    group by pcpedc.codsupervisor, pcsuperv.nome;
```

- Saída JSON da query:
```json
    [
      {"COD__INT__NO_METRICS":"27", "NOME":"WILLIAN JOSE OTAVIO", "QTPEDIDOS__INT":"7", "TOTAL":"3449.78"},
      {"COD__INT__NO_METRICS":"26", "NOME":"INTERNO ", "QTPEDIDOS__INT":"4", "TOTAL":"2304.12"},
      {"COD__INT__NO_METRICS":"5", "NOME":"RODRIGO FERREIRA LEAO", "QTPEDIDOS__INT":"8", "TOTAL":"8028.3"},
      {"COD__INT__NO_METRICS":"11", "NOME":"GREICE QUELE RODRIGUES DE ARAUJO", "QTPEDIDOS__INT":"14", "TOTAL":"13282.55"}
    ]
```

- Tags permitidas para adição no alises da query
```dart
    /*
      Forma de realizar formatação de dados e alinhamento em tela.
      Deve-se enviar a seguinte informação no final de cada nome de coluna na query, sendo maíusculo ou minúsculo:

      __int_string    => para forçar numero ser tratado e alinhado como string
      __string        => forçar o uso de String
      __double        => forçar uso de double
      __int           => forçar uso de int
      __no_metrics    => excluir da exibição de metricas dos graficos
      __nochartarea   => excluir do grafico de area e line
      __invisible     => não exibir campo no relatório
      __dontsum       => não somar na barra de totalizador
      __perc          => colocar % (percentagem) junto ao texto da coluna
      __freeze        => congelar coluna ao deslizar barra de scroll horizontal
      __sizew         => passar largura fixa de coluna. Exemplo: __sizew30

      IMPORTANTE:
      - Caso o tipo de dado não seja informado através de uma tag especificada acima,
        o tipo de formatação será determinado a partir dos dados recebidos.
    */
```

### Relatório de saída:
![Relatório de exemplo](lib/exemplo/img/exemplo.png)
