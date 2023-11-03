import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolist/provider/app-config-provider.dart';
import 'package:todolist/Theming/my-theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class settingsTab extends StatefulWidget {
  @override
  State<settingsTab> createState() => _settingsTabState();
}

class _settingsTabState extends State<settingsTab> {
  late AppConfigProvider provider;

  @override
  Widget build(BuildContext context) {
     provider = Provider.of<AppConfigProvider>(context);
     String theme = provider.AppTheme==ThemeMode.light?"Light":"Dark";
     // ///////////////////////////////////////
     String language = provider.AppLanguage=='en'?"English":"Arabic";
     // //////////////////////////////////////


     return Column(
       children: [
       Container(
       color: myTheme.primaryLight,
       height: MediaQuery.of(context).size.height*0.1
       ),
         Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context)!.language,
                style: provider.AppTheme == ThemeMode.light
                    ? Theme.of(context).textTheme.titleMedium
                    : Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: myTheme.whiteColor),
              ),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: myTheme.primaryLight,
                      width: 2,
                    ),
                    color: myTheme.whiteColor,
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: language,
                      icon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(
                          Icons.arrow_drop_down_outlined,
                          color: myTheme.primaryLight,
                        ),
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          language = newValue!;
                        });
                      },
                      items: [
                        DropdownMenuItem<String>(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                AppLocalizations.of(context)!.english,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )),
                          value: "English",
                          onTap: (){
                            provider.changeLanguage("en");
                          },
                        ),
                        DropdownMenuItem<String>(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                AppLocalizations.of(context)!.arabic,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )),
                          value: "Arabic",
                          onTap: (){
                            provider.changeLanguage("ar");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                AppLocalizations.of(context)!.mode,
                style: provider.AppTheme == ThemeMode.light
                    ? Theme.of(context).textTheme.titleMedium
                    : Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: myTheme.whiteColor),
              ),

              Container(
                margin: EdgeInsets.all(20),
                width: 319,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: myTheme.primaryLight,
                    width: 2,
                  ),
                  color: myTheme.whiteColor,
                ),
                child: DropdownButtonHideUnderline(

                  child: DropdownButton<String>(
                    value: theme,
                    icon: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.arrow_drop_down_outlined,
                        color: myTheme.primaryLight,
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        theme = newValue!;
                      });
                    },
                    items: [
                      DropdownMenuItem<String>(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              AppLocalizations.of(context)!.light,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )),
                        value: "Light",
                        onTap: () {
                          provider.changeTheme(ThemeMode.light);
                        },
                      ),
                      DropdownMenuItem<String>(
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              AppLocalizations.of(context)!.dark,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )),
                        value: "Dark",
                        onTap: () {
                          provider.changeTheme(ThemeMode.dark);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    ),
       ],
     );
  }
}
