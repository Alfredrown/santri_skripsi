import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:santri_skripsi/app.dart';

void main() {
  testWidgets('HomeScreen renders Figma sections and supports cancelling appointment',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: SantriSkripsiApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hai, Ahmed!'), findsOneWidget);
    expect(find.text('Jadwal Mendatang'), findsOneWidget);
    expect(find.text('Dr. Malik Kudus'), findsOneWidget);
    expect(find.text('Layanan Utama Rumah Sakit'), findsOneWidget);
    expect(find.text('Klinik Spesialis'), findsOneWidget);
    expect(find.text('Berita'), findsOneWidget);

    await tester.tap(find.text('Batalkan'));
    await tester.pumpAndSettle();

    expect(find.text('Batalkan Antrean?'), findsOneWidget);
    await tester.tap(find.text('Ya, Batalkan'));
    await tester.pumpAndSettle();

    expect(find.text('Dr. Malik Kudus'), findsNothing);
  });
}
