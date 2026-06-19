import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/model/sample_data.dart';
import '../utility/theme.dart';
import 'history_controller.dart';

class HistoryScreen extends StatefulWidget {
  final int initialTab;
  const HistoryScreen({super.key, this.initialTab = 0});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Inject HistoryController
    final controller = Get.put(HistoryController());

    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. Custom Header Widget
            const HistoryHeaderWidget(),
            const SizedBox(height: 10),

            // 2. Tabs Selector
            HistoryTabsWidget(tabController: _tab),
            const SizedBox(height: 10),

            // 3. Tab Body content
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  const HistoryPrescriptionsTabWidget(),
                  HistoryReportsTabWidget(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── History Header Widget ───────────────────────────────────────
class HistoryHeaderWidget extends StatelessWidget {
  const HistoryHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Safe & styled back button
            CircleAvatar(
              backgroundColor: light.withValues(alpha: 0.6),
              radius: 18,
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: dark),
                padding: EdgeInsets.zero,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'My Health Records',
              style: TextStyle(fontFamily: 'KronaOne', fontSize: 16, color: dark),
            ),
          ],
        ),
      ),
    );
  }
}

// ── History Tabs Selector Widget ────────────────────────────────
class HistoryTabsWidget extends StatelessWidget {
  final TabController tabController;

  const HistoryTabsWidget({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(4),
        child: TabBar(
          controller: tabController,
          labelStyle: const TextStyle(fontFamily: 'HankenGrotesk', fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'HankenGrotesk', fontSize: 13),
          labelColor: light,
          unselectedLabelColor: dark500,
          indicator: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          tabs: const [Tab(text: 'Prescriptions'), Tab(text: 'Reports')],
        ),
      ),
    );
  }
}

// ── History Prescriptions List Widget ───────────────────────────
class HistoryPrescriptionsTabWidget extends StatelessWidget {
  const HistoryPrescriptionsTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: PatientData.consultHistory.length,
      itemBuilder: (_, i) {
        final c = PatientData.consultHistory[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row containing Date, Diagnosis title & Doctor badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c['date']!, style: TStyle.small),
                          const SizedBox(height: 2),
                          Text(
                            c['diagnosis']!,
                            style: TStyle.h3,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: primary.withValues(alpha: .3)),
                      ),
                      child: Text(
                        c['doctor']!,
                        style: const TextStyle(
                          fontFamily: 'HankenGrotesk',
                          fontSize: 10,
                          color: primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 16),

                // Horizontal scrollable Vitals readings
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: (c['vitals'] as Map<String, String>).entries.map((e) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: black300, borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Text(
                              e.value,
                              style: const TextStyle(
                                fontFamily: 'HankenGrotesk',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: dark,
                              ),
                            ),
                            Text(e.key, style: TStyle.small),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),

                // Logged symptoms list
                const Text('Symptoms', style: TStyle.label),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (c['symptoms'] as List).map<Widget>((s) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFCC80)),
                      ),
                      child: Text(
                        s as String,
                        style: const TextStyle(
                          fontFamily: 'HankenGrotesk',
                          fontSize: 11,
                          color: Color(0xFFE65100),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Prescribed medications
                const Text('Medicines prescribed', style: TStyle.label),
                const SizedBox(height: 8),
                ...(c['medicines'] as List).map<Widget>((m) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: light.withValues(alpha: .7),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: black200),
                      ),
                      child: Row(
                        children: [
                          const Text('💊', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(m['name']!, style: TStyle.label),
                                const SizedBox(height: 2),
                                Text('${m['dose']} · ${m['freq']} · ${m['dur']}', style: TStyle.small),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                // Extra advice/notes
                if ((c['advice'] as String).isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFA5D6A7)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline_rounded, size: 16, color: success),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            c['advice']!,
                            style: const TextStyle(
                              fontFamily: 'HankenGrotesk',
                              fontSize: 12,
                              color: Color(0xFF1B5E20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Scheduled follow-up date
                if (c['followUp'] != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.event_rounded, size: 15, color: primary),
                      const SizedBox(width: 6),
                      Text(
                        'Follow-up: ${c['followUp']}',
                        style: const TextStyle(
                          fontFamily: 'HankenGrotesk',
                          fontSize: 12,
                          color: primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── History Reports List Widget ─────────────────────────────────
class HistoryReportsTabWidget extends StatelessWidget {
  final HistoryController controller;

  const HistoryReportsTabWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: PatientData.reports.length,
      itemBuilder: (_, i) {
        final r = PatientData.reports[i];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: primary.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      r['icon']!,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r['name']!, style: TStyle.h3),
                      const SizedBox(height: 3),
                      Text('${r['type']}  •  ${r['date']}', style: TStyle.small),
                      Text(r['size']!, style: TStyle.small),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => controller.showDownloadSnack(context, r['name']!),
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: .1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.download_rounded, color: primary, size: 18),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
