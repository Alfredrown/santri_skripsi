import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/accessibility/a11y_announcer.dart';
import '../../../../core/accessibility/a11y_constants.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/cancel_queue_dialog.dart';
import '../../application/home_notifier.dart';
import '../../../booking/application/booking_notifier.dart';
import '../../../jadwal/presentation/screens/jadwal_screen.dart';
import '../../../riwayat/presentation/screens/riwayat_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);
    final notifier = ref.read(homeProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: IndexedStack(
        index: homeState.selectedNavIndex,
        children: [
          _HomeTabBody(
            homeState: homeState,
            notifier: notifier,
            onStartClinicFlow: (clinicTitle) {
              ref.read(bookingProvider.notifier).startFlow(clinicTitle);
              context.push('/booking/step-1');
            },
          ),
          const JadwalScreen(),
          const RiwayatScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(
        selectedIndex: homeState.selectedNavIndex,
        onTap: (index) {
          notifier.setNavIndex(index);
          const labels = ['Home', 'Jadwal', 'Riwayat', 'Settings'];
          A11yAnnouncer.announce(context, 'Tab ${labels[index]} dipilih');
        },
      ),
    );
  }
}

class _HomeTabBody extends StatelessWidget {
  const _HomeTabBody({
    required this.homeState,
    required this.notifier,
    required this.onStartClinicFlow,
  });

  final HomeState homeState;
  final HomeNotifier notifier;
  final ValueChanged<String> onStartClinicFlow;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Header & Notification Bell
                _HeaderSection(
                  dateText: homeState.dateText,
                  userName: homeState.userName,
                  onNotificationTap: () {
                    A11yAnnouncer.announce(
                      context,
                      'Membuka halaman notifikasi',
                    );
                  },
                ),
                const Gap(12),

                // 2. Search Bar
                _SearchBar(
                  onChanged: notifier.setSearchQuery,
                ),
                const Gap(24),

                // 3. Jadwal Mendatang
                if (homeState.upcomingAppointment != null) ...[
                  Semantics(
                    header: true,
                    child: const Text(
                      'Jadwal Mendatang',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ),
                  const Gap(12),
                  _UpcomingAppointmentCard(
                    appointment: homeState.upcomingAppointment!,
                    onCancel: () async {
                      final confirmed = await showCancelQueueDialog(context);
                      if (confirmed && context.mounted) {
                        notifier.cancelAppointment();
                        AppToast.showInfo(
                          context,
                          'Jadwal kunjungan telah dibatalkan.',
                        );
                      }
                    },
                    onDetail: () {
                      context.push('/detail-antrean');
                    },
                  ),
                  const Gap(24),
                ],

                // 4. Layanan Utama Rumah Sakit (2x3 Grid)
                Semantics(
                  header: true,
                  child: const Text(
                    'Layanan Utama Rumah Sakit',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                const Gap(10),
                _HospitalServicesGrid(
                  services: homeState.services,
                  onServiceTap: (service) {
                    if (service.id == 'layanan-kamar') {
                      context.push('/rawat-inap');
                    } else if (service.id == 'layanan-operasi') {
                      context.push('/pelayanan-operasi');
                    } else {
                      onStartClinicFlow(service.title);
                    }
                  },
                ),
                const Gap(24),

                // 5. Berita Section
                Semantics(
                  header: true,
                  child: const Text(
                    'Berita',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
                const Gap(10),
                const _AccessibilityNewsCard(),
              ],
            ),
          ),
        ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.dateText,
    required this.userName,
    required this.onNotificationTap,
  });

  final String dateText;
  final String userName;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: MergeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateText,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const Gap(4),
                Semantics(
                  header: true,
                  child: Text(
                    'Hai, $userName!',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Semantics(
          button: true,
          label: 'Notifikasi',
          hint: 'Ketuk dua kali untuk membuka daftar notifikasi',
          child: InkWell(
            onTap: onNotificationTap,
            borderRadius: BorderRadius.circular(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: A11yConstants.minTouchTargetSize,
                minHeight: A11yConstants.minTouchTargetSize,
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.bell,
                  width: 28,
                  height: 28,
                  excludeFromSemantics: true,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: 'Cari dokter, spesialisasi, atau poli',
      child: Container(
        constraints: const BoxConstraints(
          minHeight: A11yConstants.minTouchTargetSize,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.outline, width: 1),
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
                onChanged: onChanged,
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
    );
  }
}

class _UpcomingAppointmentCard extends StatelessWidget {
  const _UpcomingAppointmentCard({
    required this.appointment,
    required this.onCancel,
    required this.onDetail,
  });

  final UpcomingAppointment appointment;
  final VoidCallback onCancel;
  final VoidCallback onDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Doctor & Badge row
                MergeSemantics(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment.doctorName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onPrimary,
                              ),
                            ),
                            const Gap(4),
                            Text(
                              appointment.clinicInfo,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(8),
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
                            width: 1,
                          ),
                        ),
                        child: Text(
                          appointment.badgeLabel,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(12),

                // Date & Time bar
                MergeSemantics(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppAssets.calendarWhite,
                              width: 20,
                              height: 20,
                              excludeFromSemantics: true,
                            ),
                            const Gap(8),
                            Text(
                              appointment.dateLabel,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.onPrimary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 1,
                          height: 16,
                          color: AppColors.onPrimary.withValues(alpha: 0.4),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppAssets.clockWhite,
                              width: 20,
                              height: 20,
                              excludeFromSemantics: true,
                            ),
                            const Gap(8),
                            Text(
                              appointment.timeLabel,
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
                ),
                const Gap(12),

                // Queue Numbers Row
                MergeSemantics(
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.onPrimary,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Flexible(
                                child: Text(
                                  'Antrean Anda:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.onPrimary,
                                  ),
                                ),
                              ),
                              const Gap(8),
                              Text(
                                '${appointment.userQueueNumber}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
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
                            const Flexible(
                              child: Text(
                                'Antrean saat ini:',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.queueMutedText,
                                ),
                              ),
                            ),
                            const Gap(8),
                            Text(
                              '${appointment.currentQueueNumber}',
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
                ),
                const Gap(12),

                // Action Buttons Row (WCAG 48dp minimum height)
                Row(
                  children: [
                    Semantics(
                      button: true,
                      label: 'Batalkan antrean',
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 96,
                          minHeight: A11yConstants.minTouchTargetSize,
                        ),
                        child: TextButton(
                          onPressed: onCancel,
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.danger,
                            foregroundColor: AppColors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                          ),
                          child: const Text(
                            'Batalkan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(8),
                    Expanded(
                      child: Semantics(
                        button: true,
                        label: 'Detail Tiket',
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            minHeight: A11yConstants.minTouchTargetSize,
                          ),
                          child: TextButton(
                            onPressed: onDetail,
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.surface,
                              foregroundColor: AppColors.primaryNavy,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                            ),
                            child: const Text(
                              'Detail Tiket',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HospitalServicesGrid extends StatelessWidget {
  const _HospitalServicesGrid({
    required this.services,
    required this.onServiceTap,
  });

  final List<HospitalServiceItem> services;
  final ValueChanged<HospitalServiceItem> onServiceTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 10.0;
        final cardWidth = (constraints.maxWidth - spacing) / 2;

        return Wrap(
          spacing: spacing,
          runSpacing: 14,
          children: services.map((service) {
            return SizedBox(
              width: cardWidth,
              child: Semantics(
                button: true,
                label: service.title,
                hint: service.semanticDescription,
                excludeSemantics: true,
                child: Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  elevation: 0.5,
                  shadowColor: Colors.black12,
                  child: InkWell(
                    onTap: () => onServiceTap(service),
                    borderRadius: BorderRadius.circular(12),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 112),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: service.iconBgColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  service.iconAsset,
                                  width: 24,
                                  height: 24,
                                  excludeFromSemantics: true,
                                ),
                              ),
                            ),
                            const Gap(12),
                            Text(
                              service.title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryNavy,
                                height: 1.25,
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
    );
  }
}

class _AccessibilityNewsCard extends StatelessWidget {
  const _AccessibilityNewsCard();

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 176,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    AppAssets.newsAccessibility,
                    fit: BoxFit.cover,
                    semanticLabel:
                        'Lobi utama rumah sakit yang ramah disabilitas dan lansia',
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Color(0xCC002546),
                          Color(0x00002546),
                        ],
                        stops: [0.0, 0.55],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 14,
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppAssets.accessibilityBadge,
                              width: 12,
                              height: 14,
                              excludeFromSemantics: true,
                            ),
                            const Gap(6),
                            const Flexible(
                              child: Text(
                                'Aksesibilitas Ramah Disabilitas & Lansia',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryNavy,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Layanan Pendampingan Kursi Roda & Bahasa Isyarat',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryNavy,
                      height: 1.4,
                    ),
                  ),
                  Gap(8),
                  Text(
                    'Tersedia tim asistensi staf di lobi utama untuk membantu pasien lansia, disabilitas netra, rungu, atau hambatan mobilitas tanpa biaya tambahan.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.bodyMuted,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const items = [
      (label: 'Home', icon: AppAssets.navHome),
      (label: 'Jadwal', icon: AppAssets.navJadwal),
      (label: 'Riwayat', icon: AppAssets.navRiwayat),
      (label: 'Settings', icon: AppAssets.navSettings),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 12,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == selectedIndex;

              return Expanded(
                child: Semantics(
                  button: true,
                  selected: isSelected,
                  label: item.label,
                  child: InkWell(
                    onTap: () => onTap(index),
                    borderRadius: BorderRadius.circular(16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 60),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 34,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                item.icon,
                                width: 22,
                                height: 22,
                                colorFilter: ColorFilter.mode(
                                  isSelected
                                      ? AppColors.onPrimary
                                      : AppColors.navInactive,
                                  BlendMode.srcIn,
                                ),
                                excludeFromSemantics: true,
                              ),
                            ),
                          ),
                          const Gap(6),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isSelected
                                  ? AppColors.navActiveText
                                  : AppColors.navInactive,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
