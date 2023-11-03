import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todolist/provider/AuthProvider.dart';
import 'package:todolist/provider/app-config-provider.dart';
import 'package:todolist/data_class/task.dart';
import 'package:todolist/edit-Item/edit-item.dart';
import 'package:todolist/firebase/firebase_utils.dart';
import 'package:todolist/Theming/my-theme.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class taskItem extends StatefulWidget{

  task tasks;
  taskItem({required this.tasks});

  @override
  State<taskItem> createState() => _taskItemState();
}

class _taskItemState extends State<taskItem> {
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context,listen: false);
    var provider = Provider.of<AppConfigProvider>(context);
    return
      InkWell(
        onTap: () {

          Navigator.of(context).pushNamed(editItem.routeName,arguments: widget.tasks,);
        },
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Slidable(
            startActionPane: ActionPane(
              extentRatio: 0.25,
              motion:BehindMotion(),
              children: [
                SlidableAction(
                  backgroundColor: Colors.red,
                  onPressed: (context){
                    firebaseUtils.deleteTask(widget.tasks,authProvider.currentUser!.id!).timeout(
                      Duration(milliseconds: 500),
                      onTimeout: ()
                        {
                          provider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
                          print('task deleted');
                        }
                    );
                  },
                  icon:Icons.delete,

                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft:  Radius.circular(20)),
                  label: "delete",
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(15),
              // width: 200,
              height: 100,
              decoration: BoxDecoration(
                color:provider.AppTheme == ThemeMode.light ? myTheme.whiteColor:myTheme.primayDark,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color:  widget.tasks.isDone==false? myTheme.primaryLight:Colors.green,
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: VerticalDivider(
                      width: 5,
                      thickness: 4,
                      indent: 20,
                      endIndent: 20,
                      color: widget.tasks.isDone==false? myTheme.primaryLight:Colors.green,
                    ),
                  ),
                  SizedBox(width: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${widget.tasks.title}",style: Theme.of(context).textTheme.titleLarge!.copyWith(color:widget.tasks.isDone==false? myTheme.primaryLight:Colors.green ),),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Icon(Icons.insert_chart_outlined,size: 20,color: provider.AppTheme == ThemeMode.light?myTheme.blackColor: myTheme.whiteColor),
                          SizedBox(width: 10,),
                          Text("${widget.tasks.desc}",style: provider.AppTheme==ThemeMode.light?Theme.of(context).textTheme.bodyLarge:Theme.of(context).textTheme.bodyLarge!.copyWith(color: myTheme.whiteColor),),
                        ],
                      ),
                    ],
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:widget.tasks.isDone == true ?Colors.transparent:myTheme.primaryLight,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: (){
                      widget.tasks.isDone == false?widget.tasks.isDone= true:widget.tasks.isDone=false ;
                      setState(() {

                      });
                      firebaseUtils.updateTask(widget.tasks,authProvider.currentUser!.id!).timeout(
                          Duration(milliseconds: 500),
                          onTimeout: ()
                          {
                            provider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
                          }
                      );

                    },
                    child: widget.tasks.isDone == false? Image.asset("assets/images/check.png"):Text(AppLocalizations.of(context)!.done+"!",style: TextStyle(fontSize: 30,color: Colors.green),
                  ),
                  ),

                ],
              ),
            ),
          ),
        ),
      );
  }
}