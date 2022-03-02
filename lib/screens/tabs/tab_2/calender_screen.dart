import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: SfDateRangePicker(
                onSelectionChanged: (pickedDate) {
                  setState(
                    () {
                      selectedDate = pickedDate.value;
                      print(selectedDate);
                    },
                  );
                },
              ),
            ),
          ],
        ),
        Row()
      ],
    );
  }
}
