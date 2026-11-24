import 'package:material_ui/material_ui.dart';
import 'a11y_constants.dart';

/// Enforces a minimum 48x48dp interactive hit target and coherent semantics
/// for both Android TalkBack and iOS VoiceOver.
class SemanticTouchTarget extends StatelessWidget {
  const SemanticTouchTarget({
    super.key,
    required this.child,
    this.label,
    this.hint,
    this.isButton = false,
    this.isHeader = false,
    this.enabled = true,
    this.onTap,
  });

  final Widget child;
  final String? label;
  final String? hint;
  final bool isButton;
  final bool isHeader;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton,
      header: isHeader,
      enabled: enabled,
      onTap: enabled ? onTap : null,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: A11yConstants.minTouchTargetSize,
          minHeight: A11yConstants.minTouchTargetSize,
        ),
        child: child,
      ),
    );
  }
}
