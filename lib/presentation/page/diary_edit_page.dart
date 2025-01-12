import 'package:flutter/material.dart';
import 'package:calendar_example/domain/entity/diary.dart';
import 'package:calendar_example/presentation/inherited_widget/diary_inherited_widget.dart';

class DiaryEditPage extends StatefulWidget {
  final Diary? diary;
  final DateTime selectedDate;

  const DiaryEditPage({
    super.key,
    this.diary,
    required this.selectedDate,
  });

  @override
  State<DiaryEditPage> createState() => _DiaryEditPageState();
}

class _DiaryEditPageState extends State<DiaryEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(
      text: widget.diary?.content ?? '',
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.diary == null ? 'New Diary' : 'Edit Diary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveDiary,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Diary Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Date: ${widget.selectedDate.toLocal().toString().split(' ')[0]}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveDiary() async {
    if (_formKey.currentState!.validate()) {
      final diaryInherited = DiaryInheritedWidget.of(context);
      if (diaryInherited == null) return;

      final diary = Diary(
        id: widget.diary?.id,
        date: widget.selectedDate.toIso8601String(),
        content: _contentController.text,
      );

      if (widget.diary == null) {
        await diaryInherited.useCase.createDiary(diary);
      } else {
        await diaryInherited.useCase.updateDiary(diary);
      }

      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }
}
