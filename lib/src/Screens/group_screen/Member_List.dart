import 'package:Quick/src/Commons/Helper.dart';
import 'package:Quick/src/Commons/Services.dart';
import 'package:Quick/src/Commons/responseCode.dart';
import 'package:Quick/src/Widgets/Containers/Member_Container.dart';
import 'package:flutter/material.dart';

class MemberList extends StatefulWidget{
  MemberList({this.groupId, this.isAdmin});

  final int groupId;
  final bool isAdmin;

  @override
  State<StatefulWidget> createState() {
    return _MemberList(groupId: this.groupId, isAdmin: this.isAdmin);
  }
}

class _MemberList extends State<MemberList>{
  _MemberList({this.groupId, this.isAdmin});

  TextEditingController _controller;
  String username;

  final int groupId;
  final bool isAdmin;

  bool ready;
  List<dynamic> members = [];

  void addMember() async {
    if(username == null || username.isEmpty) {
      Helper.showAlertDialog(context: context, message: "Harap cantumkan username");
      return;
    }

    Navigator.of(context, rootNavigator: true).pop();
    Helper.showloading(context);
    final data = await Services.addMember(username, groupId);
    Navigator.of(context, rootNavigator: true).pop();

    if(data["code"] == ResponseCode.member_added) {
      Helper.showAlertDialog(context: context, message: "Username berhasil diundang");
      fetchMembers();
    } else if (data["code"] == ResponseCode.member_existed) {
      Helper.showAlertDialog(
          context: context,
          message: "Username sudah terdaftar",
          onClose: addMemberDialog
      );
    } else if (data["code"] == ResponseCode.user_not_found) {
      Helper.showAlertDialog(
          context: context,
          message: "Username tidak dapat ditemukan",
          onClose: addMemberDialog
      );
    } else {
      Helper.showAlertDialog(context: context, message: "Maaf terjadi kesalahan");
    }
  }

  void addMemberDialog() {
    this.username = "";

    Widget createButton = FlatButton(
      child: Text("Undang", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
      onPressed: addMember,
    );

    Widget cancelButton = FlatButton(
      child: Text("Batal", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
      onPressed: () => {Navigator.of(context, rootNavigator: true).pop()},
    );

    Widget content = SizedBox(
        height: 50,
        child: TextField(
          decoration: InputDecoration(
              hintText: "Masukkan Username"
          ),
          controller: _controller,
          onChanged: (text) {
            username = text;
          },
        )
    );

    Helper.showDialogBox(
        context: context,
        actions: [cancelButton, createButton],
        content: content,
        title: "Undang ke Dalam Group",
        onClose: () {_controller.clear();}
    );
  }

  void fetchMembers() {
    setState(() {
      ready = false;
    });

    Services.getMembers(groupId).then((data) {
      setState(() {
        ready = true;
        if (data["code"] == ResponseCode.member_found) {
          members = data['data'];
        } else if (data["code"] == ResponseCode.member_not_found) {
          members = [];
        } else {
          Helper.showAlertDialog(context: context, message: "Error");
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return ready ? ListView(
      children: <Widget>[
        if(isAdmin) InkWell(
          onTap: addMemberDialog,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Row(
              children: [
                Icon(Icons.person_add, color: Colors.blueAccent, size: 22,),
                SizedBox(width: 5),
                Text(
                  "Tambah Member",
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
        for(Map<String, Object> member in members)
          MemberContainer(
              member: member,
              groupId: groupId,
              isAdmin: this.isAdmin,
              refreshFn: this.fetchMembers,
          )
      ],
    ) :
    SizedBox.expand(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}