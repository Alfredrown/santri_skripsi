import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/secondary_page_header.dart';

class PelayananOperasiScreen extends StatelessWidget {
  const PelayananOperasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SecondaryPageHeader(title: 'Info Pelayanan Operasi'),
              const Gap(16),

              // Total Banner
              MergeSemantics(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE7F0FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        '18',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0055D4),
                        ),
                      ),
                      Gap(4),
                      Text(
                        'Total Jumlah Operasi',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0055D4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(18),

              // Progress Cards Container
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x08000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    _OperationStatusCard(
                      title: 'Operasi sedang berlangsung',
                      count: 8,
                      total: 20,
                    ),
                    Gap(12),
                    _OperationStatusCard(
                      title: 'Operasi sudah Terlayani',
                      count: 8,
                      total: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OperationStatusCard extends StatelessWidget {
  const _OperationStatusCard({
    required this.title,
    required this.count,
    required this.total,
  });

  final String title;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Semantics(
        label: '$title, $count dari $total tersedia',
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBBD7FF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onSurface,
                ),
              ),
              const Gap(10),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0055D4),
                ),
              ),
              const Gap(4),
              Text(
                'dari $total tersedia',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Gap(10),
              LinearProgressIndicator(
                value: count / total,
                minHeight: 5,
                backgroundColor: const Color(0xFFE5E7EB),
                color: const Color(0xFF0055D4),
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
