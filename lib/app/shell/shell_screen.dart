import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import '../home/home_screen.dart';
import '../appointment/appointment_screen.dart';
import '../chat/chat_screen.dart';
import '../notifications/notifications_screen.dart';
import '../profile/profile_screen.dart';
import 'shell_controller.dart';

class ShellScreen extends StatelessWidget {
  const ShellScreen({super.key});

  static const _screens = [
    HomeScreen(),
    AppointmentScreen(),
    ChatScreen(),
    NotificationsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ShellController());

    return Scaffold(
      backgroundColor: Colors.transparent,
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
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(controller, 0, Icons.home_rounded, Icons.home_outlined, 'Home'),
                _navItem(controller, 1, Icons.calendar_month_rounded, Icons.calendar_month_outlined, 'Book'),
                _navItem(controller, 2, Icons.chat_rounded, Icons.chat_outlined, 'Chat'),
                _navItemWithBadge(controller, 3, Icons.notifications_rounded, Icons.notifications_outlined, 'Alerts', controller.unreadCount),
                _navItem(controller, 4, Icons.person_rounded, Icons.person_outlined, 'Profile'),
              ],
            )),
          ),
        ),
      ),
    );
  }

  Widget _navItem(ShellController controller, int i, IconData active, IconData inactive, String label) {
    final isSelected = controller.index.value == i;
    return GestureDetector(
      onTap: () => controller.changeIndex(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: .1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(isSelected ? active : inactive, color: isSelected ? primary : dark500, size: 22),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 10, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? primary : dark500)),
        ]),
      ),
    );
  }

  Widget _navItemWithBadge(ShellController controller, int i, IconData active, IconData inactive, String label, int badge) {
    final isSelected = controller.index.value == i;
    return GestureDetector(
      onTap: () => controller.changeIndex(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primary.withValues(alpha: .1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(clipBehavior: Clip.none, children: [
            Icon(isSelected ? active : inactive, color: isSelected ? primary : dark500, size: 22),
            if (badge > 0)
              Positioned(right: -6, top: -4,
                child: Container(
                  width: 16, height: 16,
                  decoration: const BoxDecoration(color: errorCol, shape: BoxShape.circle),
                  child: Center(child: Text('$badge', style: const TextStyle(color: light, fontSize: 9, fontWeight: FontWeight.w700))),
                )),
          ]),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 10, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400, color: isSelected ? primary : dark500)),
        ]),
      ),
    );
  }
}
