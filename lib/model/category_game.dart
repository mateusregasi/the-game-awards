import 'dart:convert';

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
}