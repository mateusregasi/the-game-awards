import 'package:thegameawards/model/user.dart';
import 'package:thegameawards/utils/database.dart';

class RegisterController {
  DatabaseHelper con = DatabaseHelper();
  User? user;

  bool register(String name, String email, String password, int role){
    user = User.fromMap({
      "name": name,
      "password": password,
      "email": email,
      "role": role,
    });

    user!.save(con);
    return true;
  }

}