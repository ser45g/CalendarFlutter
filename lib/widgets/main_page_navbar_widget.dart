import 'package:flutter/material.dart';
import 'package:test_app/extensions/context_extension.dart';
import 'package:test_app/value_notifiers/value_notifier.dart';

class MainPageNavbarWidget extends StatelessWidget {
  const MainPageNavbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(valueListenable: selectedPageNotifier, builder:
        (context, selectedPage,child){
      return NavigationBar(destinations: [
        NavigationDestination(icon: Icon(Icons.calendar_month), label: context.localizations.mainPageNavbarCalendar),
        NavigationDestination(icon: Icon(Icons.edit), label: context.localizations.mainPageNavbarNotes),

      ],onDestinationSelected: (int value){
        selectedPageNotifier.value=value;
      },
      selectedIndex: selectedPage,);
    });
  }
}