import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/accessibility/a11y_announcer.dart';
import '../../../../core/accessibility/a11y_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/secondary_page_header.dart';

class KritikSaranScreen extends StatefulWidget {
  const KritikSaranScreen({super.key});

  @override
  State<KritikSaranScreen> createState() => _KritikSaranScreenState();
}

class _KritikSaranScreenState extends State<KritikSaranScreen> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_subjectController.text.trim().isEmpty ||
        _messageController.text.trim().isEmpty) {
      A11yAnnouncer.announce(
        context,
        'Mohon lengkapi subjek dan pesan kritik atau saran terlebih dahulu.',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mohon lengkapi Subjek dan Pesan terlebih dahulu.'),
        ),
      );
      return;
    }

    A11yAnnouncer.announce(
      context,
      'Kritik dan saran Anda berhasil dikirim. Terima kasih.',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Terima kasih! Kritik dan saran Anda telah dikirim.'),
      ),
    );
    _subjectController.clear();
    _messageController.clear();
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
                    const SecondaryPageHeader(
                      title: 'Kritik dan Saran Layanan',
                    ),
                    const Gap(16),
                    Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              text: 'Subjek',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryNavy,
                              ),
                              children: [
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(color: AppColors.danger),
                                ),
                              ],
                            ),
                          ),
                          const Gap(8),
                          Semantics(
                            textField: true,
                            label: 'Subjek kritik dan saran, wajib diisi',
                            child: TextField(
                              controller: _subjectController,
                              decoration: InputDecoration(
                                hintText: 'Masukkan subjek',
                                hintStyle: const TextStyle(
                                  color: AppColors.searchHint,
                                  fontSize: 14,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF0F4FF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                          const Gap(16),
                          RichText(
                            text: const TextSpan(
                              text: 'Pesan',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryNavy,
                              ),
                              children: [
                                TextSpan(
                                  text: '*',
                                  style: TextStyle(color: AppColors.danger),
                                ),
                              ],
                            ),
                          ),
                          const Gap(8),
                          Semantics(
                            textField: true,
                            label: 'Pesan kritik dan saran, wajib diisi',
                            child: TextField(
                              controller: _messageController,
                              maxLines: 6,
                              decoration: InputDecoration(
                                hintText:
                                    'Ceritakan pengalaman Anda, waktu kejadian, atau staf medis yang bertugas agar tim dapat menindaklanjuti secara akurat...',
                                hintStyle: const TextStyle(
                                  color: AppColors.searchHint,
                                  fontSize: 14,
                                  height: 1.45,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF0F4FF),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 1.5,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(14),
                              ),
                            ),
                          ),
                        ],
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
                label: 'Lanjutkan dan kirim kritik saran',
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
