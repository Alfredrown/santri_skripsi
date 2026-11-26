import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/accessibility/a11y_announcer.dart';
import '../../../../core/accessibility/a11y_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/riwayat_mock_data.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  String _selectedYear = '2026 (Tahun Berjalan)';
  String _selectedFilter = 'Semua Kunjungan';
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static const List<String> _years = [
    '2026 (Tahun Berjalan)',
    '2025',
    '2024',
  ];

  @override
  Widget build(BuildContext context) {
    const visits = RiwayatMockData.visits;
    final filtered = visits.where((item) {
      final matchesFilter = _selectedFilter == 'Semua Kunjungan' ||
          item.serviceType == _selectedFilter;
      final q = _searchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          item.poliklinik.toLowerCase().contains(q) ||
          item.doctorName.toLowerCase().contains(q) ||
          item.serviceType.toLowerCase().contains(q);
      return matchesFilter && matchesQuery;
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
                        'Riwayat',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    const Gap(2),
                    const Text(
                      'Riwayat pemeriksaan anda',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(16),

              // Search & Year Filter Container
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.65),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    MergeSemantics(
                      child: Semantics(
                        label: 'Kolom pencarian riwayat diagnosis, obat, atau dokter',
                        hint: 'Ketuk dua kali untuk mengetik kata kunci',
                        child: Container(
                        constraints: const BoxConstraints(
                          minHeight: A11yConstants.minTouchTargetSize,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
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
                                onChanged: (v) =>
                                    setState(() => _searchQuery = v),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.onSurface,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Cari diagnosis, obat, dokter...',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.searchHint,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  filled: false,
                                  isDense: false,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                            if (_searchQuery.isNotEmpty)
                              IconButton(
                                tooltip: 'Hapus teks pencarian',
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                  A11yAnnouncer.announce(
                                    context,
                                    'Pencarian dihapus',
                                  );
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
                    Row(
                      children: [
                        const Text(
                          'Tahun:',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: Container(
                            constraints: const BoxConstraints(
                              minHeight: A11yConstants.minTouchTargetSize,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedYear,
                                isExpanded: true,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryNavy,
                                ),
                                items: _years
                                    .map(
                                      (y) => DropdownMenuItem(
                                        value: y,
                                        child: Text(y),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedYear = val);
                                    A11yAnnouncer.announce(
                                      context,
                                      'Filter tahun diubah ke $val',
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(16),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChipButton(
                      label: 'Semua Kunjungan',
                      count: visits.length,
                      icon: Icons.done_all_rounded,
                      isSelected: _selectedFilter == 'Semua Kunjungan',
                      onTap: () {
                        setState(() => _selectedFilter = 'Semua Kunjungan');
                        A11yAnnouncer.announce(
                          context,
                          'Menampilkan semua kunjungan',
                        );
                      },
                    ),
                    const Gap(10),
                    _FilterChipButton(
                      label: 'Rawat Jalan',
                      icon: Icons.medical_services_outlined,
                      isSelected: _selectedFilter == 'Rawat Jalan',
                      onTap: () {
                        setState(() => _selectedFilter = 'Rawat Jalan');
                        A11yAnnouncer.announce(
                          context,
                          'Menampilkan riwayat Rawat Jalan',
                        );
                      },
                    ),
                    const Gap(10),
                    _FilterChipButton(
                      label: 'Telemedicine',
                      icon: Icons.videocam_outlined,
                      isSelected: _selectedFilter == 'Telemedicine',
                      onTap: () {
                        setState(() => _selectedFilter = 'Telemedicine');
                        A11yAnnouncer.announce(
                          context,
                          'Menampilkan riwayat Telemedicine',
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Gap(16),

              // Visit History Cards
              ...filtered.map((visit) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Semantics(
                    button: true,
                    label:
                        '${visit.poliklinik}, ${visit.serviceType}, tanggal ${visit.dateLabel} pukul ${visit.timeLabel}, dokter ${visit.doctorName}',
                    hint: 'Ketuk dua kali untuk melihat detail rekam medis',
                    excludeSemantics: true,
                    child: Material(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      elevation: 0.5,
                      shadowColor: Colors.black12,
                      child: InkWell(
                        onTap: () => context.push('/riwayat/${visit.id}'),
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${visit.dateLabel} • ${visit.timeLabel}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryNavy,
                                      ),
                                    ),
                                  ),
                                  const Gap(8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryContainer,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      visit.serviceType,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryNavy,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Gap(8),
                              Text(
                                visit.poliklinik,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              const Gap(4),
                              Text(
                                visit.doctorName,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.onSurfaceVariant,
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
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.count,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final int? count;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: count != null ? '$label, $count kunjungan' : label,
      excludeSemantics: true,
      child: Material(
        color: isSelected ? AppColors.primaryNavy : AppColors.primaryContainer,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: A11yConstants.minTouchTargetSize,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    size: 18,
                    color: isSelected
                        ? AppColors.onPrimary
                        : AppColors.primaryNavy,
                  ),
                  const Gap(8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.onPrimary
                          : AppColors.primaryNavy,
                    ),
                  ),
                  if (count != null) ...[
                    const Gap(8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryNavy,
                        ),
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
  }
}
