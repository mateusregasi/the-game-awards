
import "../utils/database.dart";
import '../model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController {
  DatabaseHelper con = DatabaseHelper();
  User? user;

  Future<void> _getUser(String name, String password) async{
    user = await User.getUserByLogin(con, name, password);
  }

  int getRole(){
    return user!.role;
  }

  Future<bool> verifyUser(String name, String password) async{
    await _getUser(name, password);
    return user!.id != -1 ? true : false; 
  }
  
  saveSession() async{
    final SharedPreferences inst = await SharedPreferences.getInstance();
    await inst.setInt("user_id", user!.id!);
  }

  static logout() async{
    final SharedPreferences inst = await SharedPreferences.getInstance();
    await inst.remove("user_id");
  }

  Future<bool> loadSession() async{
    final SharedPreferences inst = await SharedPreferences.getInstance();
    int? id = await inst.getInt("user_id");
    if(id != null){
      user = await User.getUserById(con, id);
      return (user!.id! != -1) ? true : false; 
    }
    return false;
  }
}