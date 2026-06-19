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
    // Inject HomeController to manage and retrieve active patient and notification states
    final controller = Get.put(HomeController());
    controller.updateUnreadCount(); // update unread count whenever home is built

    final p = controller.patient;
    final upcoming = controller.upcomingAppointment;

    return AppScaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Custom Greeting Header Widget (Replaces traditional App Bar)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: HomeHeaderWidget(controller: controller),
              ),
            ),

            // Patient Identity & Medical Info Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Obx(() => PatientInfoCardWidget(patientData: Map<String, String>.from(p))),
              ),
            ),

            // Quick Access Routing grid
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: QuickAccessGridWidget(),
              ),
            ),

            // Upcoming Scheduled Appointment Info Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: Obx(() => UpcomingAppointmentCardWidget(upcomingData: Map<String, dynamic>.from(upcoming))),
              ),
            ),

            // Latest Patient Vitals Card
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: VitalsCardWidget(),
              ),
            ),

            // Recent Prescriptions List Card
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 24),
                child: RecentPrescriptionCardWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Custom Header Widget (Home Screen) ──────────────────────────
class HomeHeaderWidget extends StatelessWidget {
  final HomeController controller;

  const HomeHeaderWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final p = controller.patient;

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Circular Avatar with patient initial
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: primary.withValues(alpha: .15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Obx(() {
                final name = p['name'] ?? '';
                final initial = name.isNotEmpty ? name[0] : 'P';
                return Text(
                  initial,
                  style: const TextStyle(
                    color: primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    fontFamily: 'HankenGrotesk',
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 10),
          // Welcoming message & Patient Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Good morning 👋', style: TStyle.small),
                Obx(() => Text(
                      p['name'] ?? 'Patient',
                      style: TStyle.h3,
                    )),
              ],
            ),
          ),
          // Notification Bell Icon with Badge
          Stack(
            children: [
              IconButton(
                onPressed: () => Get.to(() => const NotificationsScreen()),
                icon: const Icon(Icons.notifications_outlined, color: dark),
              ),
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
                        color: errorCol,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$count',
                          style: const TextStyle(
                            color: light,
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Patient Identification Card Widget ─────────────────────────
class PatientInfoCardWidget extends StatelessWidget {
  final Map<String, String> patientData;

  const PatientInfoCardWidget({
    super.key,
    required this.patientData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [primary, primary2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: .35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Patient ID',
                style: TextStyle(
                  fontFamily: 'HankenGrotesk',
                  color: Colors.white70,
                  fontSize: 11,
                ),
              ),
              Icon(Icons.medical_information_outlined, color: Colors.white54, size: 20),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            patientData['rm'] ?? 'N/A',
            style: const TextStyle(
              fontFamily: 'HankenGrotesk',
              color: light,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            patientData['name'] ?? 'N/A',
            style: const TextStyle(
              fontFamily: 'HankenGrotesk',
              color: light,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          // Chips for Age, Gender, and Blood type
          Row(
            children: [
              _buildCardChip(patientData['age'] ?? ''),
              const SizedBox(width: 8),
              _buildCardChip(patientData['gender'] ?? ''),
              const SizedBox(width: 8),
              _buildCardChip(patientData['blood'] ?? ''),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                patientData['doctor'] ?? 'N/A',
                style: const TextStyle(
                  fontFamily: 'HankenGrotesk',
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
              Text(
                patientData['clinic'] ?? 'N/A',
                style: const TextStyle(
                  fontFamily: 'HankenGrotesk',
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Styled white semi-transparent chips for inside the patient card
  Widget _buildCardChip(String label) {
    if (label.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'HankenGrotesk',
          fontSize: 11,
          color: light,
        ),
      ),
    );
  }
}

// ── Quick Access Widget (Home Screen Actions) ───────────────────
class QuickAccessGridWidget extends StatelessWidget {
  const QuickAccessGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Quick access'),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildQuickBtn(
              context,
              Icons.history_rounded,
              'Medical\nHistory',
              () => Get.to(() => const HistoryScreen()),
            ),
            const SizedBox(width: 10),
            _buildQuickBtn(
              context,
              Icons.calendar_month_rounded,
              'Book\nAppointment',
              () => Get.to(() => const AppointmentScreen()),
            ),
            const SizedBox(width: 10),
            _buildQuickBtn(
              context,
              Icons.chat_outlined,
              'Message\nDoctor',
              () => Get.to(() => const ChatScreen()),
            ),
            const SizedBox(width: 10),
            _buildQuickBtn(
              context,
              Icons.folder_outlined,
              'My\nReports',
              () => Get.to(() => const HistoryScreen(initialTab: 1)),
            ),
          ],
        ),
      ],
    );
  }

  // Individual button builder for quick access items
  Widget _buildQuickBtn(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: GlassCard(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: primary, size: 24),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'HankenGrotesk',
                  fontSize: 10,
                  color: dark,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Upcoming Appointment Card Widget ───────────────────────────
class UpcomingAppointmentCardWidget extends StatelessWidget {
  final Map<String, dynamic> upcomingData;

  const UpcomingAppointmentCardWidget({
    super.key,
    required this.upcomingData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Upcoming appointment',
          action: 'Book new',
          onAction: () => Get.to(() => const AppointmentScreen()),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: primary.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.calendar_today_rounded, color: primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text((upcomingData['doctor'] ?? 'No Doctor Assigned').toString(), style: TStyle.h3),
                    const SizedBox(height: 3),
                    Text(
                      '${upcomingData['date'] ?? ''}  •  ${upcomingData['time'] ?? ''}',
                      style: TStyle.bodyMuted,
                    ),
                    const SizedBox(height: 3),
                    Text(upcomingData['type']?.toString() ?? '', style: TStyle.small),
                  ],
                ),
              ),
              StatusBadge(
                label: (upcomingData['status'] ?? 'Scheduled').toString(),
                bg: const Color(0xFFE8F5E9),
                fg: success,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Latest Patient Vitals Card Widget ──────────────────────────
class VitalsCardWidget extends StatelessWidget {
  const VitalsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Last recorded vitals',
          action: 'View history',
          onAction: () => Get.to(() => const HistoryScreen()),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            children: [
              Row(
                children: [
                  _vitalBox('BP', '118/76', 'mmHg'),
                  _buildDivider(),
                  _vitalBox('Pulse', '88', 'bpm'),
                  _buildDivider(),
                  _vitalBox('Temp', '38.5', '°C'),
                ],
              ),
              const Divider(height: 20),
              Row(
                children: [
                  _vitalBox('SpO₂', '97', '%'),
                  _buildDivider(),
                  _vitalBox('Weight', '72', 'kg'),
                  _buildDivider(),
                  _vitalBox('Visit', '28 May', '2025'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Vital block displayer
  Widget _vitalBox(String label, String value, String unit) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: TStyle.small),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'HankenGrotesk',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: dark,
            ),
          ),
          Text(unit, style: TStyle.small),
        ],
      ),
    );
  }

  Widget _buildDivider() => Container(width: 1, height: 40, color: black200);
}

// ── Recent Prescription Card Widget ────────────────────────────
class RecentPrescriptionCardWidget extends StatelessWidget {
  const RecentPrescriptionCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recent prescription',
          action: 'View all',
          onAction: () => Get.to(() => const HistoryScreen()),
        ),
        const SizedBox(height: 12),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('28 May 2025', style: TStyle.small),
              const SizedBox(height: 4),
              const Text('Viral fever with cough', style: TStyle.h3),
              const Divider(height: 16),
              ...PatientData.consultHistory.first['medicines'].take(3).map<Widget>((m) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('💊', style: TextStyle(fontSize: 14)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m['name']!, style: TStyle.label),
                              Text(
                                '${m['dose']} • ${m['freq']} • ${m['dur']}',
                                style: TStyle.small,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
