import 'package:flutter/material.dart';

import 'Assign_Task.dart';
import 'Member_List.dart';
import 'Task_List.dart';

class GroupScreen extends StatefulWidget{
  static const id = '/groupScreen';

  @override
  State<StatefulWidget> createState() {
    return _GroupScreen();
  }

}

class _GroupScreen extends State<GroupScreen> {
  int index = 0;
  bool isAdmin = true;

  _GroupScreen();

  _onTabTap(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> args = ModalRoute
        .of(context)
        .settings
        .arguments;

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
                    title: Text(args['groupName'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    bottom: TabBar(
                      onTap: _onTabTap,
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
                  TaskList(isAdmin: this.isAdmin),
                  MemberList()
                ],
              ),
              floatingActionButton: this.index == 0 && this.isAdmin?
              FloatingActionButton.extended(
                onPressed: () {Navigator.pushNamed(context, AssignTask.id);},
                label: Text('Tambah', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                icon: Icon(Icons.create, color: Colors.white,),
              ) : null,
            )
        )
    );
  }
}