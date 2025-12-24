import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../data/contacts_provider.dart';

// Conditional import for web-only functionality
import 'import_contacts_web.dart' if (dart.library.io) 'import_contacts_stub.dart' as platform;

/// Bottom sheet for importing contacts from CSV
class ImportContactsSheet extends ConsumerStatefulWidget {
  const ImportContactsSheet({super.key});

  @override
  ConsumerState<ImportContactsSheet> createState() => _ImportContactsSheetState();
}

class _ImportContactsSheetState extends ConsumerState<ImportContactsSheet> {
  bool _isLoading = false;
  String? _fileName;
  String? _csvContent;
  int? _importedCount;
  String? _error;

  Future<void> _pickFile() async {
    if (!kIsWeb) {
      setState(() {
        _error = 'CSV import is currently only available on web. Mobile support coming soon!';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _importedCount = null;
    });

    try {
      final result = await platform.pickCsvFile();
      if (result != null) {
        setState(() {
          _fileName = result.fileName;
          _csvContent = result.content;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to read file: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _importContacts() async {
    if (_csvContent == null || _csvContent!.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final count = await ref.read(contactsProvider.notifier).importFromCsv(_csvContent!);
      setState(() {
        _importedCount = count;
        _isLoading = false;
      });

      if (count > 0) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.background : AppColors.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Import Contacts',
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

          // Info box
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'CSV format: Name, Phone, Email, Company, Label\n(Header row is optional)',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Platform warning for mobile
          if (!kIsWeb) ...[
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.warning, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'CSV import is currently only available on web. For mobile, please add contacts manually.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // File picker area
          GestureDetector(
            onTap: _isLoading ? null : _pickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              decoration: BoxDecoration(
                color: isDark ? AppColorsDark.surface : AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: _fileName != null
                      ? AppColors.primary
                      : (isDark ? AppColorsDark.border : AppColors.border),
                  width: _fileName != null ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _fileName != null ? Icons.check_circle : Icons.upload_file,
                    size: 48,
                    color: _fileName != null
                        ? AppColors.sentimentPositive
                        : (isDark ? AppColorsDark.textTertiary : AppColors.gray400),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    _fileName ?? (kIsWeb ? 'Tap to select CSV file' : 'Not available on mobile'),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _fileName != null ? FontWeight.w600 : FontWeight.normal,
                      color: _fileName != null
                          ? (isDark ? AppColorsDark.textPrimary : AppColors.textPrimary)
                          : (isDark ? AppColorsDark.textSecondary : AppColors.gray500),
                    ),
                  ),
                  if (_fileName != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Tap again to change file',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? AppColorsDark.textTertiary : AppColors.gray400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Status messages
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: CircularProgressIndicator(),
              ),
            ),

          if (_error != null)
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: AppColors.error, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      _error!,
                      style: const TextStyle(fontSize: 12, color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),

          if (_importedCount != null)
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.sentimentPositive.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.sentimentPositive, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Successfully imported $_importedCount contacts!',
                    style: const TextStyle(fontSize: 12, color: AppColors.sentimentPositive),
                  ),
                ],
              ),
            ),

          const SizedBox(height: AppSpacing.lg),

          // Import button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: (_csvContent != null && !_isLoading) ? _importContacts : null,
              icon: const Icon(Icons.file_download),
              label: const Text('Import Contacts'),
            ),
          ),

          // Sample CSV download link (web only)
          if (kIsWeb) ...[
            const SizedBox(height: AppSpacing.sm),
            Center(
              child: TextButton.icon(
                onPressed: () => platform.downloadSampleCsv(),
                icon: Icon(
                  Icons.download,
                  size: 16,
                  color: isDark ? AppColorsDark.primary : AppColors.primary,
                ),
                label: Text(
                  'Download sample CSV',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColorsDark.primary : AppColors.primary,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Show import contacts sheet
void showImportContactsSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const ImportContactsSheet(),
  );
}
