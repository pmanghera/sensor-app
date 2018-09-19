import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker(
      {Key key,
      this.labelText,
      this.selectedDate,
      this.selectedTime,
      this.selectDate,
      this.selectTime,
      this.isSet = false,
      this.onCheck})
      : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final bool isSet;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;
  final ValueChanged<bool> onCheck;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) selectDate(picked);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Checkbox(
          value: isSet,
          onChanged: (bool value) => onCheck(value),
          tristate: false,
          activeColor: Theme.of(context).accentColor,
        ),
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: labelText,
            valueText: DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () {
              _selectDate(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class DateAndTimePickerDemo extends StatefulWidget {
  static const String routeName = '/material/date-and-time-pickers';
  DateAndTimePickerDemo(
      {this.fromDate,
      this.fromTime,
      this.toDate,
      this.toTime,
      this.fromSet = false,
      this.toSet = false});
  final DateTime fromDate;
  final TimeOfDay fromTime;
  final DateTime toDate;
  final TimeOfDay toTime;
  final bool toSet;
  final bool fromSet;

  @override
  _DateAndTimePickerDemoState createState() {
    if (fromSet && toSet) {
      return _DateAndTimePickerDemoState(
        fromSet: fromSet,
        fromDate: fromDate,
        fromTime: fromTime,
        toSet: toSet,
        toDate: toDate,
        toTime: toTime,
      );
    } else if (fromSet) {
      return _DateAndTimePickerDemoState(
        fromSet: fromSet,
        fromDate: fromDate,
        fromTime: fromTime,
      );
    } else if (toSet) {
      return _DateAndTimePickerDemoState(
        toSet: toSet,
        toDate: toDate,
        toTime: toTime,
      );
    }
    return _DateAndTimePickerDemoState();
  }
}

class _DateAndTimePickerDemoState extends State<DateAndTimePickerDemo> {
  _DateAndTimePickerDemoState(
      {this.fromDate,
      this.fromTime,
      this.toDate,
      this.toTime,
      this.fromSet = false,
      this.toSet = false}) {
    if (!fromSet) {
      fromDate = DateTime.now().subtract(Duration(hours: 24));
      fromTime = TimeOfDay.now();
    }
    if (!toSet) {
      toDate = DateTime.now();
      toTime = TimeOfDay.now();
    }
  }
  DateTime fromDate = DateTime.now().subtract(Duration(hours: 24));
  TimeOfDay fromTime = TimeOfDay.now();
  DateTime toDate = DateTime.now();
  TimeOfDay toTime = TimeOfDay.now();
  bool fromSet = false;
  bool toSet = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Time Range')),
      body: DropdownButtonHideUnderline(
        child: SafeArea(
          top: false,
          bottom: false,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: <Widget>[
              _DateTimePicker(
                  labelText: 'From',
                  selectedDate: fromDate,
                  selectedTime: fromTime,
                  selectDate: (DateTime date) {
                    setState(() {
                      fromDate = date;
                    });
                  },
                  selectTime: (TimeOfDay time) {
                    setState(() {
                      fromTime = time;
                    });
                  },
                  isSet: fromSet,
                  onCheck: (value) {
                    setState(() {
                      fromSet = value;
                    });
                  }),
              _DateTimePicker(
                labelText: 'To',
                selectedDate: toDate,
                selectedTime: toTime,
                selectDate: (DateTime date) {
                  setState(() {
                    toDate = date;
                  });
                },
                selectTime: (TimeOfDay time) {
                  setState(() {
                    toTime = time;
                  });
                },
                isSet: toSet,
                onCheck: (value) {
                  setState(() => toSet = value);
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Row(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        DateTime startTime = fromSet
                            ? combineDateAndTime(fromDate, fromTime)
                            : null;
                        DateTime endTime =
                            toSet ? combineDateAndTime(toDate, toTime) : null;
                        Navigator.of(context).pop([startTime, endTime]);
                      },
                      child: Text(
                        'Set',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      color: Theme.of(context).accentColor,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop([]);
                      },
                      child: Text(
                        'Reset',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      color: Theme.of(context).accentColor,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

DateTime combineDateAndTime(DateTime date, TimeOfDay time) =>
    DateTime(date.year, date.month, date.day, time.hour, time.minute);
