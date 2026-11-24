import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/accessibility/a11y_announcer.dart';
import '../../../../core/accessibility/a11y_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/secondary_page_header.dart';

class UbahKataSandiScreen extends StatefulWidget {
  const UbahKataSandiScreen({super.key});

  @override
  State<UbahKataSandiScreen> createState() => _UbahKataSandiScreenState();
}

class _UbahKataSandiScreenState extends State<UbahKataSandiScreen> {
  final _oldController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool get _hasMinLength => _newController.text.length >= 8;
  bool get _hasUpperAndLower =>
      RegExp(r'[A-Z]').hasMatch(_newController.text) &&
      RegExp(r'[a-z]').hasMatch(_newController.text);
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_newController.text);
  bool get _hasSymbol =>
      RegExp(r'[!@#\$%\^&\*]').hasMatch(_newController.text);

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_oldController.text.isEmpty ||
        !_hasMinLength ||
        !_hasUpperAndLower ||
        !_hasNumber ||
        !_hasSymbol) {
      AppToast.showError(
        context,
        'Gagal memperbarui: Pastikan kata sandi lama diisi dan semua kriteria sandi kuat terpenuhi.',
      );
      return;
    }

    if (_newController.text != _confirmController.text) {
      AppToast.showError(
        context,
        'Gagal memperbarui: Konfirmasi kata sandi baru tidak cocok.',
      );
      return;
    }

    AppToast.showSuccess(context, 'Kata sandi berhasil diperbarui!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SecondaryPageHeader(title: 'Ubah kata sandi'),
                    const Gap(16),

                    // 1. Kata Sandi Saat Ini
                    _PasswordCard(
                      icon: Icons.vpn_key_outlined,
                      title: 'Kata Sandi Saat Ini',
                      trailing: Semantics(
                        button: true,
                        label: 'Lupa Sandi',
                        child: InkWell(
                          onTap: () {
                            A11yAnnouncer.announce(
                              context,
                              'Membuka bantuan pemulihan kata sandi',
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 8,
                            ),
                            child: Text(
                              'Lupa Sandi?',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryNavy,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _PasswordField(
                            controller: _oldController,
                            hint: 'Masukkan kata sandi lama Anda',
                            label: 'Kata Sandi Saat Ini',
                            obscure: _obscureOld,
                            onToggleObscure: () =>
                                setState(() => _obscureOld = !_obscureOld),
                          ),
                          const Gap(8),
                          const Text(
                            'Gunakan kata sandi yang biasa Anda gunakan saat masuk ke portal SANTRI',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),

                    // 2. Kata Sandi Baru + Live Criteria
                    _PasswordCard(
                      icon: Icons.lock_outline_rounded,
                      title: 'Kata Sandi Baru',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _PasswordField(
                            controller: _newController,
                            hint: 'Kombinasi minimal 8 karakter',
                            label: 'Kata Sandi Baru',
                            obscure: _obscureNew,
                            onChanged: (_) => setState(() {}),
                            onToggleObscure: () =>
                                setState(() => _obscureNew = !_obscureNew),
                          ),
                          const Gap(12),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F4FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Kriteria Kata Sandi Kuat:',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primaryNavy,
                                  ),
                                ),
                                const Gap(8),
                                _CriteriaItem(
                                  label: 'Minimal 8 karakter',
                                  met: _hasMinLength,
                                ),
                                _CriteriaItem(
                                  label: 'Kombinasi huruf besar & huruf kecil',
                                  met: _hasUpperAndLower,
                                ),
                                _CriteriaItem(
                                  label: 'Minimal 1 angka (0–9)',
                                  met: _hasNumber,
                                ),
                                _CriteriaItem(
                                  label: 'Minimal 1 simbol khusus (!@#\$%^&*)',
                                  met: _hasSymbol,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(16),

                    // 3. Konfirmasi Kata Sandi Baru
                    _PasswordCard(
                      icon: Icons.verified_outlined,
                      title: 'Konfirmasi Kata Sandi Baru',
                      child: _PasswordField(
                        controller: _confirmController,
                        hint: 'Ketik ulang kata sandi baru',
                        label: 'Konfirmasi Kata Sandi Baru',
                        obscure: _obscureConfirm,
                        onToggleObscure: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sticky Bottom CTA
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.outline, width: 0.75),
                ),
              ),
              child: Semantics(
                button: true,
                label: 'Lanjutkan perubahan kata sandi',
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: double.infinity,
                    minHeight: A11yConstants.minTouchTargetSize,
                  ),
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Lanjutkan',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PasswordCard extends StatelessWidget {
  const _PasswordCard({
    required this.icon,
    required this.title,
    required this.child,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primaryNavy),
              const Gap(8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryNavy,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const Gap(12),
          child,
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.controller,
    required this.hint,
    required this.label,
    required this.obscure,
    required this.onToggleObscure,
    this.onChanged,
  });

  final TextEditingController controller;
  final String hint;
  final String label;
  final bool obscure;
  final VoidCallback onToggleObscure;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      textField: true,
      label: label,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            color: AppColors.searchHint,
            fontSize: 14,
          ),
          filled: true,
          fillColor: const Color(0xFFF0F4FF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.outline),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          suffixIcon: IconButton(
            tooltip: obscure ? 'Tampilkan kata sandi' : 'Sembunyikan kata sandi',
            onPressed: onToggleObscure,
            icon: Icon(
              obscure
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: AppColors.primaryNavy,
            ),
          ),
        ),
      ),
    );
  }
}

class _CriteriaItem extends StatelessWidget {
  const _CriteriaItem({required this.label, required this.met});

  final String label;
  final bool met;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: MergeSemantics(
        child: Semantics(
          label: '$label: ${met ? 'terpenuhi' : 'belum terpenuhi'}',
          child: Row(
            children: [
              Icon(
                met ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
                size: 18,
                color: met ? AppColors.success : AppColors.onSurfaceVariant,
              ),
              const Gap(8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    color: met ? AppColors.success : AppColors.onSurface,
                    fontWeight: met ? FontWeight.w600 : FontWeight.w400,
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
