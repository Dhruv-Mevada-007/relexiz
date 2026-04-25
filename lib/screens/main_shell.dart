import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/app_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'with_you_screen.dart';
import 'heard_screen.dart';
import 'release_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  static const _screens = [
    HomeScreen(),
    WithYouScreen(),
    HeardScreen(),
    ReleaseScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: AppColors.cream,
          body: IndexedStack(
            index: provider.currentTab,
            children: _screens,
          ),
          bottomNavigationBar: _RelaxiZNavBar(
            currentIndex: provider.currentTab,
            onTap: (index) {
              HapticFeedback.selectionClick();
              provider.setTab(index);
            },
          ),
        );
      },
    );
  }
}

class _RelaxiZNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _RelaxiZNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(label: 'home', icon: Icons.home_outlined, activeIcon: Icons.home_rounded),
      _NavItem(label: 'with you', icon: Icons.spa_outlined, activeIcon: Icons.spa_rounded),
      _NavItem(label: 'heard', icon: Icons.favorite_outline_rounded, activeIcon: Icons.favorite_rounded),
      _NavItem(label: 'release', icon: Icons.air_outlined, activeIcon: Icons.air_rounded),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cream,
        border: Border(
          top: BorderSide(
            color: AppColors.cardBorder,
            width: 0.8,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: items.asMap().entries.map((entry) {
              final idx = entry.key;
              final item = entry.value;
              final isActive = idx == currentIndex;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(idx),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Indicator dot
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: isActive ? 4 : 0,
                          height: isActive ? 4 : 0,
                          margin: const EdgeInsets.only(bottom: 4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.sage,
                          ),
                        ),
                        Icon(
                          isActive ? item.activeIcon : item.icon,
                          color: isActive
                              ? AppColors.sage
                              : AppColors.textSoft,
                          size: 22,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: GoogleFonts.dmSans(
                            fontSize: 10,
                            fontWeight: isActive
                                ? FontWeight.w500
                                : FontWeight.w400,
                            color: isActive
                                ? AppColors.sage
                                : AppColors.textSoft,
                            letterSpacing: 0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
