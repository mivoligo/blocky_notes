import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../entities/entities.dart';

class Note extends Equatable {
  final String? id;
  final String userId;
  final String content;
  final Color color;
  final DateTime timestamp;

  const Note({
    this.id,
    required this.userId,
    required this.content,
    required this.color,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, userId, content, color, timestamp];

  NoteEntity toEntity() {
    return NoteEntity(
      userId: userId,
      content: content,
      color: '${color.value.toRadixString(16)}',
      timestamp: Timestamp.fromDate(timestamp),
    );
  }

  factory Note.fromEntity(NoteEntity entity) {
    return Note(
      userId: entity.userId,
      content: entity.content,
      color: HexColor(entity.color),
      timestamp: entity.timestamp.toDate(),
    );
  }

  Note copyWith({
    String? id,
    String? userId,
    String? content,
    Color? color,
    DateTime? timestamp,
  }) {
    return Note(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      color: color ?? this.color,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
