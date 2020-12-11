import 'package:Quick/src/Commons/Helper.dart';
import 'package:Quick/src/Commons/Services.dart';
import 'package:Quick/src/Commons/responseCode.dart';
import 'package:flutter/material.dart';

import 'Assign_Task.dart';
import 'Member_List.dart';
import 'Task_List.dart';

class GroupScreen extends StatefulWidget{
  GroupScreen({this.isAdmin, this.groupId, this.groupName});

  static const id = '/groupScreen';

  final bool isAdmin;
  final dynamic groupId, groupName;

  @override
  State<StatefulWidget> createState() {
    return _GroupScreen(this.isAdmin, this.groupId, this.groupName);
  }

}

class _GroupScreen extends State<GroupScreen> {
  _GroupScreen(this.isAdmin, this.groupId, this.groupName);

  int index = 0;
  bool isAdmin, ready = false;
  dynamic groupId, groupName;

  List<dynamic> tasks = new List<Map<String, Object>>();

  _onTabTap(int index) {
    setState(() {
      this.index = index;
    });
  }

  void fetchTasks() {
    setState(() {
      ready = false;
    });

    Services.getTasks(groupId).then((data) {
      setState(() {
        ready = true;
        if (data["code"] == ResponseCode.task_found) {
          tasks = data['data'];
        } else if (data["code"] == ResponseCode.task_not_found) {
          tasks = [];
        } else {
          Helper.showAlertDialog(context: context, message: "Error");
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: SafeArea(
            child:  Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(100),
                  child: AppBar(
                    iconTheme: IconThemeData(
                        color: Colors.white
                    ),
                    title: Text(groupName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    bottom: TabBar(
                      onTap: _onTabTap,
                      indicatorColor: Colors.white,
                      tabs: [
                        Tab(
                            child: Row(
                              children: [
                                Icon(Icons.list, color: Colors.white,),
                                SizedBox(width: 10,),
                                Text('Tugas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),)
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            )
                        ),
                        Tab(
                            child: Row(
                              children: [
                                Icon(Icons.people, color: Colors.white),
                                SizedBox(width: 10,),
                                Text('Member', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),)
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                            )
                        ),
                      ],
                    ),
                  )
              ),
              body: TabBarView(
                children: [
                  ready && tasks.isNotEmpty ?
                  TaskList(this.isAdmin, tasks, fetchTasks) :
                  SizedBox.expand(
                    child: Center(
                      child: ready ?
                      Text(
                        "Belum Ada Tugas",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black26
                        ),
                      ) : CircularProgressIndicator(),
                    ),
                  ),
                  MemberList(isAdmin: this.isAdmin, groupId: groupId)
                ],
              ),
              floatingActionButton: this.index == 0 && this.isAdmin?
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.pushNamed(
                      context, AssignTask.id,
                      arguments: {
                        "groupId" : groupId,
                        "callback" : fetchTasks
                      });
                },
                label: Text('Tambah', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                icon: Icon(Icons.create, color: Colors.white,),
              ) : null,
            )
        )
    );
  }
}