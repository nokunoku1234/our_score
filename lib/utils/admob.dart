import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_google_ad_manager/flutter_google_ad_manager.dart';

class AdMob {
  static final isTest = false;
  static final isVisible = true;

  static double smartBannerWidth = 0.0;
  static double smartBannerHeight = 0.0;
  static Widget bannerContainer;
  static Widget rectangleBannerContainer;

  static Map<String, dynamic> deviceData;

  static DFPBannerViewController bannerViewController;
  static DFPInterstitialAd interstitialAd;

  static getBannerUnitId() {
    return
      Platform.isAndroid
          ? 'ca-app-pub-6087076072607667/2385839317'
          : 'ca-app-pub-6087076072607667/5203574341';
  }

  static getInterstitialUnitId() {
    return
      Platform.isAndroid
          ? ''
          : '';
  }

  static reload() {
    bannerViewController?.reload();
  }

  static void getInterstitial() {
    interstitialAd = DFPInterstitialAd(
      isDevelop: isTest,
      adUnitId: getInterstitialUnitId(),
      onAdLoaded: () {
        print('interstitialAd onAdLoaded');
      },
      onAdFailedToLoad: (errorCode) {
        print('interstitialAd onAdFailedToLoad: errorCode:$errorCode');
      },
      onAdOpened: () {
        print('interstitialAd onAdOpened');
      },
      onAdClosed: () {
        print('interstitialAd onAdClosed');
        interstitialAd.load();
      },
      onAdLeftApplication: () {
        print('interstitialAd onAdLeftApplication');
      },
    );
    interstitialAd.load();
  }

  //バナー広告表示メソッド
  static Widget getBannerContainer(BuildContext context) {
    if(!isVisible) {
      bannerContainer = Container();
    } else if (null == bannerContainer) bannerContainer = buildBannerContainer(context);

    return bannerContainer;
  }

  static Widget buildBannerContainer(BuildContext context) {
    if (Platform.isIOS) return buildSmartBannerContainer(context);

    return DFPBanner(
      isDevelop: isTest,
      adUnitId: getBannerUnitId(),
      adSize: DFPAdSize.BANNER,
      onAdViewCreated: (controller) {
        bannerViewController = controller;
      },
      onAdOpened: () { //バナー広告をタップしたときの動作
        print('Banner onAdOpened');
      },
      testDevices: MyTestDevices(),
    );
  }

  static Widget buildSmartBannerContainer(BuildContext context) {
    final adWidth   = getSmartBannerWidth(context);
    final adHeight  = getSmartBannerHeight(context);

    print('width $adWidth, height $adHeight');

    return Container(
      width: adWidth,
      height: adHeight,
      child: DFPBanner(
        isDevelop: isTest,
        adUnitId: getBannerUnitId(),
        adSize: DFPAdSize.SMART_BANNER,
        testDevices: MyTestDevices(),
      ),
    );
  }

  static double getSmartBannerWidth(BuildContext context) {
    if (0.0 == smartBannerWidth) {
      smartBannerWidth = MediaQuery.of(context).size.width;
    }

    return smartBannerWidth;
  }

  static double getSmartBannerHeight(BuildContext context) {
    if (0.0 == smartBannerHeight) {
      smartBannerHeight = initSmartBannerHeight(context, deviceData);
    }

    return smartBannerHeight;
  }

  static double initSmartBannerHeight(BuildContext context, Map<String, dynamic> deviceData) {
    final mediaQuery = MediaQuery.of(context);

    if (Platform.isAndroid) {
      if (mediaQuery.size.height > 720) {
        if (mediaQuery.size.width >= 600) {
          return 90.0;
        }
        else {
          return 50.0;
        }
      }

      if (mediaQuery.size.height > 400) return 50;
      return 50.0;
    }

    if (Platform.isIOS) {
      if (isIPad(deviceData)) return 90.0;
      if (mediaQuery.orientation == Orientation.portrait) return 50.0;
      return 32.0;
    }

    return 50.0;
  }

  static bool isIPad(Map<String, dynamic> deviceData) {
    return deviceData['name'].toString().toLowerCase().contains('ipad');
  }

  static Future<Map<String, dynamic>> getDeviceData() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    return deviceData;
  }

  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
    };
  }

  static Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

}

//実機テストするデバイスを登録
class MyTestDevices extends TestDevices {

  static MyTestDevices _instance;

  factory MyTestDevices() {
    if (_instance == null) _instance = new MyTestDevices._internal();
    return _instance;
  }

  MyTestDevices._internal();

  @override
  List<String> get values => List()
//    ..add('0F7B8121162BD49C306539490D25FB70') //井上Android
//    ..add('0105344bae7a74342068be72fe5033a0') //井上iPhoneX
    ..add('b4cc3764a6802af0cd7810e5cee84399'); //奥野iPhoneXR

}