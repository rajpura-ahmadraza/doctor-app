import 'package:flutter/material.dart';

// ── ClinixPro brand colors ──────────────────────────────────────
const primary   = Color(0xFF8C8AF8);
const primary2  = Color(0xFF4D60D6);
const orange    = Color(0xFFE6AC41);
const dark      = Color(0xFF000000);
const light     = Color(0xFFFFFFFF);
const black200  = Color(0xFFDFDFE3);
const black100  = Color(0xFFD9D9D9);
const black300  = Color(0xFFF5F5F5);
const dark500   = Color(0x80000000);
const errorCol  = Color(0xFFFF0000);
const success   = Color(0xFF23AA49);

const bgGradient = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [Color(0xFFFFF6EE), Color(0xFFF3FAFE), Color(0xFFF6F2FF)],
  stops: [0.0, 0.40, 1.0],
);

// ── Text styles ─────────────────────────────────────────────────
class TStyle {
  static const h1 = TextStyle(fontFamily: 'HankenGrotesk', fontSize: 22, fontWeight: FontWeight.w700, color: dark);
  static const h2 = TextStyle(fontFamily: 'HankenGrotesk', fontSize: 18, fontWeight: FontWeight.w600, color: dark);
  static const h3 = TextStyle(fontFamily: 'HankenGrotesk', fontSize: 15, fontWeight: FontWeight.w600, color: dark);
  static const body = TextStyle(fontFamily: 'HankenGrotesk', fontSize: 13, color: dark);
  static const bodyMuted = TextStyle(fontFamily: 'HankenGrotesk', fontSize: 13, color: dark500);
  static const small = TextStyle(fontFamily: 'HankenGrotesk', fontSize: 11, color: dark500);
  static const label = TextStyle(fontFamily: 'HankenGrotesk', fontSize: 12, fontWeight: FontWeight.w500, color: dark);
}

// ── Shared widgets ───────────────────────────────────────────────
class AppScaffold extends StatelessWidget {
  final Widget body;
  const AppScaffold({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(children: [
        Container(decoration: const BoxDecoration(gradient: bgGradient)),
        body,
      ]),
    );
  }
}

// Glass card identical to ClinixPro
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final double radius;
  const GlassCard({super.key, required this.child, this.padding, this.radius = 18});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        padding: padding ?? const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(colors: [
            light.withValues(alpha: 0.55),
            light.withValues(alpha: 0.25),
          ]),
          border: Border.all(color: dark.withValues(alpha: 0.08)),
        ),
        child: child,
      ),
    );
  }
}

// Primary button
class PrimaryBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;
  final IconData? icon;
  const PrimaryBtn({super.key, required this.label, required this.onTap, this.loading = false, this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: light,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: loading
            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: light, strokeWidth: 2))
            : Row(mainAxisSize: MainAxisSize.min, children: [
                if (icon != null) ...[Icon(icon, size: 18), const SizedBox(width: 8)],
                Text(label, style: const TextStyle(fontFamily: 'HankenGrotesk', fontSize: 15, fontWeight: FontWeight.w600, color: light)),
              ]),
      ),
    );
  }
}

// Input field
class AppInput extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final bool obscure;
  final Widget? suffix;
  final Widget? prefix;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? label;
  const AppInput({super.key, required this.hint, this.controller, this.obscure = false, this.suffix, this.prefix, this.keyboardType, this.maxLines = 1, this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: TStyle.label),
          const SizedBox(height: 6),
        ],
        Container(
          decoration: BoxDecoration(
            color: light,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: black200),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TStyle.body,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TStyle.bodyMuted,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              prefixIcon: prefix,
              suffixIcon: suffix,
            ),
          ),
        ),
      ],
    );
  }
}

// Section header
class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionHeader({super.key, required this.title, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: TStyle.h3),
      if (action != null)
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(foregroundColor: primary, padding: EdgeInsets.zero, minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
          child: Text(action!, style: const TextStyle(fontFamily: 'HankenGrotesk', fontSize: 12, color: primary)),
        ),
    ]);
  }
}

// Status badge
class StatusBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  const StatusBadge({super.key, required this.label, required this.bg, required this.fg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontFamily: 'HankenGrotesk', fontSize: 10, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}
