import '../models/models.dart';

import 'base_repository.dart';

abstract class AuthBaseRepository extends BaseRepository {
  Future<User> loginAnonymously();
  Future<User> signupWithEmailAndPassword({String email, String password});
  Future<User> loginWithEmailAndPassword({String email, String password});
  Future<User> logout();
  Future<User> getCurrentUser();
  Future<bool> isAnonymous();
}
