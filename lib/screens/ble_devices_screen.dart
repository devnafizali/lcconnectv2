import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lcconnectv2/data/api.dart';
import 'package:lcconnectv2/theme/theme_data.dart';
import 'package:lcconnectv2/utilities/functions.dart';
import 'package:lcconnectv2/widgets/custom_widgets.dart';

class BleDevicesScreen extends StatefulWidget {
  BleDevicesScreen({Key? key}) : super(key: key);

  @override
  State<BleDevicesScreen> createState() => _BleDevicesScreenState();
}

class _BleDevicesScreenState extends State<BleDevicesScreen> {
  TextEditingController deviceName = new TextEditingController();

  TextEditingController macAddress = new TextEditingController();

  List<Map> items = [];

  getItems() async {
    String jsonList = await apipost("list?session=$session", {});
    Map<String, dynamic> listmap = json.decode(jsonList);
    setState(() {
      items.clear();
    });
    listmap.forEach((key, value) {
      print(session);
      setState(() {
        print(value);
        items.add({"name": key, "SSID": value["macssid"]});
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getItems();
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
              marginTop(60),
              customText('Ble Devices', size: 30, fontWeight: FontWeight.w600),
              marginTop(40),
              customRoundedContainer(
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.height - 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      marginTop(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: customText('Device List',
                                size: 22,
                                color: bgColor,
                                fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            child: Icon(Icons.replay_circle_filled_sharp,
                                size: 30),
                            onTap: () {
                              getItems();
                            },
                          )
                        ],
                      ),
                      marginTop(10),
                      Expanded(
                          child: Container(
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            return customWifieListTile(
                                items[index]['name'], items[index]['SSID'],
                                leftIcon: Icons.bluetooth_audio,
                                rightIcon: Icons.delete, onDelete: () async {
                              String res = await apipost(
                                  "delete?session=${session}&index=$index", {});
                              if (res == "Data deleted") {
                                getItems();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Could not delete! May be Disconnected"),
                                      duration: Duration(seconds: 6)),
                                );
                              }
                            });
                          },
                        ),
                      )),
                      marginTop(15),
                      Center(
                        child: customBtn(
                          'Add Device',
                          width: 200,
                          ontap: () {
                            customDialogBox(
                              context,
                              content: Container(
                                height: 220,
                                child: Column(
                                  children: [
                                    marginTop(6),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: customText('Ble Device',
                                          color: bgColor, size: 20),
                                    ),
                                    marginTop(20),
                                    customTextField(
                                      controller: deviceName,
                                      labelTxt: 'Device Name',
                                      hintTxt: 'Enter  device name',
                                    ),
                                    marginTop(10),
                                    customTextField(
                                        controller: macAddress,
                                        labelTxt: 'Mac Address',
                                        hintTxt: 'Enter  mac address'),
                                    marginTop(25),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        customBtn('Cancel',
                                            textColor: bgColor,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            width: 100,
                                            fontSize: 17, ontap: () {
                                          Navigator.of(context).pop();
                                        }),
                                        customBtn('Add Device',
                                            width: 120,
                                            fontSize: 17, ontap: () async {
                                          String res = await apipost(
                                              "save?name=${deviceName.text}&macssid=${macAddress.text}&session=${session}",
                                              {});
                                          if (res == "Data saved") {
                                            Navigator.pop(context);
                                            deviceName.clear();
                                            macAddress.clear();
                                            getItems();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Could not update! Maybe Disconnected"),
                                                  duration:
                                                      Duration(seconds: 6)),
                                            );
                                          }
                                        }),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
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
