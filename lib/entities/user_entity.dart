import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({this.id, required this.email});

  final String? id;
  final String email;

  @override
  List<Object?> get props => [id, email];

  Map<String, dynamic> toDocument() {
    return {
      'email': email,
    };
  }

  factory UserEntity.fromSnapshot(DocumentSnapshot doc) {
    return UserEntity(
      id: doc.id,
      email: doc.data()?['email'] ?? '',
    );
  }
}
