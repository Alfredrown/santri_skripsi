import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/accessibility/a11y_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/secondary_page_header.dart';
import '../../application/booking_notifier.dart';
import '../../data/clinic_mock_catalog.dart';
import '../widgets/booking_stepper.dart';

class BookingStep1PoliScreen extends ConsumerStatefulWidget {
  const BookingStep1PoliScreen({super.key});

  @override
  ConsumerState<BookingStep1PoliScreen> createState() =>
      _BookingStep1PoliScreenState();
}

class _BookingStep1PoliScreenState
    extends ConsumerState<BookingStep1PoliScreen> {
  String _searchQuery = '';
  bool _showKetentuan = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(bookingProvider);
    final catalog = ClinicMockCatalog.forCategory(booking.clinicCategory);
    final filtered = catalog.polis.where((p) {
      if (_searchQuery.trim().isEmpty) return true;
      return p.name.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SecondaryPageHeader(title: ''),
              const BookingStepper(currentStep: 1),
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
                'Pilih Poli',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Gap(12),

              // Search Bar
              MergeSemantics(
                child: Semantics(
                  label: 'Kolom pencarian poliklinik',
                  hint: 'Ketuk dua kali untuk mencari nama poliklinik',
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
                        width: 20,
                        height: 20,
                        excludeFromSemantics: true,
                      ),
                      const Gap(10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (v) => setState(() => _searchQuery = v),
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
                            contentPadding: EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      if (_searchQuery.isNotEmpty)
                        IconButton(
                          tooltip: 'Hapus teks pencarian',
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          icon: const Icon(
                            Icons.close_rounded,
                            size: 20,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
                ),
              ),
              const Gap(12),

              // Ketentuan & Jadwal Loket Accordion
              Material(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => setState(() => _showKetentuan = !_showKetentuan),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Ketentuan & Jadwal Loket',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurface,
                              ),
                            ),
                            Icon(
                              _showKetentuan
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: AppColors.onSurface,
                            ),
                          ],
                        ),
                        if (_showKetentuan) ...[
                          const Gap(10),
                          Text(
                            catalog.ketentuan,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.onSurfaceVariant,
                              height: 1.45,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const Gap(16),

              // Poli List
              ...filtered.map((poli) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Semantics(
                    button: true,
                    label:
                        '${poli.name}, ${poli.doctorsCount} Dokter, Kuota ${poli.dailyQuota} pasien per hari',
                    excludeSemantics: true,
                    child: Material(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: () {
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
