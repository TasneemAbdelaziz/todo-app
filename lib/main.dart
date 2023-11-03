import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/provider/AuthProvider.dart';
import 'package:todolist/provider/app-config-provider.dart';
import 'package:todolist/edit-Item/edit-item.dart';
import 'package:todolist/home-screen.dart';
import 'package:todolist/Theming/my-theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todolist/register/sign_in.dart';
import 'package:todolist/register/sign_up.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // await FirebaseFirestore.instance.disableNetwork();
  // FirebaseFirestore.instance.settings = Settings(cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED);
  runApp(
      MultiProvider(providers: [
          ChangeNotifierProvider(create: (context)=>AuthProvider()),
            ChangeNotifierProvider(create: (context)=>AppConfigProvider()),
          ],
      child: MyApp(),
      )
      );
}

class MyApp extends StatefulWidget{
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<AppConfigProvider>(context);
    AuthProvider a = Provider.of<AuthProvider>(context);


    return MaterialApp(

      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale(provider.AppLanguage),

      debugShowCheckedModeBanner: false,
      routes: {
        homeScreen.routeName :(context) =>homeScreen(),
        editItem.routeName: (context) => editItem(),
        signIn.routeName: (context) => signIn(),
        signUp.routeName: (context) => signUp(),
      },
      initialRoute: signIn.routeName,
      // initialRoute: homeScreen.routeName,
      theme: myTheme.lightTheme,
      darkTheme: myTheme.darkTheme,
      themeMode:provider.AppTheme ,

    );
  }
}

