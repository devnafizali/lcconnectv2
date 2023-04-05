import 'package:flutter/material.dart';
import 'package:lcconnectv2/screens/battery_status_screen.dart';
import 'package:lcconnectv2/screens/ble_devices_screen.dart';
import 'package:lcconnectv2/screens/change_email.dart';
import 'package:lcconnectv2/screens/change_password.dart';
import 'package:lcconnectv2/screens/login.dart';
import 'package:lcconnectv2/theme/theme_data.dart';
import 'package:lcconnectv2/utilities/functions.dart';
import 'package:lcconnectv2/widgets/custom_widgets.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: txtColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg-dashboard.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Image.asset(
                    'assets/images/dash-image.png',
                    height: 200,
                    width: 200,
                    fit: BoxFit.fitHeight,
                  ),
                ),
                marginTop(30),
                customBtn('BLE Devices', width: 220, ontap: () {
                  goto(context, BleDevicesScreen());
                }, dropShadow: true),
                marginTop(20),
                customBtn('Battery Status',
                    width: 220,
                    color: Color.fromARGB(255, 189, 189, 189), ontap: () {
                  goto(context, BatteryStatusScreen());
                }, dropShadow: true),
                marginTop(20),
                customBtn('Change Email', width: 220, ontap: () {
                  goto(context, ChangeEmailScreen());
                }, dropShadow: true),
                marginTop(20),
                customBtn(
                  'Change Password',
                  width: 220,
                  ontap: () {
                    goto(context, ChangePasswordScreen());
                  },
                  dropShadow: true,
                  color: Color.fromARGB(255, 189, 189, 189),
                ),
                marginTop(20),
                customBtn('Log Out', width: 220, ontap: () {
                  session = "ABCD";
                  Navigator.pop(context);
                  goto(context, LoginScreen());
                }, dropShadow: true),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
