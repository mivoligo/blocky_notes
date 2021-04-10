import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

import '../config/paths.dart';
import '../entities/entities.dart';
import '../models/models.dart';
import 'auth_base_repository.dart';

class AuthRepository extends AuthBaseRepository {
  AuthRepository({
    FirebaseFirestore? firestore,
    auth.FirebaseAuth? firebaseAuth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore;

  final auth.FirebaseAuth _firebaseAuth;

  Future<User> _firebaseUserToUser(auth.User user) async {
    final userDoc =
        await _firestore.collection(Paths.users).doc(user.uid).get();

    if (userDoc.exists) {
      final user = User.fromEntity(UserEntity.fromSnapshot(userDoc));
      return user;
    }
    return User(id: user.uid, email: '');
  }

  @override
  Future<User> loginAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return await _firebaseUserToUser(authResult.user!);
  }

  @override
  Future<User> signupWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final currentUser = await _firebaseAuth.currentUser;
    final authCredential =
        auth.EmailAuthProvider.credential(email: email, password: password);
    final authResult = await currentUser?.linkWithCredential(authCredential);
    final user = await _firebaseUserToUser(authResult!.user!);
    _firestore
        .collection(Paths.users)
        .doc(authResult.user?.uid)
        .set(user.toEntity().toDocument());
    return user;
  }

  @override
  Future<User> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return await _firebaseUserToUser(authResult.user!);
  }

  @override
  Future<User> logout() async {
    await _firebaseAuth.signOut();
    return await loginAnonymously();
  }

  @override
  Future<User?> getCurrentUser() async {
    final currentUser = await _firebaseAuth.currentUser;
    if (currentUser == null) return null;
    return await _firebaseUserToUser(currentUser);
  }

  @override
  Future<bool> isAnonymous() async {
    final currentUser = await _firebaseAuth.currentUser;
    return currentUser?.isAnonymous ?? true;
  }

  @override
  void dispose() {}
}
