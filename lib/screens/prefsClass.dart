import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  ///
  /// Instantiation of the SharedPreferences library
  ///
  static final String _savedId = "favorited";

  /// ------------------------------------------------------------
  /// Method that returns the user language code, 'en' if not set
  /// ------------------------------------------------------------
  static Future<List> getSavedId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_savedId) ?? [];
  }

  /// ----------------------------------------------------------
  /// Method that saves the user language code
  /// ----------------------------------------------------------
  static Future<bool> setSavedId(Set value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(
        _savedId, value.map((e) => e.toString()).toList());
  }
}
