import 'dart:convert';

import 'package:thegameawards/utils/database.dart';

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

  Future<int> save(DatabaseHelper con) async {
    var db = await con.db;
    int res = await db.insert('category', toMap());
    return res;
  }
  
  Future<int> delete(DatabaseHelper con) async {
    var db = await con.db;
    int res = await db.delete("category", where: "id = ?", whereArgs: [id]);
    return res;
  }

  static Future<List<Category>> getAll(DatabaseHelper con) async {
    var db = await con.db;
    var res = await db.query("category");
    List<Category> list = res.isNotEmpty ? res.map((c) => Category.fromMap(c)).toList() : [];
    return list;
  }
}