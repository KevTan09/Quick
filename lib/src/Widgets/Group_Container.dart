import 'package:flutter/material.dart';

class GroupContainer extends StatelessWidget{
  GroupContainer({Key key, this.group, this.onTap}): super(key: key);

  final group;
  final onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(group['groupImage']),
              ),
              title: Text(group['groupName'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
            ),
          ),
        )
    );
  }

}