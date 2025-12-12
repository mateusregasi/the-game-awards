
import "../utils/database.dart";
import '../model/user.dart';

class LoginController {
  DatabaseHelper con = DatabaseHelper();
  User? user;

  _getUser(String login, String password) async{
    user = await User.getUserByLogin(con, login, password);
  }

  Future<bool> verifyUser(String login, String password) async{
    await _getUser(login, password);
    return user!.id != -1 ? true : false; 
  }
  
}