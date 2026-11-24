/// Core WCAG 2.1 AA and screen reader (Android TalkBack & iOS VoiceOver) constants.
abstract final class A11yConstants {
  /// Minimum interactive tap target size (48x48dp satisfies both
  /// Android TalkBack 48x48dp and iOS VoiceOver 44x44pt guidelines).
  static const double minTouchTargetSize = 48.0;

  /// Maximum safe text scale multiplier before clamping for extreme headers,
  /// while body text remains completely fluid up to 200%+ (WCAG 1.4.4).
  static const double maxTextScaleFactor = 2.0;

  /// Minimum WCAG AA contrast ratio for normal text.
  static const double wcagAaNormalTextContrast = 4.5;

  /// Minimum WCAG AA contrast ratio for large text and UI components.
  static const double wcagAaLargeTextContrast = 3.0;
}
