import 'package:Quick/src/Widgets/Group_Container.dart';
import 'package:Quick/src/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Group_Menu.dart';

class GroupListScreen extends StatefulWidget{
  static const id = '/groupScreenList';

  @override
  State<StatefulWidget> createState() {
    return _GroupListScreenState();
  }
}

class _GroupListScreenState extends State<GroupListScreen>{
  SharedPreferences pref;

  List<Map<String, Object>> groups;
  bool ready = false;

  void fetchGroups() async {
    pref = await SharedPreferences.getInstance();

    setState(() {
//      ready = true;
    });
  }

  void logout() {
    if(ready) {
      pref.clear();
      setState(() {
        ready = false;
      });
      Navigator.pushReplacementNamed(context, SplashScreen.id);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => (false),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/loginScreen');
                },
                textColor: Colors.white,
                child: Row(
                  children: [
                    Text('Logout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    SizedBox(width: 10),
                    Icon(Icons.power_settings_new, color: Colors.white,)
                  ],
                ),
              )
            ],
          ),
          body: ready ?
          ListView(
            children: <Widget>[
              for (var group in groups)
                GroupContainer(
                  group: group,
                  onTap: () {
                    Navigator.pushNamed(context, GroupScreen.id, arguments: {'groupName': group['groupName']});
                  },
                )
            ],
          ) :
          SizedBox.expand(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      )
    );
  }

}