import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../data/accounts_provider.dart';
import '../domain/account_model.dart';

/// Bottom sheet for adding a new account
class AddAccountSheet extends ConsumerStatefulWidget {
  const AddAccountSheet({super.key});

  @override
  ConsumerState<AddAccountSheet> createState() => _AddAccountSheetState();
}

class _AddAccountSheetState extends ConsumerState<AddAccountSheet> {
  AccountType _selectedType = AccountType.mmdsmart;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _serverController = TextEditingController();
  final _displayNumberController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _serverController.dispose();
    _displayNumberController.dispose();
    super.dispose();
  }

  Future<void> _saveAccount() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final account = Account(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      type: _selectedType,
      username: _usernameController.text.trim(),
      server: _selectedType == AccountType.sip ? _serverController.text.trim() : null,
      displayNumber: _displayNumberController.text.trim().isNotEmpty 
          ? _displayNumberController.text.trim() 
          : null,
      createdAt: DateTime.now(),
    );

    await ref.read(accountsProvider.notifier).addAccount(account);
    
    if (mounted) {
      Navigator.pop(context, account);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColorsDark.gray600 : AppColors.gray300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Add Account',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add a new account to make calls',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // Account type selector
                Text(
                  'Account Type',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _AccountTypeCard(
                        type: AccountType.mmdsmart,
                        isSelected: _selectedType == AccountType.mmdsmart,
                        onTap: () => setState(() => _selectedType = AccountType.mmdsmart),
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _AccountTypeCard(
                        type: AccountType.sip,
                        isSelected: _selectedType == AccountType.sip,
                        onTap: () => setState(() => _selectedType = AccountType.sip),
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Form fields
                _buildTextField(
                  controller: _nameController,
                  label: 'Account Name',
                  hint: _selectedType == AccountType.mmdsmart 
                      ? 'e.g., Work Account' 
                      : 'e.g., Office SIP',
                  isDark: isDark,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter an account name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _usernameController,
                  label: _selectedType == AccountType.mmdsmart ? 'Email / Username' : 'SIP Username',
                  hint: _selectedType == AccountType.mmdsmart 
                      ? 'agent@company.com' 
                      : 'sip_user',
                  isDark: isDark,
                  keyboardType: _selectedType == AccountType.mmdsmart 
                      ? TextInputType.emailAddress 
                      : TextInputType.text,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: '••••••••',
                  isDark: isDark,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: isDark ? AppColorsDark.gray500 : AppColors.gray500,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // SIP-specific fields
                if (_selectedType == AccountType.sip) ...[
                  _buildTextField(
                    controller: _serverController,
                    label: 'SIP Server',
                    hint: 'sip.example.com:5060',
                    isDark: isDark,
                    validator: (value) {
                      if (_selectedType == AccountType.sip && (value == null || value.trim().isEmpty)) {
                        return 'Please enter the SIP server address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                _buildTextField(
                  controller: _displayNumberController,
                  label: 'Display Number (Optional)',
                  hint: '+1 (555) 123-4567',
                  isDark: isDark,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 28),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveAccount,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? AppColorsDark.primary : AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Add Account',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isDark,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          style: TextStyle(
            fontSize: 15,
            color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? AppColorsDark.gray500 : AppColors.gray400,
            ),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: isDark ? AppColorsDark.surfaceVariant : AppColors.surfaceVariant,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? AppColorsDark.primary : AppColors.primary,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  final AccountType type;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _AccountTypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? primary.withValues(alpha: 0.1) 
              : (isDark ? AppColorsDark.surfaceVariant : AppColors.surfaceVariant),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected 
                    ? primary.withValues(alpha: 0.15)
                    : (isDark ? AppColorsDark.gray700 : AppColors.gray200),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                type == AccountType.mmdsmart 
                    ? Icons.cloud_outlined 
                    : Icons.phone_in_talk_outlined,
                color: isSelected 
                    ? primary 
                    : (isDark ? AppColorsDark.textSecondary : AppColors.textSecondary),
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              type == AccountType.mmdsmart ? 'MMDSmart' : 'SIP Account',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected 
                    ? primary 
                    : (isDark ? AppColorsDark.textPrimary : AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              type == AccountType.mmdsmart ? 'Cloud PBX' : 'External SIP',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? AppColorsDark.textTertiary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

