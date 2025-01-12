import 'package:flutter/material.dart';
import 'package:calendar_example/application/use_case/diary_use_case.dart';
import 'package:calendar_example/infrastructure/db/database.dart';

class DiaryInheritedWidget extends InheritedWidget {
  final DiaryDatabase database;
  final DiaryUseCase useCase;

  DiaryInheritedWidget({
    Key? key,
    required Widget child,
  })  : database = DiaryDatabase(),
        useCase = DiaryUseCase(DiaryDatabase()),
        super(key: key, child: child);

  static DiaryInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DiaryInheritedWidget>();
  }

  @override
  bool updateShouldNotify(DiaryInheritedWidget oldWidget) {
    return database != oldWidget.database || useCase != oldWidget.useCase;
  }
}
