import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:todolist/data_class/task.dart';
import 'package:todolist/dialogs.dart';
import 'package:todolist/firebase/firebase_utils.dart';
import 'package:todolist/home-screen.dart';
import 'package:todolist/provider/AuthProvider.dart';
import 'package:todolist/provider/app-config-provider.dart';
import 'package:todolist/Theming/my-theme.dart';
import 'package:intl/intl.dart';
import 'package:todolist/taskItem.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class editItem extends StatefulWidget {
  static String routeName = "editItem";
  @override
  State<editItem> createState() => _editItemState();
}

class _editItemState extends State<editItem> {
  var titleEditingController = TextEditingController();
  var descEditingController = TextEditingController();
  late DateTime date;
   task? arg;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //
  //   });
  // }



  @override
  Widget build(BuildContext context) {
    if(arg == null){
      arg = ModalRoute.of(context)!.settings.arguments as task;
      titleEditingController.text = arg!.title??"";
      descEditingController.text = arg!.desc??"";
      date = arg!.date??DateTime.now();
    }


    var size = MediaQuery.of(context).size;
    var provider = Provider.of<AppConfigProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title:
            Text( AppLocalizations.of(context)!.todo, style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Stack(
        children: [
          Container(
            color: myTheme.primaryLight,
            height: MediaQuery.of(context).size.height*0.1,
          ),
          SingleChildScrollView(
            child: Center(
              child: Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(20),
                width: size.width - 50,
                height: size.height - 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: provider.AppTheme == ThemeMode.light
                      ? myTheme.whiteColor
                      : myTheme.primayDark,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Edit task",
                      style: provider.AppTheme == ThemeMode.light
                          ? Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: myTheme.blackColor)
                          : Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(color: myTheme.whiteColor),
                      textAlign: TextAlign.center,
                    ),
                    Form(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            style: provider.AppTheme == ThemeMode.light
                                ? Theme.of(context).textTheme.titleMedium
                                : Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: myTheme.whiteColor),
                            controller: titleEditingController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            style: provider.AppTheme == ThemeMode.light
                                ? Theme.of(context).textTheme.titleMedium
                                : Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: myTheme.whiteColor),
                            decoration: InputDecoration(
                              // hintText: arguments['desc']= arguments['title'] ,
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                            ),
                            controller: descEditingController,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "Select Date",
                      style: provider.AppTheme == ThemeMode.light
                          ? Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: myTheme.blackColor)
                          : Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: myTheme.whiteColor),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        showDate();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${DateFormat('yyyy-MM-dd').format(arg!.date ??DateTime.now())}",
                            style: Theme.of(context).textTheme.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: myTheme.primaryLight,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          fixedSize: Size(255, 52),
                        ),
                        onPressed: () {
                          // task tasks = task(
                          //     title: titleEditingController.text ??"",
                          //     date: date ,
                          //     desc: descEditingController.text ??"",
                          //     );

                          arg!.title = titleEditingController.text;
                          arg!.desc = descEditingController.text;
                          arg!.date = date;
                          var authProvider =
                              Provider.of<AuthProvider>(context, listen: false);
                          firebaseUtils
                              .editTaskToFirebase(
                                  arg!, authProvider.currentUser?.id ??"")
                              .then((value) {
                            provider.getAllTasksFromFireStore(
                                arg!.id!);

                            // dialog.hideLoading(context);
                            Fluttertoast.showToast(
                                msg: "Task edited successfully ",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            firebaseUtils.updateTask(arg!,authProvider.currentUser!.id! );
                            Navigator.of(context).pop(homeScreen.routeName);
                          });
                        },
                        child: Text(
                          "Save Changes",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: myTheme.whiteColor),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showDate() async {
    var selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365 * 3)),
      initialDate: DateTime.now(),
      helpText: 'Choose date to do tasks',
    );

    if (selectedDate != null) {
      date = selectedDate;
    }
    setState(() {});
  }
}
