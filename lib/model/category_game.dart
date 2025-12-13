import 'package:thegameawards/utils/database.dart';

class CategoryGame {
  final int categoryId;
  final int gameId;

  CategoryGame({required this.categoryId, required this.gameId});

  Map<String, dynamic> toMap() => {"category_id": categoryId, "game_id": gameId};

  Future<int> save(DatabaseHelper con) async {
    var db = await con.db;
    return await db.insert('category_game', toMap());
  }
}