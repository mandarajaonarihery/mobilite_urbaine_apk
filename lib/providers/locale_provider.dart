import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale;

  LocaleProvider(this._locale);

  Locale get locale => _locale;

  /// Change la langue et notifie les widgets écoutant ce provider
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  /// Bascule entre français et malagasy (anglais ici comme langue par défaut)
  void toggleLocale() {
    if (_locale.languageCode == 'fr') {
      setLocale(const Locale('en')); // ou 'mg' si tu veux Malagasy
    } else {
      setLocale(const Locale('fr'));
    }
  }
}
