import 'package:material_ui/material_ui.dart';
import '../accessibility/a11y_constants.dart';
import '../constants/app_sizes.dart';
import '../theme/app_colors.dart';

/// Merges child text semantics so TalkBack and VoiceOver announce a card
/// as a single logical unit rather than fragmented swipe stops.
class AccessibleCard extends StatelessWidget {
  const AccessibleCard({
    super.key,
    required this.child,
    this.semanticLabel,
    this.semanticHint,
    this.onTap,
  });

  final Widget child;
  final String? semanticLabel;
  final String? semanticHint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        label: semanticLabel,
        hint: semanticHint,
        button: onTap != null,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: A11yConstants.minTouchTargetSize,
          ),
          child: Card(
            elevation: 0,
            color: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              side: const BorderSide(color: AppColors.outline, width: 1.0),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.p16),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
