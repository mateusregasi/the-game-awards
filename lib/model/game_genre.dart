import 'dart:convert';

class GameGenre {

  final int genreId;
  final int userId;

  GameGenre({
    required this.genreId,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      "genre_id": genreId,
      "user_id": userId,
    };
  }

  factory GameGenre.fromMap(Map<String, dynamic> map) {
    return GameGenre(
      genreId: map["genre_id"] as int,
      userId: map["user_id"] as int,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory GameGenre.fromJson(String source) => GameGenre.fromMap(jsonDecode(source) as Map<String, dynamic>);
}