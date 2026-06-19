import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import 'notifications_controller.dart';

/// ── Notifications Screen ────────────────────────────────────────────────────
/// Main entry point for the patient portal notifications screen.
/// Renders a responsive header, category selection filters, and a list of active alerts.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject and initialize the NotificationsController
    final controller = Get.put(NotificationsController());

    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. App Bar Header Widget (displays title, unread count, and back button)
            NotificationsHeaderWidget(controller: controller),
            const SizedBox(height: 10),

            // 2. Horizontal selection filters (All, Follow-up, Medicine, etc.)
            NotificationsFilterChipsWidget(controller: controller),
            const SizedBox(height: 10),

            // 3. Dynamic content list containing notification card rows or empty states
            Expanded(
              child: NotificationsListWidget(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

/// ── Notifications Header Widget ─────────────────────────────────────────────
/// Renders the screen top-bar containing navigation, page title, reactive unread count,
/// and quick-action "Mark all read" controls.
class NotificationsHeaderWidget extends StatelessWidget {
  final NotificationsController controller;

  const NotificationsHeaderWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            const SizedBox(width: 8),

            // Responsive title column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontFamily: 'KronaOne',
                      fontSize: 16,
                      color: dark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Obx(() {
                    final unread = controller.unreadCount;
                    if (unread > 0) {
                      return Text('$unread unread', style: TStyle.small);
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),

            // Quick trigger button to mark all notifications as read
            Obx(() {
              final unread = controller.unreadCount;
              if (unread > 0) {
                return TextButton(
                  onPressed: controller.markAllRead,
                  style: TextButton.styleFrom(
                    foregroundColor: primary,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Mark all read',
                    style: TextStyle(
                      fontFamily: 'HankenGrotesk',
                      fontSize: 12,
                      color: primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        ),
      ),
    );
  }
}

/// ── Notifications Filter Chips Widget ────────────────────────────────────────
class NotificationsFilterChipsWidget extends StatelessWidget {
  final NotificationsController controller;

  const NotificationsFilterChipsWidget({
    super.key,
    required this.controller,
  });

  // Dynamic helper mapping icons to notification categories
  IconData _getIconForFilter(String filterName) {
    switch (filterName) {
      case 'All':
        return Icons.grid_view_rounded;
      case 'Follow-up':
        return Icons.repeat_rounded;
      case 'Vaccination':
        return Icons.vaccines_rounded;
      case 'Medicine':
        return Icons.medication_rounded;
      case 'Report':
        return Icons.description_rounded;
      case 'Appointment':
        return Icons.calendar_month_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48, // Accommodates the larger pill layouts and floating shadows
      child: Obx(() {
        // Evaluate reactive list updates to rebuild counts
        final notificationsList = controller.notifications;

        return ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: controller.filters.map((f) {
            final isSelected = controller.filter.value == f;
            final icon = _getIconForFilter(f);

            // Compute unread count for this filter dynamically
            final unreadCount = notificationsList.where((n) {
              if (f == 'All') return n['read'] == false;
              return (n['type'] as String).toLowerCase() == f.toLowerCase() && n['read'] == false;
            }).length;

            return GestureDetector(
              onTap: () => controller.filter.value = f,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(right: 10, bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [primary, primary2],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : light.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : black200.withValues(alpha: 0.6),
                    width: 1,
                  ),
                  boxShadow: isSelected
                      ? []
                      : [
                          BoxShadow(
                            color: dark.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TweenAnimationBuilder<Color?>(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      tween: ColorTween(
                        begin: isSelected ? primary : light,
                        end: isSelected ? light : primary,
                      ),
                      builder: (context, color, child) {
                        return Icon(
                          icon,
                          size: 15,
                          color: color,
                        );
                      },
                    ),
                    const SizedBox(width: 6),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      style: TextStyle(
                        fontFamily: 'HankenGrotesk',
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? light : dark.withValues(alpha: 0.8),
                      ),
                      child: Text(f),
                    ),
                    if (unreadCount > 0) ...[
                      const SizedBox(width: 6),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: isSelected ? light : primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          style: TextStyle(
                            fontFamily: 'HankenGrotesk',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? primary : light,
                          ),
                          child: Text('$unreadCount'),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }
}

/// ── Notifications List Widget ───────────────────────────────────────────────
/// List observer rendering notification cards based on selected filter.
/// Shows a clean placeholder screen when no updates match the chosen criteria.
class NotificationsListWidget extends StatelessWidget {
  final NotificationsController controller;

  const NotificationsListWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.filteredNotifications;

      // Empty state placeholder
      if (list.isEmpty) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🔔', style: TextStyle(fontSize: 48)),
              SizedBox(height: 12),
              Text('No notifications', style: TStyle.h3),
              SizedBox(height: 4),
              Text('You are all caught up!', style: TStyle.bodyMuted),
            ],
          ),
        );
      }

      // Populate matching records in standard list
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (_, i) => NotificationCardWidget(
          controller: controller,
          notificationData: Map<String, dynamic>.from(list[i]),
        ),
      );
    });
  }
}

/// ── Notification Card Widget ────────────────────────────────────────────────
/// Repetitive list item card representing individual alerts.
/// Displays unique styles, custom category labels, and action states.
class NotificationCardWidget extends StatelessWidget {
  final NotificationsController controller;
  final Map<String, dynamic> notificationData;

  const NotificationCardWidget({
    super.key,
    required this.controller,
    required this.notificationData,
  });

  @override
  Widget build(BuildContext context) {
    final isUnread = notificationData['read'] == false;
    final type = notificationData['type'] as String? ?? '';
    final title = notificationData['title'] as String? ?? '';
    final body = notificationData['body'] as String? ?? '';
    final time = notificationData['time'] as String? ?? '';
    final icon = notificationData['icon'] as String? ?? '🔔';
    final colors = _typeColor(type);

    return GestureDetector(
      onTap: () => controller.markRead(notificationData),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUnread ? colors.bg.withValues(alpha: .06) : light.withValues(alpha: .5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isUnread ? colors.bg.withValues(alpha: .3) : black200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Circular container with type icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colors.bg.withValues(alpha: .12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  icon,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Content detailing notification payload
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'HankenGrotesk',
                            fontSize: 13,
                            fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                            color: dark,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: TStyle.bodyMuted,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Metadata row displaying type badge and timestamp
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: colors.bg.withValues(alpha: .12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _typeLabel(type),
                          style: TextStyle(
                            fontFamily: 'HankenGrotesk',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: colors.bg,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(time, style: TStyle.small),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to calculate background/foreground colors based on alert type
  ({Color bg, Color fg}) _typeColor(String type) {
    return switch (type) {
      'followup' => (bg: primary, fg: light),
      'vaccination' => (bg: const Color(0xFF4CAF50), fg: light),
      'medicine' => (bg: orange, fg: light),
      'report' => (bg: const Color(0xFF2196F3), fg: light),
      'appointment' => (bg: success, fg: light),
      'message' => (bg: primary2, fg: light),
      _ => (bg: dark500, fg: light),
    };
  }

  /// Formats category type string to capitalised labels
  String _typeLabel(String type) {
    return switch (type) {
      'followup' => 'Follow-up',
      'vaccination' => 'Vaccination',
      'medicine' => 'Medicine',
      'report' => 'Report',
      'appointment' => 'Appointment',
      'message' => 'Message',
      _ => type,
    };
  }
}
