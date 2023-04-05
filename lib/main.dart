import 'package:android_flutter_wifi/android_flutter_wifi.dart';
import 'package:flutter/material.dart';
import 'package:lcconnectv2/provider/app_state.dart';
import 'package:lcconnectv2/screens/esp_connect_screen.dart';
import 'package:lcconnectv2/theme/theme_data.dart';
import 'package:provider/provider.dart';

import 'utilities/functions.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AndroidFlutterWifi.init();
  takePermission();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(backgroundColor: bgColor),
        home: EspConfigScreen(),
      ),
    );
  }
}
