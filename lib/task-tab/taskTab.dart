import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:todolist/provider/AuthProvider.dart';
import 'package:todolist/provider/app-config-provider.dart';
import 'package:todolist/data_class/task.dart';
import 'package:todolist/firebase/firebase_utils.dart';
import 'package:todolist/Theming/my-theme.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist/taskItem.dart';

class taskTab extends StatefulWidget{

  @override
  State<taskTab> createState() => _taskTabState();
}

class _taskTabState extends State<taskTab> {
  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<AppConfigProvider>(context);
    var authProvider = Provider.of<AuthProvider>(context,listen: false);
    // if(listProvider.tasksList.isEmpty){
      listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
    // }

    return
      Stack(
        children: [
          Container(
            color: myTheme.primaryLight,
            height: MediaQuery.of(context).size.height*0.11,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SafeArea(
                child:
                CalendarTimeline(
                    onDateSelected: (DateTime value) {
                    listProvider.changeDate(value,authProvider.currentUser!.id!);
                    print(value);
                  },
                  showYears: true,
                  initialDate:listProvider.selectedDate,
                  firstDate: DateTime.now().subtract(Duration(days: 365*3)),
                  lastDate: DateTime.now().add(const Duration(days: 365*3 )),
                  // onDateSelected: ,
                  leftMargin: 20,
                  monthColor: myTheme.whiteColor,
                  dayColor: myTheme.grayColor,
                  dayNameColor:myTheme.primaryLight,
                  activeDayColor: myTheme.primaryLight,
                  activeBackgroundDayColor: myTheme.whiteColor,
                  dotsColor: myTheme.whiteColor,
                  // selectableDayPredicate: (date) => date.day != 23,
                  locale: 'en',
                ),
              ),

             Expanded(
               child: ListView.builder(
                   itemBuilder:(context,index)=> taskItem(tasks: listProvider.tasksList[index]),
                 itemCount: listProvider.tasksList.length,
               ),
             ),
            ],
          ),
        ],
      );

  }


}