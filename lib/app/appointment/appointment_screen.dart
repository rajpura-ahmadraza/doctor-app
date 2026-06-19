import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../utility/model/sample_data.dart';
import '../utility/theme.dart';
import '../utility/dialogs.dart';
import 'appointment_controller.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});
  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Inject AppointmentController
    final controller = Get.put(AppointmentController());

    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 1. Custom Header Widget
            const AppointmentHeaderWidget(),
            SizedBox(
              height: Get.height / 75.6,
            ),

            // 2. Tab Bar Selector
            AppointmentTabsWidget(tabController: _tab),
            SizedBox(
              height: Get.height / 75.6,
            ),

            // 3. Tab Body
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  AppointmentBookingTabWidget(
                    controller: controller,
                    parentContext: context,
                  ),
                  AppointmentHistoryTabWidget(
                    parentContext: context,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Appointment Header Widget ───────────────────────────────────
class AppointmentHeaderWidget extends StatelessWidget {
  const AppointmentHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        Get.height / 47.25,
        Get.height / 63,
        Get.height / 47.25,
        0,
      ),
      child: GlassCard(
        padding: EdgeInsets.symmetric(
          horizontal: Get.height / 50.4,
          vertical: Get.height / 63,
        ),
        child: Row(
          children: [
            Text(
              'Appointments',
              style: TextStyle(
                fontFamily: 'KronaOne',
                fontSize: Get.height / 47.25,
                color: dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Appointment Tabs Widget ─────────────────────────────────────
class AppointmentTabsWidget extends StatelessWidget {
  final TabController tabController;

  const AppointmentTabsWidget({
    super.key,
    required this.tabController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Get.height / 47.25,
      ),
      child: GlassCard(
        padding: EdgeInsets.all(
          Get.height / 189,
        ),
        child: TabBar(
          controller: tabController,
          labelStyle: TextStyle(
            fontFamily: 'HankenGrotesk',
            fontSize: Get.height / 58.15,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: 'HankenGrotesk',
            fontSize: Get.height / 58.15,
          ),
          labelColor: light,
          unselectedLabelColor: dark500,
          indicator: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(
              Get.height / 63,
            ),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Book New'),
            Tab(
              text: 'My Appointments',
            )
          ],
        ),
      ),
    );
  }
}

// ── Appointment Booking Flow Tab Widget ─────────────────────────
class AppointmentBookingTabWidget extends StatelessWidget {
  final AppointmentController controller;
  final BuildContext parentContext;

  const AppointmentBookingTabWidget({
    super.key,
    required this.controller,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        Get.height / 47.25,
        0,
        Get.height / 47.25,
        Get.height / 31.5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Branding Info Card
          GlassCard(
            child: Row(
              children: [
                CircleAvatar(
                  radius: Get.height / 30.24,
                  backgroundColor: const Color(0xFFECEBFF),
                  child: Center(
                    child: Text(
                      'P',
                      style: TextStyle(
                        fontFamily: 'HankenGrotesk',
                        fontSize: Get.height / 37.8,
                        fontWeight: FontWeight.w700,
                        color: primary,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Get.height / 63,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dr. Priya Sharma',
                        style: TStyle.h3,
                      ),
                      const Text(
                        'MBBS, MD • ClinixPro Clinic',
                        style: TStyle.small,
                      ),
                      SizedBox(
                        height: Get.height / 189,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: const Color(0xFFFFB300),
                            size: Get.height / 54,
                          ),
                          SizedBox(
                            width: Get.height / 189,
                          ),
                          const Text(
                            '4.9 • 200+ patients',
                            style: TStyle.small,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹500',
                      style: TextStyle(
                        fontFamily: 'HankenGrotesk',
                        fontSize: Get.height / 47.25,
                        fontWeight: FontWeight.w700,
                        color: dark,
                      ),
                    ),
                    const Text(
                      'per visit',
                      style: TStyle.small,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: Get.height / 54,
          ),

          // Visit type selector
          const Text(
            'Visit type',
            style: TStyle.h3,
          ),
          SizedBox(
            height: Get.height / 94.5,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: controller.types.map((t) {
                return GestureDetector(
                  onTap: () => controller.selectType(t),
                  child: Obx(() {
                    final isSelected = controller.selectedType.value == t;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: EdgeInsets.only(
                        right: Get.height / 94.5,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Get.height / 54,
                        vertical: Get.height / 94.5,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? primary : light,
                        borderRadius: BorderRadius.circular(
                          Get.height / 37.8,
                        ),
                        border: Border.all(
                          color: isSelected ? primary : black200,
                        ),
                      ),
                      child: Text(
                        t,
                        style: TextStyle(
                          fontFamily: 'HankenGrotesk',
                          fontSize: Get.height / 63,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? light : dark,
                        ),
                      ),
                    );
                  }),
                );
              }).toList(),
            ),
          ),
          SizedBox(
            height: Get.height / 47.25,
          ),

          // Date picker list
          const Text(
            'Select date',
            style: TStyle.h3,
          ),
          SizedBox(
            height: Get.height / 94.5,
          ),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 14,
              itemBuilder: (_, i) {
                final date = DateTime.now().add(Duration(days: i + 1));
                final isWeekend = date.weekday == DateTime.sunday;
                return GestureDetector(
                  onTap: isWeekend ? null : () => controller.selectDate(date),
                  child: Obx(() {
                    final isSelected = DateFormat('yyyyMMdd').format(date) ==
                        DateFormat('yyyyMMdd').format(controller.selectedDate.value);
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 58,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isWeekend
                            ? black300
                            : isSelected
                                ? primary
                                : light,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isSelected ? primary : black200),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('EEE').format(date),
                            style: TextStyle(
                              fontFamily: 'HankenGrotesk',
                              fontSize: 10,
                              color: isWeekend
                                  ? dark500
                                  : isSelected
                                      ? light
                                      : dark500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('d').format(date),
                            style: TextStyle(
                              fontFamily: 'HankenGrotesk',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isWeekend
                                  ? dark500
                                  : isSelected
                                      ? light
                                      : dark,
                            ),
                          ),
                          Text(
                            DateFormat('MMM').format(date),
                            style: TextStyle(
                              fontFamily: 'HankenGrotesk',
                              fontSize: 10,
                              color: isWeekend
                                  ? dark500
                                  : isSelected
                                      ? light.withValues(alpha: .8)
                                      : dark500,
                            ),
                          ),
                          if (isWeekend)
                            const Text('Closed',
                                style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 8, color: dark500)),
                        ],
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Time Slots selection grid
          const Text('Select time slot', style: TStyle.h3),
          const SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.5,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: PatientData.timeSlots.length,
            itemBuilder: (_, i) {
              final slot = PatientData.timeSlots[i];
              final available = slot['available'] as bool;
              return GestureDetector(
                onTap: available ? () => controller.selectSlot(slot['time']!) : null,
                child: Obx(() {
                  final isSelected = controller.selectedSlot.value == slot['time'];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: !available
                          ? black300
                          : isSelected
                              ? primary
                              : light,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isSelected ? primary : black200),
                    ),
                    child: Center(
                      child: Text(
                        slot['time']!,
                        style: TextStyle(
                          fontFamily: 'HankenGrotesk',
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: !available
                              ? dark500
                              : isSelected
                                  ? light
                                  : dark,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 16),

          // Payment Methods list options
          const Text('Payment method', style: TStyle.h3),
          const SizedBox(height: 8),
          ...[
            ('upi', Icons.account_balance_wallet_outlined, 'UPI', 'GPay, PhonePe, Paytm'),
            ('card', Icons.credit_card_outlined, 'Card', 'Credit / Debit card'),
            ('cash', Icons.money_outlined, 'Pay at clinic', 'Pay when you visit'),
          ].map((p) {
            return GestureDetector(
              onTap: () => controller.selectPayment(p.$1),
              child: Obx(() {
                final isSelected = controller.selectedPayment.value == p.$1;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? primary.withValues(alpha: .08) : light,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? primary : black200, width: isSelected ? 1.5 : 1),
                  ),
                  child: Row(
                    children: [
                      Icon(p.$2, color: isSelected ? primary : dark500, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.$3,
                              style: TextStyle(
                                fontFamily: 'HankenGrotesk',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? primary : dark,
                              ),
                            ),
                            Text(p.$4, style: TStyle.small),
                          ],
                        ),
                      ),
                      if (isSelected) const Icon(Icons.check_circle_rounded, color: primary, size: 20),
                    ],
                  ),
                );
              }),
            );
          }),
          const SizedBox(height: 16),

          // Summarized Confirmation & checkout actions
          Obx(() {
            if (controller.selectedSlot.value != null) {
              return GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Booking summary', style: TStyle.h3),
                    const Divider(height: 16),
                    _buildSummaryRow('Doctor', 'Dr. Priya Sharma'),
                    _buildSummaryRow('Date', DateFormat('dd MMM yyyy').format(controller.selectedDate.value)),
                    _buildSummaryRow('Time', controller.selectedSlot.value!),
                    _buildSummaryRow('Type', controller.selectedType.value),
                    _buildSummaryRow(
                        'Payment',
                        controller.selectedPayment.value == 'cash'
                            ? 'Pay at clinic'
                            : controller.selectedPayment.value.toUpperCase()),
                    const Divider(height: 16),
                    _buildSummaryRow('Consultation fee', '₹500', bold: true),
                    const SizedBox(height: 16),
                    PrimaryBtn(
                      label: controller.selectedPayment.value == 'cash' ? 'Confirm Appointment' : 'Pay ₹500 & Book',
                      loading: controller.booking.value,
                      icon: controller.selectedPayment.value == 'cash' ? Icons.check_rounded : Icons.payment_rounded,
                      onTap: () => controller.confirmBooking(parentContext, () => _showBookingSuccess(controller)),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TStyle.bodyMuted),
            Text(value, style: bold ? TStyle.h3 : TStyle.body),
          ],
        ),
      );

  // Booking success pop up dialog
  void _showBookingSuccess(AppointmentController controller) {
    AppDialogs.showBookingSuccessDialog(
      parentContext,
      controller.selectedDate.value,
      controller.selectedSlot.value ?? '',
    );
  }
}

// ── Appointment History/List Tab Widget ──────────────────────────
class AppointmentHistoryTabWidget extends StatelessWidget {
  final BuildContext parentContext;

  const AppointmentHistoryTabWidget({
    super.key,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: PatientData.appointments.length,
      itemBuilder: (_, i) {
        final a = PatientData.appointments[i];
        final isUpcoming = a['status'] == 'Confirmed';
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StatusBadge(
                      label: a['status']!,
                      bg: isUpcoming ? const Color(0xFFE8F5E9) : black300,
                      fg: isUpcoming ? success : dark500,
                    ),
                    Text(a['fee']!, style: TStyle.h3),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 14, color: primary),
                    const SizedBox(width: 6),
                    Text('${a['date']}  •  ${a['time']}', style: TStyle.body),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.person_outline_rounded, size: 14, color: primary),
                    const SizedBox(width: 6),
                    Text(a['doctor']!, style: TStyle.body),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.medical_services_outlined, size: 14, color: primary),
                    const SizedBox(width: 6),
                    Text(a['type']!, style: TStyle.bodyMuted),
                  ],
                ),
                if (isUpcoming) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showCancelDialog(),
                          icon: const Icon(Icons.cancel_outlined, size: 16, color: errorCol),
                          label: const Text('Cancel',
                              style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 12, color: errorCol)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: errorCol),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.chat_outlined, size: 16),
                          label: const Text('Message', style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 12)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: light,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
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

  // Cancel booking alert confirmation
  void _showCancelDialog() {
    AppDialogs.showCancelDialog(parentContext, '04 Jun 2025');
  }
}
