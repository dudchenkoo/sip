import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../calling/data/call_provider.dart';

class CallsScreen extends ConsumerStatefulWidget {
  const CallsScreen({super.key});

  @override
  ConsumerState<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends ConsumerState<CallsScreen> {
  int? _expandedIndex;

  void _onCallBack(String phoneNumber) {
    // Start the call - CallWrapper will automatically show the call screen
    ref.read(callProvider.notifier).startCall(phoneNumber: phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Recent Calls'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.filter_list_rounded, size: 22),
                onPressed: () {},
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isDark ? AppColorsDark.primary : AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _LowBalanceWarning(balance: 12.50, onTopUp: () {}, isDark: isDark),
          const SizedBox(height: 16),
          _SectionHeader(title: 'TODAY', isDark: isDark),
          const SizedBox(height: 8),
          ...List.generate(_mockCalls.length, (index) {
            final call = _mockCalls[index];
            final isExpanded = _expandedIndex == index;

            if (call.sectionHeader != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  _SectionHeader(title: call.sectionHeader!, isDark: isDark),
                  const SizedBox(height: 8),
                ],
              );
            }

            return _CallCard(
              call: call,
              isExpanded: isExpanded,
              onToggleExpand: () => setState(() => _expandedIndex = isExpanded ? null : index),
              onCallBack: () => _onCallBack(call.phoneNumber),
              onArchive: () {},
              isDark: isDark,
            );
          }),
        ],
      ),
    );
  }
}

class _LowBalanceWarning extends StatelessWidget {
  final double balance;
  final VoidCallback onTopUp;
  final bool isDark;

  const _LowBalanceWarning({required this.balance, required this.onTopUp, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.sentimentNeutral.withValues(alpha: isDark ? 0.2 : 0.15),
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusSm - 1)),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_rounded, size: 14, color: AppColors.sentimentNeutral),
                const SizedBox(width: 6),
                Text(
                  'LOW BALANCE WARNING',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.sentimentNeutral,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Balance',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$${balance.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: onTopUp,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Top Up'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColorsDark.textTertiary : AppColors.textTertiary,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _CallCard extends StatelessWidget {
  final _MockCall call;
  final bool isExpanded;
  final VoidCallback onToggleExpand;
  final VoidCallback onCallBack;
  final VoidCallback onArchive;
  final bool isDark;

  const _CallCard({
    required this.call,
    required this.isExpanded,
    required this.onToggleExpand,
    required this.onCallBack,
    required this.onArchive,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(call.phoneNumber + call.time),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.archive_rounded, color: Colors.white, size: 20),
            const SizedBox(height: 2),
            const Text('ARCHIVE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      confirmDismiss: (direction) async {
        onArchive();
        return false;
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isDark ? AppColorsDark.surface : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: call.status == CallHistoryStatus.unsuccessful
                ? AppColors.error.withValues(alpha: 0.4)
                : (isDark ? AppColorsDark.border : AppColors.border),
            width: call.status == CallHistoryStatus.unsuccessful ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            InkWell(
              onTap: onToggleExpand,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  call.phoneNumber,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              _StatusBadge(status: call.status, isDark: isDark),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.access_time_rounded, size: 12, color: isDark ? AppColorsDark.textTertiary : AppColors.textTertiary),
                              const SizedBox(width: 4),
                              Text(call.time, style: TextStyle(fontSize: 11, color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary)),
                              const Spacer(),
                              Icon(isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: isDark ? AppColorsDark.textTertiary : AppColors.textTertiary, size: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded) ...[
              Divider(height: 1, color: isDark ? AppColorsDark.divider : AppColors.divider),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _DetailItem(label: 'Disconnect Reason', value: call.disconnectReason ?? '-', isDark: isDark)),
                        Expanded(child: _DetailItem(label: 'Hangup Initiator', value: call.hangupInitiator ?? '-', isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(child: _DetailItem(label: 'Duration', value: call.duration, isDark: isDark)),
                        Expanded(child: _DetailItem(label: 'Campaign', value: call.campaign ?? '-', isDark: isDark)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: onCallBack,
                        icon: Icon(Icons.call_rounded, size: 16, color: isDark ? AppColorsDark.primary : AppColors.primary),
                        label: const Text('Call Back'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final CallHistoryStatus status;
  final bool isDark;

  const _StatusBadge({required this.status, required this.isDark});

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;
    String label;

    switch (status) {
      case CallHistoryStatus.unsuccessful:
        bgColor = AppColors.error.withValues(alpha: isDark ? 0.2 : 0.1);
        textColor = AppColors.error;
        label = 'Unsuccessful';
        break;
      case CallHistoryStatus.connected:
        bgColor = AppColors.sentimentPositive.withValues(alpha: isDark ? 0.2 : 0.1);
        textColor = AppColors.sentimentPositive;
        label = 'Connected';
        break;
      case CallHistoryStatus.noAnswer:
        bgColor = isDark ? AppColorsDark.gray700 : AppColors.gray200;
        textColor = isDark ? AppColorsDark.gray400 : AppColors.gray600;
        label = 'No Answer';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: textColor)),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _DetailItem({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, color: isDark ? AppColorsDark.textTertiary : AppColors.textTertiary, fontStyle: FontStyle.italic)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary)),
      ],
    );
  }
}

/// Call history status (distinct from active call status)
enum CallHistoryStatus { unsuccessful, connected, noAnswer }

class _MockCall {
  final String phoneNumber;
  final String time;
  final CallHistoryStatus status;
  final String duration;
  final String? disconnectReason;
  final String? hangupInitiator;
  final String? campaign;
  final String? sectionHeader;

  _MockCall({required this.phoneNumber, required this.time, required this.status, required this.duration, this.disconnectReason, this.hangupInitiator, this.campaign, this.sectionHeader});
}

final _mockCalls = [
  _MockCall(phoneNumber: '+1 (555) 123-4567', time: '10:42 AM', status: CallHistoryStatus.unsuccessful, duration: '00:00', disconnectReason: 'Busy Signal', hangupInitiator: 'System', campaign: 'Q4 Sales'),
  _MockCall(phoneNumber: '+1 (555) 555-0192', time: '1:15 PM', status: CallHistoryStatus.connected, duration: '05:23', disconnectReason: 'Normal', hangupInitiator: 'Customer', campaign: 'Support'),
  _MockCall(phoneNumber: '+1 (415) 555-0021', time: 'Yesterday, 2:30 PM', status: CallHistoryStatus.noAnswer, duration: '00:00', disconnectReason: 'No Answer', hangupInitiator: 'System', campaign: 'Q4 Sales', sectionHeader: 'YESTERDAY'),
  _MockCall(phoneNumber: '+1 (702) 555-8291', time: 'Yesterday, 1:15 PM', status: CallHistoryStatus.unsuccessful, duration: '00:12', disconnectReason: 'Call Rejected', hangupInitiator: 'Customer', campaign: 'Retention'),
  _MockCall(phoneNumber: '+1 (212) 555-3847', time: 'Yesterday, 11:00 AM', status: CallHistoryStatus.connected, duration: '12:45', disconnectReason: 'Normal', hangupInitiator: 'Agent', campaign: 'Q4 Sales'),
];
