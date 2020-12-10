import 'package:Quick/src/Commons/Helper.dart';
import 'package:Quick/src/Commons/Services.dart';
import 'package:Quick/src/Commons/responseCode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  static final String id = "/profileScreen";

  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }

}

class ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> member;
  bool editMode = false;

  String userId;
  dynamic groupId;
  dynamic callback;

  void removeMember() async {
    Navigator.of(context, rootNavigator: true).pop();
    Helper.showloading(context);
    final data = await Services.removeMember(member["user_id"], groupId);
    Navigator.of(context, rootNavigator: true).pop();

    if(data["code"] == ResponseCode.member_removed) {
      if(callback != null && callback is Function){
        callback();
      }
      Navigator.pop(context);
    } else if (data["code"] == ResponseCode.failed_remove_member) {
      Helper.showAlertDialog(
          context: context,
          message: "Gagal mengeluarkan user",
      );
    } else if (data["code"] == ResponseCode.member_not_found) {
      Helper.showAlertDialog(
          context: context,
          message: "Member tidak ditemukan",
      );
    } else {
      Helper.showAlertDialog(context: context, message: "Maaf terjadi kesalahan");
    }
  }

  void showAlert() {
    Widget okButton = FlatButton(
      child: Text("Ya", style: TextStyle(fontSize: 18, color: Colors.orange),),
      onPressed: removeMember,
    );

    Widget cancel = FlatButton(
      child: Text("Batal", style: TextStyle(fontSize: 18, color: Colors.grey)),
      onPressed: () {Navigator.of(context, rootNavigator: true).pop();},
    );

    Helper.showDialogBox(
      context: context,
      content: SizedBox(
          height: 108,
          child: Column(
            children: [
              Text("Anda yakin ingin mengeluarkan user ini?"),
              SizedBox(height: 5,),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  cancel, okButton
                ],
              )
            ],
          )
      ),
      title: "Peringatan",
    );
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        userId = value.getString("user_id");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.5;

    final Map<String, Object> args = ModalRoute
        .of(context)
        .settings
        .arguments;

    setState(() {
      this.member = args['member'];
      this.groupId = args['groupId'];
      this.callback = args['callback'];
    });

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.person, size: 30,),
              SizedBox(width: 10,),
              Text(
                "Profile",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          iconTheme: IconThemeData(
              color: Colors.white
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Hero(
                      tag: "profile",
                      child: CircleAvatar(
                          radius: 38,
                          backgroundColor: Colors.grey,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(36),
                            child: Image.network(
                              Services.serverImageUrl(member['profile_pic']),
                              width: 72,
                              height: 72,
                              fit: BoxFit.fitWidth,
                            ),
                          )
                      ),
                    ),
                    SizedBox(width: 20,),
                    Text(
                      member["username"],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20,),
                Text(
                  "Email :",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  member["email"],
                  style: TextStyle(
                      fontSize: 16
                  ),
                ),
                if(member.containsKey("user_id") && args["is_admin"] && '${member["user_id"]}' != '$userId')
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: MaterialButton(
                        padding: EdgeInsets.all(10),
                        color: Colors.deepOrangeAccent,
                        textColor: Colors.white,
                        onPressed: showAlert,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), ),
                        child: Text(
                          'Keluarkan dari group',
                          style: TextStyle(fontSize: 18, letterSpacing: .5),
                        ),
                      ),
                    ),
                  )
              ]
          ),
        )
    );
  }
}