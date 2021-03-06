import 'package:Quick/src/Screens/group_screen/Assign_Task.dart';
import 'package:Quick/src/Screens/group_screen/Group_List.dart';
import 'package:Quick/src/Screens/group_screen/Group_Menu.dart';
import 'package:Quick/src/Screens/group_screen/Profile_Screen.dart';
import 'package:Quick/src/Screens/group_screen/Task_Detail.dart';
import 'package:Quick/src/Screens/login_screen/Sign_In.dart';
import 'package:Quick/src/Screens/login_screen/Sign_Up.dart';
import 'package:Quick/src/splash_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.orange,
          accentColor: Colors.orangeAccent,

          fontFamily: 'Cardo'
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginPage.id : (context) => LoginPage(),
        SignUpPage.id : (context) => SignUpPage(),
        ProfileScreen.id : (context) => ProfileScreen(),
        GroupListScreen.id: (context) => GroupListScreen(),
        TaskDetail.id: (context) => TaskDetail(),
      },
      onGenerateRoute: (settings) {
        if(settings.name == GroupScreen.id) {
          final Map<String, dynamic> args = settings.arguments;

          return MaterialPageRoute(
            builder: (context) {
              return GroupScreen(
                groupId: args["id"],
                groupName: args["groupName"],
                isAdmin: args["is_admin"] == 1,
              );
            },
          );
        }
        if(settings.name == AssignTask.id) {
          final Map<String, dynamic> args = settings.arguments;

          return MaterialPageRoute(
            builder: (context) {
              return AssignTask(groupId: args["groupId"], callback: args["callback"]);
            },
          );
        }
      },
    );
  }
}
