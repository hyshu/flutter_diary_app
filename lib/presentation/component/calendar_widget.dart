import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendar_example/domain/entity/diary.dart';

class CalendarWidget extends StatefulWidget {
  final DateTime selectedDate;
  final List<Diary> diaries;
  final Function(DateTime) onDateSelected;
  final bool isMonthlyView;

  const CalendarWidget({
    super.key,
    required this.selectedDate,
    required this.diaries,
    required this.onDateSelected,
    required this.isMonthlyView,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(day, widget.selectedDate),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
        widget.onDateSelected(selectedDay);
      },
      calendarFormat:
          widget.isMonthlyView ? CalendarFormat.month : CalendarFormat.week,
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, date, events) {
          final hasDiary = widget.diaries
              .any((diary) => isSameDay(DateTime.parse(diary.date), date));
          return hasDiary
              ? Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null;
        },
      ),
    );
  }
}
