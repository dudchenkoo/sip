import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/call_model.dart';

/// Call state for the provider
class CallState {
  final ActiveCall? activeCall;
  final bool hasActiveCall;

  const CallState({
    this.activeCall,
  }) : hasActiveCall = activeCall != null;

  CallState copyWith({
    ActiveCall? activeCall,
    bool clearCall = false,
  }) {
    return CallState(
      activeCall: clearCall ? null : (activeCall ?? this.activeCall),
    );
  }
}

/// Call notifier for managing call state
class CallNotifier extends StateNotifier<CallState> {
  CallNotifier() : super(const CallState());

  Timer? _durationTimer;
  Timer? _dialingTimer;

  /// Start an outgoing call
  Future<void> startCall({
    required String phoneNumber,
    String? contactName,
    String? accountId,
    String? accountName,
  }) async {
    // Create new call
    final call = ActiveCall(
      id: const Uuid().v4(),
      phoneNumber: phoneNumber,
      contactName: contactName,
      accountId: accountId,
      accountName: accountName,
      direction: CallDirection.outgoing,
      status: CallStatus.dialing,
      startTime: DateTime.now(),
    );

    state = state.copyWith(activeCall: call);

    // Simulate dialing -> ringing -> connected flow
    _simulateCallFlow();
  }

  /// Simulate call connection (for demo purposes)
  void _simulateCallFlow() {
    // After 1.5s, change to ringing
    _dialingTimer = Timer(const Duration(milliseconds: 1500), () {
      if (state.activeCall?.status == CallStatus.dialing) {
        state = state.copyWith(
          activeCall: state.activeCall?.copyWith(status: CallStatus.ringing),
        );

        // After 2s more, connect the call
        _dialingTimer = Timer(const Duration(milliseconds: 2000), () {
          if (state.activeCall?.status == CallStatus.ringing) {
            _connectCall();
          }
        });
      }
    });
  }

  /// Connect the call and start duration timer
  void _connectCall() {
    state = state.copyWith(
      activeCall: state.activeCall?.copyWith(
        status: CallStatus.connected,
        connectedTime: DateTime.now(),
      ),
    );

    // Start duration timer to update UI every second
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.activeCall?.status == CallStatus.connected ||
          state.activeCall?.status == CallStatus.onHold) {
        // Force state update to refresh duration
        state = state.copyWith(
          activeCall: state.activeCall?.copyWith(),
        );
      }
    });
  }

  /// End the current call
  void endCall() {
    _dialingTimer?.cancel();
    _durationTimer?.cancel();

    if (state.activeCall != null) {
      state = state.copyWith(
        activeCall: state.activeCall?.copyWith(
          status: CallStatus.ended,
          endTime: DateTime.now(),
        ),
      );

      // Clear call after a short delay (check if still mounted)
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          state = state.copyWith(clearCall: true);
        }
      });
    }
  }

  /// Toggle mute
  void toggleMute() {
    if (state.activeCall != null) {
      state = state.copyWith(
        activeCall: state.activeCall?.copyWith(
          isMuted: !state.activeCall!.isMuted,
        ),
      );
    }
  }

  /// Toggle speaker
  void toggleSpeaker() {
    if (state.activeCall != null) {
      state = state.copyWith(
        activeCall: state.activeCall?.copyWith(
          isSpeakerOn: !state.activeCall!.isSpeakerOn,
        ),
      );
    }
  }

  /// Toggle hold
  void toggleHold() {
    if (state.activeCall != null) {
      final newStatus = state.activeCall!.isOnHold
          ? CallStatus.connected
          : CallStatus.onHold;
      state = state.copyWith(
        activeCall: state.activeCall?.copyWith(
          isOnHold: !state.activeCall!.isOnHold,
          status: newStatus,
        ),
      );
    }
  }

  @override
  void dispose() {
    _dialingTimer?.cancel();
    _durationTimer?.cancel();
    super.dispose();
  }
}

/// Provider for call state
final callProvider = StateNotifierProvider<CallNotifier, CallState>((ref) {
  return CallNotifier();
});

