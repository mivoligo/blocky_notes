import 'package:equatable/equatable.dart';

import '../entities/user_entity.dart';

class User extends Equatable {
  final String id;
  final String email;

  const User({
    required this.id,
    required this.email,
  });

  @override
  List<Object?> get props => [id, email];

  UserEntity toEntity() => UserEntity(id: id, email: email);

  factory User.fromEntity(UserEntity entity) =>
      User(id: entity.id!, email: entity.email);
}
