import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../accounts/data/accounts_provider.dart';
import '../../accounts/presentation/compact_account_selector.dart';
import '../../calling/data/call_provider.dart';

class DialerScreen extends ConsumerStatefulWidget {
  const DialerScreen({super.key});

  @override
  ConsumerState<DialerScreen> createState() => _DialerScreenState();
}

class _DialerScreenState extends ConsumerState<DialerScreen> {
  String _phoneNumber = '';

  void _onDigitPressed(String digit) {
    HapticFeedback.lightImpact();
    setState(() => _phoneNumber += digit);
  }

  void _onBackspacePressed() {
    if (_phoneNumber.isNotEmpty) {
      HapticFeedback.selectionClick();
      setState(() => _phoneNumber = _phoneNumber.substring(0, _phoneNumber.length - 1));
    }
  }

  void _onBackspaceLongPress() {
    if (_phoneNumber.isNotEmpty) {
      HapticFeedback.heavyImpact();
      setState(() => _phoneNumber = '');
    }
  }

  void _onCallPressed() {
    if (_phoneNumber.isEmpty) return;
    HapticFeedback.mediumImpact();
    
    // Get selected account
    final accountsState = ref.read(accountsProvider);
    final selectedAccount = accountsState.selectedAccount;
    
    // Start the call - CallWrapper will automatically show the call screen
    ref.read(callProvider.notifier).startCall(
      phoneNumber: _phoneNumber,
      accountId: selectedAccount?.id,
      accountName: selectedAccount?.name,
    );
    
    // Clear the dialed number
    setState(() => _phoneNumber = '');
  }

  String _formatPhoneNumber(String number) {
    if (number.length <= 3) return number;
    if (number.length <= 6) return '(${number.substring(0, 3)}) ${number.substring(3)}';
    if (number.length <= 10) return '(${number.substring(0, 3)}) ${number.substring(3, 6)}-${number.substring(6)}';
    return '+${number.substring(0, number.length - 10)} (${number.substring(number.length - 10, number.length - 7)}) ${number.substring(number.length - 7, number.length - 4)}-${number.substring(number.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Button size: responsive but with good defaults
    final buttonSize = ((screenWidth - 64) / 3).clamp(72.0, 92.0);

    return Scaffold(
      backgroundColor: isDark ? AppColorsDark.background : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColorsDark.background : AppColors.background,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            Text(
              'Dialer',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
              ),
            ),
          ],
        ),
        actions: [
          // Compact Account Selector
          const CompactAccountSelector(),
          const SizedBox(width: 8),
          
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.sentimentPositive.withValues(alpha: isDark ? 0.2 : 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.sentimentPositive,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                const Text(
                  'Available',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.sentimentPositive,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Phone number display - takes available space at top
            Expanded(
              flex: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        child: Text(
                          _phoneNumber.isEmpty ? 'Enter number' : _formatPhoneNumber(_phoneNumber),
                          key: ValueKey(_phoneNumber),
                          style: TextStyle(
                            fontSize: _phoneNumber.isEmpty ? 26 : (_phoneNumber.length > 10 ? 28 : 36),
                            fontWeight: FontWeight.w500,
                            color: _phoneNumber.isEmpty
                                ? (isDark ? AppColorsDark.textTertiary : AppColors.gray400)
                                : (isDark ? AppColorsDark.textPrimary : AppColors.textPrimary),
                            letterSpacing: _phoneNumber.isEmpty ? 0 : 1.5,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: _phoneNumber.isNotEmpty ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            'Mobile',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Dialpad grid - fixed height based on button size
            SizedBox(
              height: (buttonSize * 4) + (20 * 3), // 4 rows + 3 gaps
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _DialpadRow(digits: ['1', '2', '3'], buttonSize: buttonSize, onDigit: _onDigitPressed, isDark: isDark),
                    _DialpadRow(digits: ['4', '5', '6'], buttonSize: buttonSize, onDigit: _onDigitPressed, isDark: isDark),
                    _DialpadRow(digits: ['7', '8', '9'], buttonSize: buttonSize, onDigit: _onDigitPressed, isDark: isDark),
                    _DialpadRow(digits: ['*', '0', '#'], buttonSize: buttonSize, onDigit: _onDigitPressed, isDark: isDark),
                  ],
                ),
              ),
            ),

            // Action buttons
            Expanded(
              flex: 2,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Spacer (same width as delete button for balance)
                    const SizedBox(width: 80),
                    
                    // Call button - prominent center
                    _CallButton(
                      isEnabled: _phoneNumber.isNotEmpty,
                      onPressed: _phoneNumber.isNotEmpty ? _onCallPressed : null,
                    ),
                    
                    // Delete button
                    SizedBox(
                      width: 80,
                      child: Center(
                        child: _DeleteButton(
                          isEnabled: _phoneNumber.isNotEmpty,
                          onTap: _phoneNumber.isNotEmpty ? _onBackspacePressed : null,
                          onLongPress: _phoneNumber.isNotEmpty ? _onBackspaceLongPress : null,
                          isDark: isDark,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialpadRow extends StatelessWidget {
  final List<String> digits;
  final double buttonSize;
  final Function(String) onDigit;
  final bool isDark;

  const _DialpadRow({
    required this.digits,
    required this.buttonSize,
    required this.onDigit,
    required this.isDark,
  });

  static const Map<String, String> _subLabels = {
    '1': '',
    '2': 'ABC',
    '3': 'DEF',
    '4': 'GHI',
    '5': 'JKL',
    '6': 'MNO',
    '7': 'PQRS',
    '8': 'TUV',
    '9': 'WXYZ',
    '*': '',
    '0': '+',
    '#': '',
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits.map((digit) {
        return _DialpadButton(
          digit: digit,
          subLabel: _subLabels[digit] ?? '',
          size: buttonSize,
          onTap: () => onDigit(digit),
          isDark: isDark,
        );
      }).toList(),
    );
  }
}

class _DialpadButton extends StatefulWidget {
  final String digit;
  final String subLabel;
  final double size;
  final VoidCallback onTap;
  final bool isDark;

  const _DialpadButton({
    required this.digit,
    required this.subLabel,
    required this.size,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<_DialpadButton> createState() => _DialpadButtonState();
}

class _DialpadButtonState extends State<_DialpadButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = _isPressed
        ? (widget.isDark ? AppColorsDark.gray700 : AppColors.gray200)
        : (widget.isDark ? AppColorsDark.surface : AppColors.white);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: (widget.isDark ? Colors.black : AppColors.darkGray)
                        .withValues(alpha: widget.isDark ? 0.5 : 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.digit,
              style: TextStyle(
                fontSize: widget.size * 0.4, // 40% of button size
                fontWeight: FontWeight.w400,
                color: widget.isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                height: 1.1,
              ),
            ),
            if (widget.subLabel.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  widget.subLabel,
                  style: TextStyle(
                    fontSize: widget.size * 0.12, // 12% of button size
                    fontWeight: FontWeight.w600,
                    color: widget.isDark ? AppColorsDark.textTertiary : AppColors.textTertiary,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CallButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;

  const _CallButton({
    required this.isEnabled,
    this.onPressed,
  });

  @override
  State<_CallButton> createState() => _CallButtonState();
}

class _CallButtonState extends State<_CallButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.sentimentPositive;
    final effectiveColor = widget.isEnabled ? color : AppColors.gray400;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: effectiveColor,
            shape: BoxShape.circle,
            boxShadow: widget.isEnabled
                ? [
                    BoxShadow(
                      color: effectiveColor.withValues(alpha: 0.5),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: const Icon(
            Icons.call_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatefulWidget {
  final bool isEnabled;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isDark;

  const _DeleteButton({
    required this.isEnabled,
    this.onTap,
    this.onLongPress,
    required this.isDark,
  });

  @override
  State<_DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<_DeleteButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.isDark ? AppColorsDark.textSecondary : AppColors.textSecondary;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      onLongPress: widget.onLongPress,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: widget.isEnabled ? 1.0 : 0.25,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: _isPressed
                ? (widget.isDark ? AppColorsDark.gray700 : AppColors.gray200)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.backspace_outlined,
            size: 28,
            color: color,
          ),
        ),
      ),
    );
  }
}
