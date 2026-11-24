import 'package:material_ui/material_ui.dart';
import 'package:flutter/semantics.dart';

/// Helper to announce dynamic status changes to Android TalkBack and iOS VoiceOver.
abstract final class A11yAnnouncer {
  /// Announces [message] politely via the active platform screen reader.
  static void announce(BuildContext context, String message) {
    if (message.trim().isEmpty) return;
    final view = View.maybeOf(context);
    if (view != null) {
      SemanticsService.sendAnnouncement(
        view,
        message,
        Directionality.of(context),
      );
    }
  }
}
