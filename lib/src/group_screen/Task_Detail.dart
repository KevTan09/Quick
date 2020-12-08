import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskDetail extends StatefulWidget{
  static const id = '/taskDetail';

  @override
  State<StatefulWidget> createState() {
    return _TaskDetail();
  }
}

class _TaskDetail extends State<TaskDetail> {
  bool done;

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> args = ModalRoute
        .of(context)
        .settings
        .arguments;

    setState(() {
      this.done = args['status'];
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color.fromRGBO(200, 200, 200, 1)))
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Dikerjakan oleh: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      Text(args['assignee'], style: TextStyle(fontSize: 18),)
                    ],
                  )
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color.fromRGBO(200, 200, 200, 1)))
              ),
              margin: const EdgeInsets.only(bottom: 15),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('status: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      Row(
                        children: [
                          Text(this.done ? 'Selesai' : 'Belum Selesai', style: TextStyle(fontSize: 18),),
                          SizedBox(width: !this.done ? 10 : 0,),
                          !this.done ? GestureDetector(
                            onTap: () {
                              print('selesai');
                              setState(() {
                                args['status'] = true;
                              });
                            },
                            child: Text('Tandai Selesai', style: TextStyle(fontSize: 18, color: Colors.blueAccent),),
                          ) : Text('')
                        ],
                      )
                    ],
                  )
              ),
            ),
            Container(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Deskripsi Tugas:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      SizedBox(height: 10,),
                      Text(args['task'], style: TextStyle(fontSize: 18),)
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}