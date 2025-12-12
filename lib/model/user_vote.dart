import 'dart:convert';

class UserVote {

  final int? id;
  final int userId;
  final int categoryId;
  final int voteGameId;

  UserVote({
    this.id, 
    required this.userId, 
    required this.categoryId, 
    required this.voteGameId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      "id": id,
      "user_id": userId,
      "category_id": categoryId,
      "vote_game_id": voteGameId,
    };
  }

  factory UserVote.fromMap(Map<String, dynamic> map) {
    return UserVote(
      id: map["id"] ??= map["id"],
      userId: map["user_id"] as int,
      categoryId: map["category_id"] as int,
      voteGameId: map["vote_game_id"] as int
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UserVote.fromJson(String source) => UserVote.fromMap(jsonDecode(source) as Map<String, dynamic>);
}