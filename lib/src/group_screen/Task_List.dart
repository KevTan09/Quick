import 'package:Quick/src/Widgets/Task_Container.dart';
import 'package:flutter/material.dart';

class TaskList extends StatefulWidget{
  TaskList({this.isAdmin});

  final bool isAdmin;

  @override
  _TaskList createState() => _TaskList(this.isAdmin);
}

class _TaskList extends State<TaskList>{
  _TaskList(this.isAdmin);
  bool isAdmin;
  List<Map<String, Object>> tasks;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: this.isAdmin ? const EdgeInsets.only(bottom: 70) : null,
      children: <Widget>[
        for(Map<String, Object> task in tasks) TaskContainer(task: task)
      ],
    );
  }

}