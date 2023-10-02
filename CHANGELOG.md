## 0.0.2
Correções

## 0.0.1
Package de criação de relatórios automaticamente a partir de uma entrada de JSON.
Ao receber o JSON, será criação a partir das keys do JSON as colunas e será definido com os values das
respectivas keys.
    FUNCIONALIDADES PRINCIPAIS:
    - Ordenação de cada coluna
    - Gráficos de linha, pizza, barras, etc
    - Exportar dados para excel

## 0.0.0 create
criar package:

``` shell
    flutter create --template=package package_reports
```

PUBLICAR PACKAGE
dart pub publish -> publicar um package
O uso do --dry-run permite que você verifique se tudo está configurado corretamente

``` shell
    dart pub publish --dry-run
    
    OU
    
    dart pub publish
```
    