import '../../../core/constants/app_assets.dart';

class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.badgeLabel,
    required this.title,
    required this.summary,
    required this.fullContent,
    required this.publishedDate,
    required this.author,
    required this.imageAsset,
    required this.imageSemanticLabel,
  });

  final String id;
  final String badgeLabel;
  final String title;
  final String summary;
  final List<String> fullContent;
  final String publishedDate;
  final String author;
  final String imageAsset;
  final String imageSemanticLabel;
}

abstract final class NewsMockData {
  static const List<NewsArticle> articles = [
    NewsArticle(
      id: 'pendampingan-kursi-roda',
      badgeLabel: 'Aksesibilitas Ramah Disabilitas & Lansia',
      title: 'Layanan Pendampingan Kursi Roda & Bahasa Isyarat',
      summary:
          'Tersedia tim asistensi staf di lobi utama untuk membantu pasien lansia, disabilitas netra, rungu, atau hambatan mobilitas tanpa biaya tambahan.',
      fullContent: [
        'RSUD Dr. Soetomo melalui portal SANTRI kini menyediakan layanan pendampingan khusus bagi pasien lansia, penyandang disabilitas netra, tuli/rungu, serta pasien dengan hambatan mobilitas.',
        'Tim asistensi terlatih siaga di Lobi Utama setiap hari Senin hingga Sabtu mulai pukul 06.30 WIB. Fasilitas mencakup peminjaman kursi roda gratis, jalur pemandu taktil (guiding block), serta juru bahasa isyarat BISINDO untuk membantu komunikasi saat konsultasi dokter.',
        'Pasien atau pendamping cukup menunjukkan kode QR antrean kepada petugas di meja informasi lobi utama untuk langsung mendapatkan prioritas pendampingan tanpa biaya tambahan.',
      ],
      publishedDate: '24 November 2026',
      author: 'Tim Humas & Aksesibilitas RS',
      imageAsset: AppAssets.newsAccessibility,
      imageSemanticLabel:
          'Lobi utama rumah sakit yang ramah disabilitas dan lansia',
    ),
    NewsArticle(
      id: 'antrean-online-h7',
      badgeLabel: 'Info Layanan Digital',
      title: 'Pendaftaran Antrean Online Kini Bisa Dilakukan H-7',
      summary:
          'Pasien BPJS maupun Umum dapat memesan nomor antrean poliklinik hingga 7 hari sebelum jadwal kunjungan langsung dari aplikasi SANTRI.',
      fullContent: [
        'Untuk mengurangi kepadatan di ruang tunggu pagi hari, sistem antrean online SANTRI kini mendukung pemesanan jadwal poliklinik hingga H-7 sebelum tanggal pemeriksaan.',
        'Setelah berhasil mendaftar, nomor antrean dan estimasi waktu panggilan akan tampil secara real-time di halaman Beranda. Pasien cukup melakukan scan QR Code kedatangan maksimal 30 menit sebelum jam praktik dokter dimulai.',
        'Jika berhalangan hadir, pasien dapat membatalkan antrean langsung melalui aplikasi agar kuota dapat digunakan oleh pasien lain yang membutuhkan.',
      ],
      publishedDate: '18 November 2026',
      author: 'Instalasi Sistem Informasi RS',
      imageAsset: AppAssets.newsAccessibility,
      imageSemanticLabel:
          'Suasana pendaftaran anjungan mandiri pasien rumah sakit',
    ),
    NewsArticle(
      id: 'telemedicine-kontrol-obat',
      badgeLabel: 'Telemedicine & Farmasi',
      title: 'Kontrol Obat Rutin Lebih Mudah via Video Telemedicine',
      summary:
          'Pasien penyakit kronis kini dapat berkonsultasi dengan dokter spesialis dari rumah dengan layanan antar obat langsung ke alamat pasien.',
      fullContent: [
        'Layanan Telemedicine SANTRI memudahkan pasien lansia dan pasien kontrol rutin (hipertensi, diabetes, dan jantung) untuk berkonsultasi tatap muka secara daring tanpa harus antre di rumah sakit.',
        'Resep elektronik yang diterbitkan dokter akan langsung diteruskan ke Instalasi Farmasi. Obat dapat diambil oleh keluarga di loket khusus Drive-Thru atau dikirim langsung ke rumah pasien melalui mitra kurir resmi.',
      ],
      publishedDate: '10 November 2026',
      author: 'Instalasi Farmasi & Telemedicine',
      imageAsset: AppAssets.newsAccessibility,
      imageSemanticLabel:
          'Layanan konsultasi kesehatan dan farmasi rumah sakit',
    ),
  ];

  static NewsArticle findById(String id) {
    return articles.firstWhere(
      (a) => a.id == id,
      orElse: () => articles.first,
    );
  }
}
