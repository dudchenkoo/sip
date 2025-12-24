import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/account_model.dart';

/// State class for accounts
class AccountsState {
  final List<Account> accounts;
  final String? selectedAccountId;
  final bool isLoading;

  const AccountsState({
    this.accounts = const [],
    this.selectedAccountId,
    this.isLoading = false,
  });

  Account? get selectedAccount {
    if (selectedAccountId == null) return null;
    try {
      return accounts.firstWhere((a) => a.id == selectedAccountId);
    } catch (_) {
      return accounts.isNotEmpty ? accounts.first : null;
    }
  }

  AccountsState copyWith({
    List<Account>? accounts,
    String? selectedAccountId,
    bool? isLoading,
  }) {
    return AccountsState(
      accounts: accounts ?? this.accounts,
      selectedAccountId: selectedAccountId ?? this.selectedAccountId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Accounts notifier for managing account state
class AccountsNotifier extends StateNotifier<AccountsState> {
  AccountsNotifier() : super(const AccountsState(isLoading: true)) {
    _loadAccounts();
  }

  static const String _accountsKey = 'call_accounts';
  static const String _selectedKey = 'selected_account_id';

  /// Load accounts from storage
  Future<void> _loadAccounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accountsJson = prefs.getString(_accountsKey);
      final selectedId = prefs.getString(_selectedKey);

      List<Account> accounts = [];
      
      if (accountsJson != null) {
        final List<dynamic> decoded = jsonDecode(accountsJson);
        accounts = decoded.map((json) => Account.fromJson(json)).toList();
      }

      // Add default MMDSmart account if no accounts exist
      if (accounts.isEmpty) {
        accounts = [
          Account(
            id: 'mmd_default',
            name: 'MMDSmart Main',
            type: AccountType.mmdsmart,
            username: 'agent@mmdsmart.com',
            displayNumber: '+1 (555) 000-0001',
            isDefault: true,
            createdAt: DateTime.now(),
          ),
        ];
        await _saveAccounts(accounts);
      }

      state = AccountsState(
        accounts: accounts,
        selectedAccountId: selectedId ?? accounts.first.id,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// Save accounts to storage
  Future<void> _saveAccounts(List<Account> accounts) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(accounts.map((a) => a.toJson()).toList());
    await prefs.setString(_accountsKey, json);
  }

  /// Save selected account ID
  Future<void> _saveSelectedId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedKey, id);
  }

  /// Select an account
  Future<void> selectAccount(String accountId) async {
    state = state.copyWith(selectedAccountId: accountId);
    await _saveSelectedId(accountId);
  }

  /// Add a new account
  Future<void> addAccount(Account account) async {
    final updatedAccounts = [...state.accounts, account];
    state = state.copyWith(accounts: updatedAccounts);
    await _saveAccounts(updatedAccounts);
  }

  /// Update an existing account
  Future<void> updateAccount(Account account) async {
    final updatedAccounts = state.accounts.map((a) {
      return a.id == account.id ? account : a;
    }).toList();
    state = state.copyWith(accounts: updatedAccounts);
    await _saveAccounts(updatedAccounts);
  }

  /// Delete an account
  Future<void> deleteAccount(String accountId) async {
    final updatedAccounts = state.accounts.where((a) => a.id != accountId).toList();
    
    // If deleting selected account, select another
    String? newSelectedId = state.selectedAccountId;
    if (state.selectedAccountId == accountId && updatedAccounts.isNotEmpty) {
      newSelectedId = updatedAccounts.first.id;
    }
    
    state = state.copyWith(
      accounts: updatedAccounts,
      selectedAccountId: newSelectedId,
    );
    await _saveAccounts(updatedAccounts);
    if (newSelectedId != null) {
      await _saveSelectedId(newSelectedId);
    }
  }

  /// Set account as default
  Future<void> setDefaultAccount(String accountId) async {
    final updatedAccounts = state.accounts.map((a) {
      return a.copyWith(isDefault: a.id == accountId);
    }).toList();
    state = state.copyWith(accounts: updatedAccounts);
    await _saveAccounts(updatedAccounts);
  }
}

/// Provider for accounts state
final accountsProvider = StateNotifierProvider<AccountsNotifier, AccountsState>((ref) {
  return AccountsNotifier();
});

