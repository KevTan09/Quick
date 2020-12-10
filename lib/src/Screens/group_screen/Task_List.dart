import 'package:Quick/src/Commons/Helper.dart';
import 'package:Quick/src/Commons/Services.dart';
import 'package:Quick/src/Commons/responseCode.dart';
import 'package:Quick/src/Widgets/Containers/Task_Container.dart';
import 'package:flutter/material.dart';

class TaskList extends StatefulWidget{
  TaskList({this.isAdmin, this.groupId});

  final bool isAdmin;
  final int groupId;

  @override
  _TaskList createState() => _TaskList(this.isAdmin, this.groupId);
}

class _TaskList extends State<TaskList> {
  _TaskList(this.isAdmin, this.groupId);

  bool isAdmin, ready;
  int groupId;
  List<dynamic> tasks = new List<Map<String, Object>>();

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
    return ready && tasks.isNotEmpty ? ListView(
      padding: this.isAdmin ? const EdgeInsets.only(bottom: 70) : null,
      children: <Widget>[
        for(Map<String, Object> task in tasks) TaskContainer(task: task, callback: fetchTasks,),
      ],
    ) :
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
    );
  }
}