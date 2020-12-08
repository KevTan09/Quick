import 'package:flutter/material.dart';

class Helper {
  static void showAlertDialog({BuildContext context, String message}) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {Navigator.of(context, rootNavigator: true).pop();},
    );

    AlertDialog alert = AlertDialog(
      title: Text(
          'Informasi',
          style: TextStyle(color: Colors.lightBlue),
          textAlign: TextAlign.center
      ),
      content: Text(message),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static void showloading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text('Harap tunggu', textAlign: TextAlign.center,),
      content: SizedBox(
        height: 100,
        width: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ) ,
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}