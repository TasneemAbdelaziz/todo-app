import 'package:flutter/material.dart';

class myTheme{


  static Color primaryLight = Color(0xff5D9CEC);
  static Color greenColor = Color(0xffDFECDB);
  static Color blackColor = Color(0xff363636);
  static Color reddColor = Color(0xff363636);
  static Color whiteColor = Color(0xffffffff);
  static Color grayColor = Color(0xffC8C9CB);
  static Color hinitColor = Color(0xff707070);

  static Color primayDark = Color(0xff141922);
  static Color backColor = Color(0xff060E1E);





  static ThemeData lightTheme = ThemeData(

    primaryColor:primaryLight ,
    scaffoldBackgroundColor: greenColor,
    appBarTheme: AppBarTheme(

      color: myTheme.primaryLight,
      toolbarHeight: 90,
      elevation: 0,
    ),


    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      // backgroundColor:whiteColor,
      unselectedItemColor: grayColor,
      selectedItemColor:primaryLight ,
    ),

    floatingActionButtonTheme:FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      shape:StadiumBorder(side: BorderSide(
        color: whiteColor,
        width: 4,
      )) ,
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: whiteColor,
      ),
      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: blackColor,
      ),
      bodySmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: hinitColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        color: primaryLight,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        color: blackColor,
      )
    ),


  );

  static ThemeData darkTheme = ThemeData(
    bottomAppBarColor: primayDark,
    primaryColor:primayDark ,
    scaffoldBackgroundColor: backColor,
    appBarTheme: AppBarTheme(
      color: myTheme.primaryLight,
      toolbarHeight: 90,
      elevation: 0,

    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor:primayDark,
      unselectedItemColor: grayColor,
      selectedItemColor:primaryLight ,
    ),

    floatingActionButtonTheme:FloatingActionButtonThemeData(
      backgroundColor: primaryLight,
      shape:StadiumBorder(side: BorderSide(
        color: primayDark,
        width: 4,
      )) ,
    ),
    textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color:backColor ,
        ),
        titleMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: blackColor,
        ),
        bodySmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: hinitColor,
        ),
        bodyMedium: TextStyle(
          fontSize: 18,
          color: primaryLight,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          color: blackColor,
        )
    ),


  );


}