import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lcconnectv2/screens/esp_connect_screen.dart';
import 'package:lcconnectv2/theme/theme_data.dart';
import 'package:lcconnectv2/utilities/functions.dart';
import 'package:lcconnectv2/widgets/custom_widgets.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int steps = 0;
  myFun() async {
    if (steps < 100) {
      Future.delayed(
        new Duration(milliseconds: 20),
        () {
          setState(() {
            steps++;
          });
        },
      ).then((value) {
        myFun();
      });
    } else {
      allFinishGoto(context, EspConfigScreen());
    }
  }

  @override
  void initState() {
    myFun();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/wifi-white.png',
                height: 170,
                width: 170,
                fit: BoxFit.fitWidth,
              ),
              customText(
                'LC Connect'.toUpperCase(),
                size: 35,
                fontWeight: FontWeight.bold,
              ),
              customText(
                'Control Enclosure Smartly',
                size: 18,
              ),
              marginTop(100),
              Container(
                width: 210,
                decoration: BoxDecoration(
                    border: Border.all(color: txtColor, width: 1),
                    borderRadius: BorderRadius.circular(15)),
                child: StepProgressIndicator(
                  totalSteps: 100,
                  currentStep: steps,
                  size: 9,
                  padding: 0,
                  roundedEdges: Radius.circular(15),
                  selectedColor: txtColor,
                  unselectedColor: bgColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
