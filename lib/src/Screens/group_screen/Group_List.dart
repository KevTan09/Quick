import 'dart:io';

import 'package:Quick/src/Commons/Helper.dart';
import 'package:Quick/src/Commons/Services.dart';
import 'package:Quick/src/Commons/responseCode.dart';
import 'package:Quick/src/Widgets/Containers/Group_Container.dart';
import 'package:Quick/src/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Group_Menu.dart';

class GroupListScreen extends StatefulWidget{
  static const id = '/groupScreenList';

  @override
  State<StatefulWidget> createState() {
    return _GroupListScreenState();
  }
}

class _GroupListScreenState extends State<GroupListScreen>{
  TextEditingController _controller;

  SharedPreferences pref;
  final ImagePicker picker = new ImagePicker();
  

  String userId;
  String profileImage = "default_profile.png";
  List<dynamic> groups = new List<Map<String, Object>>();
  bool ready = false;

  String groupName = "";
  File _image;

  _imgFromGallery(StateSetter setState) async {
    PickedFile image = await picker.getImage(
        source: ImageSource.gallery, imageQuality: 50
    );

    setState(() {
      _image = File(image.path);
    });
  }

  void init() async {
    pref = await SharedPreferences.getInstance();

    setState(() {
      userId = pref.getString("user_id");
      profileImage = pref.getString("profile_pic");
    });

    fetchGroup();
  }

  void createGroup() async {
    if(groupName == null || groupName.isEmpty) {
      Helper.showAlertDialog(context: context, message: "Nama Group Tidak Boleh Kosong");
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();
    Helper.showloading(context);
    final data = await Services.createGroup(groupName, userId, _image);
    Navigator.of(context, rootNavigator: true).pop();

    if(data["code"] == ResponseCode.group_created) {
      Helper.showAlertDialog(context: context, message: "berhasil");
      fetchGroup();
    } else if (data["code"] == ResponseCode.failed_create_group) {
      Helper.showAlertDialog(context: context, message: "gagal");
      print("${data['msg']}");
    } else {
      Helper.showAlertDialog(context: context, message: "Error");
    }
  }

  void fetchGroup() {
    setState(() {
      ready = false;
    });

    Services.getGroups(userId).then((data) {
      setState(() {
        ready = true;
        if(data["code"] == ResponseCode.groups_found) {
          groups = data['data'];
        } else if (data["code"] == ResponseCode.groups_not_found) {
          groups = [];
        } else {
          Helper.showAlertDialog(context: context, message: "Error");
        }
      });
    });
  }

  void showGroupDialog() {
    setState(() {
      groupName = "";
      _image = null;
    });

    Widget createButton = FlatButton(
      child: Text("Simpan", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
      onPressed: createGroup,
    );

    Widget cancelButton = FlatButton(
      child: Text("Batal", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
      onPressed: () => {Navigator.of(context, rootNavigator: true).pop()},
    );

    Widget content = StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return SizedBox(
          height: 180,
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey,
                  child: GestureDetector(
                    onTap: () => _imgFromGallery(setState),
                    child: _image != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.file(
                        _image,
                        width: 95,
                        height: 95,
                        fit: BoxFit.fitWidth,
                      ),
                    )
                        : Container(
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(50)),
                      width: 95,
                      height: 95,
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
              TextField(
                decoration: InputDecoration(
                    hintText: "Masukkan Nama Group yang Dibuat"
                ),
                controller: _controller,
                onChanged: (text) {
                  setState(() {
                    groupName = text;
                  });
                },
              )
            ],
          ),
        );
      },
    );

    Helper.showDialogBox(
        context: context,
        actions: [cancelButton, createButton],
        content: content,
        title: "Masukkan Nama Group",
        onClose: () {_controller.clear();}
    );
  }

  void logout() {
    if(ready) {
      pref.clear();
      setState(() {
        ready = false;
      });
      Navigator.popAndPushNamed(context, SplashScreen.id);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => (false),
        child: SafeArea(
          child: Scaffold(
              resizeToAvoidBottomPadding: false,
              floatingActionButton: FloatingActionButton(
                  heroTag: "profile",
                  onPressed: (){},
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.network(
                      Services.serverImageUrl(profileImage),
                      width: 50,
                      height: 50,
                      fit: BoxFit.fitWidth,
                    ),
                  )
              ),
              appBar: AppBar(
                leading: Icon(Icons.home, color: Colors.white, size: 30,),
                actions: [
                  FlatButton(
                    onPressed: logout,
                    textColor: Colors.white,
                    child: Row(
                      children: [
                        Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        SizedBox(width: 10),
                        Icon(Icons.power_settings_new)
                      ],
                    ),
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: ready ?
                Column(
                    children: <Widget>[
                      InkWell(
                        onTap: showGroupDialog,
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            children: [
                              Icon(Icons.group_add, color: Colors.blueAccent, size: 22,),
                              SizedBox(width: 5),
                              Text(
                                "Buat Group Baru",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueAccent
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      for (var group in groups)
                        GroupContainer(
                          group: group,
                          onTap: () {
                            Navigator.pushNamed(context, GroupScreen.id, arguments: {'groupName': group['group_name'], 'id' : group['group_id']});
                          },
                        ),
                      if (groups.isEmpty)
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              "Anda Belum Memiliki Group",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black26
                              ),
                            ),
                          ),
                        ),
                    ]
                ):
                SizedBox.expand(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
          ),
        )
    );
  }

}