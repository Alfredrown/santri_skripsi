import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';

/// 4-step visual progress stepper matching Figma booking flow (Steps 1–4).
class BookingStepper extends StatelessWidget {
  const BookingStepper({
    super.key,
    required this.currentStep,
    this.totalSteps = 4,
  });

  /// 1-based index: 1..totalSteps.
  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Langkah $currentStep dari $totalSteps',
      excludeSemantics: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(totalSteps, (index) {
          final step = index + 1;
          final isCompleted = step < currentStep;
          final isActive = step == currentStep;

          return Row(
            children: [
              _StepCircle(
                step: step,
                isCompleted: isCompleted,
                isActive: isActive,
              ),
              if (step < totalSteps) ...[
                const Gap(8),
                const Row(
                  children: [
                    _StepDot(),
                    Gap(4),
                    _StepDot(),
                    Gap(4),
                    _StepDot(),
                  ],
                ),
                const Gap(8),
              ],
            ],
          );
        }),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  const _StepCircle({
    required this.step,
    required this.isCompleted,
    required this.isActive,
  });

  final int step;
  final bool isCompleted;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: Color(0xFF00A81C),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 16,
          color: Colors.white,
        ),
      );
    }

    if (isActive) {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.outline, width: 1.5),
        ),
        child: Center(
          child: Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFF00A81C),
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.outline, width: 1.5),
      ),
      child: Center(
        child: Text(
          '$step',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: Color(0xFFD1D5DB),
        shape: BoxShape.circle,
      ),
    );
  }
}
