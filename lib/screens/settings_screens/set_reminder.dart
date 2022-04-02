import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/AuthSwitchState.dart';
import '../../models/LockScreen.dart';
import '../../models/NotificationHandler.dart';

class ReminderSettings extends StatefulWidget {
  static const routeName = '/ReminderSettings';
  const ReminderSettings({Key? key}) : super(key: key);

  @override
  State<ReminderSettings> createState() => _ReminderSettingsState();
}

class _ReminderSettingsState extends State<ReminderSettings> {
  bool isSwitched = false;
  TimeOfDay selectedTime = TimeOfDay.now();

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Reminder')),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 80, bottom: 19),
                  child: SvgPicture.asset(
                    'assets/images/remind.svg',
                    width: 300,
                    height: 150.0,
                  ),
                ),
              ],
            ),
            const Text("Never Forget to Preserve Your Precious Memories"),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
              child: Form(
                child: TextFormField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    hintText: "${selectedTime.hour}:${selectedTime.minute}",
                    enabled: false,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () async {
                await _selectTime(context).whenComplete(() {
                  NotificationHandler.showScheduledNotificaion(
                    scheduledDate: selectedTime,
                  );
                  final snackBar = SnackBar(
                    content: Text(
                        'Daily Reminder is Set to ${selectedTime.hour}:${selectedTime.minute}'),
                  );
                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(snackBar);
                });
              },
              child: const Text("Set Reminder"),
            ),
            // IconButton(
            //     icon: const Icon(Icons.alarm),
            //     onPressed: () {
            //       NotificationHandler.showNotificaion(
            //         title: 'sample',
            //         body: 'ambo',
            //         payload: 'sarah.abs',
            //       );
            //     }),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     IconButton(
            //         icon: const Icon(Icons.alarm_add),
            //         onPressed: () {
            //           NotificationHandler.showScheduledNotificaion(
            //             scheduledDate: selectedTime,
            //           );
            //           final snackBar = SnackBar(
            //             content: Text(
            //                 'Daily Reminder is Set to ${selectedTime.hour}:${selectedTime.minute}'),
            //           );
            //           ScaffoldMessenger.of(context)
            //             ..removeCurrentSnackBar()
            //             ..showSnackBar(snackBar);
            //         }),
            //   ],
            // ),
          ],
        ));
  }
}
