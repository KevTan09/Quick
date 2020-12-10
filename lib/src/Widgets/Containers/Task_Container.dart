import 'package:Quick/src/Screens/group_screen/Task_Detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskContainer extends StatelessWidget {
  TaskContainer({Key key, this.task, this.callback}) : super(key: key);

  final Map<String, Object> task;
  final callback;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          onTap: () => {
            Navigator.pushNamed(context, TaskDetail.id, arguments: {
              'task_id': task["task_id"],
              'assignee': task['assignee'],
              'task' : task['task_description'],
              'created_at' : task['created_at'],
              'submitted_at' : task['submitted_at'],
              'user_id' : task['user_id'],
              'status' : task['status'],
              'callback' : this.callback
            })
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                SizedBox(
                    height: 60,
                    child: Container(
                        child: Icon(task['status'] == 1 ? Icons.done : Icons.clear,
                            color: task['status'] == 1 ? Colors.lightBlueAccent : Colors.red,
                            size: 30
                        ))
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            task['task_description'],
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
                        ),
                        SizedBox(height: 10),
                        Text('Dikerjakan : ${task['assignee']}')
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}