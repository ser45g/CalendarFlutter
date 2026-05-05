import 'dart:async';
import 'dart:ui';

class GeneralStream{
  const GeneralStream._();

  static StreamController<Locale> languageStream= StreamController.broadcast();
}