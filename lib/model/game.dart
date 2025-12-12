import 'dart:convert';

import 'package:thegameawards/utils/database.dart';

class Game {

  final int? id;
  final int userId;
  final String name;
  final String description;
  final String releaseDate;

  Game({
    this.id,
    required this.userId,
    required this.name, 
    required this.description, 
    required this.releaseDate, 
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      "id": id,
      "user_id": userId,
      "name": name,
      "description": description,
      "release_date": releaseDate,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map["id"] ??= map["id"],
      userId: map["user_id"] as int,
      name: map["name"] as String,
      description: map["description"] as String,
      releaseDate: map["release_date"] as String,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory Game.fromJson(String source) => Game.fromMap(jsonDecode(source) as Map<String, dynamic>);


  Future<int> save(DatabaseHelper con) async {
    var db = await con.db;
    int res = await db.insert('game', toMap());
    return res;
  }
  
  Future<int> delete(DatabaseHelper con) async {
    var db = await con.db;
    int res = await db.delete("game", where: "id = ?", whereArgs: [id]);
    return res;
  }

  static Future<List<Game>> getAll(DatabaseHelper con) async {
    var db = await con.db;
    var res = await db.query("game");
    List<Game> list = res.isNotEmpty ? res.map((c) => Game.fromMap(c)).toList() : [];
    return list;
  }

  static Future<List<Game>> getAllByCategoryId(DatabaseHelper con, int id) async {
    var db = await con.db;
    var res = await db.query(
      "game", 
      where: "id in (select game_id from category_game where category_id = $id)"
    );
    List<Game> list = res.isNotEmpty ? res.map((c) => Game.fromMap(c)).toList() : [];
    return list;
  }
}