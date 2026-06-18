import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import '../login/forgot_password_screen.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final p = controller.patient;

    return AppScaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Row(children: [
                  const Text('My Profile', style: TextStyle(fontFamily: 'KronaOne', fontSize: 16, color: dark)),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _showEditDialog(context, controller),
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: primary.withValues(alpha: .1), borderRadius: BorderRadius.circular(8)),
                      child: const Icon(Icons.edit_outlined, size: 18, color: primary),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ]),
              ),
            )),

            // Avatar + name
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: GlassCard(
                child: Obx(() => Column(children: [
                  Stack(children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [primary, primary2], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: primary.withValues(alpha: .4), blurRadius: 16, offset: const Offset(0, 6))],
                      ),
                      child: Center(child: Text(
                        p['name']!.isNotEmpty ? p['name']![0] : 'R',
                        style: const TextStyle(color: light, fontSize: 32, fontWeight: FontWeight.w800, fontFamily: 'HankenGrotesk'),
                      )),
                    ),
                    Positioned(bottom: 2, right: 2, child: Container(
                      width: 22, height: 22,
                      decoration: const BoxDecoration(color: success, shape: BoxShape.circle),
                      child: const Icon(Icons.check, color: light, size: 14),
                    )),
                  ]),
                  const SizedBox(height: 12),
                  Text(p['name']!, style: TStyle.h2),
                  const SizedBox(height: 4),
                  Text(p['rm']!, style: const TextStyle(fontFamily: 'HankenGrotesk', fontSize: 12, color: primary, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    _chip(p['age']!),
                    const SizedBox(width: 6),
                    _chip(p['gender']!),
                    const SizedBox(width: 6),
                    _chip(p['blood']!),
                  ]),
                ])),
              ),
            )),

            // Stats
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(children: [
                Expanded(child: _statCard('3', 'Visits', Icons.history_rounded)),
                const SizedBox(width: 10),
                Expanded(child: _statCard('1', 'Upcoming', Icons.calendar_today_rounded)),
                const SizedBox(width: 10),
                Expanded(child: _statCard('8', 'Reports', Icons.folder_rounded)),
              ]),
            )),

            // Personal details
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: GlassCard(child: Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SectionHeader(title: 'Personal details'),
                const Divider(height: 16),
                _detailRow(Icons.phone_outlined, 'Mobile', p['phone']!),
                _detailRow(Icons.email_outlined, 'Email', p['email']!),
                _detailRow(Icons.cake_outlined, 'Date of birth', p['dob']!),
                _detailRow(Icons.location_on_outlined, 'Address', p['address']!, multiline: true),
              ]))),
            )),

            // Doctor info
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: GlassCard(child: Obx(() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SectionHeader(title: 'My doctor'),
                const Divider(height: 16),
                Row(children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(color: primary.withValues(alpha: .15), shape: BoxShape.circle),
                    child: const Center(child: Text('P', style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 18, fontWeight: FontWeight.w700, color: primary))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(p['doctor']!, style: TStyle.h3),
                    Text(p['clinic']!, style: TStyle.small),
                  ])),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(10)),
                    child: const Text('Active', style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 10, color: success, fontWeight: FontWeight.w600)),
                  ),
                ]),
              ]))),
            )),

            // Settings
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: GlassCard(child: Column(children: [
                _menuItem(Icons.lock_outlined, 'Change Password', () => Get.to(() => const ChangePasswordScreen())),
                _divider(),
                _menuItem(Icons.notifications_outlined, 'Notification Preferences', () => controller.showComingSoon(context)),
                _divider(),
                _menuItem(Icons.language_outlined, 'Language', () => controller.showComingSoon(context)),
                _divider(),
                _menuItem(Icons.help_outline_rounded, 'Help & Support', () => controller.showComingSoon(context)),
                _divider(),
                _menuItem(Icons.privacy_tip_outlined, 'Privacy Policy', () => controller.showComingSoon(context)),
                _divider(),
                _menuItem(Icons.info_outline_rounded, 'App Version  •  v1.0.0', () {}),
              ])),
            )),

            // Logout
            SliverToBoxAdapter(child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              child: OutlinedButton.icon(
                onPressed: () => controller.confirmLogout(context),
                icon: const Icon(Icons.logout_rounded, color: errorCol, size: 18),
                label: const Text('Sign out', style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 14, color: errorCol, fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: errorCol),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: primary.withValues(alpha: .1), borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: const TextStyle(fontFamily: 'HankenGrotesk', fontSize: 11, color: primary, fontWeight: FontWeight.w500)),
  );

  Widget _statCard(String value, String label, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      child: Column(children: [
        Icon(icon, color: primary, size: 20),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontFamily: 'HankenGrotesk', fontSize: 20, fontWeight: FontWeight.w800, color: dark)),
        const SizedBox(height: 2),
        Text(label, style: TStyle.small, textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _detailRow(IconData icon, String label, String value, {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center, children: [
        Icon(icon, size: 18, color: primary),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TStyle.small),
          const SizedBox(height: 2),
          Text(value, style: TStyle.body),
        ])),
      ]),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: primary, size: 20),
      title: Text(label, style: TStyle.body),
      trailing: const Icon(Icons.chevron_right_rounded, color: dark500, size: 20),
      dense: true,
      onTap: onTap,
    );
  }

  Widget _divider() => Divider(height: 0, color: dark.withValues(alpha: .06));

  void _showEditDialog(BuildContext context, ProfileController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: GlassCard(child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Edit profile', style: TStyle.h3),
            IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close_rounded, size: 20), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
          ]),
          const SizedBox(height: 16),
          AppInput(label: 'Full name', hint: 'Rahul Mehta', controller: controller.nameCtrl),
          const SizedBox(height: 12),
          AppInput(label: 'Email', hint: 'rahul.mehta@email.com', controller: controller.emailCtrl),
          const SizedBox(height: 12),
          AppInput(label: 'Address', hint: 'Enter address', controller: controller.addressCtrl, maxLines: 2),
          const SizedBox(height: 16),
          PrimaryBtn(label: 'Save changes', icon: Icons.save_rounded, onTap: controller.saveProfile),
        ])),
      ),
    );
  }
}
