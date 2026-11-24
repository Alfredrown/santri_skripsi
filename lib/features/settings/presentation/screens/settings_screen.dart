import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/accessibility/a11y_announcer.dart';
import '../../../../core/accessibility/a11y_constants.dart';
import '../../../../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
              // 1. Profil Pasien Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      header: true,
                      child: const Text(
                        'Profil Pasien',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    const Gap(14),
                    const _ProfileRow(
                      icon: Icons.badge_outlined,
                      label: 'NIK',
                      value: '312125125125',
                    ),
                    const Divider(color: AppColors.outline, height: 20),
                    const _ProfileRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Nama',
                      value: 'Ahmed',
                    ),
                    const Divider(color: AppColors.outline, height: 20),
                    const _ProfileRow(
                      icon: Icons.tag_rounded,
                      label: 'No Rekam Medis',
                      value: '2064870',
                    ),
                    const Divider(color: AppColors.outline, height: 20),
                    const _ProfileRow(
                      icon: Icons.home_outlined,
                      label: 'Alamat',
                      value: 'Jl. Raya Sumput RT 11 RW 03',
                    ),
                    const Divider(color: AppColors.outline, height: 20),
                    const _ProfileRow(
                      icon: Icons.alternate_email_rounded,
                      label: 'Email',
                      value: 'ahmed@santriskripsi.id',
                    ),
                    const Gap(20),
                    const Text(
                      'Scan QR Code ini di Rumah Sakit!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const Gap(12),
                    Center(
                      child: Semantics(
                        image: true,
                        label: 'QR Code Pasien nomor rekam medis 2064870',
                        child: Container(
                          width: 152,
                          height: 152,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.outline),
                          ),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            size: 128,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Gap(20),

              // 2. Pengaturan Akun & Keamanan Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                      header: true,
                      child: const Text(
                        'Pengaturan Akun & Keamanan',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    const Gap(14),
                    _SettingsMenuTile(
                      icon: Icons.pin_outlined,
                      title: 'Ubah Kata Sandi',
                      subtitle: 'Digunakan saat validasi pendaftaran dan obat',
                      onTap: () => context.push('/ubah-kata-sandi'),
                    ),
                    const Gap(10),
                    _SettingsMenuTile(
                      icon: Icons.rate_review_outlined,
                      title: 'Kritik & Saran Layanan',
                      subtitle: 'Sampaikan evaluasi & masukan mutu RS',
                      onTap: () => context.push('/kritik-saran'),
                    ),
                    const Gap(10),
                    _SettingsMenuTile(
                      icon: Icons.help_outline_rounded,
                      title: 'Bantuan & FAQ (Tanya Jawab)',
                      subtitle: 'Pertanyaan umum seputar layanan & BPJS',
                      onTap: () => context.push('/faq'),
                    ),
                  ],
                ),
              ),
              const Gap(18),

              // 3. Logout Button
              Semantics(
                button: true,
                label: 'Keluar dari Akun Pasien',
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: A11yConstants.minTouchTargetSize,
                  ),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      A11yAnnouncer.announce(
                        context,
                        'Konfirmasi keluar dari akun pasien',
                      );
                    },
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: AppColors.danger,
                    ),
                    label: const Text(
                      'Keluar dari Akun Pasien',
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

class _ProfileRow extends StatelessWidget {
  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryNavy),
          const Gap(10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsMenuTile extends StatelessWidget {
  const _SettingsMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '$title. $subtitle',
      excludeSemantics: true,
      child: Material(
        color: AppColors.primaryContainer.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: A11yConstants.minTouchTargetSize,
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: AppColors.primaryNavy,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryNavy,
                          ),
                        ),
                        const Gap(2),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
