import 'package:flutter/material.dart';

/// Contact model for the app
class Contact {
  final String id;
  final String name;
  final String phoneNumber;
  final String? email;
  final String? company;
  final String? label; // Work, Mobile, Home, etc.
  final String? notes;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Contact({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.email,
    this.company,
    this.label,
    this.notes,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Get initials from name
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name.substring(0, name.length.clamp(0, 2)).toUpperCase() : '?';
  }

  /// Get avatar color based on name hash
  Color get avatarColor {
    final colors = [
      const Color(0xFFFF6B35), // Orange
      const Color(0xFF2196F3), // Blue
      const Color(0xFF00C853), // Green
      const Color(0xFFFFB300), // Amber
      const Color(0xFFE91E63), // Pink
      const Color(0xFF9C27B0), // Purple
      const Color(0xFF00BCD4), // Cyan
      const Color(0xFF795548), // Brown
    ];
    return colors[name.hashCode.abs() % colors.length];
  }

  /// Create a copy with modified fields
  Contact copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? email,
    String? company,
    String? label,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Contact(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      company: company ?? this.company,
      label: label ?? this.label,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'company': company,
      'label': label,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Create from JSON map
  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      email: json['email'] as String?,
      company: json['company'] as String?,
      label: json['label'] as String?,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Create from CSV row (expects: name, phone, email, company, label)
  factory Contact.fromCsvRow(List<dynamic> row, String id) {
    return Contact(
      id: id,
      name: row.isNotEmpty ? row[0].toString().trim() : '',
      phoneNumber: row.length > 1 ? row[1].toString().trim() : '',
      email: row.length > 2 && row[2].toString().trim().isNotEmpty 
          ? row[2].toString().trim() 
          : null,
      company: row.length > 3 && row[3].toString().trim().isNotEmpty 
          ? row[3].toString().trim() 
          : null,
      label: row.length > 4 && row[4].toString().trim().isNotEmpty 
          ? row[4].toString().trim() 
          : null,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Contact && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

