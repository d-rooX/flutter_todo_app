import 'package:flutter/material.dart';
import 'package:flutter_todo_app/bloc/bloc_exports.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class TaskCalendar extends StatefulWidget {
  const TaskCalendar({Key? key}) : super(key: key);

  @override
  State<TaskCalendar> createState() => _TaskCalendarState();
}

class _TaskCalendarState extends State<TaskCalendar> {
  DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    TasksBloc bloc = context.read<TasksBloc>();

    if (_selectedDate == null) {
      _focusedDate = bloc.state.selectedDay ?? DateTime.now();
      _selectedDate = _focusedDate;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TableCalendar(
        eventLoader: (day) {
          if (day.isAtSameMomentAs(_selectedDate!)) return [];
          return bloc.state.tasksList?[day.millisecondsSinceEpoch] ?? [];
        },
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
          markerDecoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
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
        selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDate = selectedDay;
            _focusedDate = focusedDay; // update `_focusedDay` here as well
            bloc.add(ChangeSelectedDay(date: selectedDay));
          });
        },
        focusedDay: _focusedDate,
        firstDay: DateTime.now().subtract(const Duration(days: 365 * 10)),
        lastDay: DateTime.now().add(const Duration(days: 365 * 10)),
      ),
    );
  }
}
