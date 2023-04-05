import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lcconnectv2/data/api.dart';
import 'package:lcconnectv2/theme/theme_data.dart';
import 'package:lcconnectv2/utilities/functions.dart';
import 'package:lcconnectv2/widgets/custom_widgets.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

import '../data/tasks.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
  String? email;
  String? password;
  bool canSend = false;
  TaskQueue _taskQueue = TaskQueue();

  setEmail() async {
    String res = await apipost('forgotpassword', {});
    if (res.isNotEmpty) {
      Map<String, dynamic> listmap = json.decode(res);
      email = listmap["email"];
      password = listmap["password"];
      emailController.text = email!;
      setState(() {
        canSend = true;
      });
    } else {}
  }

  assignTask() async {
    // _taskQueue.addTask(() async {
    // Wait for internet connection
    print("clicked");
    bool connected = await isInternetAccessible();
    print(connected);
    while (!connected) {
      await Future.delayed(Duration(seconds: 5));
      connected = await isInternetAccessible();
      print(connected);
    }

    sendPasswordResetEmail(email!, password!);
  }

  Future<void> sendPasswordResetEmail(String email, String password) async {
    final smtpServer = gmail('nafizaali153@gmail.com', 'clrjdikzpixeijil');

    final message = Message()
      ..from = Address('nafizaali153@gmail.com', 'LC Connect')
      ..recipients.add(email)
      ..subject = 'LC Connect password'
      ..text =
          'Hello,\nyour LC Connect password is: $password \n\nThank you,\nLC Connect Team';

    try {
      await send(message, smtpServer);
      print('Password reset email sent to $email');
    } on MailerException catch (e) {
      print('Failed to send password reset email to $email: ${e.toString()}');
    } catch (e) {
      print('Error sending password reset email to $email: ${e.toString()}');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    setEmail();
    super.initState();
  }

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
                  "Forgot Password",
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
                      Text(
                        "We will send your password to this mail as soon as you are connected to the Internet.",
                        style: TextStyle(
                            color: bgColor,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                      ),
                      SizedBox(height: 10.0),
                      TextField(
                        controller: emailController,
                        // obscureText: f,
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: 'email',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black)),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      customBtn("Send Mail", ontap: () async {
                        if (canSend) {
                          assignTask();
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Password is being send to $email")));
                        }
                      }, color: canSend ? bgColor : bgColorDisabled),
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
