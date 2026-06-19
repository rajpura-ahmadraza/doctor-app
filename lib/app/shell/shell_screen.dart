import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import '../utility/dialogs.dart';
import '../home/home_screen.dart';
import '../appointment/appointment_screen.dart';
import '../chat/chat_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import 'shell_controller.dart';

/// ── Shell Screen ────────────────────────────────────────────────────────────
/// Acts as the main container scaffold providing navigation layout across multiple tabs.
/// Embeds bottom navigation tabs for Home, Book, Chat, Alerts, and Profile.
class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key});

  // Cached screen routes/views matching index
  static const _screens = [
    HomeScreen(),
    AppointmentScreen(),
    ChatScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Inject and instantiate the ShellController
    final controller = Get.put(ShellController());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        if (controller.index.value != 0) {
          // Redirect to the Home page if back is pressed on another tab
          controller.changeIndex(0);
        } else {
          // If we are already on the Home tab, show the exit app confirmation dialog
          AppDialogs.showExitDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // Render screens dynamically using IndexedStack to preserve states
        body: Obx(() => IndexedStack(index: controller.index.value, children: _screens)),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: light,
            border: Border(top: BorderSide(color: dark.withValues(alpha: .08))),
            boxShadow: [BoxShadow(color: dark.withValues(alpha: .06), blurRadius: 20, offset: const Offset(0, -4))],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              // Obx wrapper evaluates index.value directly, registering proper state dependencies.
              child: Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ShellNavItemWidget(
                        isSelected: controller.index.value == 0,
                        onTap: () => controller.changeIndex(0),
                        activeIcon: Icons.home_rounded,
                        inactiveIcon: Icons.home_outlined,
                        label: 'Home',
                      ),
                      ShellNavItemWidget(
                        isSelected: controller.index.value == 1,
                        onTap: () => controller.changeIndex(1),
                        activeIcon: Icons.calendar_month_rounded,
                        inactiveIcon: Icons.calendar_month_outlined,
                        label: 'Book',
                      ),
                      ShellNavItemWidget(
                        isSelected: controller.index.value == 2,
                        onTap: () => controller.changeIndex(2),
                        activeIcon: Icons.chat_rounded,
                        inactiveIcon: Icons.chat_outlined,
                        label: 'Chat',
                      ),
                      ShellNavItemWithBadgeWidget(
                        isSelected: controller.index.value == 3,
                        onTap: () => controller.changeIndex(3),
                        activeIcon: Icons.notifications_rounded,
                        inactiveIcon: Icons.notifications_outlined,
                        label: 'Alerts',
                        badgeCount: controller.unreadCount,
                      ),
                      ShellNavItemWidget(
                        isSelected: controller.index.value == 4,
                        onTap: () => controller.changeIndex(4),
                        activeIcon: Icons.person_rounded,
                        inactiveIcon: Icons.person_outlined,
                        label: 'Profile',
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

/// ── Shell Navigation Item Widget ────────────────────────────────────────────
/// Renders standard individual menu buttons on the bottom navigation bar.
class ShellNavItemWidget extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;

  const ShellNavItemWidget({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: .1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? primary : dark500,
              size: 22,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'HankenGrotesk',
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? primary : dark500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ── Shell Navigation Item With Badge Widget ─────────────────────────────────
/// A specialized bottom navigation item widget displaying a notification badge
/// count on top of the icon (useful for alerts/notifications).
class ShellNavItemWithBadgeWidget extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String label;
  final int badgeCount;

  const ShellNavItemWithBadgeWidget({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    required this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: .1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : inactiveIcon,
                  color: isSelected ? primary : dark500,
                  size: 22,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -6,
                    top: -4,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: errorCol,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$badgeCount',
                          style: const TextStyle(
                            color: light,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'HankenGrotesk',
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? primary : dark500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
