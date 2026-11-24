import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../accessibility/a11y_constants.dart';
import '../theme/app_colors.dart';

/// Accessible "< Kembali" header + Page Title matching the Figma secondary screens.
class SecondaryPageHeader extends StatelessWidget {
  const SecondaryPageHeader({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          button: true,
          label: 'Kembali ke halaman sebelumnya',
          excludeSemantics: true,
          child: InkWell(
            onTap: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/');
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: A11yConstants.minTouchTargetSize,
                minHeight: A11yConstants.minTouchTargetSize,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.chevron_left_rounded,
                    size: 24,
                    color: AppColors.onSurface,
                  ),
                  Gap(4),
                  Text(
                    'Kembali',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface,
                    ),
                  ),
                  Gap(8),
                ],
              ),
            ),
          ),
        ),
        const Gap(6),
        Semantics(
          header: true,
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
