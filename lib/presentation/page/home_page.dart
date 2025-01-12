import 'package:flutter/material.dart';
import 'package:calendar_example/presentation/inherited_widget/diary_inherited_widget.dart';
import 'package:calendar_example/domain/entity/diary.dart';
import 'package:calendar_example/presentation/component/calendar_widget.dart';
import 'package:calendar_example/presentation/page/diary_edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  bool _isMonthlyView = true;

  @override
  Widget build(BuildContext context) {
    final diaryInherited = DiaryInheritedWidget.of(context);
    if (diaryInherited == null) {
      return const Scaffold(
        body: Center(child: Text('Error: DiaryInheritedWidget not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diary App'),
        actions: [
          IconButton(
            icon: Icon(_isMonthlyView
                ? Icons.calendar_view_week
                : Icons.calendar_view_month),
            onPressed: () {
              setState(() {
                _isMonthlyView = !_isMonthlyView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCalendar(),
          Expanded(
            child: _buildDiaryList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewDiary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCalendar() {
    return FutureBuilder<List<Diary>>(
      future: DiaryInheritedWidget.of(context)!.useCase.getAllDiaries(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final diaries = snapshot.data ?? [];

        return CalendarWidget(
          selectedDate: _selectedDate,
          diaries: diaries,
          onDateSelected: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
          isMonthlyView: _isMonthlyView,
        );
      },
    );
  }

  Widget _buildDiaryList() {
    return FutureBuilder<List<Diary>>(
      future: DiaryInheritedWidget.of(context)!.useCase.getDiariesByDate(
            _selectedDate.toIso8601String(),
          ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final diaries = snapshot.data ?? [];

        if (diaries.isEmpty) {
          return const Center(
            child: Text('No entries for this date'),
          );
        }

        return ListView.builder(
          itemCount: diaries.length,
          itemBuilder: (context, index) {
            final diary = diaries[index];
            return ListTile(
              title: Text(diary.content),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _deleteDiary(diary),
              ),
              onTap: () => _editDiary(diary),
            );
          },
        );
      },
    );
  }

  void _deleteDiary(Diary diary) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Diary'),
        content:
            const Text('Are you sure you want to delete this diary entry?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DiaryInheritedWidget.of(context)!.useCase.deleteDiary(diary.id!);
      setState(() {});
    }
  }

  void _editDiary(Diary diary) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DiaryEditPage(
          diary: diary,
          selectedDate: _selectedDate,
        ),
      ),
    );
    setState(() {});
  }

  void _addNewDiary() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DiaryEditPage(
          selectedDate: _selectedDate,
        ),
      ),
    );
    setState(() {});
  }
}
