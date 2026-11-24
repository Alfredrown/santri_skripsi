import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santri_skripsi/app.dart';

void main() {
  testWidgets(
    'All 4 main tabs (Home, Jadwal, Riwayat, Settings) meet WCAG 2.1 AA contrast, Android TalkBack (48x48dp), iOS VoiceOver (44x44pt), and labeled tap target guidelines',
    (WidgetTester tester) async {
      final SemanticsHandle handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          const ProviderScope(
            child: SantriSkripsiApp(),
          ),
        );
        await tester.pumpAndSettle();

        const tabs = ['Home', 'Jadwal', 'Riwayat', 'Settings'];
        for (final tab in tabs) {
          await tester.tap(find.text(tab));
          await tester.pumpAndSettle();

          await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
          await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
          await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
          await expectLater(tester, meetsGuideline(textContrastGuideline));
        }
      } finally {
        handle.dispose();
      }
    },
  );
}
