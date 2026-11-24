import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/secondary_page_header.dart';

class _RoomClassData {
  const _RoomClassData({
    required this.name,
    required this.available,
    required this.total,
    required this.accentColor,
    required this.borderColor,
  });

  final String name;
  final int available;
  final int total;
  final Color accentColor;
  final Color borderColor;
}

class RawatInapScreen extends StatelessWidget {
  const RawatInapScreen({super.key});

  static const List<_RoomClassData> _rooms = [
    _RoomClassData(
      name: 'ICU',
      available: 8,
      total: 20,
      accentColor: Color(0xFF0055D4),
      borderColor: Color(0xFFBBD7FF),
    ),
    _RoomClassData(
      name: 'NICU',
      available: 8,
      total: 20,
      accentColor: Color(0xFF007A43),
      borderColor: Color(0xFFB7E8CE),
    ),
    _RoomClassData(
      name: 'Kelas 1',
      available: 9,
      total: 20,
      accentColor: Color(0xFFC81E4C),
      borderColor: Color(0xFFFBC4D2),
    ),
    _RoomClassData(
      name: 'Kelas II',
      available: 9,
      total: 20,
      accentColor: Color(0xFFB45309),
      borderColor: Color(0xFFFDE0A6),
    ),
    _RoomClassData(
      name: 'Kelas III',
      available: 10,
      total: 20,
      accentColor: Color(0xFF0055D4),
      borderColor: Color(0xFFBBD7FF),
    ),
    _RoomClassData(
      name: 'VIP',
      available: 10,
      total: 20,
      accentColor: Color(0xFF007A43),
      borderColor: Color(0xFFB7E8CE),
    ),
  ];

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
              const SecondaryPageHeader(
                title: 'Ketersediaan Kamar Rawat Inap',
              ),
              const Gap(16),

              // Top 3 Summary KPI Cards
              const Row(
                children: [
                  Expanded(
                    child: _SummaryStatCard(
                      value: '42',
                      label: 'Bed Tersedia',
                      bgColor: Color(0xFFEAF7EE),
                      textColor: Color(0xFF006B3C),
                    ),
                  ),
                  Gap(10),
                  Expanded(
                    child: _SummaryStatCard(
                      value: '8',
                      label: 'IGD Terisi',
                      bgColor: Color(0xFFFDECEF),
                      textColor: Color(0xFFC81E4C),
                    ),
                  ),
                  Gap(10),
                  Expanded(
                    child: _SummaryStatCard(
                      value: '182',
                      label: 'Total Bed',
                      bgColor: Color(0xFFE7F0FF),
                      textColor: Color(0xFF0055D4),
                    ),
                  ),
                ],
              ),
              const Gap(18),

              // 2x3 Room Class Grid Card
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const spacing = 10.0;
                    final cardWidth = (constraints.maxWidth - spacing) / 2;
                    return Wrap(
                      spacing: spacing,
                      runSpacing: 12,
                      children: _rooms.map((room) {
                        return SizedBox(
                          width: cardWidth,
                          child: MergeSemantics(
                            child: Semantics(
                              label:
                                  'Kamar ${room.name}, tersedia ${room.available} dari ${room.total} tempat tidur',
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: room.borderColor),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      room.name,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    const Gap(8),
                                    Text(
                                      '${room.available}',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: room.accentColor,
                                      ),
                                    ),
                                    const Gap(4),
                                    Text(
                                      'dari ${room.total} tersedia',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                    const Gap(8),
                                    LinearProgressIndicator(
                                      value: room.available / room.total,
                                      minHeight: 5,
                                      backgroundColor: const Color(0xFFE5E7EB),
                                      color: room.accentColor,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryStatCard extends StatelessWidget {
  const _SummaryStatCard({
    required this.value,
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  final String value;
  final String label;
  final Color bgColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const Gap(4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
