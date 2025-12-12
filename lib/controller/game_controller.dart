import 'package:thegameawards/model/category.dart';
import 'package:thegameawards/model/game.dart';
import 'package:thegameawards/model/user.dart';
import 'package:thegameawards/model/user_vote.dart';
import 'package:thegameawards/utils/database.dart';

class GameController{
  DatabaseHelper con = DatabaseHelper();

  Future<List<Game>> getAllByCategoryId(int id) async{
    return await Game.getAllByCategoryId(con, id);
  }

  Future<List<Game>> getAllGames(){
    return Game.getAll(con);
  }

  Future<void> vote(User user, Category category, Game game) async{
    UserVote user_vote = UserVote.fromMap({
      "user_id": user.id,
      "category_id": category.id,
      "vote_game_id": game.id
    });
  }
 
  Future<void> unvote(User user, Category category) async{
    await UserVote.deleteByUserCategory(con, user.id!, category.id!);
  }
}