import 'package:material_ui/material_ui.dart';
import '../accessibility/a11y_constants.dart';
import '../theme/app_colors.dart';

/// Accessible confirmation dialog shown before cancelling an active queue appointment.
Future<bool> showCancelQueueDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Batalkan Antrean?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        content: const Text(
          'Apakah Anda yakin ingin membatalkan jadwal kunjungan ini? Nomor antrean Anda akan dilepas dan Anda perlu mendaftar ulang jika ingin berkunjung.',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.onSurfaceVariant,
            height: 1.45,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: A11yConstants.minTouchTargetSize,
            ),
            child: TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(
                'Tidak, Kembali',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryNavy,
                ),
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: A11yConstants.minTouchTargetSize,
            ),
            child: ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.danger,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Ya, Batalkan',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
