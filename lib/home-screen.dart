import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/add-task.dart';
import 'package:todolist/dialogs.dart';
import 'package:todolist/provider/AuthProvider.dart';
import 'package:todolist/provider/app-config-provider.dart';
import 'package:todolist/Theming/my-theme.dart';
import 'package:todolist/register/sign_in.dart';
import 'package:todolist/settings-tab/settingsTab.dart';
import 'package:todolist/task-tab/taskTab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



class homeScreen extends StatefulWidget{
  static String routeName = 'home';

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int selectedIndex = 0;
  List<Widget> tabs = [
    taskTab(),
    settingsTab(),
  ];
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);

    var authProvider = Provider.of<AuthProvider>(context);
    return
        Scaffold(
          appBar: AppBar(
            title: Text(selectedIndex == 0?"${ AppLocalizations.of(context)!.todo} ${authProvider.currentUser!.name}":"Settings",style:Theme.of(context).textTheme.titleLarge),
            actions: [
              IconButton(
                icon:Icon(Icons.logout),
              onPressed: (){
                provider.tasksList = [];
                authProvider.currentUser = null;
                Navigator.of(context).pushReplacementNamed(signIn.routeName);
              },
              ),
              SizedBox(width: 10,),
            ],
          ),
          floatingActionButton:
          FloatingActionButton( //Floating action button on Scaffold
            onPressed: (){
              showModalBottomSheet(
                backgroundColor:provider.AppTheme == ThemeMode.light ?myTheme.whiteColor:myTheme.primayDark ,
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(40),
                    ),
                  ),
                  context: context, builder:
              (context) =>
                addTask()

              );
            },
            child: Icon(Icons.add),//icon inside button
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

          bottomNavigationBar: BottomAppBar(
            notchMargin: 10,
            shape: CircularNotchedRectangle(),
            child: Container(
              child: (
              BottomNavigationBar(
                backgroundColor:Colors.transparent,
                elevation: 0,
                currentIndex: selectedIndex,
                onTap:(index)
                {
                  selectedIndex = index;
                  setState(() {

                  });
                },
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted_outlined),label: "" ),
                  BottomNavigationBarItem(icon: Icon(Icons.settings),label: "" ),
                ],
              )
              ),
            ),
          ),
          body:tabs[selectedIndex],
        );
  }

}