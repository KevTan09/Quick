import 'dart:async';

import 'package:Quick/src/group_screen/Group_List.dart';
import 'package:Quick/src/login_screen/Sign_In.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splashscreen';

  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen>{
  _getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString('user_id');
    if (userId != '' && userId != null) {
      Navigator.pushReplacementNamed(context, GroupListScreen.id);
    } else {
      Navigator.pushReplacementNamed(context, LoginPage.id);
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), _getPref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Center(
            child: ClipRect(
              child: Image.asset("lib/src/asset/LogoApp.png"),
            ),
          ),
        );
  }

}