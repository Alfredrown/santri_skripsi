import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/accessibility/a11y_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/secondary_page_header.dart';
import '../../../home/application/home_notifier.dart';
import '../../application/booking_notifier.dart';

class BookingStep6SuccessScreen extends ConsumerWidget {
  const BookingStep6SuccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    const Gap(8),
                    const Center(
                      child: Icon(
                        Icons.check_circle_outline_rounded,
                        size: 48,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const Gap(10),
                    Semantics(
                      header: true,
                      child: const Text(
                        'Antrian Berhasil\nDidaftarkan!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const Gap(6),
                    const Text(
                      'Simpan tiket ini sebagai bukti antrian',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const Gap(14),
                    const Text(
                      'Nomor Antrean Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const Gap(12),

                    // Ticket Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outline),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '001',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const Gap(4),
                          const Text(
                            'Poli',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const Gap(2),
                          Text(
                            booking.selectedPoli,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                          const Gap(4),
                          Text(
                            booking.selectedDoctor,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const Gap(16),
                          const Divider(color: AppColors.outline, height: 1),
                          const Gap(16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: _TicketMeta(
                                  label: 'Rumah Sakit',
                                  value: 'RSUD Dr.Soetomo',
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: _TicketMeta(
                                  label: 'Tanggal',
                                  value: booking.selectedDate,
                                ),
                              ),
                            ],
                          ),
                          const Gap(14),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _TicketMeta(
                                  label: 'Nama Pasien',
                                  value: booking.patientName,
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: _TicketMeta(
                                  label: 'Jam Periksa',
                                  value: booking.selectedTime,
                                ),
                              ),
                            ],
                          ),
                          const Gap(20),
                          Semantics(
                            image: true,
                            label: 'QR Code Tiket Antrean nomor 001',
                            child: const Icon(
                              Icons.qr_code_2_rounded,
                              size: 136,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom CTA -> Detail Antrean (Step 7)
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
                    ref.read(homeProvider.notifier).setUpcomingAppointment(
                          UpcomingAppointment(
                            doctorName: booking.selectedDoctor,
                            clinicInfo:
                                '${booking.clinicCategory} • ${booking.selectedPoli}',
                            badgeLabel: 'TERDAFTAR',
                            dateLabel: booking.selectedDate,
                            timeLabel: booking.selectedTime,
                            userQueueNumber: 1,
                            currentQueueNumber: 1,
                          ),
                        );
                    AppToast.showSuccess(
                      context,
                      'Jadwal kunjungan aktif ditambahkan ke Beranda.',
                    );
                    context.go('/');
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

class _TicketMeta extends StatelessWidget {
  const _TicketMeta({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const Gap(2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}
