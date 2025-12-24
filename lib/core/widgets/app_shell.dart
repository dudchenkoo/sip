import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../router/app_router.dart';
import '../theme/app_theme.dart';

/// Main app shell with bottom navigation
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const _BottomNavBar(),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.dialer)) return 0;
    if (location.startsWith(AppRoutes.calls)) return 1;
    if (location.startsWith(AppRoutes.contacts)) return 2;
    if (location.startsWith(AppRoutes.settings)) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.dialer);
        break;
      case 1:
        context.go(AppRoutes.calls);
        break;
      case 2:
        context.go(AppRoutes.contacts);
        break;
      case 3:
        context.go(AppRoutes.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColorsDark.surface : AppColors.white,
        boxShadow: [
          BoxShadow(
            color: (isDark ? Colors.black : AppColors.darkGray).withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.dialpad_rounded,
                label: 'Dialer',
                isSelected: selectedIndex == 0,
                onTap: () => _onItemTapped(context, 0),
                isDark: isDark,
              ),
              _NavItem(
                icon: Icons.history_rounded,
                label: 'Calls',
                isSelected: selectedIndex == 1,
                onTap: () => _onItemTapped(context, 1),
                isDark: isDark,
              ),
              _NavItem(
                icon: Icons.contacts_rounded,
                label: 'Contacts',
                isSelected: selectedIndex == 2,
                onTap: () => _onItemTapped(context, 2),
                isDark: isDark,
              ),
              _NavItem(
                icon: Icons.settings_rounded,
                label: 'Settings',
                isSelected: selectedIndex == 3,
                onTap: () => _onItemTapped(context, 3),
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final primary = isDark ? AppColorsDark.primary : AppColors.primary;
    final inactive = isDark ? AppColorsDark.gray500 : AppColors.gray500;
    final containerColor = isDark ? AppColorsDark.primaryContainer : AppColors.primaryContainer;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? containerColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected ? primary : inactive,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? primary : inactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
