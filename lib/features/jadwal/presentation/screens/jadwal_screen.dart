import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/accessibility/a11y_announcer.dart';
import '../../../../core/accessibility/a11y_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../booking/application/booking_notifier.dart';
import '../../../booking/data/clinic_mock_catalog.dart';

class _ServiceCategory {
  const _ServiceCategory({
    required this.id,
    required this.title,
    required this.iconAsset,
    required this.iconBgColor,
  });

  final String id;
  final String title;
  final String iconAsset;
  final Color iconBgColor;
}

class JadwalScreen extends ConsumerStatefulWidget {
  const JadwalScreen({super.key});

  @override
  ConsumerState<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends ConsumerState<JadwalScreen> {
  String _selectedCategoryId = 'klinik-spesialis';
  String _searchQuery = '';

  static const List<_ServiceCategory> _categories = [
    _ServiceCategory(
      id: 'klinik-spesialis',
      title: 'Klinik Spesialis',
      iconAsset: AppAssets.klinikSpesialis,
      iconBgColor: AppColors.iconBgSpesialis,
    ),
    _ServiceCategory(
      id: 'klinik-eksekutif',
      title: 'Klinik Eksekutif',
      iconAsset: AppAssets.klinikEksekutif,
      iconBgColor: AppColors.iconBgEksekutif,
    ),
    _ServiceCategory(
      id: 'telemedicine',
      title: 'Telemedicine',
      iconAsset: AppAssets.telemedicine,
      iconBgColor: AppColors.iconBgTelemedicine,
    ),
    _ServiceCategory(
      id: 'kanker-terpadu',
      title: 'Kanker Terpadu',
      iconAsset: AppAssets.kankerTerpadu,
      iconBgColor: AppColors.iconBgKanker,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedCat = _categories.firstWhere(
      (c) => c.id == _selectedCategoryId,
    );
    final catalog = ClinicMockCatalog.forCategory(selectedCat.title);
    final filteredPolis = catalog.polis.where((poli) {
      if (_searchQuery.trim().isEmpty) return true;
      return poli.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return SafeArea(
      bottom: false,
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              MergeSemantics(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      header: true,
                      child: const Text(
                        'Jadwal',
                        style: TextStyle(
                          fontSize: 20,
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
                  ],
                ),
              ),
              const Gap(16),

              // Kategori Layanan Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    header: true,
                    child: RichText(
                      text: const TextSpan(
                        text: 'Kategori Layanan ',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                        children: [
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: AppColors.danger),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      '4 Pilihan',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryNavy,
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(12),

              // 2x2 Category Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  const spacing = 10.0;
                  final cardWidth = (constraints.maxWidth - spacing) / 2;

                  return Wrap(
                    spacing: spacing,
                    runSpacing: 12,
                    children: _categories.map((cat) {
                      final isSelected = cat.id == _selectedCategoryId;
                      return SizedBox(
                        width: cardWidth,
                        child: Semantics(
                          button: true,
                          selected: isSelected,
                          label: cat.title,
                          hint: isSelected
                              ? 'Kategori terpilih'
                              : 'Ketuk dua kali untuk memilih kategori ${cat.title}',
                          excludeSemantics: true,
                          child: Material(
                            color: isSelected
                                ? AppColors.primaryNavy
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            elevation: 0.5,
                            shadowColor: Colors.black12,
                            child: InkWell(
                              onTap: () {
                                setState(() => _selectedCategoryId = cat.id);
                                A11yAnnouncer.announce(
                                  context,
                                  'Kategori ${cat.title} dipilih',
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(minHeight: 110),
                                child: Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: cat.iconBgColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            cat.iconAsset,
                                            width: 24,
                                            height: 24,
                                            excludeFromSemantics: true,
                                          ),
                                        ),
                                      ),
                                      const Gap(12),
                                      Text(
                                        cat.title,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? AppColors.onPrimary
                                              : AppColors.primaryNavy,
                                        ),
                                      ),
                                    ],
                                  ),
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
              const Gap(20),
              const Divider(color: AppColors.outline, height: 1),
              const Gap(18),

              // Pilih Poliklinik Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: RichText(
                        text: const TextSpan(
                          text: 'Pilih Poliklinik Spesialis ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                          children: [
                            TextSpan(
                              text: '*',
                              style: TextStyle(color: AppColors.danger),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'Wajib dipilih',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const Gap(12),

              // Search Bar (48dp min height)
              MergeSemantics(
                child: Semantics(
                  label: 'Kolom pencarian poliklinik, dokter, atau spesialisasi',
                  hint: 'Ketuk dua kali untuk mengetik kata kunci',
                  child: Container(
                  constraints: const BoxConstraints(
                    minHeight: A11yConstants.minTouchTargetSize,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outline),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.search,
                        width: 22,
                        height: 22,
                        excludeFromSemantics: true,
                      ),
                      const Gap(10),
                      Expanded(
                        child: TextField(
                          onChanged: (v) => setState(() => _searchQuery = v),
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.onSurface,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Cari dokter, spesialisasi, atau poli...',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: AppColors.searchHint,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            isDense: false,
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ),
              ),
              const Gap(14),

              // Poliklinik List
              ...filteredPolis.map((poli) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Semantics(
                    button: true,
                    label:
                        '${poli.name}, ${poli.doctorsCount} Dokter, Kuota ${poli.dailyQuota} pasien per hari',
                    hint: 'Ketuk dua kali untuk melihat jadwal dokter',
                    excludeSemantics: true,
                    child: Material(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: () {
                          ref
                              .read(bookingProvider.notifier)
                              .startFlow(selectedCat.title);
                          ref
                              .read(bookingProvider.notifier)
                              .selectPoli(poli.name);
                          context.push('/booking/step-2');
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          constraints: const BoxConstraints(minHeight: 74),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.outline),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      poli.name,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    const Gap(4),
                                    Text(
                                      '${poli.doctorsCount} Dokter • Kuota ${poli.dailyQuota} pasien/hari',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right_rounded,
                                color: AppColors.primaryNavy,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
