import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../data/accounts_provider.dart';
import '../domain/account_model.dart';
import 'add_account_sheet.dart';

/// Account selector dropdown for the dialer
class AccountSelector extends ConsumerWidget {
  const AccountSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accountsState = ref.watch(accountsProvider);

    if (accountsState.isLoading) {
      return const SizedBox(
        height: 48,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    final selectedAccount = accountsState.selectedAccount;

    return GestureDetector(
      onTap: () => _showAccountPicker(context, ref, accountsState, isDark),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? AppColorsDark.surface : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColorsDark.border : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : AppColors.darkGray).withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Account type icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: (isDark ? AppColorsDark.primary : AppColors.primary).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                selectedAccount?.type == AccountType.mmdsmart
                    ? Icons.cloud_outlined
                    : Icons.phone_in_talk_outlined,
                size: 18,
                color: isDark ? AppColorsDark.primary : AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),

            // Account info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedAccount?.name ?? 'Select Account',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    selectedAccount?.typeLabel ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Dropdown arrow
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isDark ? AppColorsDark.gray500 : AppColors.gray500,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _showAccountPicker(
    BuildContext context,
    WidgetRef ref,
    AccountsState state,
    bool isDark,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _AccountPickerSheet(
        accounts: state.accounts,
        selectedId: state.selectedAccountId,
        onSelect: (account) {
          ref.read(accountsProvider.notifier).selectAccount(account.id);
          Navigator.pop(ctx);
        },
        onAddAccount: () async {
          Navigator.pop(ctx);
          final result = await showModalBottomSheet<Account>(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder: (_) => const AddAccountSheet(),
          );
          if (result != null) {
            ref.read(accountsProvider.notifier).selectAccount(result.id);
          }
        },
        isDark: isDark,
      ),
    );
  }
}

class _AccountPickerSheet extends StatelessWidget {
  final List<Account> accounts;
  final String? selectedId;
  final Function(Account) onSelect;
  final VoidCallback onAddAccount;
  final bool isDark;

  const _AccountPickerSheet({
    required this.accounts,
    required this.selectedId,
    required this.onSelect,
    required this.onAddAccount,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColorsDark.gray600 : AppColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    'Select Account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: onAddAccount,
                    icon: Icon(
                      Icons.add_rounded,
                      size: 18,
                      color: isDark ? AppColorsDark.primary : AppColors.primary,
                    ),
                    label: Text(
                      'Add New',
                      style: TextStyle(
                        color: isDark ? AppColorsDark.primary : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Account list
            ...accounts.map((account) => _AccountTile(
              account: account,
              isSelected: account.id == selectedId,
              onTap: () => onSelect(account),
              isDark: isDark,
            )),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final Account account;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _AccountTile({
    required this.account,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        color: isSelected 
            ? primary.withValues(alpha: 0.08) 
            : Colors.transparent,
        child: Row(
          children: [
            // Account type icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: account.type == AccountType.mmdsmart
                    ? primary.withValues(alpha: 0.12)
                    : (isDark ? AppColorsDark.gray700 : AppColors.gray200),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                account.type == AccountType.mmdsmart
                    ? Icons.cloud_outlined
                    : Icons.phone_in_talk_outlined,
                size: 22,
                color: account.type == AccountType.mmdsmart
                    ? primary
                    : (isDark ? AppColorsDark.textSecondary : AppColors.textSecondary),
              ),
            ),
            const SizedBox(width: 14),

            // Account info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          account.name,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (account.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    account.displayNumber ?? account.username,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    account.typeLabel,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColorsDark.textTertiary : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),

            // Selected indicator
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: primary,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

