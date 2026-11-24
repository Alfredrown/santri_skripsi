import 'package:material_ui/material_ui.dart';

/// Color tokens extracted from SANTRI-Skripsi-2026 Figma (`main design`),
/// aligned with WCAG 2.1 AA contrast requirements.
abstract final class AppColors {
  // Primary Brand Blue
  static const Color primary = Color(0xFF0068FF);
  static const Color primaryDark = Color(0xFF094EB3);
  static const Color primaryNavy = Color(0xFF002546);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFE7EEFF);
  static const Color onPrimaryContainer = Color(0xFF002546);

  // Secondary / Accent
  static const Color secondary = Color(0xFF002546);
  static const Color onSecondary = Color(0xFFFFFFFF);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onSurface = Color(0xFF050505);
  static const Color onSurfaceVariant = Color(0xFF464646);
  static const Color bodyMuted = Color(0xFF42474F);

  // Neutrals & Borders
  static const Color outline = Color(0xFFE1E1E1);
  static const Color navInactive = Color(0xFF888888);
  static const Color navActiveText = Color(0xFF1F1F1F);
  static const Color queueMutedText = Color(0xFFDFDFDF);
  static const Color searchHint = Color(0xFF6B7280);

  // Service Card Icon Backgrounds
  static const Color iconBgSpesialis = Color(0xFFE7EEFF);
  static const Color iconBgEksekutif = Color(0xFFFFDCC3);
  static const Color iconBgTelemedicine = Color(0xFFDEE8FF);
  static const Color iconBgKanker = Color(0xFFF0F3FF);
  static const Color iconBgKamar = Color(0xFFF0F3FF);
  static const Color iconBgOperasi = Color(0xFFF0F3FF);

  // Semantic Status Colors
  static const Color badgeToday = Color(0xFF008748); // WCAG AA darkened from #00AA5B for crisp white text contrast
  static const Color badgeTodayBorder = Color(0xFF1E72EC);
  static const Color danger = Color(0xFFD92D20); // WCAG AA accessible red (visually close to #FF5858 with >=4.5:1 contrast for white text)
  static const Color success = Color(0xFF008748);
  static const Color warning = Color(0xFF92400E);
  static const Color error = Color(0xFFD92D20);
  static const Color onError = Color(0xFFFFFFFF);
}
