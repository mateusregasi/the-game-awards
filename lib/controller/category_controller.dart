import 'package:thegameawards/model/category.dart';
import 'package:thegameawards/utils/database.dart';

class CategoryController {
  DatabaseHelper con = DatabaseHelper();

  Future<List<Category>> getCategories() async {
    return await Category.getAll(con);
  }

  Future<bool> saveCategory(Category category) async {
    int res;
    if (category.id == null) {
      
      res = await category.save(con);
    } else {
      
      res = await category.update(con); 
    }
    return res > 0;
  }

  // Excluir Categoria
  Future<bool> deleteCategory(int id) async {
    Category t = Category(id: id, userId: 0, title: "", description: "", date: "");
    int res = await t.delete(con);
    return res > 0;
  }
}