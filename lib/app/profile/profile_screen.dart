import 'package:clinixpro_patient/app/forgot%20password/forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utility/theme.dart';
import 'profile_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject ProfileController for managing patient profile details
    final controller = Get.put(ProfileController());
    final p = controller.patient;

    return AppScaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // 1. Custom Header Widget
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: ProfileHeaderWidget(controller: controller),
              ),
            ),

            // 2. Avatar + Patient Card Widget
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Obx(() => ProfileCardWidget(patientData: Map<String, String>.from(p))),
              ),
            ),

            // 3. Stats Info Row Widget
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: ProfileStatsRowWidget(),
              ),
            ),

            // 4. Personal Details Widget
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: Obx(() => ProfilePersonalDetailsWidget(patientData: Map<String, String>.from(p))),
              ),
            ),

            // 5. Doctor Information Widget
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Obx(() => ProfileDoctorInfoWidget(patientData: Map<String, String>.from(p))),
              ),
            ),

            // 6. Settings Menu Options Widget
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: ProfileSettingsMenuWidget(controller: controller),
              ),
            ),

            // 7. Sign Out Button Widget
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                child: ProfileSignOutWidget(controller: controller),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Profile Header Widget ───────────────────────────────────────
class ProfileHeaderWidget extends StatelessWidget {
  final ProfileController controller;

  const ProfileHeaderWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          const Text(
            'My Profile',
            style: TextStyle(fontFamily: 'KronaOne', fontSize: 16, color: dark),
          ),
          const Spacer(),
          // Edit Profile trigger button
          IconButton(
            onPressed: () => _showEditDialog(context, controller),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: primary.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.edit_outlined, size: 18, color: primary),
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // Edit dialog helper method
  void _showEditDialog(BuildContext context, ProfileController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: light,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: black200),
            boxShadow: [
              BoxShadow(
                color: dark.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Edit profile', style: TStyle.h2),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, size: 20, color: dark),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              AppInput(label: 'Full name', hint: 'Rahul Mehta', controller: controller.nameCtrl),
              const SizedBox(height: 14),
              AppInput(label: 'Email', hint: 'rahul.mehta@email.com', controller: controller.emailCtrl),
              const SizedBox(height: 14),
              AppInput(label: 'Address', hint: 'Enter address', controller: controller.addressCtrl, maxLines: 2),
              const SizedBox(height: 20),
              PrimaryBtn(label: 'Save changes', icon: Icons.save_rounded, onTap: controller.saveProfile),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Profile Avatar & Name Card Widget ───────────────────────────
class ProfileCardWidget extends StatelessWidget {
  final Map<String, String> patientData;

  const ProfileCardWidget({
    super.key,
    required this.patientData,
  });

  @override
  Widget build(BuildContext context) {
    final name = patientData['name'] ?? '';
    final initial = name.isNotEmpty ? name[0] : 'R';

    return GlassCard(
      child: Column(
        children: [
          // Profile Avatar image initials representation
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primary, primary2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: .4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: const TextStyle(
                      color: light,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'HankenGrotesk',
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(color: success, shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: light, size: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Name and ID details
          Text(name, style: TStyle.h2),
          const SizedBox(height: 4),
          Text(
            patientData['rm'] ?? 'N/A',
            style: const TextStyle(
              fontFamily: 'HankenGrotesk',
              fontSize: 12,
              color: primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          // Chips showing age, gender, blood type
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChip(patientData['age'] ?? 'N/A'),
              const SizedBox(width: 6),
              _buildChip(patientData['gender'] ?? 'N/A'),
              const SizedBox(width: 6),
              _buildChip(patientData['blood'] ?? 'N/A'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: primary.withValues(alpha: .1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'HankenGrotesk',
            fontSize: 11,
            color: primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}

// ── Profile Stats Row Widget ────────────────────────────────────
class ProfileStatsRowWidget extends StatelessWidget {
  const ProfileStatsRowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard('3', 'Visits', Icons.history_rounded)),
        const SizedBox(width: 10),
        Expanded(child: _buildStatCard('1', 'Upcoming', Icons.calendar_today_rounded)),
        const SizedBox(width: 10),
        Expanded(child: _buildStatCard('8', 'Reports', Icons.folder_rounded)),
      ],
    );
  }

  // Stat card builder
  Widget _buildStatCard(String value, String label, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      child: Column(
        children: [
          Icon(icon, color: primary, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'HankenGrotesk',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: dark,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: TStyle.small, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ── Personal Details List Widget ────────────────────────────────
class ProfilePersonalDetailsWidget extends StatelessWidget {
  final Map<String, String> patientData;

  const ProfilePersonalDetailsWidget({
    super.key,
    required this.patientData,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'Personal details'),
          const Divider(height: 16),
          _buildDetailRow(Icons.phone_outlined, 'Mobile', patientData['phone'] ?? 'N/A'),
          _buildDetailRow(Icons.email_outlined, 'Email', patientData['email'] ?? 'N/A'),
          _buildDetailRow(Icons.cake_outlined, 'Date of birth', patientData['dob'] ?? 'N/A'),
          _buildDetailRow(Icons.location_on_outlined, 'Address', patientData['address'] ?? 'N/A', multiline: true),
        ],
      ),
    );
  }

  // Details row helper
  Widget _buildDetailRow(IconData icon, String label, String value, {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TStyle.small),
                const SizedBox(height: 2),
                Text(value, style: TStyle.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Doctor Info Card Widget ─────────────────────────────────────
class ProfileDoctorInfoWidget extends StatelessWidget {
  final Map<String, String> patientData;

  const ProfileDoctorInfoWidget({
    super.key,
    required this.patientData,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(title: 'My doctor'),
          const Divider(height: 16),
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(color: primary.withValues(alpha: .15), shape: BoxShape.circle),
                child: const Center(
                  child: Text(
                    'P',
                    style: TextStyle(
                      fontFamily: 'HankenGrotesk',
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(patientData['doctor'] ?? 'No Doctor Assigned', style: TStyle.h3),
                    Text(patientData['clinic'] ?? 'ClinixPro Clinic', style: TStyle.small),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  'Active',
                  style: TextStyle(
                    fontFamily: 'HankenGrotesk',
                    fontSize: 10,
                    color: success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Settings Menu Widget ────────────────────────────────────────
class ProfileSettingsMenuWidget extends StatelessWidget {
  final ProfileController controller;

  const ProfileSettingsMenuWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        children: [
          _buildMenuItem(Icons.lock_outlined, 'Change Password', () => Get.to(() => const ChangePasswordScreen())),
          _buildDivider(),
          _buildMenuItem(
              Icons.notifications_outlined, 'Notification Preferences', () => controller.showComingSoon(context)),
          _buildDivider(),
          _buildMenuItem(Icons.language_outlined, 'Language', () => controller.showComingSoon(context)),
          _buildDivider(),
          _buildMenuItem(Icons.help_outline_rounded, 'Help & Support', () => controller.showComingSoon(context)),
          _buildDivider(),
          _buildMenuItem(Icons.privacy_tip_outlined, 'Privacy Policy', () => controller.showComingSoon(context)),
          _buildDivider(),
          _buildMenuItem(Icons.info_outline_rounded, 'App Version  •  v1.0.0', () {}),
        ],
      ),
    );
  }

  // MenuItem helper
  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: primary, size: 20),
      title: Text(label, style: TStyle.body),
      trailing: const Icon(Icons.chevron_right_rounded, color: dark500, size: 20),
      dense: true,
      onTap: onTap,
    );
  }

  Widget _buildDivider() => Divider(height: 0, color: dark.withValues(alpha: .06));
}

// ── Sign Out Button Widget ──────────────────────────────────────
class ProfileSignOutWidget extends StatelessWidget {
  final ProfileController controller;

  const ProfileSignOutWidget({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => controller.confirmLogout(context),
      icon: const Icon(Icons.logout_rounded, color: errorCol, size: 18),
      label: const Text(
        'Sign out',
        style: TextStyle(
          fontFamily: 'HankenGrotesk',
          fontSize: 14,
          color: errorCol,
          fontWeight: FontWeight.w600,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        side: const BorderSide(color: errorCol),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
