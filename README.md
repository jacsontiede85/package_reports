# Package Reports
- Package de criação de relatórios automaticamente a partir de uma entrada de JSON
    - Principais funções:
    - Relatório com totalizadores e ordenação
    - Relatórios dinamicoes
    - Gráficos (Barras, pizza, ...)
    - Exportação para excel

## Getting Started

- Entre no arquivo pubspec.yaml
- Adicione isto ao arquivo pubspec.yaml do seu pacote:
``` Dart
dependencies:
     package_reports: ^0.0.3
```
- Get dependencies

``` shell
flutter pub get
```

## Exemplo de 'cabeçalho' que arquivo .PHP que contém a query deve ter
- Em um arquivo .PHP Crie uma variavel que receberá um mapa com os dados necessarios para a formação de relatorios.

    - Esse mapa tem as seguintes chaves como OBRIGATORIOS:
        * menu; 
        * submenu; 
        * url-api;
        * iconFlutterID (nome do icone que deseja exibir, não pode passar Icon., apenas o nome do icone);
        * name;
        
- Com apenas esses valores em sua variavel já possivel consumir a pagina de relatorios.
- Dentro desse mesmo mapa existe a chave 'filtros' que é usada para construir a pagina de filtros e seleção de filtros, essa chave recebe como valor um mapa, podendo receber as seguintes chaves, (*) marcado os OBRIGATORIOS:

    * tipo (checkbox, datapicker) *
    * titulo *
    - Caso o filtro seja do tipo 'checkbox' as seguintes chaves também serão obrigatorias -
        * banco *
        * arquivoquery *
        * funcao *
    - As chaves acima são necessaria para saber qual função será executada para criar as opções de filtros
        - subtitulo

- Exemplo filtros :
    ```php
        'filtros' => [
            "cardPeriodo" => [
                "tipo" => "datapicker",
                "titulo" => "Selecionar pediodo"
            ],
            "cardFilial" => [
                "banco" => "atacado_analytics",
                "arquivoquery" =>"query_filtros.php",
                "funcao" => "getfilial",
                "tipo" => "checkbox",
                "titulo" => "Selecionar filial",
                "subtitulo" => "São exibidos somente filiais com permissão na rotina 131 do Winthor"
            ],
        ]
    ```
### Pagina de Filtro:
![Exemplo pagina de filtros](lib/global/src/img/filtro.png)

![Selecionar valores para filtrar](lib/global/src/img/selecionar_filtros.png)

- Para a criação de relatorios dinamicos, no mapa da variavel que foi criada, tornasse necesasrio adiconar as seguintes chaves

    * indexPage (valor inteiro que indica qual query será a executada)
    * page (necessario para que a nevegação para proxima pagina do relatorio seja feita) 

- ```page``` tambem é do tipo map, e receberá os mesmo valores da variavel inicial ou seja tudo que foi explicado acima pode ser passado 
dentro de ```page```, ```page``` é a proxima pagina do relatorio e tambem pode recerber a si mesma

    
- Exemplo variavel princial:


```php
    $config = [
        'menu'=> $menu,
        'submenu'=> $submenu,
        'urlapi'=> $urlapi.$nomeDoArquivo,
        'name'=> $name,
        'iconFlutterID'=> 'trending_up', // --> https://fonts.google.com/icons?selected=Material+Icons&icon.platform=flutter
        'graficosDisponiveis' => [
            'barras',
            'linhas',
            'circular',
        ],
        'indexPage'=> 0,
        'filtros'=> [
            "cardPeriodo" => [
                "tipo" => "datapicker",
                "titulo" => "Selecionar pediodo"
            ],
            "cardsupervisor" => [
                "banco" => "atacado_analytics",
                "arquivoquery" =>"query_filtros.php",
                "funcao" => "getSupervisor",
                "tipo" => "checkbox",
                "titulo" => "Selecionar supervisor",
                "subtitulo" => "São exibidos somente supervisores com permissão na rotina 131 do Winthor"
            ],
        ],

        'page' => [
            'menu'=> $menu,
            'submenu'=> $submenu,
            'urlapi'=> 'repositorio/reports/query/compras/sql1.php',
            'name'=> 'Resumo de vendas (Por rca)',
            'iconFlutterID'=> 'trending_up',
            'indexPage'=> 1,
            'selectedRow' => [],
            'filtros'=> [
                "cardPeriodo" => [
                    "tipo" => "datapicker",
                    "titulo" => "Selecionar pediodo"
                ],
                "cardFilial" => [
                    "banco" => "atacado_analytics",
                    "arquivoquery" =>"query_filtros.php",
                    "funcao" => "getfilial",
                    "tipo" => "checkbox",
                    "titulo" => "Selecionar filial",
                    "subtitulo" => "São exibidos somente filiais com permissão na rotina 131 do Winthor"
                ],
            ],

            'page' => [
                'menu'=> $menu,
                'submenu'=> $submenu,
                'urlapi'=> 'repositorio/reports/query/compras/sql1.php',
                'name'=> 'Teste segunda navegação',
                'iconFlutterID'=> 'trending_up',
                'indexPage'=> 2,
                'selectedRow' => [],
            ]
        ]
    ];
```

- O arquivo .PHP tendo a variavel preenchido dessa forma basta fazer uma requisição do tipo ```GET``` para obter os valores:
    ```php
        if ($_SERVER['REQUEST_METHOD'] === 'GET'){
            echo json_encode($config);
            exit;
        }
    ```

        
- Agora para receber o valor da query basta enviar um body/json em uma requisição do tipo ```POST```, para retornar relatorio simples basta fazer o segiunte retorno:
    ```php
        $sql = "SELECT 1 + 1 SOMA FROM DUAL"
        $result = $classe->select( $sql );
        echo json_encode($result);
        exit;
    ```
- Para obter o retorno do relatorio dinamico, no arquivo principal é necessario uma pequena tratativa para executar as query informadas em cadas arquivo, lembrando que as que nesse tipo de relatorio os arquivos precisarão apenas da tratativa do ```selectedRow``` e o ```indexPage```, os arquivos mostrado no exemplo abaixo pode ser usado mais de uma vez, um mesmo arquivo que contem querys diferentes:

```php

    else{
        include_once "data_input_and_jwt_validation.php";
        $obj = get_data_input_and_jwt_validation();

        include_once "bd_instancia.php";
        
        switch($obj->indexPage){
            case 0:
                include_once "query_teste_api.php";
                $db     = instancia_DB($obj->database);
                $result = $db->select($sql);
                break;

            case 1:
                include_once "sql1.php";
                $db     = instancia_DB($obj->database);
                $result = $db->select($sql);
                break;
        }

        http_response_code(200);
        echo json_encode($result);
        exit;        
    }
```
### Saída JSON da query:
```json
    [
      {"COD__INT__NO_METRICS":"4321","NOME":"ADIL MENESES DOS SANTOS","QTDE_PEDIDOS__INT":"1","TOTAL":"487.37"},
      {"COD__INT__NO_METRICS":"2940","NOME":"ADMILTON MOREIRA SOUZA","QTDE_PEDIDOS__INT":"3","TOTAL":"1486.18"},
      {"COD__INT__NO_METRICS":"4318","NOME":"LUIZ FERRAZ DOS SANTOS","QTDE_PEDIDOS__INT":"1","TOTAL":"940.4"},
      {"COD__INT__NO_METRICS":"4307","NOME":"AGATINE OFLIA DE OLIVEIRA","QTDE_PEDIDOS__INT":"1","TOTAL":"1826.08"},
      {"COD__INT__NO_METRICS":"2","NOME":"FERREIRA DE OLIVEIRA","QTDE_PEDIDOS__INT":"3","TOTAL":"2802.86"}
    ]
```

- Tags permitidas para adição no alises da query
```dart
    /*
      Forma de realizar formatação de dados e alinhamento em tela.
      Deve-se enviar a seguinte informação no final de cada nome de coluna na query:

      __INT_STRING    => para forçar numero ser tratado e alinhado como string
      __STRING        => forçar o uso de String
      __DOUBLE        => forçar uso de double
      __INT           => forçar uso de int
      __NO_METRICS    => excluir da exibição de metricas dos graficos
      __NOCHARTAREA   => excluir do grafico de area e line
      __INVISIBLE     => não exibir campo no relatório
      __DONTSUM       => não somar na barra de totalizador
      __PERC          => colocar % (percentagem) junto ao texto da coluna
      __FREEZE        => congelar coluna ao deslizar barra de scroll horizontal
      __SIZEW         => passar largura fixa de coluna. Exemplo: __SIZEW300
      __LOCK          => Validar se o usuario tem acesso ao campo
      __ISRODAPE      => Usar para fazer um rodapé personalizado

      IMPORTANTE: coso o tipo de dado não seja informado, o tipo de formatação será identificado a partir dos dados recebidos
    */
```

### Relatório de saída:
![Relatório de exemplo](lib/global/src/img/exemplo.png)

### Relatório de saída - Gráficos:
![Relatório de exemplo](lib/global/src/img/exemplo_grafico.png)

### Relatório de saída - Exporte para Excel:
![Relatório de exemplo](lib/global/src/img/exemplo_xlsx.png)


## Estrutura do package_reports
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