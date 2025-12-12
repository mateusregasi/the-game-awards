import 'package:thegameawards/model/category.dart';
import 'package:thegameawards/model/game.dart';
import 'package:thegameawards/utils/database.dart';

class CategoryController{
  DatabaseHelper con = DatabaseHelper();

  Future<List<Category>> getCategories() async{
    return await Category.getAll(con);
  }

  Future<int> getCategoryLength(Category category) async{
    return (await Game.getAllByCategoryId(con, category.id!)).length;
  }

}