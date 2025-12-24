import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../domain/contact_model.dart';

/// State for contacts
class ContactsState {
  final List<Contact> contacts;
  final bool isLoading;
  final String? error;

  const ContactsState({
    this.contacts = const [],
    this.isLoading = false,
    this.error,
  });

  ContactsState copyWith({
    List<Contact>? contacts,
    bool? isLoading,
    String? error,
  }) {
    return ContactsState(
      contacts: contacts ?? this.contacts,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Get contacts sorted alphabetically by name
  List<Contact> get sortedContacts {
    final sorted = List<Contact>.from(contacts);
    sorted.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return sorted;
  }

  /// Group contacts by first letter
  Map<String, List<Contact>> get groupedContacts {
    final Map<String, List<Contact>> grouped = {};
    for (final contact in sortedContacts) {
      final letter = contact.name.isNotEmpty 
          ? contact.name[0].toUpperCase() 
          : '#';
      grouped.putIfAbsent(letter, () => []).add(contact);
    }
    return grouped;
  }
}

/// Contacts notifier for managing contact state
class ContactsNotifier extends StateNotifier<ContactsState> {
  ContactsNotifier() : super(const ContactsState(isLoading: true)) {
    _loadContacts();
  }

  static const _storageKey = 'contacts_list';
  final _uuid = const Uuid();

  /// Load contacts from storage
  Future<void> _loadContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactsJson = prefs.getStringList(_storageKey);
      
      if (contactsJson != null) {
        final contacts = contactsJson
            .map((json) => Contact.fromJson(jsonDecode(json)))
            .toList();
        state = state.copyWith(contacts: contacts, isLoading: false);
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Save contacts to storage
  Future<void> _saveContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final contactsJson = state.contacts
          .map((contact) => jsonEncode(contact.toJson()))
          .toList();
      await prefs.setStringList(_storageKey, contactsJson);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  /// Add a new contact
  Future<void> addContact({
    required String name,
    required String phoneNumber,
    String? email,
    String? company,
    String? label,
    String? notes,
  }) async {
    final contact = Contact(
      id: _uuid.v4(),
      name: name,
      phoneNumber: phoneNumber,
      email: email,
      company: company,
      label: label,
      notes: notes,
    );

    state = state.copyWith(
      contacts: [...state.contacts, contact],
    );
    await _saveContacts();
  }

  /// Update an existing contact
  Future<void> updateContact(Contact updatedContact) async {
    final contacts = state.contacts.map((contact) {
      return contact.id == updatedContact.id ? updatedContact : contact;
    }).toList();

    state = state.copyWith(contacts: contacts);
    await _saveContacts();
  }

  /// Delete a contact
  Future<void> deleteContact(String id) async {
    final contacts = state.contacts.where((c) => c.id != id).toList();
    state = state.copyWith(contacts: contacts);
    await _saveContacts();
  }

  /// Import contacts from CSV data
  /// Expected format: name,phone,email,company,label (header row optional)
  Future<int> importFromCsv(String csvData) async {
    try {
      final lines = csvData.split('\n');
      final newContacts = <Contact>[];
      
      int startIndex = 0;
      // Check if first row is a header
      if (lines.isNotEmpty) {
        final firstLine = lines[0].toLowerCase();
        if (firstLine.contains('name') || firstLine.contains('phone')) {
          startIndex = 1; // Skip header row
        }
      }

      for (int i = startIndex; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        // Parse CSV line (handle quoted values)
        final row = _parseCsvLine(line);
        
        if (row.isNotEmpty && row[0].toString().trim().isNotEmpty) {
          final contact = Contact.fromCsvRow(row, _uuid.v4());
          if (contact.name.isNotEmpty && contact.phoneNumber.isNotEmpty) {
            newContacts.add(contact);
          }
        }
      }

      if (newContacts.isNotEmpty) {
        state = state.copyWith(
          contacts: [...state.contacts, ...newContacts],
        );
        await _saveContacts();
      }

      return newContacts.length;
    } catch (e) {
      state = state.copyWith(error: 'Failed to import CSV: $e');
      return 0;
    }
  }

  /// Parse a CSV line handling quoted values
  List<String> _parseCsvLine(String line) {
    final List<String> result = [];
    bool inQuotes = false;
    StringBuffer current = StringBuffer();

    for (int i = 0; i < line.length; i++) {
      final char = line[i];
      
      if (char == '"') {
        inQuotes = !inQuotes;
      } else if (char == ',' && !inQuotes) {
        result.add(current.toString());
        current = StringBuffer();
      } else {
        current.write(char);
      }
    }
    result.add(current.toString());
    
    return result;
  }

  /// Search contacts by name or phone
  List<Contact> searchContacts(String query) {
    if (query.isEmpty) return state.sortedContacts;
    
    final lowerQuery = query.toLowerCase();
    return state.sortedContacts.where((contact) {
      return contact.name.toLowerCase().contains(lowerQuery) ||
          contact.phoneNumber.contains(query) ||
          (contact.email?.toLowerCase().contains(lowerQuery) ?? false) ||
          (contact.company?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  /// Clear all contacts
  Future<void> clearAllContacts() async {
    state = state.copyWith(contacts: []);
    await _saveContacts();
  }

  /// Clear any error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// Provider for contacts state
final contactsProvider = StateNotifierProvider<ContactsNotifier, ContactsState>((ref) {
  return ContactsNotifier();
});

