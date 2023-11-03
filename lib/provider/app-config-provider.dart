import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist/data_class/task.dart';
import 'package:todolist/firebase/firebase_utils.dart';

class AppConfigProvider extends ChangeNotifier{

  ThemeMode AppTheme = ThemeMode.light;
  String AppLanguage = 'en';

  List<task> tasksList = [];
  DateTime selectedDate = DateTime.now();


  void changeLanguage(String newLanguage)
  {
    if(AppLanguage == newLanguage)
    {
      return;
    }
    else{
      AppLanguage = newLanguage;
    }
    notifyListeners();
  }



  void changeTheme(ThemeMode newTheme)
  {
    if(AppTheme == newTheme)
      {
        return;
      }
    else{
      AppTheme = newTheme;
    }
    notifyListeners();
  }


  void getAllTasksFromFireStore(String uId)async
  {

    QuerySnapshot<task> querySnapshot = await firebaseUtils.getTasksCollections(uId).get();
    tasksList =querySnapshot.docs.map((doc)
    {
      return doc.data();
    }
    ).toList();

    //filltering
    tasksList = tasksList.where((element)
    {
      if(element.date?.day == selectedDate.day
      && element.date?.month == selectedDate.month
      && element.date?.year == selectedDate.year
      )
        {
            return true;
        }
      return false;
    }
    ).toList();

    //sorting
     tasksList.sort(
        (task task1 , task task2)
            {
              return task1.date!.compareTo(task2.date!);
            }
    );notifyListeners();
  }

  void changeDate(newDate,String uId)
  {
    selectedDate = newDate;
    getAllTasksFromFireStore(uId);
  }

}