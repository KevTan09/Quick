import 'dart:io';

import 'package:Quick/src/Commons/Helper.dart';
import 'package:Quick/src/Commons/Services.dart';
import 'package:Quick/src/Commons/responseCode.dart';
import 'package:Quick/src/Screens/group_screen/Group_List.dart';
import 'package:Quick/src/Screens/login_screen/Sign_In.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SignUpWidgetState();
  }
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker picker = new ImagePicker();

  String _email, _password, _username;
  File _image;

  _imgFromCamera() async {
    PickedFile image = await picker.getImage(
        source: ImageSource.camera, imageQuality: 50
    );

    setState(() {
      _image = File(image.path);
    });
  }

  _imgFromGallery() async {
    PickedFile image = await  picker.getImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = File(image.path);
    });
  }

  void signUp() async {
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      try{
        Helper.showloading(context);
        Map<String, dynamic> response = await Services.register(_username, _email, _password, _image);
        Navigator.of(context, rootNavigator: true).pop();

        if(response['code'] == ResponseCode.register_success) {
          Map<String, dynamic> data = response["data"];

          SharedPreferences pref = await SharedPreferences.getInstance();
          await pref.setString("user_id", data["user_id"]);
          await pref.setString("username", data["username"]);
          await pref.setString("email", data["email"]);
          await pref.setString("profile_pic", data["profile_pic"]);

          Navigator.popAndPushNamed(context, GroupListScreen.id);
        } else if (response['code'] == ResponseCode.email_used){
          Helper.showAlertDialog(context: context, message: 'Email Sudah Pernah Terdaftar');
        } else if (response['code'] == ResponseCode.username_used){
          Helper.showAlertDialog(context: context, message: 'Username Sudah Dipakai');
        } else if (response['code'] == ResponseCode.register_failed){
          Helper.showAlertDialog(context: context, message: 'Gagal Mendaftar');
        } else {
          print(response.toString());
          Helper.showAlertDialog(context: context, message: "Error");
        }
      }catch(e){
        print(e.message);
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Silahkan Daftar', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                SizedBox(height: 20,),
                Center(
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.grey,
                    child: GestureDetector(
                      onTap: () => _imgFromGallery(),
                      child: _image != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.file(
                          _image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.fitWidth,
                        ),
                      )
                          : Container(
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(50)),
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.add_photo_alternate,
                          size: 25,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                TextFormField(
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Masukkan Username Anda!';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Username'
                  ),
                  onSaved: (input) => _username = input,
                ),
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
                SizedBox(height: 20,),
                Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      MaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        color: Colors.orangeAccent,
                        textColor: Colors.white,
                        onPressed: signUp,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), ),
                        child: Text(
                            'Daftar',
                          style: TextStyle(fontSize: 18, letterSpacing: .5),
                        ),
                      ),
                      SizedBox(height: 5),
                      MaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        color: Colors.red,
                        textColor: Colors.white,
                        onPressed: () {Navigator.popAndPushNamed(context, LoginPage.id);},
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), ),
                        child: Text(
                          'Batal',
                          style: TextStyle(fontSize: 18, letterSpacing: .5),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
        )
    );
  }
}