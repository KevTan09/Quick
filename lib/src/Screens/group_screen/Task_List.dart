import 'package:Quick/src/Widgets/Containers/Task_Container.dart';
import 'package:flutter/material.dart';

class TaskList extends StatelessWidget {
  TaskList(this.isAdmin, this.tasks, this.refreshFn);

  final bool isAdmin;
  List<dynamic> tasks = new List<Map<String, Object>>();
  final Function refreshFn;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: this.isAdmin ? const EdgeInsets.only(bottom: 70) : null,
      children: <Widget>[
        for(Map<String, Object> task in tasks) TaskContainer(task: task, callback: refreshFn,),
      ],
    );
  }
}