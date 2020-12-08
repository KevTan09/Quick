import 'package:Quick/src/Widgets/Member_Container.dart';
import 'package:flutter/material.dart';

class MemberList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MemberList();
  }
}

class _MemberList extends State<MemberList>{
  List<Map<String, Object>> members;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        for(Map<String, Object> member in members) MemberContainer(member: member)
      ],
    );
  }
}