import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../accounts/data/accounts_provider.dart';
import '../data/call_provider.dart';
import '../domain/call_model.dart';

class ActiveCallScreen extends ConsumerStatefulWidget {
  const ActiveCallScreen({super.key});

  @override
  ConsumerState<ActiveCallScreen> createState() => _ActiveCallScreenState();
}

class _ActiveCallScreenState extends ConsumerState<ActiveCallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(callProvider);
    final call = callState.activeCall;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (call == null) {
      // No active call, close screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });
      return const SizedBox.shrink();
    }

    final isConnecting = call.status == CallStatus.dialing ||
        call.status == CallStatus.ringing ||
        call.status == CallStatus.connecting;

    return Scaffold(
      backgroundColor: isDark ? AppColorsDark.background : AppColors.darkGray,
      body: SafeArea(
        child: Column(
          children: [
            // Top section with call info
            Expanded(
              flex: 3,
              child: _buildCallInfo(context, call, isConnecting, isDark),
            ),

            // Middle section with call actions
            Expanded(
              flex: 2,
              child: _buildCallActions(context, call, isDark),
            ),

            // Bottom section with end call button
            Expanded(
              flex: 2,
              child: _buildEndCallSection(context, call, isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallInfo(
    BuildContext context,
    ActiveCall call,
    bool isConnecting,
    bool isDark,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Avatar with pulse animation when connecting
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: isConnecting ? _pulseAnimation.value : 1.0,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.2),
                  border: Border.all(
                    color: isConnecting
                        ? AppColors.primary.withValues(alpha: 0.5)
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    call.displayName.isNotEmpty
                        ? call.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),

        // Contact name / Phone number
        Text(
          call.displayName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),

        // Phone number (if we have contact name)
        if (call.contactName != null)
          Text(
            call.phoneNumber,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        const SizedBox(height: 16),

        // Call status / duration
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _getStatusColor(call.status).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (call.status == CallStatus.connected ||
                  call.status == CallStatus.onHold)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: call.status == CallStatus.onHold
                        ? AppColors.warning
                        : AppColors.success,
                    shape: BoxShape.circle,
                  ),
                ),
              Text(
                call.statusText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _getStatusColor(call.status),
                ),
              ),
            ],
          ),
        ),

        // Account info
        if (call.accountName != null) ...[
          const SizedBox(height: 12),
          Text(
            'via ${call.accountName}',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCallActions(BuildContext context, ActiveCall call, bool isDark) {
    final callNotifier = ref.read(callProvider.notifier);
    final isConnected = call.status == CallStatus.connected ||
        call.status == CallStatus.onHold;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mute button
          _ActionButton(
            icon: call.isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            label: call.isMuted ? 'Unmute' : 'Mute',
            isActive: call.isMuted,
            isEnabled: isConnected,
            onTap: isConnected ? callNotifier.toggleMute : null,
          ),

          // Keypad button
          _ActionButton(
            icon: Icons.dialpad_rounded,
            label: 'Keypad',
            isEnabled: isConnected,
            onTap: isConnected ? () => _showKeypad(context) : null,
          ),

          // Speaker button
          _ActionButton(
            icon: call.isSpeakerOn
                ? Icons.volume_up_rounded
                : Icons.volume_down_rounded,
            label: 'Speaker',
            isActive: call.isSpeakerOn,
            isEnabled: isConnected,
            onTap: isConnected ? callNotifier.toggleSpeaker : null,
          ),
        ],
      ),
    );
  }

  Widget _buildEndCallSection(
    BuildContext context,
    ActiveCall call,
    bool isDark,
  ) {
    final callNotifier = ref.read(callProvider.notifier);
    final isConnected = call.status == CallStatus.connected ||
        call.status == CallStatus.onHold;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Hold button (only when connected)
        if (isConnected) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ActionButton(
                icon: call.isOnHold
                    ? Icons.play_arrow_rounded
                    : Icons.pause_rounded,
                label: call.isOnHold ? 'Resume' : 'Hold',
                isActive: call.isOnHold,
                onTap: callNotifier.toggleHold,
              ),
              const SizedBox(width: 48),
              _ActionButton(
                icon: Icons.add_call,
                label: 'Add Call',
                onTap: () {
                  // TODO: Implement add call
                },
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],

        // End call button
        GestureDetector(
          onTap: () {
            HapticFeedback.heavyImpact();
            callNotifier.endCall();
          },
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.error,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.call_end_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'End Call',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(CallStatus status) {
    switch (status) {
      case CallStatus.connected:
        return AppColors.success;
      case CallStatus.onHold:
        return AppColors.warning;
      case CallStatus.dialing:
      case CallStatus.ringing:
      case CallStatus.connecting:
        return AppColors.primary;
      case CallStatus.ended:
        return Colors.white70;
      case CallStatus.failed:
        return AppColors.error;
      default:
        return Colors.white;
    }
  }

  void _showKeypad(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _InCallKeypad(),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isEnabled;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.isEnabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: isEnabled ? 1.0 : 0.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isActive ? AppColors.darkGray : Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? Colors.white : Colors.white70,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InCallKeypad extends StatelessWidget {
  const _InCallKeypad();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkGray,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            // Keypad grid
            ...['123', '456', '789', '*0#'].map((row) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: row.split('').map((digit) {
                    return _KeypadButton(
                      digit: digit,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        // TODO: Send DTMF tone
                      },
                    );
                  }).toList(),
                ),
              );
            }),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Hide Keypad',
                style: TextStyle(color: AppColors.primary, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String digit;
  final VoidCallback onTap;

  const _KeypadButton({required this.digit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

