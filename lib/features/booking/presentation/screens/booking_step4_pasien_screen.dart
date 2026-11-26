import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import '../../../../core/accessibility/a11y_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/secondary_page_header.dart';
import '../../application/booking_notifier.dart';
import '../widgets/booking_stepper.dart';

class BookingStep4PasienScreen extends ConsumerStatefulWidget {
  const BookingStep4PasienScreen({super.key});

  @override
  ConsumerState<BookingStep4PasienScreen> createState() =>
      _BookingStep4PasienScreenState();
}

class _BookingStep4PasienScreenState
    extends ConsumerState<BookingStep4PasienScreen> {
  late final TextEditingController _nikController;
  late final TextEditingController _nameController;
  late final TextEditingController _birthController;
  bool _useUserData = true;

  @override
  void initState() {
    super.initState();
    final state = ref.read(bookingProvider);
    _useUserData = state.useUserData;
    _nikController = TextEditingController(text: state.patientNik);
    _nameController = TextEditingController(text: state.patientName);
    _birthController = TextEditingController(text: state.patientBirthDate);
  }

  @override
  void dispose() {
    _nikController.dispose();
    _nameController.dispose();
    _birthController.dispose();
    super.dispose();
  }

  void _showTermsDialog() {
    if (_nikController.text.trim().isEmpty ||
        _nameController.text.trim().isEmpty ||
        _birthController.text.trim().isEmpty) {
      AppToast.showError(
        context,
        'Gagal melanjutkan: Mohon lengkapi NIK, Nama, dan Tanggal Lahir pasien.',
      );
      return;
    }

    ref.read(bookingProvider.notifier).updatePatient(
          nik: _nikController.text.trim(),
          name: _nameController.text.trim(),
          birthDate: _birthController.text.trim(),
          useUserData: _useUserData,
        );

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Text(
                        'Syarat & Ketentuan\nAntrian Online',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Tutup dialog',
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),
                const Gap(6),
                const Text(
                  'Dengan mendaftar layanan ini berarti anda setuju untuk:',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const Gap(14),
                const _TermRow(
                  number: '1',
                  text: 'Datang 30 menit sebelum loket pendaftaran dibuka,',
                ),
                const _TermRow(
                  number: '2',
                  text: 'Dipanggil sesuai nomor antrean SANtri,',
                ),
                const _TermRow(
                  number: '3',
                  text:
                      'Melakukan konfirmasi kedatangan kepada petugas dengan menunjukkan bukti nomor antrean,',
                ),
                const _TermRow(
                  number: '4',
                  text:
                      'Dipanggil setelah 4 nomor panggilan selanjutnya setelah kedatangan, jika pada saat nomor antreannya sudah dipanggil 3 kali tapi tidak hadir',
                ),
                const Gap(18),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: A11yConstants.minTouchTargetSize,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      context.push('/booking/success');
                    },
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
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final booking = ref.watch(bookingProvider);

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
                    const SecondaryPageHeader(title: ''),
                    const BookingStepper(currentStep: 4),
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
                      'Masukkan data pasien',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const Gap(12),

                    // Peserta + Isi data pengguna checkbox
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Peserta',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        MergeSemantics(
                          child: Row(
                            children: [
                              const Text(
                                'Isi data pengguna',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.onSurfaceVariant,
                                ),
                              ),
                              Checkbox(
                                semanticLabel: 'Isi data pengguna',
                                value: _useUserData,
                                onChanged: (v) {
                                  final checked = v ?? false;
                                  setState(() {
                                    _useUserData = checked;
                                    if (checked) {
                                      _nikController.text = '312125125125';
                                      _nameController.text = 'Ahmed';
                                      _birthController.text = '12 Mei 1998';
                                    } else {
                                      _nikController.clear();
                                      _nameController.clear();
                                      _birthController.clear();
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const _FieldLabel('NIK'),
                    TextField(
                      controller: _nikController,
                      enabled: !_useUserData,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Masukkan NIK',
                        filled: true,
                        fillColor: _useUserData
                            ? const Color(0xFFE5E7EB)
                            : AppColors.surface,
                        suffixIcon:
                            !_useUserData && _nikController.text.isNotEmpty
                                ? IconButton(
                                    tooltip: 'Hapus NIK',
                                    onPressed: () {
                                      _nikController.clear();
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 20,
                                    ),
                                  )
                                : null,
                      ),
                    ),
                    const Gap(12),
                    const _FieldLabel('Nama'),
                    TextField(
                      controller: _nameController,
                      enabled: !_useUserData,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Masukkan Nama Lengkap',
                        filled: true,
                        fillColor: _useUserData
                            ? const Color(0xFFE5E7EB)
                            : AppColors.surface,
                        suffixIcon:
                            !_useUserData && _nameController.text.isNotEmpty
                                ? IconButton(
                                    tooltip: 'Hapus Nama',
                                    onPressed: () {
                                      _nameController.clear();
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 20,
                                    ),
                                  )
                                : null,
                      ),
                    ),
                    const Gap(12),
                    const _FieldLabel('Tanggal Lahir'),
                    TextField(
                      controller: _birthController,
                      enabled: !_useUserData,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Masukkan Tanggal Lahir',
                        filled: true,
                        fillColor: _useUserData
                            ? const Color(0xFFE5E7EB)
                            : AppColors.surface,
                        suffixIcon:
                            !_useUserData && _birthController.text.isNotEmpty
                                ? IconButton(
                                    tooltip: 'Hapus Tanggal Lahir',
                                    onPressed: () {
                                      _birthController.clear();
                                      setState(() {});
                                    },
                                    icon: const Icon(
                                      Icons.close_rounded,
                                      size: 20,
                                    ),
                                  )
                                : const Icon(Icons.calendar_today_outlined),
                      ),
                    ),
                    const Gap(20),

                    // Rekap Jadwal Card
                    Semantics(
                      header: true,
                      child: const Text(
                        'Rekap Jadwal',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ),
                    const Gap(10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x08000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _RecapRow(label: 'Poli', value: booking.selectedPoli),
                          const Divider(color: AppColors.outline, height: 20),
                          _RecapRow(
                            label: 'Dokter',
                            value: booking.selectedDoctor,
                          ),
                          const Divider(color: AppColors.outline, height: 20),
                          _RecapRow(
                            label: 'Tanggal',
                            value: booking.selectedDate,
                          ),
                          const Divider(color: AppColors.outline, height: 20),
                          _RecapRow(label: 'Jam', value: booking.selectedTime),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                  top: BorderSide(color: AppColors.outline, width: 0.75),
                ),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minWidth: double.infinity,
                  minHeight: A11yConstants.minTouchTargetSize,
                ),
                child: ElevatedButton(
                  onPressed: _showTermsDialog,
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
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
      ),
    );
  }
}

class _RecapRow extends StatelessWidget {
  const _RecapRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermRow extends StatelessWidget {
  const _TermRow({required this.number, required this.text});
  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              ),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.onSurface,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
