import 'package:flutter/material.dart';

class Helper {
  static void showDialogBox({BuildContext context, Widget content, List<Widget> actions, String title, bool barrierDismissible, onClose}) {
      AlertDialog alert = AlertDialog(
        title: Text(
            title != null && title.isNotEmpty ? title : "Informasi",
            style: TextStyle(color: Colors.orange),
            textAlign: TextAlign.center
        ),
        content: content,
        actions: actions,
      );

      showDialog(
        barrierDismissible: barrierDismissible != null ? barrierDismissible : true,
        context: context,
        builder: (BuildContext context) => alert
      ).then((value) {
        if(onClose != null && onClose is Function)
          onClose();
      });
  }

  static void showAlertDialog({BuildContext context, String message, onClose}) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {Navigator.of(context, rootNavigator: true).pop();},
    );

    showDialogBox(context: context, content: Text(message), actions: [okButton], onClose: onClose);
  }

  static void showloading(BuildContext context) {
    Widget indicator = WillPopScope(
      onWillPop: (){},
      child: SizedBox(
          height: 100,
          width: 100,
          child: Center(
            child: CircularProgressIndicator(),
          )
      ),
    );

    showDialogBox(
      barrierDismissible: false,
      context: context,
      content: indicator,
      title: "Harap Tunggu"
    );
  }
}