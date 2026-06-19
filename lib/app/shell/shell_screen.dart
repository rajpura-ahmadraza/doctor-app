import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
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
          _showExitDialog(context);
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

  // Beautiful custom exit application dialog
  void _showExitDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Circular exit app warning badge
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: errorCol.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.power_settings_new_rounded,
                    color: errorCol,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title styled with KronaOne typography
              const Text(
                'Exit App?',
                style: TextStyle(
                  fontFamily: 'KronaOne',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: dark,
                ),
              ),
              const SizedBox(height: 8),

              // Dialog description text
              const Text(
                'Are you sure you want to close and exit the ClinixPro application?',
                style: TStyle.bodyMuted,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Dual button action controls
              Row(
                children: [
                  // Cancel Exit button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: black200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'HankenGrotesk',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: dark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Exit app confirmation button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: errorCol,
                        foregroundColor: light,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Exit',
                        style: TextStyle(
                          fontFamily: 'HankenGrotesk',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: light,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
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
