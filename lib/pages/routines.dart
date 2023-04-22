import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../components/common.dart';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.transparent),
          ),
        ),
        toolbarHeight: 80,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(CupertinoIcons.arrow_left),
        ),
        title: const Text('Routines'),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 8,
        shadowColor: Colors.white.withAlpha(50),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25),
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
                dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0],
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
                  _focused = focusedDay; // update `_focusedDay` here as well
                });
              },
              focusedDay: _focused,
              firstDay: DateTime.now().subtract(const Duration(days: 365 * 10)),
              lastDay: DateTime.now().add(const Duration(days: 365 * 10)),
            ),
          ),
          Section(
            title: "Today Tasks",
            // onSeeAll: () {},
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: const [
                  RoundedTaskItem(emoji: "🥤", title: "Drink Water"),
                  RoundedTaskItem(emoji: "❤️", title: "Meet Kate"),
                  RoundedTaskItem(emoji: "🔥", title: "Overclock AMD"),
                  RoundedTaskItem(emoji: "🍏", title: "Eat fruits"),
                  RoundedTaskItem(emoji: "🎂", title: "SAN Birthday"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
