import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todolist/dialogs.dart';
import 'package:todolist/provider/AuthProvider.dart';
import 'package:todolist/provider/app-config-provider.dart';
import 'package:todolist/data_class/task.dart';
import 'package:todolist/firebase/firebase_utils.dart';
import 'package:todolist/Theming/my-theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class addTask extends StatefulWidget{
  @override
  State<addTask> createState() => _addTaskState();
}

class _addTaskState extends State<addTask> {
  String title = '';
  String desc = '';
  late AppConfigProvider listProvider;
  late AppConfigProvider provider;
  String errorString = '';

  DateTime date =DateTime.now();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
     provider = Provider.of<AppConfigProvider>(context);
    listProvider = Provider.of<AppConfigProvider>(context);
    return
      Container(
        // height: 500,
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Spacer(),
            Text(AppLocalizations.of(context)!.add_new_task,style:provider.AppTheme == ThemeMode.light?Theme.of(context).textTheme.titleMedium:Theme.of(context).textTheme.titleMedium!.copyWith(color: myTheme.whiteColor),textAlign: TextAlign.center,),
            Spacer(),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    style: provider.AppTheme == ThemeMode.light? Theme.of(context).textTheme.titleMedium: Theme.of(context).textTheme.titleMedium!.copyWith(color: myTheme.whiteColor),

                    validator: (value)
                    {
                      if(value==null||value.isEmpty)
                        {
                          return "please enter task";
                        }
                      return null;
                    },
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.enter_task,
                    hintStyle: Theme.of(context).textTheme.bodySmall,
                  ),
                    onChanged: (text){
                      title = text;
                    },
            ),

                  TextFormField(
                    style: provider.AppTheme == ThemeMode.light? Theme.of(context).textTheme.titleMedium: Theme.of(context).textTheme.titleMedium!.copyWith(color: myTheme.whiteColor),

                    onChanged: (text){
                      desc = text;
                    },
                    maxLines: 4,
                    validator: (value)
                    {
                      if(value==null||value.isEmpty)
                      {
                        return "please enter description";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.enter_desc,
                      hintStyle:Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Row(
              children: [
                Text(AppLocalizations.of(context)!.select_date,style:provider.AppTheme == ThemeMode.light? Theme.of(context).textTheme.bodySmall!.copyWith(color: myTheme.blackColor):Theme.of(context).textTheme.bodySmall!.copyWith(color: myTheme.whiteColor),),
              ],
            ),
            Spacer(),
            InkWell(
                onTap: ()
                {
                 showDate();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${DateFormat('yyyy-MM-dd').format(date)}",style: Theme.of(context).textTheme.bodySmall,textAlign: TextAlign.center,),
                  ],
                ),
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: myTheme.primaryLight
              ),
              child: IconButton(

                onPressed:() {
                  addTask();
                },
                  icon: Icon(Icons.check_rounded,color: myTheme.whiteColor,),

              ),
            ),
          ],
        ),
      );
  }

  void addTask()
  {
    if(formKey.currentState?.validate()==true){
      task tasks = task(title: title, date: date, desc: desc);
      // dialog.showLoading(context, 'Loading...');
      var authProvider = Provider.of<AuthProvider>(context,listen: false);
      firebaseUtils.addTaskToFirebase(tasks,authProvider.currentUser!.id!).
      then((value){
        dialog.hideLoading(context);
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.task_added,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
        );
        // Navigator.pop(context);
      })

          .timeout(
        Duration(milliseconds: 500),
        onTimeout:(){
          Fluttertoast.showToast(
              msg: AppLocalizations.of(context)!.task_added,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0
          );
          listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
          // Navigator.pop(context);
        }
      );
    }
  }
  void showDate()async{
  var selectedDate = await showDatePicker(
    context: context,
    builder: (context, child) {
      return  Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary:  provider.AppTheme == ThemeMode.light? myTheme.greenColor:myTheme.blackColor,
            onPrimary: provider.AppTheme == ThemeMode.light? myTheme.backColor:myTheme.greenColor,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red, // button text color
            ),
          ),
          dialogBackgroundColor: provider.AppTheme == ThemeMode.light? myTheme.greenColor:myTheme.blackColor,
        ),
        child: child!,
      );
    },
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(Duration(days: 365*3)),
    initialDate:date,
    helpText: 'Choose date of your task',
    );

  if(selectedDate!= null)
    {
      date = selectedDate;
    }
  setState(() {

  });
}

}