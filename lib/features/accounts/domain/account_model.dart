/// Account type enumeration
enum AccountType {
  mmdsmart,
  sip,
}

/// Account model for call center accounts
class Account {
  final String id;
  final String name;
  final AccountType type;
  final String username;
  final String? server;
  final String? displayNumber;
  final bool isDefault;
  final DateTime createdAt;

  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.username,
    this.server,
    this.displayNumber,
    this.isDefault = false,
    required this.createdAt,
  });

  /// Get account type display name
  String get typeLabel {
    switch (type) {
      case AccountType.mmdsmart:
        return 'MMDSmart';
      case AccountType.sip:
        return 'SIP Account';
    }
  }

  /// Get account icon based on type
  String get typeIcon {
    switch (type) {
      case AccountType.mmdsmart:
        return 'mmd';
      case AccountType.sip:
        return 'sip';
    }
  }

  /// Create a copy with modified fields
  Account copyWith({
    String? id,
    String? name,
    AccountType? type,
    String? username,
    String? server,
    String? displayNumber,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      username: username ?? this.username,
      server: server ?? this.server,
      displayNumber: displayNumber ?? this.displayNumber,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'username': username,
      'server': server,
      'displayNumber': displayNumber,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      name: json['name'] as String,
      type: AccountType.values[json['type'] as int],
      username: json['username'] as String,
      server: json['server'] as String?,
      displayNumber: json['displayNumber'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Account && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

