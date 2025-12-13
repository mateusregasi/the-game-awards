import 'package:thegameawards/utils/database.dart';

class Game {
  final int? id;
  final int userId;
  final String name;
  final String description;
  final String releaseDate;

  Game({this.id, required this.userId, required this.name, required this.description, required this.releaseDate});

  Map<String, dynamic> toMap() => {"id": id, "user_id": userId, "name": name, "description": description, "release_date": releaseDate};

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(id: map["id"], userId: map["user_id"], name: map["name"], description: map["description"], releaseDate: map["release_date"]);
  }

  Future<int> save(DatabaseHelper con) async {
    var db = await con.db;
    return await db.insert('game', toMap());
  }
  
  Future<int> update(DatabaseHelper con) async {
    var db = await con.db;
    return await db.update('game', toMap(), where: "id = ?", whereArgs: [id]);
  }

  Future<int> delete(DatabaseHelper con) async {
    var db = await con.db;
    return await db.delete("game", where: "id = ?", whereArgs: [id]);
  }

  static Future<List<Game>> getAll(DatabaseHelper con) async {
    var db = await con.db;
    var res = await db.query("game");
    return res.isNotEmpty ? res.map((c) => Game.fromMap(c)).toList() : [];
  }

  static Future<List<Game>> getAllByCategoryId(DatabaseHelper con, int id) async {
    var db = await con.db;
    var res = await db.rawQuery("SELECT * FROM game WHERE id IN (SELECT game_id FROM category_game WHERE category_id = ?)", [id]);
    return res.isNotEmpty ? res.map((c) => Game.fromMap(c)).toList() : [];
  }
}