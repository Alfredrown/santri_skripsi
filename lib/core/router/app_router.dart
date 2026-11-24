import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/antrean/presentation/screens/detail_antrean_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/services/presentation/screens/pelayanan_operasi_screen.dart';
import '../../features/services/presentation/screens/rawat_inap_screen.dart';
import '../../features/settings/presentation/screens/faq_screen.dart';
import '../../features/settings/presentation/screens/kritik_saran_screen.dart';
import '../../features/settings/presentation/screens/ubah_kata_sandi_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/detail-antrean',
        name: 'detail-antrean',
        builder: (context, state) => const DetailAntreanScreen(),
      ),
      GoRoute(
        path: '/rawat-inap',
        name: 'rawat-inap',
        builder: (context, state) => const RawatInapScreen(),
      ),
      GoRoute(
        path: '/pelayanan-operasi',
        name: 'pelayanan-operasi',
        builder: (context, state) => const PelayananOperasiScreen(),
      ),
      GoRoute(
        path: '/ubah-kata-sandi',
        name: 'ubah-kata-sandi',
        builder: (context, state) => const UbahKataSandiScreen(),
      ),
      GoRoute(
        path: '/kritik-saran',
        name: 'kritik-saran',
        builder: (context, state) => const KritikSaranScreen(),
      ),
      GoRoute(
        path: '/faq',
        name: 'faq',
        builder: (context, state) => const FaqScreen(),
      ),
    ],
  );
});
