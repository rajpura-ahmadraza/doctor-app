import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import 'notifications_controller.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationsController());

    return AppScaffold(
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(children: [
                IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18)),
                const SizedBox(width: 4),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Notifications', style: TStyle.h3),
                  Obx(() {
                    final unread = controller.unreadCount;
                    if (unread > 0) {
                      return Text('$unread unread', style: TStyle.small);
                    }
                    return const SizedBox.shrink();
                  }),
                ])),
                Obx(() {
                  final unread = controller.unreadCount;
                  if (unread > 0) {
                    return TextButton(
                      onPressed: controller.markAllRead,
                      style: TextButton.styleFrom(foregroundColor: primary, padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: const Text('Mark all read', style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 12, color: primary)),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ]),
            ),
          ),
          const SizedBox(height: 10),

          // Filter chips
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: controller.filters.map((f) => GestureDetector(
                onTap: () => controller.filter.value = f,
                child: Obx(() {
                  final isSelected = controller.filter.value == f;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? primary : light,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? primary : black200),
                    ),
                    child: Text(f, style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 12, fontWeight: FontWeight.w500, color: isSelected ? light : dark)),
                  );
                }),
              )).toList(),
            ),
          ),
          const SizedBox(height: 10),

          // List
          Expanded(
            child: Obx(() {
              final list = controller.filteredNotifications;
              if (list.isEmpty) {
                return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('🔔', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text('No notifications', style: TStyle.h3),
                  const SizedBox(height: 4),
                  Text('You are all caught up!', style: TStyle.bodyMuted),
                ]));
              }
              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _notifCard(controller, list[i], i),
              );
            }),
          ),
        ]),
      ),
    );
  }

  Widget _notifCard(NotificationsController controller, Map<String, dynamic> n, int i) {
    final isUnread = n['read'] == false;
    final color = _typeColor(n['type'] as String);

    return GestureDetector(
      onTap: () => controller.markRead(n),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnread ? color.$1.withValues(alpha: .06) : light.withValues(alpha: .5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isUnread ? color.$1.withValues(alpha: .3) : black200),
        ),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Icon circle
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: color.$1.withValues(alpha: .12), shape: BoxShape.circle),
            child: Center(child: Text(n['icon']!, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(n['title']!, style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 13, fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500, color: dark))),
              if (isUnread)
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: primary, shape: BoxShape.circle)),
            ]),
            const SizedBox(height: 4),
            Text(n['body']!, style: TStyle.bodyMuted, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: color.$1.withValues(alpha: .12), borderRadius: BorderRadius.circular(6)),
                child: Text(_typeLabel(n['type'] as String), style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 10, fontWeight: FontWeight.w600, color: color.$1)),
              ),
              const SizedBox(width: 8),
              Text(n['time']!, style: TStyle.small),
            ]),
          ])),
        ]),
      ),
    );
  }

  (Color, Color) _typeColor(String type) {
    return switch (type) {
      'followup'    => (primary, light),
      'vaccination' => (const Color(0xFF4CAF50), light),
      'medicine'    => (orange, light),
      'report'      => (const Color(0xFF2196F3), light),
      'appointment' => (success, light),
      'message'     => (primary2, light),
      _             => (dark500, light),
    };
  }

  String _typeLabel(String type) {
    return switch (type) {
      'followup'    => 'Follow-up',
      'vaccination' => 'Vaccination',
      'medicine'    => 'Medicine',
      'report'      => 'Report',
      'appointment' => 'Appointment',
      'message'     => 'Message',
      _             => type,
    };
  }
}
