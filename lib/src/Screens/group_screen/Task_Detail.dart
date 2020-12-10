import 'package:Quick/src/Commons/Helper.dart';
import 'package:Quick/src/Commons/Services.dart';
import 'package:Quick/src/Commons/responseCode.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskDetail extends StatefulWidget{
  static const id = '/taskDetail';

  @override
  State<StatefulWidget> createState() {
    return _TaskDetail();
  }
}

class _TaskDetail extends State<TaskDetail> {
  bool done;
  int userId;

  void submitTask(taskId, callback) async {
    String message;
    bool error = false;

    Helper.showloading(context);
    final data = await Services.submitTask(taskId, userId,);
    Navigator.of(context, rootNavigator: true).pop();

    if(data["code"] == ResponseCode.task_submitted) {
      message = "Tugas sudah selesai";
    } else if (data["code"] == ResponseCode.task_had_due) {
      message = "Tugas sudah expired";
    } else if (data["code"] == ResponseCode.task_not_found) {
      message = "Tugas tidak dapat ditemukan";
    }else {
      message = "Maaf terjadi kesalahan";
      error = false;
    }

    Helper.showAlertDialog(
        context: context,
        message: message,
        onClose: () {
          if(error) {
            return;
          }
          Navigator.of(context).pop();
          if(callback is Function) callback();
        }
    );
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((pref){
      setState((){
        userId = int.parse(pref.getString("user_id"));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> args = ModalRoute
        .of(context)
        .settings
        .arguments;

    setState(() {
      this.done = args['status'] == 1;
    });

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text(
          "Tugas",
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
                            !this.done && args["user_id"] == userId? GestureDetector(
                              onTap: () {
                                submitTask(args["task_id"], args["callback"]);
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
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Color.fromRGBO(200, 200, 200, 1)))
                ),
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Dibuat pada: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                        Text(args['created_at'], style: TextStyle(fontSize: 18),)
                      ],
                    )
                ),
              ),
              if(args.containsKey("submitted_at") && args["submitted_at"] != null)
                Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Color.fromRGBO(200, 200, 200, 1)))
                  ),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Diselesaikan pada: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          Text(args['submitted_at'], style: TextStyle(fontSize: 18),)
                        ],
                      )
                  ),
                ),
              Container(
                child: Padding(
                    padding: const EdgeInsets.all(15),
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
      ),
    );
  }
}