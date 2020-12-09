import 'package:flutter/material.dart';

class MemberContainer extends StatelessWidget{
  MemberContainer({Key key, this.member}): super(key: key);

  final Map<String, Object> member;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(member['profilePic']),
            ),
            title: Text(member['name'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
            trailing: (() {
              if (this.member['isAdmin']){
                return Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: Colors.green)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text('Admin', style: TextStyle(color: Colors.green)),
                  ),
                );
              }
            })(),
          ),
        )
    );
  }
}