class Diary {
  final int? id;
  final String date;
  final String content;

  Diary({
    this.id,
    required this.date,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'content': content,
    };
  }

  factory Diary.fromMap(Map<String, dynamic> map) {
    return Diary(
      id: map['id'],
      date: map['date'],
      content: map['content'],
    );
  }

  @override
  String toString() {
    return 'Diary(id: $id, date: $date, content: $content)';
  }
}
