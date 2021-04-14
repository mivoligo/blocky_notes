import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';

import '../../../../config/failure.dart';
import '../../../../config/paths.dart';
import '../../entities/entities.dart';
import '../../models/models.dart';
import 'base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  AuthRepository({
    FirebaseFirestore? firestore,
    auth.FirebaseAuth? firebaseAuth,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore;

  final auth.FirebaseAuth _firebaseAuth;

  Future<User> _firebaseUserToUser(auth.User user) async {
    try {
      final userDoc =
          await _firestore.collection(Paths.users).doc(user.uid).get();

      if (userDoc.exists) {
        final user = User.fromEntity(UserEntity.fromSnapshot(userDoc));
        return user;
      }
      return User(id: user.uid, email: '');
    } on auth.FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message);
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message);
    }
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
    try {
      final currentUser = await _firebaseAuth.currentUser;
      final authCredential =
          auth.EmailAuthProvider.credential(email: email, password: password);
      final authResult = await currentUser?.linkWithCredential(authCredential);
      final user = await _firebaseUserToUser(authResult!.user!);
      _firestore
          .collection(Paths.users)
          .doc(user.id)
          .set(user.toEntity().toDocument());
      return user;
    } on auth.FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message);
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message);
    }
  }

  @override
  Future<User> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return await _firebaseUserToUser(authResult.user!);
    } on auth.FirebaseAuthException catch (e) {
      throw Failure(code: e.code, message: e.message);
    } on PlatformException catch (e) {
      throw Failure(code: e.code, message: e.message);
    }
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
}
