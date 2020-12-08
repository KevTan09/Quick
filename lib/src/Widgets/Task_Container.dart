import 'package:Quick/src/group_screen/Task_Detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskContainer extends StatelessWidget {
  TaskContainer({Key key, this.task}) : super(key: key);

  final Map<String, Object> task;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          onTap: () => {
            Navigator.pushNamed(context, TaskDetail.id, arguments: {
              'assignee': task['assignee'],
              'task' : task['task'],
              'status' : task['status']
            })
          },
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                SizedBox(
                    height: 60,
                    child: Container(
                        child: Icon(task['status'] == true ? Icons.done : Icons.clear,
                            color: task['status'] == true ? Colors.lightBlueAccent : Colors.red,
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
                            task['task'],
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