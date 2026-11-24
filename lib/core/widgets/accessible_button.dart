import 'package:material_ui/material_ui.dart';
import '../accessibility/a11y_constants.dart';
import '../constants/app_sizes.dart';

/// WCAG 2.1 AA and screen-reader (TalkBack / VoiceOver) friendly button.
class AccessibleButton extends StatelessWidget {
  const AccessibleButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.semanticHint,
    this.icon,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final String? semanticHint;
  final IconData? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final effectiveLabel = isLoading ? '$label, sedang memuat' : label;

    return Semantics(
      button: true,
      enabled: onPressed != null && !isLoading,
      label: effectiveLabel,
      hint: semanticHint,
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: A11yConstants.minTouchTargetSize,
          minHeight: A11yConstants.minTouchTargetSize,
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading) ...[
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.5),
                ),
                const SizedBox(width: AppSizes.p12),
              ] else if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: AppSizes.p8),
              ],
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
