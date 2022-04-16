import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import '../widgets/tab_widget.dart';
import 'auth_switch_state.dart';

class LockScreen {
  BuildContext? ctx;
  LockScreen(this.ctx);

  LocalAuthentication localAuth = LocalAuthentication();

  userAuth({String? path, bool? value, User? user}) async {
    bool canCheckBiometrics = await localAuth.canCheckBiometrics;

    if (canCheckBiometrics == true) {
      List<BiometricType> existingBiometrics =
          await localAuth.getAvailableBiometrics();
      bool didAuthneticate = false;
      if (existingBiometrics.contains(BiometricType.fingerprint)) {
        try {
          didAuthneticate = await localAuth.authenticate(
              stickyAuth: true,
              sensitiveTransaction: false,
              localizedReason: 'Use Fingerprint to Authenticate');
        } on PlatformException catch (e) {
          if (e.code == auth_error.notAvailable) {
            print(e);
          }
          return didAuthneticate;
        }
        if (path == 'main') {
          if (didAuthneticate == true) {
            // Success
            Navigator.of(ctx as BuildContext).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(user: user as User),
              ),
            );
          } else {
            // Close Application!
            SystemNavigator.pop();
          }
        } else {
          if (didAuthneticate == true) {
            // Save Auth State in Settings Screen
            AuthSwitchState().saveAuthSwtich(value as bool);
          }
        }
      }
    }
  }
}
