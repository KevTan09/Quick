import 'package:Quick/src/Widgets/Login_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget{
  static const String id = '/loginScreen';

  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage>{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.lightBlueAccent,
            body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('lib/src/asset/Background.jpg'),
                        fit: BoxFit.cover
                    )
                ),
                child: Center(
                  child: SingleChildScrollView(
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          width: 350,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, .85),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.grey, width: 1)
                          ),
                          child: Center(child: LoginWidget())
                      )
                  ),
                )
            )
        )
    );
  }
}