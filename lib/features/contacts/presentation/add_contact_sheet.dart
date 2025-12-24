import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../data/contacts_provider.dart';
import '../domain/contact_model.dart';

/// Bottom sheet for adding or editing a contact
class AddContactSheet extends ConsumerStatefulWidget {
  final Contact? existingContact; // If provided, edit mode

  const AddContactSheet({super.key, this.existingContact});

  @override
  ConsumerState<AddContactSheet> createState() => _AddContactSheetState();
}

class _AddContactSheetState extends ConsumerState<AddContactSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _companyController;
  late final TextEditingController _notesController;
  String _selectedLabel = 'Mobile';

  final _labels = ['Mobile', 'Work', 'Home', 'Other'];

  bool get _isEditMode => widget.existingContact != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.existingContact?.name);
    _phoneController = TextEditingController(text: widget.existingContact?.phoneNumber);
    _emailController = TextEditingController(text: widget.existingContact?.email);
    _companyController = TextEditingController(text: widget.existingContact?.company);
    _notesController = TextEditingController(text: widget.existingContact?.notes);
    _selectedLabel = widget.existingContact?.label ?? 'Mobile';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(contactsProvider.notifier);

      if (_isEditMode) {
        // Update existing contact
        final updatedContact = widget.existingContact!.copyWith(
          name: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
          company: _companyController.text.trim().isEmpty ? null : _companyController.text.trim(),
          label: _selectedLabel,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          updatedAt: DateTime.now(),
        );
        notifier.updateContact(updatedContact);
      } else {
        // Add new contact
        notifier.addContact(
          name: _nameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
          company: _companyController.text.trim().isEmpty ? null : _companyController.text.trim(),
          label: _selectedLabel,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.background : AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: bottomInset + AppSpacing.md,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isEditMode ? 'Edit Contact' : 'Add Contact',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: isDark ? AppColorsDark.textSecondary : AppColors.gray500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),

                // Name field (required)
                _buildTextField(
                  controller: _nameController,
                  label: 'Name *',
                  hint: 'John Doe',
                  icon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Phone field (required)
                _buildTextField(
                  controller: _phoneController,
                  label: 'Phone Number *',
                  hint: '+1 (555) 123-4567',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Phone number is required';
                    }
                    return null;
                  },
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Label selector
                Text(
                  'Label',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColorsDark.textSecondary : AppColors.gray500,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  children: _labels.map((label) {
                    final isSelected = _selectedLabel == label;
                    return ChoiceChip(
                      label: Text(label),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedLabel = label);
                      },
                      selectedColor: AppColors.primary.withValues(alpha: 0.2),
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColorsDark.textPrimary : AppColors.textPrimary),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppSpacing.sm),

                // Email field (optional)
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'john@example.com',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Company field (optional)
                _buildTextField(
                  controller: _companyController,
                  label: 'Company',
                  hint: 'Acme Inc.',
                  icon: Icons.business_outlined,
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.sm),

                // Notes field (optional)
                _buildTextField(
                  controller: _notesController,
                  label: 'Notes',
                  hint: 'Additional information...',
                  icon: Icons.note_outlined,
                  maxLines: 2,
                  isDark: isDark,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveContact,
                    child: Text(_isEditMode ? 'Update Contact' : 'Add Contact'),
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
    required IconData icon,
    required bool isDark,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColorsDark.textSecondary : AppColors.gray500,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 20),
            filled: true,
            fillColor: isDark ? AppColorsDark.surface : AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: BorderSide(color: isDark ? AppColorsDark.border : AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              borderSide: BorderSide(color: isDark ? AppColorsDark.border : AppColors.border),
            ),
          ),
        ),
      ],
    );
  }
}

/// Show add contact sheet
void showAddContactSheet(BuildContext context, {Contact? contact}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AddContactSheet(existingContact: contact),
  );
}

