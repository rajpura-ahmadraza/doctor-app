import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../utility/model/sample_data.dart';
import '../utility/theme.dart';
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
    final controller = Get.put(AppointmentController());

    return AppScaffold(
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(children: [
                IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18)),
                const SizedBox(width: 4),
                Text('Appointments', style: TStyle.h3),
              ]),
            ),
          ),
          const SizedBox(height: 10),

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GlassCard(
              padding: const EdgeInsets.all(4),
              child: TabBar(
                controller: _tab,
                labelStyle: const TextStyle(fontFamily: 'HankenGrotesk', fontSize: 13, fontWeight: FontWeight.w600),
                unselectedLabelStyle: const TextStyle(fontFamily: 'HankenGrotesk', fontSize: 13),
                labelColor: light, unselectedLabelColor: dark500,
                indicator: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(12)),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                tabs: const [Tab(text: 'Book New'), Tab(text: 'My Appointments')],
              ),
            ),
          ),
          const SizedBox(height: 10),

          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [_bookingTab(controller), _historyTab()],
            ),
          ),
        ]),
      ),
    );
  }

  // ── Booking tab ──
  Widget _bookingTab(AppointmentController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Doctor info
        GlassCard(child: Row(children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: primary.withValues(alpha: .15), shape: BoxShape.circle),
            child: const Center(child: Text('P', style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 20, fontWeight: FontWeight.w700, color: primary))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Dr. Priya Sharma', style: TStyle.h3),
            Text('MBBS, MD • ClinixPro Clinic', style: TStyle.small),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.star_rounded, color: Color(0xFFFFB300), size: 14),
              const SizedBox(width: 4),
              Text('4.9 • 200+ patients', style: TStyle.small),
            ]),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            const Text('₹500', style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 16, fontWeight: FontWeight.w700, color: dark)),
            Text('per visit', style: TStyle.small),
          ]),
        ])),
        const SizedBox(height: 14),

        // Visit type
        Text('Visit type', style: TStyle.h3),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: controller.types.map((t) => GestureDetector(
            onTap: () => controller.selectType(t),
            child: Obx(() {
              final isSelected = controller.selectedType.value == t;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? primary : light,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? primary : black200),
                ),
                child: Text(t, style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 12, fontWeight: FontWeight.w500, color: isSelected ? light : dark)),
              );
            }),
          )).toList()),
        ),
        const SizedBox(height: 16),

        // Date picker
        Text('Select date', style: TStyle.h3),
        const SizedBox(height: 8),
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
                  final isSelected = DateFormat('yyyyMMdd').format(date) == DateFormat('yyyyMMdd').format(controller.selectedDate.value);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 58,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isWeekend ? black300 : isSelected ? primary : light,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isSelected ? primary : black200),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(DateFormat('EEE').format(date), style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 10, color: isWeekend ? dark500 : isSelected ? light : dark500)),
                      const SizedBox(height: 4),
                      Text(DateFormat('d').format(date), style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 18, fontWeight: FontWeight.w700, color: isWeekend ? dark500 : isSelected ? light : dark)),
                      Text(DateFormat('MMM').format(date), style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 10, color: isWeekend ? dark500 : isSelected ? light.withValues(alpha: .8) : dark500)),
                      if (isWeekend) Text('Closed', style: const TextStyle(fontFamily: 'HankenGrotesk', fontSize: 8, color: dark500)),
                    ]),
                  );
                }),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Time slots
        Text('Select time slot', style: TStyle.h3),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 2.5, crossAxisSpacing: 8, mainAxisSpacing: 8),
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
                    color: !available ? black300 : isSelected ? primary : light,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? primary : black200),
                  ),
                  child: Center(child: Text(
                    slot['time']!,
                    style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 11, fontWeight: FontWeight.w500,
                      color: !available ? dark500 : isSelected ? light : dark),
                  )),
                );
              }),
            );
          },
        ),
        const SizedBox(height: 16),

        // Payment method
        Text('Payment method', style: TStyle.h3),
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
                child: Row(children: [
                  Icon(p.$2, color: isSelected ? primary : dark500, size: 22),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p.$3, style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? primary : dark)),
                    Text(p.$4, style: TStyle.small),
                  ])),
                  if (isSelected) const Icon(Icons.check_circle_rounded, color: primary, size: 20),
                ]),
              );
            }),
          );
        }),
        const SizedBox(height: 16),

        // Summary & Book button
        Obx(() {
          if (controller.selectedSlot.value != null) {
            return GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Booking summary', style: TStyle.h3),
              const Divider(height: 16),
              _summaryRow('Doctor', 'Dr. Priya Sharma'),
              _summaryRow('Date', DateFormat('dd MMM yyyy').format(controller.selectedDate.value)),
              _summaryRow('Time', controller.selectedSlot.value!),
              _summaryRow('Type', controller.selectedType.value),
              _summaryRow('Payment', controller.selectedPayment.value == 'cash' ? 'Pay at clinic' : controller.selectedPayment.value.toUpperCase()),
              const Divider(height: 16),
              _summaryRow('Consultation fee', '₹500', bold: true),
              const SizedBox(height: 16),
              PrimaryBtn(
                label: controller.selectedPayment.value == 'cash' ? 'Confirm Appointment' : 'Pay ₹500 & Book',
                loading: controller.booking.value,
                icon: controller.selectedPayment.value == 'cash' ? Icons.check_rounded : Icons.payment_rounded,
                onTap: () => controller.confirmBooking(context, () => _showBookingSuccess(controller)),
              ),
            ]));
          }
          return const SizedBox.shrink();
        }),
      ]),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TStyle.bodyMuted),
      Text(value, style: bold ? TStyle.h3 : TStyle.body),
    ]),
  );

  // ── Appointments history ──
  Widget _historyTab() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      itemCount: PatientData.appointments.length,
      itemBuilder: (_, i) {
        final a = PatientData.appointments[i];
        final isUpcoming = a['status'] == 'Confirmed';
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: GlassCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              StatusBadge(
                label: a['status']!,
                bg: isUpcoming ? const Color(0xFFE8F5E9) : black300,
                fg: isUpcoming ? success : dark500,
              ),
              Text(a['fee']!, style: TStyle.h3),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              const Icon(Icons.calendar_today_rounded, size: 14, color: primary),
              const SizedBox(width: 6),
              Text('${a['date']}  •  ${a['time']}', style: TStyle.body),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.person_outline_rounded, size: 14, color: primary),
              const SizedBox(width: 6),
              Text(a['doctor']!, style: TStyle.body),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.medical_services_outlined, size: 14, color: primary),
              const SizedBox(width: 6),
              Text(a['type']!, style: TStyle.bodyMuted),
            ]),
            if (isUpcoming) ...[
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => _showCancelDialog(),
                  icon: const Icon(Icons.cancel_outlined, size: 16, color: errorCol),
                  label: const Text('Cancel', style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 12, color: errorCol)),
                  style: OutlinedButton.styleFrom(side: const BorderSide(color: errorCol), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                )),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_outlined, size: 16),
                  label: const Text('Message', style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 12)),
                  style: ElevatedButton.styleFrom(backgroundColor: primary, foregroundColor: light, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                )),
              ]),
            ],
          ])),
        );
      },
    );
  }

  void _showBookingSuccess(AppointmentController controller) {
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 64, height: 64, decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
          child: const Icon(Icons.check_circle_rounded, color: success, size: 40)),
        const SizedBox(height: 16),
        const Text('Appointment Booked!', style: TStyle.h2, textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Text('Your appointment with Dr. Priya Sharma on ${DateFormat('dd MMM yyyy').format(controller.selectedDate.value)} at ${controller.selectedSlot.value} is confirmed.', style: TStyle.bodyMuted, textAlign: TextAlign.center),
        const SizedBox(height: 20),
        PrimaryBtn(label: 'Done', onTap: () { Get.back(); Get.back(); }),
      ]),
    ));
  }

  void _showCancelDialog() {
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Cancel appointment?', style: TStyle.h3),
      content: Text('Are you sure you want to cancel your appointment with Dr. Priya Sharma on 04 Jun 2025?', style: TStyle.bodyMuted),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Keep', style: TextStyle(color: primary, fontFamily: 'HankenGrotesk'))),
        TextButton(onPressed: () { Get.back(); }, child: const Text('Cancel Appointment', style: TextStyle(color: errorCol, fontFamily: 'HankenGrotesk'))),
      ],
    ));
  }
}
