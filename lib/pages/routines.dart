import 'package:flutter/material.dart';
import 'package:nyava_ui/main.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class RoutinesPage extends StatefulWidget {
  const RoutinesPage({Key? key}) : super(key: key);

  @override
  State<RoutinesPage> createState() => _RoutinesPageState();
}

class _RoutinesPageState extends State<RoutinesPage> {
  DateTime _focused = DateTime.now();
  DateTime _selected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TableCalendar(
                  headerStyle: const HeaderStyle(
                    headerPadding: EdgeInsets.only(bottom: 5),
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    leftChevronMargin: EdgeInsets.zero,
                    rightChevronMargin: EdgeInsets.zero,
                    titleCentered: true,
                  ),
                  rowHeight: 42,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.grey.shade500),
                    weekendStyle: TextStyle(color: Colors.grey.shade500),
                    dowTextFormatter: (date, locale) =>
                        DateFormat.E(locale).format(date)[0],
                  ),
                  calendarStyle: CalendarStyle(
                    cellMargin: const EdgeInsets.all(2),
                    outsideDaysVisible: false,
                    selectedDecoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    todayTextStyle: const TextStyle(color: Colors.black),
                    todayDecoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(
                          color: Colors.grey.shade400,
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selected, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selected = selectedDay;
                      _focused =
                          focusedDay; // update `_focusedDay` here as well
                    });
                  },
                  focusedDay: _focused,
                  firstDay:
                      DateTime.now().subtract(const Duration(days: 365 * 10)),
                  lastDay: DateTime.now().add(const Duration(days: 365 * 10)),
                ),
              ),
              Section(
                title: "Today Tasks",
                onSeeAll: () {},
                child: Column(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
