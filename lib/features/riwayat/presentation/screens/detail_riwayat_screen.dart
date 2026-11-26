import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/secondary_page_header.dart';
import '../../data/riwayat_mock_data.dart';

class DetailRiwayatScreen extends StatelessWidget {
  const DetailRiwayatScreen({
    super.key,
    required this.visitId,
  });

  final String visitId;

  @override
  Widget build(BuildContext context) {
    final visit = RiwayatMockData.findById(visitId);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SecondaryPageHeader(title: 'Detail Pemeriksaan'),
              const Gap(14),

              // 1. Blue Ticket Summary Card (matches DetailAntreanScreen)
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
                                      visit.doctorName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onPrimary,
                                      ),
                                    ),
                                    const Gap(4),
                                    Text(
                                      '${visit.serviceType} • ${visit.poliklinik}',
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
                                child: const Text(
                                  'SELESAI',
                                  style: TextStyle(
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
                                      visit.dateLabel,
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
                                      visit.timeLabel,
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.onPrimary),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Nomor Antrean Saat Itu:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.onPrimary,
                                  ),
                                ),
                                const Gap(8),
                                Text(
                                  '${visit.queueNumber}',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),

              // 2. Hasil Pemeriksaan & Diagnosis
              Semantics(
                header: true,
                child: const Text(
                  'Hasil Pemeriksaan',
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Diagnosis Dokter',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        visit.diagnosis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const Gap(12),
                      const Divider(color: AppColors.outline, height: 1),
                      const Gap(12),
                      const Text(
                        'Catatan & Anjuran',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryNavy,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        visit.doctorNotes,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.bodyMuted,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(20),

              // 3. Resep Obat
              Semantics(
                header: true,
                child: const Text(
                  'Resep Obat',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              const Gap(10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: visit.prescriptions.map((rx) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.medication_outlined,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          const Gap(10),
                          Expanded(
                            child: Text(
                              rx,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.onSurface,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Jenis Pembayaran',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        visit.paymentType,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
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
