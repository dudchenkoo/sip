/// Call status enumeration
enum CallStatus {
  idle,
  dialing,
  ringing,
  connecting,
  connected,
  onHold,
  ended,
  failed,
}

/// Call direction
enum CallDirection {
  outgoing,
  incoming,
}

/// Active call model
class ActiveCall {
  final String id;
  final String phoneNumber;
  final String? contactName;
  final String? accountId;
  final String? accountName;
  final CallDirection direction;
  final CallStatus status;
  final DateTime startTime;
  final DateTime? connectedTime;
  final DateTime? endTime;
  final bool isMuted;
  final bool isSpeakerOn;
  final bool isOnHold;
  final String? failureReason;

  const ActiveCall({
    required this.id,
    required this.phoneNumber,
    this.contactName,
    this.accountId,
    this.accountName,
    required this.direction,
    required this.status,
    required this.startTime,
    this.connectedTime,
    this.endTime,
    this.isMuted = false,
    this.isSpeakerOn = false,
    this.isOnHold = false,
    this.failureReason,
  });

  /// Get display name (contact name or phone number)
  String get displayName => contactName ?? phoneNumber;

  /// Get call duration if connected
  Duration? get duration {
    if (connectedTime == null) return null;
    final end = endTime ?? DateTime.now();
    return end.difference(connectedTime!);
  }

  /// Format duration as MM:SS
  String get formattedDuration {
    final d = duration;
    if (d == null) return '00:00';
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Get status text
  String get statusText {
    switch (status) {
      case CallStatus.idle:
        return '';
      case CallStatus.dialing:
        return 'Dialing...';
      case CallStatus.ringing:
        return 'Ringing...';
      case CallStatus.connecting:
        return 'Connecting...';
      case CallStatus.connected:
        return formattedDuration;
      case CallStatus.onHold:
        return 'On Hold';
      case CallStatus.ended:
        return 'Call Ended';
      case CallStatus.failed:
        return failureReason ?? 'Call Failed';
    }
  }

  /// Create a copy with modified fields
  ActiveCall copyWith({
    String? id,
    String? phoneNumber,
    String? contactName,
    String? accountId,
    String? accountName,
    CallDirection? direction,
    CallStatus? status,
    DateTime? startTime,
    DateTime? connectedTime,
    DateTime? endTime,
    bool? isMuted,
    bool? isSpeakerOn,
    bool? isOnHold,
    String? failureReason,
  }) {
    return ActiveCall(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      contactName: contactName ?? this.contactName,
      accountId: accountId ?? this.accountId,
      accountName: accountName ?? this.accountName,
      direction: direction ?? this.direction,
      status: status ?? this.status,
      startTime: startTime ?? this.startTime,
      connectedTime: connectedTime ?? this.connectedTime,
      endTime: endTime ?? this.endTime,
      isMuted: isMuted ?? this.isMuted,
      isSpeakerOn: isSpeakerOn ?? this.isSpeakerOn,
      isOnHold: isOnHold ?? this.isOnHold,
      failureReason: failureReason ?? this.failureReason,
    );
  }
}

