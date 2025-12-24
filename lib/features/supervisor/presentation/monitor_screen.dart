import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Live Monitor'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats overview
            _buildStatsRow(context),
            const SizedBox(height: 24),
            
            // Active calls header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Active Calls',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.sentimentPositive.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_mockActiveCalls.length} Live',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.sentimentPositive,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Active calls list
            ...List.generate(
              _mockActiveCalls.length,
              (index) => _ActiveCallCard(call: _mockActiveCalls[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.headset_mic_rounded,
            label: 'Agents Online',
            value: '12',
            color: AppColors.sentimentPositive,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.call_rounded,
            label: 'Active Calls',
            value: '8',
            color: AppColors.info,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            icon: Icons.warning_rounded,
            label: 'Needs Attention',
            value: '3',
            color: AppColors.sentimentNegative,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ActiveCallCard extends StatelessWidget {
  final _MockActiveCall call;

  const _ActiveCallCard({required this.call});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(
          color: call.sentimentColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          // Header row
          Row(
            children: [
              // Agent avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    call.agentInitials,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Agent & call info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          call.agentName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: call.sentimentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                call.sentimentIcon,
                                size: 14,
                                color: call.sentimentColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                call.sentimentScore,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: call.sentimentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Speaking with ${call.customerName}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Duration
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    call.duration,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Text(
                    'Duration',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Action buttons
          Row(
            children: [
              Expanded(
                child: _SupervisorAction(
                  icon: Icons.hearing_rounded,
                  label: 'Listen',
                  color: AppColors.info,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SupervisorAction(
                  icon: Icons.record_voice_over_rounded,
                  label: 'Whisper',
                  color: AppColors.sentimentNeutral,
                  onTap: () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _SupervisorAction(
                  icon: Icons.group_rounded,
                  label: 'Barge',
                  color: AppColors.sentimentNegative,
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupervisorAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _SupervisorAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MockActiveCall {
  final String agentName;
  final String agentInitials;
  final String customerName;
  final String duration;
  final CallSentiment sentiment;
  final String sentimentScore;

  _MockActiveCall({
    required this.agentName,
    required this.agentInitials,
    required this.customerName,
    required this.duration,
    required this.sentiment,
    required this.sentimentScore,
  });

  IconData get sentimentIcon {
    switch (sentiment) {
      case CallSentiment.positive:
        return Icons.sentiment_satisfied_rounded;
      case CallSentiment.neutral:
        return Icons.sentiment_neutral_rounded;
      case CallSentiment.negative:
        return Icons.sentiment_dissatisfied_rounded;
    }
  }

  Color get sentimentColor {
    switch (sentiment) {
      case CallSentiment.positive:
        return AppColors.sentimentPositive;
      case CallSentiment.neutral:
        return AppColors.sentimentNeutral;
      case CallSentiment.negative:
        return AppColors.sentimentNegative;
    }
  }
}

enum CallSentiment { positive, neutral, negative }

final _mockActiveCalls = [
  _MockActiveCall(
    agentName: 'Jessica Davis',
    agentInitials: 'JD',
    customerName: 'Robert Chen',
    duration: '5:23',
    sentiment: CallSentiment.positive,
    sentimentScore: '92%',
  ),
  _MockActiveCall(
    agentName: 'Michael Brown',
    agentInitials: 'MB',
    customerName: 'Linda Garcia',
    duration: '12:08',
    sentiment: CallSentiment.negative,
    sentimentScore: '34%',
  ),
  _MockActiveCall(
    agentName: 'Sarah Wilson',
    agentInitials: 'SW',
    customerName: 'James Miller',
    duration: '3:45',
    sentiment: CallSentiment.neutral,
    sentimentScore: '65%',
  ),
];


