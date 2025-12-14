import 'package:thegameawards/model/category.dart';
import 'package:thegameawards/model/category_game.dart';
import 'package:thegameawards/model/game.dart';
import 'package:thegameawards/model/user.dart';
import 'package:thegameawards/model/user_vote.dart';
import 'package:thegameawards/utils/database.dart';

class GameController {
  DatabaseHelper con = DatabaseHelper();

  Future<List<Category>> getAllCategories() async {
    return await Category.getAll(con);
  }

  Future<List<Game>> getAllByCategoryId(int id) async {
    return await Game.getAllByCategoryId(con, id);
  }

  Future<List<Game>> getAllGames() async {
    return await Game.getAll(con);
  }

  // --- Função Crítica para os Votos ---
  Future<int> getVoteCount(int gameId) async {
    var db = await con.db;
    var res = await db.rawQuery("SELECT COUNT(*) as count FROM user_vote WHERE vote_game_id = ?", [gameId]);
    
    if (res.isNotEmpty) {
      return res.first['count'] as int;
    }
    return 0;
  }

  Future<int?> getGameCategoryId(int gameId) async {
    var db = await con.db;
    var res = await db.query("category_game", columns: ["category_id"], where: "game_id = ?", whereArgs: [gameId]);
    if (res.isNotEmpty) return res.first["category_id"] as int;
    return null;
  }

  Future<bool> saveGame(Game game, int categoryId) async {
    int gameId;
    var db = await con.db;

    if (game.id == null) {
      gameId = await game.save(con);
      if (gameId > 0 && categoryId > 0) {
        CategoryGame link = CategoryGame(categoryId: categoryId, gameId: gameId);
        await link.save(con);
      }
      return gameId > 0;
    } else {
      int res = await game.update(con);
      if (categoryId > 0) {
        var check = await db.query("category_game", where: "game_id = ?", whereArgs: [game.id]);
        if (check.isNotEmpty) {
          await db.update("category_game", {"category_id": categoryId}, where: "game_id = ?", whereArgs: [game.id]);
        } else {
          await db.insert("category_game", {"category_id": categoryId, "game_id": game.id});
        }
      }
      return res > 0;
    }
  }

  Future<bool> deleteGame(int id) async {
    Game game = Game(id: id, userId: 0, name: "", description: "", releaseDate: "");
    int res = await game.delete(con);
    return res > 0;
  }

  Future<void> vote(User user, Category category, Game game) async {
    await UserVote.deleteByUserCategory(con, user.id!, category.id!);
    UserVote userVote = UserVote(userId: user.id!, categoryId: category.id!, voteGameId: game.id!);
    await userVote.save(con);
  }
}