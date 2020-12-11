import 'package:Quick/src/Commons/Helper.dart';
import 'package:Quick/src/Commons/Services.dart';
import 'package:Quick/src/Commons/responseCode.dart';
import 'package:Quick/src/Screens/group_screen/Group_Menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AssignTask extends StatefulWidget{
  AssignTask({this.groupId, this.callback});

  static const id = '/assignTask';

  final groupId, callback;

  @override
  State<StatefulWidget> createState() {
    return _AssignTask(groupId: this.groupId, callback: this.callback);
  }
}

class _AssignTask extends State<AssignTask> {
  _AssignTask({this.groupId, this.callback});
  List<DropdownMenuItem<String>> groupMembers = [];

  String memberChosen;
  dynamic memberId, groupId, callback;
  String taskDesc;

  void createTask() async {
    if(taskDesc == null || taskDesc.isEmpty || memberId == null) {
      Helper.showAlertDialog(context: context, message: "Harap isi semua informasi");
      return;
    }

    SharedPreferences pref = await SharedPreferences.getInstance();

    Helper.showloading(context);
    final data = await Services.createTask(
        groupId,
        pref.getString("user_id"),
        memberId,
        taskDesc
    );
    Navigator.of(context, rootNavigator: true).pop();

    if(data["code"] == ResponseCode.task_created) {
      Navigator.pop(context);
      if(callback!=null && callback is Function){
        callback();
      }
    } else if (data["code"] == ResponseCode.failed_create_task) {
      Helper.showAlertDialog(
          context: context,
          message: "Gagal membuat tugas",
          onClose: () {
            Navigator.pop(context);
            if(callback!=null && callback is Function){
              callback();
            }
          }
      );
    } else if (data["code"] == ResponseCode.unauthorized_user) {
      Helper.showAlertDialog(
          context: context,
          message: "Anda tidak memiliki hak membuat tugas",
          onClose: () {
            Navigator.pop(context);
            if(callback!=null && callback is Function){
              callback();
            }
          }
      );
    } else {
      Helper.showAlertDialog(context: context, message: "Maaf terjadi kesalahan");
    }
  }

  void fetchMembers(groupId) {
    Services.getMembers(groupId).then((data) {
      List<dynamic> members;
      if (data["code"] == ResponseCode.member_found) {
        members = data['data'];

        setState(() {
          groupMembers = members.map((member) {
            return DropdownMenuItem<String>(
              value: member['username'],
              child: Text(member['username']),
              onTap: (){
                setState(() {
                  memberId = member["user_id"];
                });
              },
            );
          }).toList();
        });

      } else if (data["code"] == ResponseCode.member_not_found) {
        members = [];
      } else {
        Helper.showAlertDialog(context: context, message: "Error");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMembers(groupId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Tambah Tugas",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(
              color: Colors.white
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color.fromRGBO(200, 200, 200, 1)))
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Serahkan Pada: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        Container(
                          width: 150,
                          child: DropdownButton(
                            underline: Container(
                              height: 0,
                            ),
                            isExpanded: true,
                            hint: Text('Pilih Member'),
                            value: this.memberChosen,
                            onChanged: (value) {
                              setState(() {
                                this.memberChosen = value;
                              });
                            },
                            items: this.groupMembers,
                          ),
                        )
                      ],
                    )
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Deskripsi Tugas:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        SizedBox(height: 10,),
                        TextField(
                          autocorrect: false,
                          enableSuggestions: false,
                          decoration: InputDecoration(
                              hintText: 'Jelaskan Tugas yang Akan Diberikan'
                          ),
                          maxLines: null,
                          onChanged: (t) {
                            setState(() {
                              taskDesc = t;
                            });
                          },
                        )
                      ],
                    )
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  onPressed: createTask,
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text('Submit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}