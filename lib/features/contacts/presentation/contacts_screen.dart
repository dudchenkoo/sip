import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../calling/data/call_provider.dart';
import '../data/contacts_provider.dart';
import '../domain/contact_model.dart';
import 'add_contact_sheet.dart';
import 'import_contacts_sheet.dart';

class ContactsScreen extends ConsumerStatefulWidget {
  const ContactsScreen({super.key});

  @override
  ConsumerState<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends ConsumerState<ContactsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onCallContact(Contact contact) {
    ref.read(callProvider.notifier).startCall(
      phoneNumber: contact.phoneNumber,
      contactName: contact.name,
    );
  }

  void _onEditContact(Contact contact) {
    showAddContactSheet(context, contact: contact);
  }

  void _onDeleteContact(Contact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${contact.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(contactsProvider.notifier).deleteContact(contact.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final contactsState = ref.watch(contactsProvider);

    // Filter contacts based on search
    final filteredContacts = _searchQuery.isEmpty
        ? contactsState.sortedContacts
        : ref.read(contactsProvider.notifier).searchContacts(_searchQuery);

    // Group contacts
    final Map<String, List<Contact>> groupedContacts = {};
    for (final contact in filteredContacts) {
      final letter = contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '#';
      groupedContacts.putIfAbsent(letter, () => []).add(contact);
    }
    final sortedKeys = groupedContacts.keys.toList()..sort();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          // Import CSV button
          IconButton(
            icon: const Icon(Icons.upload_file, size: 22),
            tooltip: 'Import CSV',
            onPressed: () => showImportContactsSheet(context),
          ),
          // Add contact button
          IconButton(
            icon: const Icon(Icons.person_add_rounded, size: 22),
            tooltip: 'Add Contact',
            onPressed: () => showAddContactSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: Icon(
                  Icons.search_rounded,
                  size: 20,
                  color: isDark ? AppColorsDark.gray500 : AppColors.gray400,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear_rounded,
                          size: 18,
                          color: isDark ? AppColorsDark.gray500 : AppColors.gray400,
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
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
          ),

          // Contact count
          if (contactsState.contacts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredContacts.length} contact${filteredContacts.length != 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColorsDark.textSecondary : AppColors.gray500,
                    ),
                  ),
                  if (_searchQuery.isEmpty && contactsState.contacts.length > 5)
                    TextButton.icon(
                      onPressed: () => _showClearAllDialog(context),
                      icon: Icon(Icons.delete_sweep, size: 16, color: AppColors.error),
                      label: Text(
                        'Clear All',
                        style: TextStyle(fontSize: 12, color: AppColors.error),
                      ),
                    ),
                ],
              ),
            ),

          // Content
          Expanded(
            child: contactsState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredContacts.isEmpty
                    ? _EmptyState(
                        searchQuery: _searchQuery,
                        isDark: isDark,
                        onAddContact: () => showAddContactSheet(context),
                        onImportCsv: () => showImportContactsSheet(context),
                      )
                    : ListView.builder(
                        itemCount: sortedKeys.length,
                        itemBuilder: (context, index) {
                          final letter = sortedKeys[index];
                          final contacts = groupedContacts[letter]!;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Letter header
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                                child: Text(
                                  letter,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? AppColorsDark.primary : AppColors.primary,
                                  ),
                                ),
                              ),
                              // Contacts in this group
                              ...contacts.map((contact) => _ContactItem(
                                contact: contact,
                                onCall: () => _onCallContact(contact),
                                onEdit: () => _onEditContact(contact),
                                onDelete: () => _onDeleteContact(contact),
                                isDark: isDark,
                              )),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
      // FAB for quick add
      floatingActionButton: contactsState.contacts.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => showAddContactSheet(context),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Contacts'),
        content: const Text('This will delete all contacts. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(contactsProvider.notifier).clearAllContacts();
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String searchQuery;
  final bool isDark;
  final VoidCallback onAddContact;
  final VoidCallback onImportCsv;

  const _EmptyState({
    required this.searchQuery,
    required this.isDark,
    required this.onAddContact,
    required this.onImportCsv,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              searchQuery.isEmpty ? Icons.contacts_rounded : Icons.search_off_rounded,
              size: 64,
              color: isDark ? AppColorsDark.gray600 : AppColors.gray300,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              searchQuery.isEmpty ? 'No contacts yet' : 'No contacts found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              searchQuery.isEmpty
                  ? 'Add contacts manually or import from CSV'
                  : 'Try a different search term',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColorsDark.textSecondary : AppColors.gray500,
              ),
              textAlign: TextAlign.center,
            ),
            if (searchQuery.isEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton.icon(
                    onPressed: onAddContact,
                    icon: const Icon(Icons.person_add, size: 18),
                    label: const Text('Add Contact'),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton.icon(
                    onPressed: onImportCsv,
                    icon: const Icon(Icons.upload_file, size: 18),
                    label: const Text('Import CSV'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback onCall;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDark;

  const _ContactItem({
    required this.contact,
    required this.onCall,
    required this.onEdit,
    required this.onDelete,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(contact.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) async {
        onDelete();
        return false; // We handle deletion in the dialog
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
        decoration: BoxDecoration(
          color: isDark ? AppColorsDark.surface : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
        ),
        child: ListTile(
          onTap: onCall,
          onLongPress: onEdit,
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: CircleAvatar(
            radius: 18,
            backgroundColor: contact.avatarColor.withValues(alpha: isDark ? 0.25 : 0.15),
            child: Text(
              contact.initials,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: contact.avatarColor,
              ),
            ),
          ),
          title: Text(
            contact.name,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    contact.phoneNumber,
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary,
                    ),
                  ),
                ),
                if (contact.label != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                    decoration: BoxDecoration(
                      color: isDark ? AppColorsDark.surfaceVariant : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      contact.label!,
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColorsDark.textTertiary : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: isDark ? AppColorsDark.textSecondary : AppColors.gray500,
                ),
                onPressed: onEdit,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                tooltip: 'Edit',
              ),
              IconButton(
                icon: const Icon(Icons.call_rounded, size: 20),
                color: AppColors.sentimentPositive,
                onPressed: onCall,
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
                tooltip: 'Call',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
