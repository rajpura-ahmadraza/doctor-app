import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/model/sample_data.dart';
import '../utility/theme.dart';
import '../appointment/appointment_screen.dart';
import '../chat/chat_screen.dart';
import '../history/history_screen.dart';
import '../notifications/notifications_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    controller.updateUnreadCount(); // update unread count whenever home is built

    final p = controller.patient;
    final upcoming = controller.upcomingAppointment;

    return AppScaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: GlassCard(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                        color: primary.withValues(alpha: .15),
                        shape: BoxShape.circle),
                    child: const Center(
                        child: Text('R',
                            style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                                fontFamily: 'HankenGrotesk'))),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                        Text('Good morning 👋', style: TStyle.small),
                        Obx(() => Text(p['name']!, style: TStyle.h3)),
                      ])),
                  Stack(children: [
                    IconButton(
                        onPressed: () => Get.to(() => const NotificationsScreen()),
                        icon: const Icon(Icons.notifications_outlined,
                            color: dark)),
                    Obx(() {
                      final count = controller.unreadNotificationsCount.value;
                      if (count > 0) {
                        return Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                  color: errorCol, shape: BoxShape.circle),
                              child: Center(
                                  child: Text('$count',
                                      style: const TextStyle(
                                          color: light,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700))),
                            ));
                      }
                      return const SizedBox.shrink();
                    }),
                  ]),
                ]),
              ),
            )),

            // Patient card
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [primary, primary2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        color: primary.withValues(alpha: .35),
                        blurRadius: 20,
                        offset: const Offset(0, 8))
                  ],
                ),
                child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Patient ID',
                                style: TextStyle(
                                    fontFamily: 'HankenGrotesk',
                                    color: Colors.white70,
                                    fontSize: 11)),
                            const Icon(Icons.medical_information_outlined,
                                color: Colors.white54, size: 20),
                          ]),
                      const SizedBox(height: 4),
                      Text(p['rm']!,
                          style: const TextStyle(
                              fontFamily: 'HankenGrotesk',
                              color: light,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1)),
                      const SizedBox(height: 14),
                      Text(p['name']!,
                          style: const TextStyle(
                              fontFamily: 'HankenGrotesk',
                              color: light,
                              fontSize: 18,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 6),
                      Row(children: [
                        _cardChip(p['age']!),
                        const SizedBox(width: 8),
                        _cardChip(p['gender']!),
                        const SizedBox(width: 8),
                        _cardChip(p['blood']!),
                      ]),
                      const SizedBox(height: 14),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(p['doctor']!,
                                style: const TextStyle(
                                    fontFamily: 'HankenGrotesk',
                                    color: Colors.white70,
                                    fontSize: 12)),
                            Text(p['clinic']!,
                                style: const TextStyle(
                                    fontFamily: 'HankenGrotesk',
                                    color: Colors.white70,
                                    fontSize: 12)),
                          ]),
                    ])),
              ),
            )),

            // Quick actions
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionHeader(title: 'Quick access'),
                    const SizedBox(height: 12),
                    Row(children: [
                      _quickBtn(
                          context,
                          Icons.history_rounded,
                          'Medical\nHistory',
                          () => Get.to(() => const HistoryScreen())),
                      const SizedBox(width: 10),
                      _quickBtn(
                          context,
                          Icons.calendar_month_rounded,
                          'Book\nAppointment',
                          () => Get.to(() => const AppointmentScreen())),
                      const SizedBox(width: 10),
                      _quickBtn(
                          context,
                          Icons.chat_outlined,
                          'Message\nDoctor',
                          () => Get.to(() => const ChatScreen())),
                      const SizedBox(width: 10),
                      _quickBtn(
                          context,
                          Icons.folder_outlined,
                          'My\nReports',
                          () => Get.to(() => const HistoryScreen(initialTab: 1))),
                    ]),
                  ]),
            )),

            // Upcoming appointment
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                        title: 'Upcoming appointment',
                        action: 'Book new',
                        onAction: () => Get.to(() => const AppointmentScreen())),
                    const SizedBox(height: 12),
                    GlassCard(
                        child: Obx(() => Row(children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: primary.withValues(alpha: .12),
                            borderRadius: BorderRadius.circular(14)),
                        child: const Icon(Icons.calendar_today_rounded,
                            color: primary, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(upcoming['doctor']!, style: TStyle.h3),
                            const SizedBox(height: 3),
                            Text('${upcoming['date']}  •  ${upcoming['time']}',
                                style: TStyle.bodyMuted),
                            const SizedBox(height: 3),
                            Text(upcoming['type']!, style: TStyle.small),
                          ])),
                      StatusBadge(
                          label: upcoming['status']!,
                          bg: const Color(0xFFE8F5E9),
                          fg: success),
                    ]))),
                  ]),
            )),

            // Last vitals
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                        title: 'Last recorded vitals',
                        action: 'View history',
                        onAction: () => Get.to(() => const HistoryScreen())),
                    const SizedBox(height: 12),
                    GlassCard(
                        child: Column(children: [
                      Row(children: [
                        _vitalBox('BP', '118/76', 'mmHg'),
                        _divider(),
                        _vitalBox('Pulse', '88', 'bpm'),
                        _divider(),
                        _vitalBox('Temp', '38.5', '°C'),
                      ]),
                      const Divider(height: 20),
                      Row(children: [
                        _vitalBox('SpO₂', '97', '%'),
                        _divider(),
                        _vitalBox('Weight', '72', 'kg'),
                        _divider(),
                        _vitalBox('Visit', '28 May', '2025'),
                      ]),
                    ])),
                  ]),
            )),

            // Recent prescription
            SliverToBoxAdapter(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                        title: 'Recent prescription',
                        action: 'View all',
                        onAction: () => Get.to(() => const HistoryScreen())),
                    const SizedBox(height: 12),
                    GlassCard(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('28 May 2025', style: TStyle.small),
                          const SizedBox(height: 4),
                          Text('Viral fever with cough', style: TStyle.h3),
                          const Divider(height: 16),
                          ...PatientData.consultHistory.first['medicines']
                              .take(3)
                              .map<Widget>((m) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('💊',
                                              style: TextStyle(fontSize: 14)),
                                          const SizedBox(width: 8),
                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                Text(m['name']!,
                                                    style: TStyle.label),
                                                Text(
                                                    '${m['dose']} • ${m['freq']} • ${m['dur']}',
                                                    style: TStyle.small),
                                              ])),
                                        ]),
                                  )),
                        ])),
                  ]),
            )),
          ],
        ),
      ),
    );
  }

  Widget _quickBtn(
      BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(children: [
            Icon(icon, color: primary, size: 24),
            const SizedBox(height: 6),
            Text(label,
                style: const TextStyle(
                    fontFamily: 'HankenGrotesk',
                    fontSize: 10,
                    color: dark,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }

  Widget _vitalBox(String label, String value, String unit) {
    return Expanded(
        child: Column(children: [
      Text(label, style: TStyle.small),
      const SizedBox(height: 4),
      Text(value,
          style: const TextStyle(
              fontFamily: 'HankenGrotesk',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: dark)),
      Text(unit, style: TStyle.small),
    ]));
  }

  Widget _divider() => Container(width: 1, height: 40, color: black200);

  Widget _cardChip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
            color: Colors.white24, borderRadius: BorderRadius.circular(20)),
        child: Text(label,
            style: const TextStyle(
                fontFamily: 'HankenGrotesk', fontSize: 11, color: light)),
      );
}
