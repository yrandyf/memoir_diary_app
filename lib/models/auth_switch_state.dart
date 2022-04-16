import 'package:shared_preferences/shared_preferences.dart';

class AuthSwitchState {
  // Gets an Instance of SharedPreferences
  final Future<SharedPreferences> _sPref = SharedPreferences.getInstance();

  // Save the auth state of the user
  void saveAuthSwtich(bool state) async {
    final sPrefInstance = await _sPref;
    sPrefInstance.setBool('state', state);
  }

  // Read State
  Future<bool> getAuthState() async {
    final sPrefInstance = await _sPref;
    if (sPrefInstance.containsKey('state')) {
      final value = sPrefInstance.getBool('state');
      return value!;
    } else {
      return false;
    }
  }
}
