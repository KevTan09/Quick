import 'package:Quick/src/Commons/Services.dart';
import 'package:Quick/src/Screens/group_screen/Profile_Screen.dart';
import 'package:flutter/material.dart';

class MemberContainer extends StatelessWidget{
  MemberContainer({Key key, this.member, this.isAdmin, this.refreshFn, this.groupId}): super(key: key);

  final Map<String, dynamic> member;
  final bool isAdmin;
  final refreshFn;
  final groupId;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(
          onTap: (){
            Navigator.pushNamed(
                context,
                ProfileScreen.id,
                arguments: {
                  "member" : this.member,
                  "groupId" : this.groupId,
                  "is_admin": this.isAdmin,
                  "callback": this.refreshFn
                });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(Services.serverImageUrl(member['profile_pic'])),
              ),
              title: Text(member['username'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,),
              trailing: (() {
                if (member["is_admin"] == 1){
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
          ),
        )
    );
  }
}