import 'package:thegameawards/model/user.dart';
import 'package:thegameawards/utils/database.dart';

class RegisterController {
  DatabaseHelper con = DatabaseHelper();
  User? user;

  Future<bool> register(String name, String email, String password, int role) async {
    user = User(
      name: name,
      password: password,
      email: email,
      role: role,
    );
    int result = await user!.save(con);

    return result > 0;
  }
}
