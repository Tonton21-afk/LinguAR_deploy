import 'package:lingua_arv1/model/Authentication.dart';

abstract class LoginRepository {
  Future<Authentication> login(String email, String password);
}
