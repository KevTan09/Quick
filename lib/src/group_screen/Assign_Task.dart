import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AssignTask extends StatefulWidget{
  static const id = '/assignTask';

  @override
  State<StatefulWidget> createState() {
    return _AssignTask();
  }
}

class _AssignTask extends State<AssignTask> {
  final List<DropdownMenuItem<String>> member = [];
//  groupMember.map<DropdownMenuItem<String>>((member) {
//    return DropdownMenuItem<String>(
//      value: member['name'],
//      child: Text(member['name']),
//    );
//  }).toList();

  String memberChosen;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
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
                          items: this.member,
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
                      )
                    ],
                  )
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  onPressed: () {Navigator.pop(context);},
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text('Submit', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}