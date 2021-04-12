import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdMobService {
  String getAppId() {
    if (Platform.isIOS) {
      return '';
    } else if (Platform.isAndroid) {
      return '';
    }
    return null;
  }

  String getBannerAdUnitId() {
    const bool kReleaseMode =
        bool.fromEnvironment('dart.vm.product', defaultValue: false);
    if (kReleaseMode) {
      if (Platform.isIOS) {
        return '';
      } else if (Platform.isAndroid) {
        return '';
      }
    }
    return BannerAd.testAdUnitId;
  }

  String getInterstitialAdUnitId() {
    const bool kReleaseMode =
        bool.fromEnvironment('dart.vm.product', defaultValue: false);
    if (kReleaseMode) {
      if (Platform.isIOS) {
        return '';
      } else if (Platform.isAndroid) {
        return '';
      }
    }
    return InterstitialAd.testAdUnitId;
  }
}
