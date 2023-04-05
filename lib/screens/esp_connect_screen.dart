import 'dart:async';
import 'dart:io';
import 'package:android_flutter_wifi/android_flutter_wifi.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lcconnectv2/data/api.dart';
import 'package:lcconnectv2/provider/app_state.dart';
import 'package:lcconnectv2/screens/dashboard_screen.dart';
import 'package:lcconnectv2/screens/login.dart';
import 'package:lcconnectv2/theme/theme_data.dart';
import 'package:lcconnectv2/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:http/http.dart' as http;

import '../utilities/functions.dart';

class EspConfigScreen extends StatefulWidget {
  EspConfigScreen({Key? key}) : super(key: key);

  @override
  State<EspConfigScreen> createState() => _EspConfigScreenState();
}

class _EspConfigScreenState extends State<EspConfigScreen> {
  TextEditingController password = TextEditingController();

  bool isVerified = true;
  late AppState providerData;
  bool connecting = false;
  bool canGoForWifi = false;
  bool canSearch = true;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    // startScan();
  }

  // startScan() async {
  //   bool checkWifi = await AndroidFlutterWifi.isWifiEnabled();
  //   if (!checkWifi) {
  //     AndroidFlutterWifi.enableWifi();
  //   } else {
  //     Provider.of<AppState>(context, listen: false).setWifiList();
  //   }
  //   Timer(Duration(seconds: 5), () {
  //     startScan();
  //   });
  // }

  startapi() async {
    if (canSearch) {
      dynamic res = await apipost("varify", {}).timeout(Duration(seconds: 3),
          onTimeout: () {
        print("Timed Out");
      });
      print(res);
      if (res.toString() == "true") {
        setState(() {
          connecting = false;
          connected = true;
        });
        timer!.cancel();
      } else {
        print("ESP not found");
        if (canGoForWifi) {
          if (Platform.isAndroid) {
            print("intenting");
            final AndroidIntent intent = AndroidIntent(
              action: 'android.settings.WIFI_SETTINGS',
            );
            intent.launch();
          } else if (Platform.isIOS) {
            const url = 'App-Prefs:root=WIFI';
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          }
          canGoForWifi = false;
        }
        Timer(Duration(seconds: 3), () {
          startapi();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    providerData = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
          child: Column(
            children: [
              marginTop(40),
              customText('Connect Your Device',
                  size: 25, fontWeight: FontWeight.w600),
              marginTop(40),
              customRoundedContainer(
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.height - 200,
                  child: Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: InkWell(
                              onTap: () {
                                if (connected) {
                                  setState(() {
                                    connected = false;
                                    session = "ABCD";
                                  });
                                } else if (connecting) {
                                  setState(() {
                                    connecting = false;
                                  });
                                } else {
                                  setState(() {
                                    connecting = true;
                                    canGoForWifi = true;
                                    canSearch = true;
                                    startapi();
                                    timer = Timer(Duration(seconds: 25), () {
                                      setState(() {
                                        connecting = false;
                                        canSearch = false;
                                        canGoForWifi = false;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Device not found, please try again."),
                                              duration: Duration(seconds: 6)),
                                        );
                                      });
                                    });
                                  });
                                }
                              },
                              child: Container(
                                height: 160,
                                width: 160,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      if (connecting || connected)
                                        BoxShadow(
                                            color: bgColor,
                                            offset: Offset(2, 2),
                                            spreadRadius: 1,
                                            blurRadius: 50.0)
                                    ],
                                    border: !connecting && !connected
                                        ? Border.all(
                                            color: bgColor,
                                            width: 3,
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(100)),
                                child: Center(
                                    child: Stack(
                                  children: [
                                    if (connecting)
                                      Center(
                                          child: Container(
                                        height: 160,
                                        width: 160,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 9,
                                          color: bgColor,
                                        ),
                                      )),
                                    Center(
                                      child: Text(
                                        connecting
                                            ? "verifying"
                                            : connected
                                                ? "Disconnect"
                                                : "Connect",
                                        style: TextStyle(
                                            color: bgColor,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                )),
                              ),
                            ),
                          ),

                          // Expanded(
                          //     flex: 10,
                          //     child: Container(
                          //         child: providerData.getWifiList != null &&
                          //                 providerData.getWifiList!.length > 0
                          //             ? ListView.builder(
                          //                 itemCount:
                          //                     providerData.wifiList?.length ?? 0,
                          //                 itemBuilder: (context, index) {
                          //                   return customWifieListTile(
                          //                       providerData.wifiList![index].ssid,
                          //                       providerData.wifiList![index].bssid,
                          //                       ontap: () async {
                          //                     final AndroidIntent intent =
                          //                         AndroidIntent(
                          //                       action:
                          //                           'android.settings.WIFI_SETTINGS',
                          //                     );
                          //                     intent.launch();

                          //                     // customDialogBox(
                          //                     //   context,
                          //                     //   content: Container(
                          //                     //     height: 200,
                          //                     //     child: Column(
                          //                     //       children: [
                          //                     //         Align(
                          //                     //           alignment:
                          //                     //               Alignment.topLeft,
                          //                     //           child: customText(
                          //                     //               '${providerData.wifiList![index].ssid}',
                          //                     //               color: bgColor,
                          //                     //               size: 20),
                          //                     //         ),
                          //                     //         marginTop(20),
                          //                     //         customTextField(
                          //                     //             controller: password,
                          //                     //             labelTxt: 'Password',
                          //                     //             hintTxt:
                          //                     //                 'Enter Password'),
                          //                     //         marginTop(20),
                          //                     //         Row(
                          //                     //           mainAxisAlignment:
                          //                     //               MainAxisAlignment
                          //                     //                   .spaceAround,
                          //                     //           children: [
                          //                     //             customBtn(
                          //                     //               textColor: bgColor,
                          //                     //               'Cancel',
                          //                     //               color:
                          //                     //                   Color.fromARGB(
                          //                     //                       255,
                          //                     //                       255,
                          //                     //                       255,
                          //                     //                       255),
                          //                     //               ontap: () {
                          //                     //                 Navigator.of(
                          //                     //                         context)
                          //                     //                     .pop();
                          //                     //               },
                          //                     //             ),
                          //                     //             customBtn('Connect',
                          //                     //                 ontap: () async {
                          //                     //               connectEspDevice(
                          //                     //                   id: providerData
                          //                     //                       .wifiList![
                          //                     //                           index]
                          //                     //                       .ssid,
                          //                     //                   pass: password
                          //                     //                       .text);
                          //                     //               Navigator.of(
                          //                     //                       context)
                          //                     //                   .pop();

                          //                     //               customDialogBox(
                          //                     //                 context,
                          //                     //                 isVerified:
                          //                     //                     isVerified,
                          //                     //                 content: Container(
                          //                     //                     height: 200,
                          //                     //                     child: isVerified
                          //                     //                         ? Column(
                          //                     //                             children: [
                          //                     //                               marginTop(20),
                          //                     //                               Image.asset(
                          //                     //                                 'assets/images/verified.png',
                          //                     //                                 height: 70,
                          //                     //                                 width: 70,
                          //                     //                                 fit: BoxFit.fitHeight,
                          //                     //                               ),
                          //                     //                               marginTop(20),
                          //                     //                               customText('Verifying',
                          //                     //                                   color: bgColor,
                          //                     //                                   fontWeight: FontWeight.w600,
                          //                     //                                   size: 20),
                          //                     //                               marginTop(20),
                          //                     //                               customBtn(
                          //                     //                                   textColor: bgColor,
                          //                     //                                   'Cancel',
                          //                     //                                   color: Color.fromARGB(255, 255, 255, 255),
                          //                     //                                   width: 100, ontap: () {
                          //                     //                                 Navigator.of(context).pop();
                          //                     //                               }),
                          //                     //                             ],
                          //                     //                           )
                          //                     //                         : Column(
                          //                     //                             children: [
                          //                     //                               marginTop(20),
                          //                     //                               Image.asset(
                          //                     //                                 'assets/images/not-found.png',
                          //                     //                                 height: 120,
                          //                     //                                 width: 120,
                          //                     //                                 fit: BoxFit.fitHeight,
                          //                     //                               ),
                          //                     //                               marginTop(30),
                          //                     //                               customText('LC  Not Found',
                          //                     //                                   color: bgColor,
                          //                     //                                   fontWeight: FontWeight.w600,
                          //                     //                                   size: 22),
                          //                     //                             ],
                          //                     //                           )),
                          //                     //               );
                          //                     //             })
                          //                     //           ],
                          //                     //         ),
                          //                     //         marginTop(20),
                          //                     //         InkWell(
                          //                     //           child: customText(
                          //                     //               'Forgot Password?',
                          //                     //               color: bgColor),
                          //                     //         ),
                          //                     //       ],
                          //                     //     ),
                          //                     //   ),
                          //                     // );
                          //                   });
                          //                 },
                          //               )
                          //             : Center(
                          //                 child: Container(
                          //                   height: 200,
                          //                   child: Column(
                          //                     children: [
                          //                       Icon(
                          //                         Icons.warning_amber_rounded,
                          //                         color: bgColor,
                          //                         size: 75,
                          //                       ),
                          //                       customText('No Available Devices',
                          //                           size: 19, color: bgColor),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ))),
                          // Expanded(
                          //   child: Container(
                          //     child: Align(
                          //       alignment: Alignment.bottomCenter,
                          //       child: customText(
                          //         'Find Your LC Device And And Connect With It\'s Wifi',
                          //         size: 14,
                          //         color: bgColor,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          connecting
                              ? "Trying to connect"
                              : connected
                                  ? "Connected"
                                  : "Not Connected",
                          style: TextStyle(
                              color: connected
                                  ? Colors.greenAccent
                                  : connecting
                                      ? bgColor
                                      : bgColorDisabled,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.only(bottom: 40),
                          child: customBtn('Log In',
                              width: 220,
                              color: connected
                                  ? bgColor
                                  : Color.fromARGB(255, 189, 189, 189),
                              ontap: () {
                            if (connected) goto(context, LoginScreen());
                          }, dropShadow: true),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
