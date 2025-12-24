import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance card
            _buildBalanceCard(context),
            const SizedBox(height: 24),
            
            // Quick top-up options
            Text(
              'Quick Top Up',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildTopUpOptions(),
            const SizedBox(height: 24),
            
            // Usage stats
            Text(
              'This Month',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _buildUsageStats(context),
            const SizedBox(height: 24),
            
            // Recent transactions
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            ...List.generate(
              _mockTransactions.length,
              (index) => _TransactionItem(transaction: _mockTransactions[index]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Balance',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                '2,547',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '.50',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _BalanceAction(
                icon: Icons.add_rounded,
                label: 'Top Up',
                onTap: () {},
              ),
              const SizedBox(width: 16),
              _BalanceAction(
                icon: Icons.send_rounded,
                label: 'Transfer',
                onTap: () {},
              ),
              const SizedBox(width: 16),
              _BalanceAction(
                icon: Icons.receipt_long_rounded,
                label: 'Invoice',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopUpOptions() {
    final amounts = ['\$10', '\$25', '\$50', '\$100'];
    
    return Row(
      children: amounts.map((amount) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: amount != amounts.last ? 12 : 0,
            ),
            child: _TopUpOption(amount: amount),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUsageStats(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _UsageStatRow(
            icon: Icons.call_made_rounded,
            label: 'Outbound Calls',
            value: '1,247 mins',
            amount: '-\$186.90',
          ),
          const Divider(height: 24),
          _UsageStatRow(
            icon: Icons.call_received_rounded,
            label: 'Inbound Calls',
            value: '892 mins',
            amount: '-\$89.20',
          ),
          const Divider(height: 24),
          _UsageStatRow(
            icon: Icons.sms_rounded,
            label: 'SMS Sent',
            value: '156 messages',
            amount: '-\$15.60',
          ),
        ],
      ),
    );
  }
}

class _BalanceAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BalanceAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopUpOption extends StatelessWidget {
  final String amount;

  const _TopUpOption({required this.amount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Center(
          child: Text(
            amount,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _UsageStatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String amount;

  const _UsageStatRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final _MockTransaction transaction;

  const _TransactionItem({required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: transaction.isCredit
                  ? AppColors.sentimentPositiveBg
                  : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.icon,
              color: transaction.isCredit
                  ? AppColors.sentimentPositive
                  : AppColors.gray600,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  transaction.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${transaction.isCredit ? '+' : '-'}\$${transaction.amount}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: transaction.isCredit
                  ? AppColors.sentimentPositive
                  : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MockTransaction {
  final String title;
  final String date;
  final String amount;
  final bool isCredit;
  final IconData icon;

  _MockTransaction({
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.icon,
  });
}

final _mockTransactions = [
  _MockTransaction(
    title: 'Top Up - Credit Card',
    date: 'Today, 2:30 PM',
    amount: '100.00',
    isCredit: true,
    icon: Icons.add_circle_outline_rounded,
  ),
  _MockTransaction(
    title: 'Outbound Calls',
    date: 'Today, 11:00 AM',
    amount: '23.50',
    isCredit: false,
    icon: Icons.call_made_rounded,
  ),
  _MockTransaction(
    title: 'SMS Messages',
    date: 'Yesterday',
    amount: '5.20',
    isCredit: false,
    icon: Icons.sms_rounded,
  ),
  _MockTransaction(
    title: 'Top Up - PayPal',
    date: 'Dec 20, 2024',
    amount: '50.00',
    isCredit: true,
    icon: Icons.add_circle_outline_rounded,
  ),
];


