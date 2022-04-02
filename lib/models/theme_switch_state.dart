import 'package:shared_preferences/shared_preferences.dart';

class ThemeSwitchState {
  final Future<SharedPreferences> _sPref = SharedPreferences.getInstance();

  void saveSwitchState(bool status) async {
    final Future<SharedPreferences> _sPref = SharedPreferences.getInstance();
    final sPrefInstance = await _sPref;
    sPrefInstance.setBool('status', status);
  }

  // Read State
  Future<bool> getSwitchState() async {
    final sPrefInstance = await _sPref;
    if (sPrefInstance.containsKey('status')) {
      final value = sPrefInstance.getBool('status');
      return value!;
    } else {
      return false;
    }
  }
}
