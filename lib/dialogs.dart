import 'package:flutter/material.dart';
import 'package:todolist/Theming/my-theme.dart';

class dialog {

  static void showLoading(BuildContext context,String message){
    showDialog(
        barrierDismissible: false,
        context: context, builder: (context){
      return AlertDialog(
        backgroundColor: myTheme.greenColor,
        content: Row(
          children: [
            CircularProgressIndicator(
              color: myTheme.primaryLight,
            ),
            SizedBox(width: 12,),
            Text(message),
          ],
        ),
      );
    });
  }

  static void hideLoading(BuildContext context){
    Navigator.of(context).pop();
  }




  static void showMessage(BuildContext context,String message,{String title = '' ,String? posActionName, VoidCallback? posAction,String? negActionName, VoidCallback? negAction }) {

    List<Widget>actions = [];
    if(posActionName != null){
      actions.add(TextButton(onPressed: (){
        Navigator.of(context).pop();
        posAction?.call();
      }, child: Text(posActionName)));
    }
    if(negActionName != null){
      actions.add(TextButton(onPressed: (){
        Navigator.of(context).pop();
        negAction?.call();
      }, child: Text(negActionName)));
    }

    showDialog(context: context, builder: (context){
      return
        AlertDialog(
          content:Text(message),
          title: Text(title,style: TextStyle(color: myTheme.blackColor),),

          actions: actions,
          backgroundColor: myTheme.greenColor,
        );
    });


  }
}