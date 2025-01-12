flutter_diary_app
----

I had Cline and deepsee-chat create a Flutter app.  
(Please let me know if there are any improvements)

# Way of trying
1. Reset to empty project.
```
git reset bf97dd425660c4eb10a9c2f3489450f56a324836
```
2. Move `ios` and `android` out.
3. Run the following prompt in Cline.
```
Create a diary app in Flutter.

Requirements:
- Editing pubspec.yaml is prohibited. Use only the packages already added.
- Creating new directories is prohibited. Follow the directory structure in the `lib` directory for the architecture.
- Use `InheritedWidget` to pass UseCase, Entity, and Store to the View.
- The diary entries will be accessible by date through a calendar. The calendar can be switched between monthly and weekly views. In the weekly view, the contents of the diary entries can be seen in a list format.
- Tapping a date on the calendar should display the diary below the calendar.
- Diaries can be edited and deleted. When deleting, show a confirmation dialog.
- Diaries can be created for today or any day in the past.
- Diaries should be saved in the `diary` table using `sqflite`.
- Perform Widget tests and Unit tests.
```

# Screenshots
<img src="https://github.com/user-attachments/assets/7675df15-d950-448c-9ed0-fc37758eb68c" width="49%">
<img src="https://github.com/user-attachments/assets/4c07dbd7-4266-42d8-98d4-0004043658c6" width="49%">
