import 'package:flutter/material.dart';
import 'package:lcconnectv2/data/api.dart';
import 'package:lcconnectv2/screens/battery_status_screen.dart';
import 'package:lcconnectv2/screens/ble_devices_screen.dart';
import 'package:lcconnectv2/screens/dashboard_screen.dart';
import 'package:lcconnectv2/theme/theme_data.dart';
import 'package:lcconnectv2/utilities/functions.dart';
import 'package:lcconnectv2/widgets/custom_widgets.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({Key? key}) : super(key: key);
  TextEditingController oldpasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
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
                Text(
                  "Change Password",
                  style: TextStyle(
                      color: bgColor,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                marginTop(20),
                Container(
                  margin: EdgeInsets.all(20.0),
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: bgColor,
                          offset: Offset(2, 2),
                          spreadRadius: 1,
                          blurRadius: 50.0)
                    ],
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: oldpasswordController,
                        decoration: InputDecoration(
                          hintText: 'Old Password',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: newpasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'New Password',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      customBtn("Submit", ontap: () async {
                        print(
                            "email ${oldpasswordController.text} , password: ${newpasswordController.text}");
                        String key = await apipost(
                            "changepassword?oldPassword=${oldpasswordController.text}&newPassword=${newpasswordController.text}&session=$session",
                            {});
                        print(key);
                        if (key == "Password changed successfully") {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(key)));
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Please check password and try again")));
                        }
                      }),
                      marginTop(10),
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      //   child: Text(
                      //     "Login?",
                      //     style: TextStyle(
                      //         color: bgColor,
                      //         fontSize: 17,
                      //         fontWeight: FontWeight.bold),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
