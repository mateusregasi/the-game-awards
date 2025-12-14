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
      id: map["id"],
      userId: map["user_id"] as int,
      title: map["title"] as String,
      description: map["description"] as String,
      date: map["date"] as String
    );
  }

  Future<int> save(DatabaseHelper con) async {
    var db = await con.db;
    return await db.insert('category', toMap());
  }
  
  // -
  Future<int> update(DatabaseHelper con) async {
    var db = await con.db;
    return await db.update('category', toMap(), where: "id = ?", whereArgs: [id]);
  }

  Future<int> delete(DatabaseHelper con) async {
    var db = await con.db;
    return await db.delete("category", where: "id = ?", whereArgs: [id]);
  }

  static Future<List<Category>> getAll(DatabaseHelper con) async {
    var db = await con.db;
    var res = await db.query("category");
    return res.isNotEmpty ? res.map((c) => Category.fromMap(c)).toList() : [];
  }
}