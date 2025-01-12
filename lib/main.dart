import 'package:flutter/material.dart';
import 'package:calendar_example/presentation/inherited_widget/diary_inherited_widget.dart';
import 'package:calendar_example/presentation/page/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DiaryInheritedWidget(
      child: MaterialApp(
        title: 'Diary App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
