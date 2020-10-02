import 'package:app/screens/big_screen.dart';
import 'package:app/screens/gallery_screen.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_view/pin_code_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PinScreen extends StatefulWidget {
  static String id = "pin_screen";
  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  checkuser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var time = prefs.getInt('time');
    if (time == 1) {
      setState(() {
        message = "Enter PIN";
      });
    } else {
      setState(() {
        message = "Set up PIN";
      });
    }
  }

  String enteredcode;
  String message;

  @override
  void initState() {
    super.initState();
    checkuser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PinCode(
      keyTextStyle: TextStyle(color: Colors.redAccent, fontSize: 30.0),
      codeTextStyle: TextStyle(color: Colors.redAccent, fontSize: 30.0),
      title: Text(
        "Gallery",
        style: TextStyle(
            fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 20.0),
      ),
      subTitle: Text(
        "$message",
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
      obscurePin: true,
      codeLength: 4,
      onCodeEntered: (code) {
        enteredcode = code;
        setState(() async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var time = prefs.getInt('time');
          if (time == 1) {
            var currentcode = prefs.getString("currentcode");
            if (enteredcode == currentcode) {
              Navigator.pushNamed(context, GalleryScreen.id);
              message = "Enter PIN";
            } else {
              setState(() {
                message = "Wrong PIN! Enter PIN";
              });
            }
          } else {
            prefs.setString("currentcode", enteredcode);
            prefs.setInt("time", 1);
            Navigator.pushNamed(context, GalleryScreen.id);
            message = "Enter PIN";
          }
        });
      },
    ));
  }
}
