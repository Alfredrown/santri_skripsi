import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/accessibility/a11y_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/secondary_page_header.dart';
import '../../application/booking_notifier.dart';
import '../../data/clinic_mock_catalog.dart';
import '../widgets/booking_stepper.dart';

class BookingStep2DokterScreen extends ConsumerStatefulWidget {
  const BookingStep2DokterScreen({super.key});

  @override
  ConsumerState<BookingStep2DokterScreen> createState() =>
      _BookingStep2DokterScreenState();
}

class _BookingStep2DokterScreenState
    extends ConsumerState<BookingStep2DokterScreen> {
  String _searchQuery = '';
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
    final filtered = catalog.doctors.where((d) {
      if (_searchQuery.trim().isEmpty) return true;
      return d.name.toLowerCase().contains(_searchQuery.toLowerCase());
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
              const BookingStepper(currentStep: 2),
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
                'Pilih Dokter',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Gap(12),

              // Search Bar
              MergeSemantics(
                child: Semantics(
                  label: 'Kolom pencarian nama dokter',
                  hint: 'Ketuk dua kali untuk mencari nama dokter',
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
              const Gap(16),

              // Doctor Cards
              ...filtered.map((doc) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Semantics(
                    button: doc.available,
                    enabled: doc.available,
                    label: '${doc.name}. ${doc.schedule}. ${doc.status}',
                    excludeSemantics: true,
                    child: Material(
                      color: doc.available
                          ? AppColors.surface
                          : const Color(0xFFEBEBEB),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        onTap: () {
                          if (!doc.available) {
                            AppToast.showError(
                              context,
                              '${doc.name} tidak dapat dipilih (${doc.status}).',
                            );
                            return;
                          }
                          ref
                              .read(bookingProvider.notifier)
                              .selectDoctor(doc.name);
                          context.push('/booking/step-3');
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.outline),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doc.name,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.onSurface,
                                      ),
                                    ),
                                    const Gap(6),
                                    if (doc.available)
                                      Text(
                                        doc.schedule,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.onSurfaceVariant,
                                          height: 1.4,
                                        ),
                                      )
                                    else
                                      RichText(
                                        text: TextSpan(
                                          text: '${doc.schedule} • ',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.onSurfaceVariant,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: doc.status,
                                              style: const TextStyle(
                                                color: AppColors.danger,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              if (doc.available) ...[
                                const Gap(8),
                                Text(
                                  doc.status,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.success,
                                  ),
                                ),
                              ],
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
