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


  Future<bool> saveGame(Game game, int categoryId) async {
    int gameId;
    
    if (game.id == null) {
  
      gameId = await game.save(con);
 
      if (gameId > 0 && categoryId > 0) {
        CategoryGame link = CategoryGame(
          categoryId: categoryId, 
          gameId: gameId
        );
        await link.save(con);
      }
      return gameId > 0;
    } else {
    
      int res = await game.update(con);
      return res > 0;
    }
  }

 
  Future<bool> deleteGame(int id) async {
 
    Game game = Game(id: id, userId: 0, name: "", description: "", releaseDate: "");
    int res = await game.delete(con);
    return res > 0;
  }

  // Votar em um jogo
  Future<void> vote(User user, Category category, Game game) async {
   
    await UserVote.deleteByUserCategory(con, user.id!, category.id!);
    
  
    UserVote userVote = UserVote(
      userId: user.id!,
      categoryId: category.id!,
      voteGameId: game.id!
    );
    await userVote.save(con);
  }
 
  
  Future<void> unvote(User user, Category category) async {
    await UserVote.deleteByUserCategory(con, user.id!, category.id!);
  }
}