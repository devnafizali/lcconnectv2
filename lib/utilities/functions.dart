import 'package:android_flutter_wifi/android_flutter_wifi.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:lcconnectv2/widgets/custom_widgets.dart';
import 'package:request_permission/request_permission.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;

goto(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

allFinishGoto(context, page) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

bool connected = false;
String session = "ABCDE";
String email = "";

connectEspDevice({id, pass}) async {
  String ssid = id;
  String password = pass;

  if (ssid.isEmpty) {
    throw ("SSID can't be empty");
  }
  if (password.isEmpty) {
    throw ("Password can't be empty");
  }
  debugPrint('Ssid: $ssid, Password: $password');

  ///Return boolean value
  ///If true then connection is success
  ///If false then connection failed due to authentication
  WiFiForIoTPlugin.getIP();
  var result = await AndroidFlutterWifi.connectToNetwork(ssid, password);

  debugPrint('---------Connection result-----------: ${result.toString()}');
}

takePermission() async {
  RequestPermission requestPermission = RequestPermission.instace;
  requestPermission.requestMultipleAndroidPermissions({
    "android.permission.CHANGE_WIFI_STATE",
    "android.permission.ACCESS_WIFI_STATE",
    "android.permission.ACCESS_NETWORK_STATE",
    "android.permission.ACCESS_FINE_LOCATION",
    "android.permission.ACCESS_COARSE_LOCATION"
  }, 101);
}

showMyDialog({required context, title, required message, isLoading}) {
  showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Dialog(
            child: Container(
              height: 120,
              // width: 300,
              padding: EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  marginTop(20),
                  Text(
                    message,
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

bool isMacAddress(String input) {
  final RegExp regex = RegExp(
    r'^([0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}$',
    caseSensitive: false,
    multiLine: false,
  );
  return regex.hasMatch(input);
}

bool isNum(text) {
  try {
    double.parse(text);
    return true;
  } catch (e) {
    return false;
  }
}

Future<bool> isInternetAccessible() async {
  print("Checking Internet");
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult != ConnectivityResult.none) {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(Duration(seconds: 3));
      if (response.statusCode == 200) {
        // Internet connection is available.
        return true;
      }
    } catch (e) {
      // Error while trying to access the internet.
      return false;
    }
  }
  // No internet connection.
  return false;
}
