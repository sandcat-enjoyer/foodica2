import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:fl_chart/fl_chart.dart';

class CalorieDetailPage extends StatefulWidget {
  const CalorieDetailPage({Key? key}) : super(key: key);

  @override
  _CalorieDetailPageState createState() => _CalorieDetailPageState();
}

class _CalorieDetailPageState extends State<CalorieDetailPage> {
  PieChartSectionData _fat = PieChartSectionData(
      color: Colors.red, value: 15, title: "Fat", radius: 50);
  PieChartSectionData _sugar = PieChartSectionData(
      color: Colors.blue, value: 10, title: "Sugar", radius: 50);
  PieChartSectionData _salt = PieChartSectionData(
      color: Colors.green, value: 12, title: "Salt", radius: 50);
  DateTime selectedDate = DateTime.now();
  _selectDate(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    assert(theme.platform != null);
    switch (theme.platform) {
      case TargetPlatform.android:
        return buildMaterialDatePicker(context);
      case TargetPlatform.iOS:
        return buildCupertinoDatePicker(context);
      default:
        return buildMaterialDatePicker(context);
    }
  }

  buildCupertinoDatePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            color: Colors.white,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (picked) {
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              initialDateTime: selectedDate,
              minimumYear: 2000,
              maximumYear: 2025,
            ),
          );
        });
  }

  _setThemeForDatePicker() {
    //need to set a fitting light theme since it's just default now
    //but leaving it like this for now
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    if (isDarkMode) {
      return ThemeData.dark();
    } else {
      return ThemeData.light();
    }
  }

  buildMaterialDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDatePickerMode: DatePickerMode.day,
      cancelText: 'Cancel',
      confirmText: 'Select',
      errorFormatText: 'Enter valid date',
      errorInvalidText: 'Enter date in valid range',
      fieldLabelText: 'Booking date',
      fieldHintText: 'Month/Date/Year',
      builder: (context, child) {
        return Theme(data: _setThemeForDatePicker(), child: child!);
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    _dateFormatter(selectedDate);
  }

  String _dateFormatter(DateTime tm) {
    DateTime today = DateTime.now();
    Duration oneDay = const Duration(days: 1);
    Duration twoDay = const Duration(days: 2);
    String month;
    switch (tm.month) {
      case 1:
        month = "January";
        break;
      case 2:
        month = "February";
        break;
      case 3:
        month = "March";
        break;
      case 4:
        month = "April";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "June";
        break;
      case 7:
        month = "July";
        break;
      case 8:
        month = "August";
        break;
      case 9:
        month = "September";
        break;
      case 10:
        month = "October";
        break;
      case 11:
        month = "November";
        break;
      case 12:
        month = "December";
        break;
      default:
        month = "Unknown";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Today";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Yesterday";
    } else {
      return "${tm.day} $month ${tm.year}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final _sections = [_fat, _sugar, _salt];
    return Scaffold(
        appBar: AppBar(
            title: Text("Details",
                style: TextStyle(
                    fontFamily: "Poppins", fontWeight: FontWeight.bold)),
            actions: [
              IconButton(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_month_outlined),
              )
            ]),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text("Details",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 36,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 8.0),
                      Text(
                        _dateFormatter(selectedDate),
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  )),
              SizedBox(
                  width: 300,
                  height: 300,
                  child: Column(children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          sections: _sections,
                          borderData: FlBorderData(show: false),
                          centerSpaceRadius: 90,
                          sectionsSpace: 9,
                        ),
                      ),
                    ),
                  ])),
              Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(20.0),
                  child: Text("Fats consumed: "))
            ],
          ),
        ));
  }
}
