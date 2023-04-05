import 'package:flutter/material.dart';
import 'package:lcconnectv2/data/api.dart';
import 'package:lcconnectv2/screens/battery_status_screen.dart';
import 'package:lcconnectv2/screens/ble_devices_screen.dart';
import 'package:lcconnectv2/screens/dashboard_screen.dart';
import 'package:lcconnectv2/screens/forgot_password.dart';
import 'package:lcconnectv2/theme/theme_data.dart';
import 'package:lcconnectv2/utilities/functions.dart';
import 'package:lcconnectv2/widgets/custom_widgets.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
            child: Container(
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
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  customBtn("Login", ontap: () async {
                    print(
                        "email ${emailController.text} , password: ${passwordController.text}");
                    String key = await apipost(
                        "login?email=${emailController.text}&password=${passwordController.text}",
                        {});
                    if (key.length == 10) {
                      session = key;
                      email = emailController.text;
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardScreen()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Please check email and passwordand try again")));
                    }
                  }),
                  marginTop(10),
                  InkWell(
                    onTap: () {
                      goto(context, ForgotPasswordScreen());
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: bgColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
