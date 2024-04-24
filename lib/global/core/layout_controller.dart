import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:responsive_builder/responsive_builder.dart';
part 'layout_controller.g.dart';

class LayoutControllerPackage = LayoutControllerPackageBase with _$LayoutControllerPackage;

abstract class LayoutControllerPackageBase with Store {


  // ALTURA E LARGURA DO DISPOSITIVO
  @observable
  double height = 0;
  @observable
  double width = 0;

  // TIPO DE DISPOSITIVO E PLATAFORMA
  @observable
  bool mobile = true;
  @observable
  bool tablet = false;
  @observable
  bool desktop = false;
  @observable
  bool web = false;
  @observable
  bool platformIOSAndroid = true;
  @observable
  bool platformIOS = false;


  // TELA HOME
  @observable
  double widthMenuDesktop = 0;
  @observable
  double widthAreaDeCardDesktop = 0;
  @observable
  double widthCard = 0;

  //CONFIGURAÇÃO DE JANELA MODAL
  @observable
  double widthCampoPesquisa = 250;

  @observable
  bool loadApp = true;

  @observable
  bool menuDrawerDesktopVisible = true;

  @computed
  double get larguraEndDrawerFiltros{
    if(desktop && width <1100) {
      return 400;
    } else if(desktop && width >1500){
      return 500;      
    }
    else if( mobile || tablet ){
      return width;      
    }
    else{
      return width*0.35;      
    }
  }

  @computed
  double get larguraJanelaFiltrosPesquisa{
    if( mobile || tablet ) {
      return width;
    } else if(desktop && width <1100){
      return width*0.50;      
    }
    else{
      return width*0.40;      
    }
  }


  @action
  setSizeScreen({required altura, required largura, required SizingInformation sizingInformation, required BuildContext context}) {
    setDeviceScreenType(sizingInformation: sizingInformation, context: context);
    height = altura;
    width = largura;

    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      tablet = sizingInformation.deviceScreenType == DeviceScreenType.tablet;
    }else {
      desktop = sizingInformation.deviceScreenType == DeviceScreenType.tablet;
    }

    if ( width >= 900 ) {
      desktop = true;
      mobile = false;
      tablet = false;
    }else if (!mobile) {
      mobile = width < 300 ? true : false;
      desktop = false;
    }


    widthMenuDesktop = (width * 0.25) > 400 ? 400 : (width * 0.25); //25% da largura da tela, se maior que 400, será considerado 400 como largura máxima

    if (mobile || tablet) {
      widthAreaDeCardDesktop = width;
    } else {
      widthAreaDeCardDesktop = width;
    }

    if (mobile || tablet) {
      widthCard = width - 10;
    } else {
      if (widthAreaDeCardDesktop < 900) {
        widthCard = widthAreaDeCardDesktop * 0.999; //95%
      } else {
        widthCard = widthAreaDeCardDesktop * 0.48; //47%
      }
    }

  }



  setDeviceScreenType({required SizingInformation sizingInformation, required BuildContext context}) {
    mobile = sizingInformation.deviceScreenType == DeviceScreenType.mobile;
    tablet = sizingInformation.deviceScreenType == DeviceScreenType.tablet;
    desktop = sizingInformation.deviceScreenType == DeviceScreenType.desktop;
    web = kIsWeb ? true : false;
    platformIOSAndroid = (Theme.of(context).platform == TargetPlatform.iOS || Theme.of(context).platform == TargetPlatform.android);

    platformIOS = (Theme.of(context).platform == TargetPlatform.iOS);
  }
}
