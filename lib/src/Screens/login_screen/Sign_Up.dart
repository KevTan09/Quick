import 'package:Quick/src/Widgets/Forms/Signup_Widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUpPage extends StatefulWidget {
  static const id = '/registerScreen';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                      child:Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          width: 350,
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, .85),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.grey, width: 1)
                          ),
                          child: Center(child: SignUpWidget())
                      )
                  ),
                )
            )
        )
    );
  }
}