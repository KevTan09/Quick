import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Screens/group_screen/Group_List.dart';
import 'Screens/login_screen/Sign_In.dart';

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
    Timer(Duration(seconds: 2), _getPref);
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