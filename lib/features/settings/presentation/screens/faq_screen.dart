import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/accessibility/a11y_announcer.dart';
import '../../../../core/accessibility/a11y_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/secondary_page_header.dart';

class _FaqTopic {
  const _FaqTopic({
    required this.id,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  final String id;
  final String label;
  final IconData icon;
  final Color iconColor;
}

class _FaqItem {
  const _FaqItem({
    required this.topicId,
    required this.question,
    required this.subtitle,
    required this.answer,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
  });

  final String topicId;
  final String question;
  final String subtitle;
  final String answer;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
}

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  String _selectedTopic = 'all';
  bool _expandAll = false;
  final Set<int> _expandedIndices = {};

  static const List<_FaqTopic> _topics = [
    _FaqTopic(
      id: 'all',
      label: 'Semua Topik',
      icon: Icons.apps_rounded,
      iconColor: AppColors.primaryNavy,
    ),
    _FaqTopic(
      id: 'antrean',
      label: 'Antrean Online',
      icon: Icons.event_available_outlined,
      iconColor: AppColors.primaryNavy,
    ),
    _FaqTopic(
      id: 'bpjs',
      label: 'BPJS & Rujukan',
      icon: Icons.verified_user_outlined,
      iconColor: Color(0xFF007A43),
    ),
    _FaqTopic(
      id: 'difabel',
      label: 'Lansia & Difabel',
      icon: Icons.accessible_rounded,
      iconColor: AppColors.primaryNavy,
    ),
    _FaqTopic(
      id: 'farmasi',
      label: 'Resep Farmasi',
      icon: Icons.medication_outlined,
      iconColor: Color(0xFF92400E),
    ),
    _FaqTopic(
      id: 'igd',
      label: 'IGD 24 Jam',
      icon: Icons.emergency_outlined,
      iconColor: AppColors.danger,
    ),
  ];

  static const List<_FaqItem> _faqs = [
    _FaqItem(
      topicId: 'antrean',
      question: 'Bagaimana cara mengambil nomor antrean online di aplikasi?',
      subtitle: 'Pendaftaran Online • H-7 Kunjungan',
      answer:
          'Buka tab Jadwal, pilih Kategori Layanan dan Poliklinik Spesialis yang dituju, lalu pilih dokter dan jam praktik. Nomor antrean dan QR Code akan langsung tersedia di halaman Home.',
      icon: Icons.schedule_rounded,
      iconBg: Color(0xFFE7EEFF),
      iconColor: AppColors.primaryNavy,
    ),
    _FaqItem(
      topicId: 'bpjs',
      question:
          'Apakah surat rujukan BPJS Faskes 1 wajib dibawa fisik saat berobat?',
      subtitle: 'Ketentuan BPJS Kesehatan • Validitas 90 Hari',
      answer:
          'Tidak wajib membawa fisik apabila rujukan sudah terintegrasi secara elektronik (P-Care / VClaim), namun disarankan membawa kartu identitas (KTP) dan menunjukkan QR Code pasien di anjungan rumah sakit.',
      icon: Icons.assignment_turned_in_outlined,
      iconBg: Color(0xFFD1FAE5),
      iconColor: Color(0xFF007A43),
    ),
    _FaqItem(
      topicId: 'difabel',
      question:
          'Bagaimana cara meminta bantuan kursi roda atau pendamping difabel?',
      subtitle: 'Aksesibilitas & Prioritas Ramah Lansia',
      answer:
          'Tim asistensi ramah disabilitas dan lansia siaga di lobi utama setiap hari tanpa biaya tambahan. Anda juga dapat mengaktifkan kebutuhan pendampingan saat mendaftar antrean.',
      icon: Icons.accessible_forward_rounded,
      iconBg: Color(0xFFE7EEFF),
      iconColor: AppColors.primaryNavy,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visibleFaqs = _faqs.where((f) {
      return _selectedTopic == 'all' || f.topicId == _selectedTopic;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SecondaryPageHeader(title: 'FAQ'),
              const Gap(16),

              // Kategori Populer Header
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Kategori Populer',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  Text(
                    'Sentuh untuk filter',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF007A43),
                    ),
                  ),
                ],
              ),
              const Gap(12),

              // 2-column Topic Chips Grid
              LayoutBuilder(
                builder: (context, constraints) {
                  const spacing = 10.0;
                  final width = (constraints.maxWidth - spacing) / 2;
                  return Wrap(
                    spacing: spacing,
                    runSpacing: 10,
                    children: _topics.map((topic) {
                      final isSelected = _selectedTopic == topic.id;
                      return SizedBox(
                        width: width,
                        child: Semantics(
                          button: true,
                          selected: isSelected,
                          label: 'Filter topik ${topic.label}',
                          excludeSemantics: true,
                          child: Material(
                            color: isSelected
                                ? AppColors.primaryNavy
                                : const Color(0xFFF0F4FF),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              onTap: () {
                                setState(() => _selectedTopic = topic.id);
                                A11yAnnouncer.announce(
                                  context,
                                  'Filter FAQ diubah ke ${topic.label}',
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minHeight: A11yConstants.minTouchTargetSize,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        topic.icon,
                                        size: 18,
                                        color: isSelected
                                            ? AppColors.onPrimary
                                            : topic.iconColor,
                                      ),
                                      const Gap(8),
                                      Expanded(
                                        child: Text(
                                          topic.label,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? AppColors.onPrimary
                                                : AppColors.primaryNavy,
                                          ),
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
              const Gap(24),

              // Daftar Tanya Jawab Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Daftar Tanya Jawab',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _expandAll = !_expandAll;
                        _expandedIndices.clear();
                        if (_expandAll) {
                          for (var i = 0; i < visibleFaqs.length; i++) {
                            _expandedIndices.add(i);
                          }
                        }
                      });
                    },
                    icon: const Icon(Icons.unfold_more_rounded, size: 18),
                    label: Text(_expandAll ? 'Tutup Semua' : 'Buka Semua'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primaryNavy,
                    ),
                  ),
                ],
              ),
              const Gap(8),

              // FAQ Accordion Cards
              ...List.generate(visibleFaqs.length, (index) {
                final item = visibleFaqs[index];
                final isExpanded = _expandedIndices.contains(index);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Material(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    elevation: 0.5,
                    shadowColor: Colors.black12,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expandedIndices.remove(index);
                          } else {
                            _expandedIndices.add(index);
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: item.iconBg,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    item.icon,
                                    size: 18,
                                    color: item.iconColor,
                                  ),
                                ),
                                const Gap(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.question,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.onSurface,
                                          height: 1.35,
                                        ),
                                      ),
                                      const Gap(6),
                                      Text(
                                        item.subtitle,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Gap(8),
                                Icon(
                                  isExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.primaryNavy,
                                ),
                              ],
                            ),
                            if (isExpanded) ...[
                              const Gap(12),
                              const Divider(
                                color: AppColors.outline,
                                height: 1,
                              ),
                              const Gap(12),
                              Text(
                                item.answer,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.bodyMuted,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ],
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
