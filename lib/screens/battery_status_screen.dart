import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lcconnectv2/data/api.dart';
import 'package:lcconnectv2/theme/theme_data.dart';
import 'package:lcconnectv2/utilities/functions.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../widgets/custom_widgets.dart';

class BatteryStatusScreen extends StatefulWidget {
  const BatteryStatusScreen({Key? key}) : super(key: key);

  @override
  State<BatteryStatusScreen> createState() => _BatteryStatusScreenState();
}

class _BatteryStatusScreenState extends State<BatteryStatusScreen> {
  double percentage = 0.0;
  Timer? timer;
  getBattery() async {
    String res = await apipost("battery?session=$session", {});
    print(res);
    if (isNum(res)) {
      setState(() {
        double per = double.parse(res);
        percentage = per <= 100 ? per : 100;
      });
    }
    timer = Timer(Duration(seconds: 5), () {
      getBattery();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer!.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    getBattery();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
        child: Column(
          children: [
            marginTop(40),
            Center(
                child: customText('Battery Status',
                    size: 25, fontWeight: FontWeight.w600)),
            marginTop(150),
            customRoundedContainer(
                height: 250,
                width: 250,
                child: Column(
                  children: [
                    CircularPercentIndicator(
                      radius: 90.0,
                      lineWidth: 20.0,
                      percent: percentage / 100,
                      center: customText('${percentage}%',
                          color: Colors.black,
                          size: 40,
                          fontWeight: FontWeight.bold),
                      linearGradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomRight,
                        colors: [bgColor, Color.fromARGB(255, 2, 139, 197)],
                      ),
                      backgroundColor: Color.fromARGB(255, 223, 223, 223),
                    ),
                    marginTop(11),
                    customText('$percentage% Remaining',
                        size: 15, color: bgColor)
                  ],
                )),
          ],
        ),
      )),
    );
  }
}
