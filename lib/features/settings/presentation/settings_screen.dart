import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_theme.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _dndEnabled = false;

  void _showThemePicker(BuildContext context, AppThemeMode currentMode, ThemeNotifier notifier) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColorsDark.surface : AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColorsDark.gray600 : AppColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Choose Theme',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary,
                ),
              ),
            ),
            _ThemeOptionTile(
              icon: Icons.light_mode_rounded,
              title: 'Light',
              subtitle: 'Bright and clean interface',
              isSelected: currentMode == AppThemeMode.light,
              onTap: () {
                notifier.setTheme(AppThemeMode.light);
                Navigator.pop(ctx);
              },
              isDark: isDark,
            ),
            _ThemeOptionTile(
              icon: Icons.dark_mode_rounded,
              title: 'Dark',
              subtitle: 'Easy on the eyes at night',
              isSelected: currentMode == AppThemeMode.dark,
              onTap: () {
                notifier.setTheme(AppThemeMode.dark);
                Navigator.pop(ctx);
              },
              isDark: isDark,
            ),
            _ThemeOptionTile(
              icon: Icons.brightness_auto_rounded,
              title: 'System',
              subtitle: 'Match your device settings',
              isSelected: currentMode == AppThemeMode.system,
              onTap: () {
                notifier.setTheme(AppThemeMode.system);
                Navigator.pop(ctx);
              },
              isDark: isDark,
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeMode = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Card
            _buildProfileCard(context, isDark),
            const SizedBox(height: 16),

            // Agent Settings
            _SectionLabel(label: 'Agent Settings', isDark: isDark),
            const SizedBox(height: 8),
            _SettingsCard(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.headset_mic_rounded,
                  title: 'VoIP Configuration',
                  subtitle: 'SIP settings and audio',
                  onTap: () {},
                  isDark: isDark,
                ),
                _SettingsTile(
                  icon: Icons.notifications_rounded,
                  title: 'Notifications',
                  subtitle: 'Push and sound settings',
                  onTap: () {},
                  isDark: isDark,
                  badge: '3',
                ),
                _SettingsTile(
                  icon: Icons.do_not_disturb_rounded,
                  title: 'Do Not Disturb',
                  subtitle: 'Pause incoming calls',
                  onTap: () => setState(() => _dndEnabled = !_dndEnabled),
                  isDark: isDark,
                  trailing: Switch.adaptive(
                    value: _dndEnabled,
                    onChanged: (v) => setState(() => _dndEnabled = v),
                    activeColor: isDark ? AppColorsDark.primary : AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Appearance
            _SectionLabel(label: 'Appearance', isDark: isDark),
            const SizedBox(height: 8),
            _SettingsCard(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.palette_rounded,
                  title: 'Theme',
                  subtitle: themeNotifier.themeModeLabel,
                  onTap: () => _showThemePicker(context, themeMode, themeNotifier),
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // App Settings
            _SectionLabel(label: 'App Settings', isDark: isDark),
            const SizedBox(height: 8),
            _SettingsCard(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.language_rounded,
                  title: 'Language',
                  subtitle: 'English (US)',
                  onTap: () {},
                  isDark: isDark,
                ),
                _SettingsTile(
                  icon: Icons.volume_up_rounded,
                  title: 'Audio Settings',
                  subtitle: 'Ringtone and earpiece',
                  onTap: () {},
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Support
            _SectionLabel(label: 'Support', isDark: isDark),
            const SizedBox(height: 8),
            _SettingsCard(
              isDark: isDark,
              children: [
                _SettingsTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help Center',
                  subtitle: 'FAQs and guides',
                  onTap: () {},
                  isDark: isDark,
                ),
                _SettingsTile(
                  icon: Icons.info_outline_rounded,
                  title: 'About',
                  subtitle: 'Version 1.0.0',
                  onTap: () {},
                  isDark: isDark,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Log out
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.logout_rounded, color: AppColors.error, size: 18),
                label: const Text('Log Out', style: TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: const BorderSide(color: AppColors.error),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  isDark ? AppColorsDark.primary : AppColors.primary,
                  isDark ? AppColorsDark.primaryDark : AppColors.primaryDark,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('JD', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jane Doe',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary),
                ),
                Text(
                  'Senior Agent',
                  style: TextStyle(fontSize: 12, color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.sentimentPositive.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppColors.sentimentPositive, shape: BoxShape.circle)),
                      const SizedBox(width: 4),
                      const Text('Available', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.sentimentPositive)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.edit_rounded, color: isDark ? AppColorsDark.primary : AppColors.primary, size: 20),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SectionLabel({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColorsDark.textTertiary : AppColors.textTertiary,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final bool isDark;

  const _SettingsCard({required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: isDark ? AppColorsDark.border : AppColors.border),
      ),
      child: Column(
        children: List.generate(children.length, (i) {
          return Column(
            children: [
              children[i],
              if (i < children.length - 1)
                Divider(height: 1, indent: 48, color: isDark ? AppColorsDark.divider : AppColors.divider),
            ],
          );
        }),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDark;
  final Widget? trailing;
  final String? badge;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isDark,
    this.trailing,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isDark ? AppColorsDark.primaryContainer : AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: isDark ? AppColorsDark.primary : AppColors.primary, size: 16),
      ),
      title: Text(title, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary)),
      trailing: trailing ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(8)),
                  child: Text(badge!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              Icon(Icons.chevron_right_rounded, color: isDark ? AppColorsDark.gray500 : AppColors.gray400, size: 20),
            ],
          ),
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _ThemeOptionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: 0.15) : (isDark ? AppColorsDark.surfaceVariant : AppColors.surfaceVariant),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: isSelected ? primary : (isDark ? AppColorsDark.textSecondary : AppColors.textSecondary)),
      ),
      title: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: isDark ? AppColorsDark.textPrimary : AppColors.textPrimary)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? AppColorsDark.textSecondary : AppColors.textSecondary)),
      trailing: isSelected ? Icon(Icons.check_circle_rounded, color: primary) : null,
    );
  }
}
