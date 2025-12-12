import 'dart:convert';

class Category {

  final int? id;
  final int userId; 
  final String title;
  final String description;
  final String date;

  Category({
    this.id, 
    required this.userId, 
    required this.title, 
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      "id": id,
      "user_id": userId,
      "title": title,
      "description": description,
      "date": date,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map["id"] ??= map["id"],
      userId: map["user_id"] as int,
      title: map["title"] as String,
      description: map["description"] as String,
      date: map["date"] as String
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Category.fromJson(String source) => Category.fromMap(jsonDecode(source) as Map<String, dynamic>);
}