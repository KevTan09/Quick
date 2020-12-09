import 'package:Quick/src/Commons/Helper.dart';
import 'package:Quick/src/Commons/Services.dart';
import 'package:Quick/src/Commons/responseCode.dart';
import 'package:Quick/src/Screens/group_screen/Group_List.dart';
import 'package:Quick/src/Screens/login_screen/Sign_Up.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LoginWidgetState();
  }
}

class _LoginWidgetState extends State<LoginWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email, _password;

  void signIn() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        Helper.showloading(context);
        Map<String, dynamic> response = await Services.login(_email, _password);
        Navigator.of(context, rootNavigator: true).pop();

        if(response['code'] == ResponseCode.login_success) {
          Map<String, dynamic> data = response["data"];

          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString("user_id", data["user_id"]);
          await pref.setString("username", data["username"]);
          await pref.setString("email", data["email"]);
          await pref.setString("profile_pic", data["profile_pic"]);

          Navigator.popAndPushNamed(context, GroupListScreen.id);
        } else if (response['code'] == ResponseCode.login_failed){
          Helper.showAlertDialog(context: context, message: 'Pengguna tidak dapat ditemukan, pastikan anda memasukkan email dan password dengan benar');
        } else {
          print(response.toString());
          Helper.showAlertDialog(context: context, message: "Error");
        }

      }catch(e){
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text('Silahkan Login', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Masukkan Email Anda!';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Email'
                  ),
                  onSaved: (input) => _email = input,
                ),
                TextFormField(
                  validator: (input) {
                    if (input.length < 6) {
                      return 'Password harus lebih dari 6 Karakter';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Password'
                  ),
                  onSaved: (input) => _password = input,
                  obscureText: true,
                ),
                SizedBox(height: 30,),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MaterialButton(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      color: Colors.orangeAccent,
                      textColor: Colors.white,
                      onPressed: signIn,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), ),
                      child: Text(
                        'Masuk',
                        style: TextStyle(fontSize: 18, letterSpacing: .5),
                      ),
                    ),
                    SizedBox(height: 10,),
                    Center(
                      child: Text(
                        'Pengguna Baru?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange
                        ),
                      ),
                    ),
                    SizedBox(height: 5),
                    MaterialButton(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      color: Colors.deepOrangeAccent,
                      textColor: Colors.white,
                      onPressed: () {Navigator.popAndPushNamed(context, SignUpPage.id);},
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), ),
                      child: Text(
                        'Daftar',
                        style: TextStyle(fontSize: 18, letterSpacing: .5),
                      ),
                    ),
                  ],
                )
              ],
            )
        )
    );
  }
}