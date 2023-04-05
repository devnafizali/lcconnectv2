import 'dart:async';

import 'package:android_flutter_wifi/android_flutter_wifi.dart';
import 'package:flutter/cupertino.dart';

class AppState extends ChangeNotifier {
  List<WifiNetwork>? wifiList;
  setWifiList() async {
    ActiveWifiNetwork activeWifiNetwork =
        await AndroidFlutterWifi.getActiveWifiInfo();

    wifiList = await AndroidFlutterWifi.getWifiScanResult();
    if (wifiList!.isNotEmpty) {
      WifiNetwork wifiNetwork = this.wifiList![0];
      print(activeWifiNetwork.ssid);
    }
    notifyListeners();
  }

  get getWifiList => wifiList;
}
