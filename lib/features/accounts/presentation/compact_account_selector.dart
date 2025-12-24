import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../data/accounts_provider.dart';
import '../domain/account_model.dart';
import 'add_account_sheet.dart';

/// Compact account selector for the app bar
class CompactAccountSelector extends ConsumerWidget {
  const CompactAccountSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accountsState = ref.watch(accountsProvider);

    if (accountsState.isLoading) {
      return const SizedBox(width: 32, height: 32);
    }

    final selectedAccount = accountsState.selectedAccount;

    return GestureDetector(
      onTap: () => _showAccountPicker(context, ref, accountsState, isDark),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isDark ? AppColorsDark.surface : AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDark ? AppColorsDark.border : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Account type icon
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: (isDark ? AppColorsDark.primary : AppColors.primary).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(
                selectedAccount?.type == AccountType.mmdsmart
                    ? Icons.cloud_outlined
                    : Icons.phone_in_talk_outlined,
                size: 14,
                color: isDark ? AppColorsDark.primary : AppColors.primary,
              ),
            ),
            const SizedBox(width: 6),
            
            // Account name (truncated)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 80),
              child: Text(
                selectedAccount?.name ?? 'Account',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: isDark ? AppColorsDark.gray500 : AppColors.gray500,
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

            // Title row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 12, 8),
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
                        fontSize: 13,
                        color: isDark ? AppColorsDark.primary : AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        color: isSelected ? primary.withValues(alpha: 0.08) : Colors.transparent,
        child: Row(
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
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
                size: 20,
                color: account.type == AccountType.mmdsmart
                    ? primary
                    : (isDark ? AppColorsDark.textSecondary : AppColors.textSecondary),
              ),
            ),
            const SizedBox(width: 12),

            // Info
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
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (account.isDefault) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: primary),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${account.typeLabel} • ${account.displayNumber ?? account.username}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            if (isSelected)
              Icon(Icons.check_circle_rounded, color: primary, size: 22),
          ],
        ),
      ),
    );
  }
}

