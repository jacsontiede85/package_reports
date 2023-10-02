## description

Package de criação de relatórios automaticamente a partir de uma entrada de JSON

## Getting Started

- Entre no arquivo pubspec.yaml
- Adicione isto ao arquivo pubspec.yaml do seu pacote:
``` Dart
dependencies:
     package_reports: ^0.0.1
```
- Get dependencies

``` shell
flutter pub get
``` 

## package_reports struct
``` shell
'--  lib
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