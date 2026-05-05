import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/extensions/context_extension.dart';
import 'package:test_app/services/localization_service.dart';
import 'package:test_app/value_notifiers/value_notifier.dart';

import '../l10n/l10n.dart';
import '../streams/general_stream.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.localizations.settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [

            Row(children: [
              Expanded(child: Row(children: [
                Icon(Icons.language),
                SizedBox(width: 4,),
                Text(context.localizations.homeLanguage, style: TextStyle(fontSize: 17,
                    fontWeight: FontWeight.bold),),
              ],)),


              Expanded(
                flex: 2,
                child: DropdownButton(items: [
                  DropdownMenuItem(child: Text("Русский"),value: "ru",),
                  DropdownMenuItem(child: Text("English"),value: 'en',)
                ],
                    value: LocalizationService.currentLanguage(context),
                    onChanged: (String? value) async {
                      //SharedPreferences prefs = await SharedPreferences.getInstance();

                        LocalizationService.setLanguage(value,context);
                        //languageNotifier.value=value??languageNotifier.value;
                        //prefs.setString("language", languageNotifier.value);
                        //GeneralStream.languageStream.add(L10n.locals
                          //  .firstWhere((element)=>element==Locale(selectedMenuItem??
                          //  context.localizations.localeName)));

                    }),
              ),
            ],),

          ],
        ),
      ),
    );
  }
}
