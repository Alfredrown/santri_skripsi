import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/accessibility/a11y_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/cancel_queue_dialog.dart';
import '../../../../core/widgets/secondary_page_header.dart';
import '../../../home/application/home_notifier.dart';

class DetailAntreanScreen extends ConsumerWidget {
  const DetailAntreanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointment = ref.watch(homeProvider).upcomingAppointment;
    final userQueue = appointment?.userQueueNumber ?? 16;
    final currentQueue = appointment?.currentQueueNumber ?? 11;
    final patientsAhead = (userQueue - currentQueue).clamp(0, 999);
    final progressRatio =
        userQueue > 0 ? (currentQueue / userQueue).clamp(0.0, 1.0) : 1.0;
    final estimatedMinutes = patientsAhead * 7;
    final isYourTurn = patientsAhead == 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SecondaryPageHeader(title: 'Detail Antrean'),
              const Gap(14),

              // 1. Blue Ticket Card
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: -62,
                      top: -32,
                      child: IgnorePointer(
                        child: SvgPicture.asset(
                          AppAssets.cardEllipse,
                          width: 235,
                          height: 235,
                          excludeFromSemantics: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      appointment?.doctorName ??
                                          'Dr. Malik Kudus',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onPrimary,
                                      ),
                                    ),
                                    const Gap(4),
                                    Text(
                                      appointment?.clinicInfo ??
                                          'Klinik Spesialis • Poli Anak',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: AppColors.onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.badgeToday,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: AppColors.badgeTodayBorder,
                                  ),
                                ),
                                child: Text(
                                  appointment?.badgeLabel ?? 'HARI INI',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryDark,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppAssets.calendarWhite,
                                      width: 18,
                                      height: 18,
                                      excludeFromSemantics: true,
                                    ),
                                    const Gap(8),
                                    Text(
                                      appointment?.dateLabel ??
                                          'Senin, 1 November',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      AppAssets.clockWhite,
                                      width: 18,
                                      height: 18,
                                      excludeFromSemantics: true,
                                    ),
                                    const Gap(8),
                                    Text(
                                      appointment?.timeLabel ?? '09.00 - 10.00',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Gap(12),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: AppColors.onPrimary),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Antrean Anda:',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: AppColors.onPrimary,
                                        ),
                                      ),
                                      const Gap(8),
                                      Text(
                                        '${appointment?.userQueueNumber ?? 16}',
                                        style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.onPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Antrean saat ini:',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.queueMutedText,
                                      ),
                                    ),
                                    const Gap(6),
                                    Text(
                                      '${appointment?.currentQueueNumber ?? 11}',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.queueMutedText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),

              // 2. Queue Progress Card (Live & Interactive Mock)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MergeSemantics(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '$currentQueue',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              const Gap(10),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: progressRatio,
                                  minHeight: 6,
                                  backgroundColor: const Color(0xFFCBD5E1),
                                  color: isYourTurn
                                      ? AppColors.success
                                      : AppColors.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const Gap(10),
                              Text(
                                '$userQueue',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: isYourTurn
                                      ? AppColors.success
                                      : AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          const Gap(14),
                          Row(
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: isYourTurn
                                      ? AppColors.success
                                      : AppColors.primaryNavy,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  isYourTurn
                                      ? Icons.notifications_active_rounded
                                      : Icons.groups_outlined,
                                  color: AppColors.onPrimary,
                                  size: 24,
                                ),
                              ),
                              const Gap(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isYourTurn
                                          ? 'Giliran Anda Sekarang!'
                                          : '$patientsAhead Pasien di Depan Anda',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    const Gap(2),
                                    Text(
                                      isYourTurn
                                          ? 'Silakan menuju ruang periksa sekarang.'
                                          : 'Estimasi panggilan: ± $estimatedMinutes menit lagi',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (!isYourTurn) ...[
                      const Gap(12),
                      Semantics(
                        button: true,
                        label: 'Simulasikan panggilan antrean berikutnya',
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: A11yConstants.minTouchTargetSize,
                          ),
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ref
                                  .read(homeProvider.notifier)
                                  .advanceCurrentQueue();
                              final nextAhead = patientsAhead - 1;
                              if (nextAhead == 0) {
                                AppToast.showSuccess(
                                  context,
                                  'Giliran Anda sekarang! Silakan menuju ruang periksa.',
                                );
                              } else {
                                AppToast.showInfo(
                                  context,
                                  'Antrean maju: $nextAhead pasien di depan Anda.',
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.fast_forward_rounded,
                              size: 18,
                              color: AppColors.primaryNavy,
                            ),
                            label: const Text(
                              'Simulasi Antrean Maju (+1)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryNavy,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: AppColors.surface,
                              side: const BorderSide(color: AppColors.outline),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Gap(20),

              // 3. Verifikasi Kedatangan + QR Code
              Semantics(
                header: true,
                child: const Text(
                  'Verifikasi kedatangan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const Gap(10),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Scan kedatangan anda di Rumah Sakit kode QR dibawah',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const Gap(14),
                    Semantics(
                      image: true,
                      label: 'Kode QR verifikasi kedatangan antrean',
                      child: Container(
                        width: 152,
                        height: 152,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.qr_code_2_rounded,
                          size: 128,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),

              // 4. Informasi Pembayaran
              Semantics(
                header: true,
                child: const Text(
                  'Informasi Pembayaran',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const Gap(10),
              MergeSemantics(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jenis Pembayaran',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      Gap(4),
                      Text(
                        'Umum',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(18),

              // 5. Batalkan Pemeriksaan Button
              Semantics(
                button: true,
                label: 'Batalkan Pemeriksaan',
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: A11yConstants.minTouchTargetSize,
                  ),
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final confirmed = await showCancelQueueDialog(context);
                      if (confirmed && context.mounted) {
                        ref.read(homeProvider.notifier).cancelAppointment();
                        AppToast.showInfo(
                          context,
                          'Pemeriksaan telah dibatalkan.',
                        );
                        context.go('/');
                      }
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.danger,
                    ),
                    label: const Text(
                      'Batalkan Pemeriksaan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.danger,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      side: BorderSide(
                        color: AppColors.danger.withValues(alpha: 0.35),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
