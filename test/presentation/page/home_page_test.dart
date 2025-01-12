import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calendar_example/presentation/page/home_page.dart';
import 'package:calendar_example/domain/entity/diary.dart';
import 'package:calendar_example/presentation/inherited_widget/diary_inherited_widget.dart';
import 'package:calendar_example/application/use_case/diary_use_case.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:calendar_example/infrastructure/db/database.dart';

class MockDatabase extends Mock implements DiaryDatabase {
  @override
  Future<Database> get database async {
    return MockDb();
  }

  @override
  Future<void> close() async {}

  @override
  Future _onCreate(Database db, int version) async {}
}

class MockDb extends Mock implements Database {}

void main() {
  late MockDatabase mockDatabase;

  setUp(() {
    mockDatabase = MockDatabase();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: DiaryInheritedWidget(
        child: const HomePage(),
      ),
    );
  }

  testWidgets('HomePage shows loading indicator when loading diaries',
      (tester) async {
    final mockDb = MockDb();
    when(() => mockDatabase.database).thenAnswer((_) async => mockDb);
    when(() => mockDb.query('diary')).thenAnswer((_) async => []);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('HomePage shows error message when loading fails',
      (tester) async {
    when(() => mockDatabase.database).thenThrow(Exception('Failed to load'));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Error: Exception: Failed to load'), findsOneWidget);
  });

  testWidgets('HomePage shows diary list when loaded successfully',
      (tester) async {
    final testDiaries = [
      Diary(id: 1, date: '2023-01-01', content: 'Test content 1'),
      Diary(id: 2, date: '2023-01-02', content: 'Test content 2'),
    ];

    final mockDb = MockDb();
    when(() => mockDatabase.database).thenAnswer((_) async => mockDb);
    when(() => mockDb.query('diary')).thenAnswer((_) async => [
          {'id': 1, 'date': '2023-01-01', 'content': 'Test content 1'},
          {'id': 2, 'date': '2023-01-02', 'content': 'Test content 2'},
        ]);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Test content 1'), findsOneWidget);
    expect(find.text('Test content 2'), findsOneWidget);
  });

  testWidgets('Tapping delete shows confirmation dialog', (tester) async {
    final testDiaries = [
      Diary(id: 1, date: '2023-01-01', content: 'Test content 1'),
    ];

    final mockDb = MockDb();
    when(() => mockDatabase.database).thenAnswer((_) async => mockDb);
    when(() => mockDb.query('diary')).thenAnswer((_) async => [
          {'id': 1, 'date': '2023-01-01', 'content': 'Test content 1'},
        ]);
    when(() => mockDb.delete('diary', where: any(named: 'where')))
        .thenAnswer((_) async => 1);

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete));
    await tester.pump();

    expect(find.text('Delete Diary'), findsOneWidget);
    expect(find.text('Are you sure you want to delete this diary entry?'),
        findsOneWidget);
  });
}
