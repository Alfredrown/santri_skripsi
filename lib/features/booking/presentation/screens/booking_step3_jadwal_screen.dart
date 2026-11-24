import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/accessibility/a11y_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/secondary_page_header.dart';
import '../../application/booking_notifier.dart';
import '../widgets/booking_stepper.dart';

class BookingStep3JadwalScreen extends ConsumerStatefulWidget {
  const BookingStep3JadwalScreen({super.key});

  @override
  ConsumerState<BookingStep3JadwalScreen> createState() =>
      _BookingStep3JadwalScreenState();
}

class _BookingStep3JadwalScreenState
    extends ConsumerState<BookingStep3JadwalScreen> {
  int _selectedDateIdx = 0;
  String _selectedTime = '10.00';

  static const _dates = [
    (
      day: 'SENIN',
      num: '19',
      month: 'MAR',
      full: 'Senin, 19 Maret 2026',
      enabled: true,
    ),
    (
      day: 'SELASA',
      num: '20',
      month: 'MAR',
      full: 'Selasa, 20 Maret 2026',
      enabled: true,
    ),
    (
      day: 'RABU',
      num: '21',
      month: 'MAR',
      full: 'Rabu, 21 Maret 2026',
      enabled: false,
    ),
    (
      day: 'KAMIS',
      num: '22',
      month: 'MAR',
      full: 'Kamis, 22 Maret 2026',
      enabled: true,
    ),
  ];

  static const _slots = [
    (time: '08.00', status: 'Sisa 2', available: true),
    (time: '09.00', status: 'Sisa 2', available: true),
    (time: '10.00', status: 'Sisa 2', available: true),
    (time: '11.00', status: 'Sisa 3', available: true),
    (time: '12.00', status: 'Sisa 3', available: true),
    (time: '13.00', status: 'Penuh', available: false),
    (time: '14.00', status: 'Penuh', available: false),
  ];

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(bookingProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SecondaryPageHeader(title: ''),
                    const BookingStepper(currentStep: 3),
                    const Gap(18),
                    Semantics(
                      header: true,
                      child: Text(
                        booking.clinicCategory,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    const Gap(2),
                    const Text(
                      'Pilih Jadwal',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const Gap(14),

                    // Date Picker Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(_dates.length, (i) {
                          final d = _dates[i];
                          final isSelected = i == _selectedDateIdx;
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Semantics(
                              button: d.enabled,
                              selected: isSelected,
                              enabled: d.enabled,
                              label: d.full,
                              excludeSemantics: true,
                              child: Material(
                                color: !d.enabled
                                    ? const Color(0xFFD1D5DB)
                                    : (isSelected
                                        ? AppColors.primary
                                        : AppColors.surface),
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  onTap: () {
                                    if (!d.enabled) {
                                      AppToast.showError(
                                        context,
                                        'Jadwal pada ${d.full} tidak tersedia.',
                                      );
                                      return;
                                    }
                                    setState(() => _selectedDateIdx = i);
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    width: 76,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.outline,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          d.day,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? AppColors.onPrimary
                                                : AppColors.onSurfaceVariant,
                                          ),
                                        ),
                                        const Gap(4),
                                        Text(
                                          d.num,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: isSelected
                                                ? AppColors.onPrimary
                                                : AppColors.onSurface,
                                          ),
                                        ),
                                        const Gap(2),
                                        Text(
                                          d.month,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? AppColors.onPrimary
                                                : AppColors.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const Gap(18),
                    const Divider(color: AppColors.outline, height: 1),
                    const Gap(18),

                    // Jadwal Konsultasi Grid
                    Semantics(
                      header: true,
                      child: const Text(
                        'Jadwal Konsultasi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    const Gap(12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        const spacing = 10.0;
                        final width = (constraints.maxWidth - spacing * 2) / 3;
                        return Wrap(
                          spacing: spacing,
                          runSpacing: 12,
                          children: _slots.map((slot) {
                            final isSelected = slot.time == _selectedTime;
                            return SizedBox(
                              width: width,
                              child: Semantics(
                                button: slot.available,
                                selected: isSelected,
                                enabled: slot.available,
                                label: 'Jam ${slot.time}, ${slot.status}',
                                excludeSemantics: true,
                                child: Material(
                                  color: !slot.available
                                      ? const Color(0xFFEBEBEB)
                                      : (isSelected
                                          ? AppColors.primary
                                          : AppColors.surface),
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                    onTap: () {
                                      if (!slot.available) {
                                        AppToast.showError(
                                          context,
                                          'Kuota pukul ${slot.time} WIB sudah penuh. Silakan pilih jam lain.',
                                        );
                                        return;
                                      }
                                      setState(() => _selectedTime = slot.time);
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.outline,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            slot.time,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: isSelected
                                                  ? AppColors.onPrimary
                                                  : AppColors.onSurface,
                                            ),
                                          ),
                                          const Gap(6),
                                          Text(
                                            slot.status,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: isSelected
                                                  ? AppColors.onPrimary
                                                  : AppColors.onSurfaceVariant,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.outline, width: 0.75),
                ),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: double.infinity,
                  minHeight: A11yConstants.minTouchTargetSize,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(bookingProvider.notifier).selectSchedule(
                          date: _dates[_selectedDateIdx].full,
                          time: '$_selectedTime WIB',
                        );
                    context.push('/booking/step-4');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
