import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:santri_skripsi/app.dart';
import 'package:santri_skripsi/core/theme/app_theme.dart';
import 'package:santri_skripsi/features/antrean/presentation/screens/detail_antrean_screen.dart';
import 'package:santri_skripsi/features/booking/presentation/screens/booking_step1_poli_screen.dart';
import 'package:santri_skripsi/features/booking/presentation/screens/booking_step2_dokter_screen.dart';
import 'package:santri_skripsi/features/booking/presentation/screens/booking_step3_jadwal_screen.dart';
import 'package:santri_skripsi/features/booking/presentation/screens/booking_step4_pasien_screen.dart';
import 'package:santri_skripsi/features/booking/presentation/screens/booking_step6_success_screen.dart';
import 'package:santri_skripsi/features/news/presentation/screens/news_detail_screen.dart';
import 'package:santri_skripsi/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:santri_skripsi/features/riwayat/presentation/screens/detail_riwayat_screen.dart';
import 'package:santri_skripsi/features/services/presentation/screens/pelayanan_operasi_screen.dart';
import 'package:santri_skripsi/features/services/presentation/screens/rawat_inap_screen.dart';
import 'package:santri_skripsi/features/settings/presentation/screens/faq_screen.dart';
import 'package:santri_skripsi/features/settings/presentation/screens/kritik_saran_screen.dart';
import 'package:santri_skripsi/features/settings/presentation/screens/ubah_kata_sandi_screen.dart';

Future<void> _verifyAllWcagGuidelines(WidgetTester tester) async {
  // 1. Android TalkBack minimum tap target size (48x48dp)
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  // 2. iOS VoiceOver minimum tap target size (44x44pt)
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  // 3. Every interactive control has a screen-reader semantic label
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  // 4. WCAG 2.1 AA text contrast (4.5:1 normal, 3.0:1 large)
  await expectLater(tester, meetsGuideline(textContrastGuideline));
}

Widget _wrapScreen(Widget screen) {
  return ProviderScope(
    child: MaterialApp(
      theme: AppTheme.lightTheme,
      home: screen,
    ),
  );
}

void main() {
  testWidgets(
    'All 4 main tabs (Home, Jadwal, Riwayat, Settings) pass WCAG 2.1 AA, TalkBack & VoiceOver guidelines',
    (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(const ProviderScope(child: SantriSkripsiApp()));
        await tester.pumpAndSettle();

        const tabs = ['Home', 'Jadwal', 'Riwayat', 'Settings'];
        for (final tab in tabs) {
          await tester.tap(find.text(tab));
          await tester.pumpAndSettle();
          await _verifyAllWcagGuidelines(tester);
        }
      } finally {
        handle.dispose();
      }
    },
  );

  final secondaryScreens = <String, Widget>{
    'DetailAntreanScreen': const DetailAntreanScreen(),
    'RawatInapScreen': const RawatInapScreen(),
    'PelayananOperasiScreen': const PelayananOperasiScreen(),
    'UbahKataSandiScreen': const UbahKataSandiScreen(),
    'KritikSaranScreen': const KritikSaranScreen(),
    'FaqScreen': const FaqScreen(),
    'NewsDetailScreen':
        const NewsDetailScreen(articleId: 'pendampingan-kursi-roda'),
    'NotificationsScreen': const NotificationsScreen(),
    'DetailRiwayatScreen': const DetailRiwayatScreen(visitId: 'visit-1'),
    'BookingStep1PoliScreen': const BookingStep1PoliScreen(),
    'BookingStep2DokterScreen': const BookingStep2DokterScreen(),
    'BookingStep3JadwalScreen': const BookingStep3JadwalScreen(),
    'BookingStep4PasienScreen': const BookingStep4PasienScreen(),
    'BookingStep6SuccessScreen': const BookingStep6SuccessScreen(),
  };

  for (final entry in secondaryScreens.entries) {
    testWidgets(
      '${entry.key} passes WCAG 2.1 AA, TalkBack (48dp), VoiceOver (44pt) & labeled tap targets',
      (WidgetTester tester) async {
        final SemanticsHandle handle = tester.ensureSemantics();
        try {
          await tester.pumpWidget(_wrapScreen(entry.value));
          await tester.pumpAndSettle();
          await _verifyAllWcagGuidelines(tester);
        } finally {
          handle.dispose();
        }
      },
    );
  }
}
