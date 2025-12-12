import 'dart:convert';

import 'package:thegameawards/utils/database.dart';

class CategoryGame {

  final int categoryId;
  final int gameId;

  CategoryGame({
    required this.categoryId,
    required this.gameId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      "category_id": categoryId,
      "game_id": gameId,
    };
  }

  factory CategoryGame.fromMap(Map<String, dynamic> map) {
    return CategoryGame(
      categoryId: map["category_id"] as int,
      gameId: map["game_id"] as int,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory CategoryGame.fromJson(String source) => CategoryGame.fromMap(jsonDecode(source) as Map<String, dynamic>);

  Future<int> save(DatabaseHelper con) async {
    var db = await con.db;
    int res = await db.insert('category_game', toMap());
    return res;
  }
  
  Future<int> delete(DatabaseHelper con) async {
    var db = await con.db;
    int res = await db.delete("category_game", where: "category_id = ? and game_id = ?", whereArgs: [categoryId, gameId]);
    return res;
  }

  Future<List<CategoryGame>> getAll(DatabaseHelper con) async {
    var db = await con.db;
    var res = await db.query("user");
    List<CategoryGame> list = res.isNotEmpty ? res.map((c) => CategoryGame.fromMap(c)).toList() : [];
    return list;
  }
}