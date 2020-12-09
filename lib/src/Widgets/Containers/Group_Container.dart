import 'package:Quick/src/Commons/Services.dart';
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
                backgroundColor: Colors.orangeAccent,
                backgroundImage: NetworkImage(Services.serverImageUrl(group['group_image'])),
              ),
              title: Text(group['group_name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
            ),
          ),
        )
    );
  }

}