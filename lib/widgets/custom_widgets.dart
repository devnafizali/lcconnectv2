import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lcconnectv2/screens/dashboard_screen.dart';
import 'package:lcconnectv2/theme/theme_data.dart';
import 'package:lcconnectv2/utilities/functions.dart';

Widget customText(txt, {double? size, color, fontWeight}) {
  return Text(
    txt,
    style: TextStyle(
        fontSize: size,
        color: color != null ? color : txtColor,
        fontWeight: fontWeight != null ? fontWeight : FontWeight.normal),
  );
}

Widget marginTop(double? value) {
  return SizedBox(
    height: value,
  );
}

Widget marginLeft(double? value) {
  return SizedBox(
    width: value,
  );
}

Widget customRoundedContainer({
  Widget? child,
  double? height,
  double? width,
  bgcolor,
}) {
  return Container(
    padding: EdgeInsets.all(20),
    height: height,
    width: width,
    child: child,
    decoration: BoxDecoration(
      color: bgcolor != null ? bgcolor : txtColor,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

Widget customWifieListTile(title, secTitle,
    {rightIcon, leftIcon, ontap, onDelete}) {
  return InkWell(
    onTap: ontap,
    child: Container(
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                leftIcon != null ? leftIcon : Icons.wifi_rounded,
                size: 35,
                color: bgColor,
              ),
              marginLeft(20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  customText(title, size: 20, color: bgColor),
                  marginTop(5),
                  customText('${secTitle}', size: 15, color: bgColor),
                ],
              ),
              marginLeft(40),
            ],
          ),
          InkWell(
            onTap: onDelete,
            child: Icon(
              rightIcon != null ? rightIcon : Icons.arrow_forward_ios_rounded,
              size: 30,
              color: bgColor,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget customBtn(text,
    {color, textColor, double? width, ontap, double? fontSize, dropShadow}) {
  if (dropShadow == null) {
    dropShadow = false;
  }
  return InkWell(
    onTap: ontap,
    child: Container(
      width: width != null ? width : null,
      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
      decoration: BoxDecoration(
        color: color != null ? color : bgColor,
        borderRadius: BorderRadius.circular(7),
        boxShadow: dropShadow
            ? [
                BoxShadow(
                  color: Color.fromARGB(31, 46, 46, 46).withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: Offset(0, 3),
                )
              ]
            : null,
      ),
      child: Center(
        child: customText(
          text,
          fontWeight: FontWeight.bold,
          size: fontSize != null ? fontSize : 17,
          color: textColor != null ? textColor : Colors.white,
        ),
      ),
    ),
  );
}

Future customDialogBox(context, {content, bool? isVerified}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      if (isVerified != null) {
        if (isVerified) {
          Future.delayed(Duration(seconds: 2), () {
            allFinishGoto(context, DashboardScreen());
          });
        } else {
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pop(true);
          });
        }
      }
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        content: content,
        actions: [
          // TextButton(
          //   child: Text('Close'),
          //   onPressed: () {
          //     Navigator.of(context).pop();
          //   },
          // ),
        ],
      );
    },
  );
}

Widget customTextField({controller, labelTxt, hintTxt}) {
  return TextField(
    controller: controller,
    // obscureText: true,
    decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 10, top: 0),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: bgColor,
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: bgColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: bgColor, width: 1.5),
        ),
        labelText: labelTxt,
        hintText: hintTxt,
        labelStyle: TextStyle(color: bgColor, fontSize: 18),
        hintStyle: TextStyle(color: bgColor, fontSize: 18)),
  );
}
