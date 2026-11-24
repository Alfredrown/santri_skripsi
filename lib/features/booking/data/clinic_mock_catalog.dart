/// Mock data models & catalog for all 4 clinic categories:
/// Klinik Spesialis, Klinik Eksekutif, Telemedicine, and Kanker Terpadu.
class PoliMock {
  const PoliMock({
    required this.name,
    required this.doctorsCount,
    required this.dailyQuota,
  });

  final String name;
  final int doctorsCount;
  final int dailyQuota;
}

class DoctorMock {
  const DoctorMock({
    required this.name,
    required this.schedule,
    required this.status,
    required this.available,
  });

  final String name;
  final String schedule;
  final String status;
  final bool available;
}

class ClinicCatalogEntry {
  const ClinicCatalogEntry({
    required this.ketentuan,
    required this.paymentType,
    required this.polis,
    required this.doctors,
  });

  final String ketentuan;
  final String paymentType;
  final List<PoliMock> polis;
  final List<DoctorMock> doctors;
}

abstract final class ClinicMockCatalog {
  static ClinicCatalogEntry forCategory(String category) {
    switch (category) {
      case 'Klinik Eksekutif':
        return _klinikEksekutif;
      case 'Telemedicine':
        return _telemedicine;
      case 'Kanker Terpadu':
        return _kankerTerpadu;
      case 'Klinik Spesialis':
      default:
        return _klinikSpesialis;
    }
  }

  static const _klinikSpesialis = ClinicCatalogEntry(
    ketentuan:
        'Klinik Spesialis melayani pasien BPJS Kesehatan (dengan surat rujukan Faskes 1 aktif) dan pasien Umum. Loket buka pukul 07.00–13.00 WIB (Senin–Sabtu).',
    paymentType: 'BPJS Kesehatan / Umum',
    polis: [
      PoliMock(
        name: 'Poli Jantung & Pembuluh Darah',
        doctorsCount: 5,
        dailyQuota: 48,
      ),
      PoliMock(name: 'Poli Anak', doctorsCount: 4, dailyQuota: 40),
      PoliMock(name: 'Poli Penyakit Dalam', doctorsCount: 6, dailyQuota: 55),
      PoliMock(name: 'Poli Gigi & Mulut', doctorsCount: 3, dailyQuota: 30),
      PoliMock(name: 'Poli Syaraf', doctorsCount: 3, dailyQuota: 28),
      PoliMock(name: 'Poli Mata', doctorsCount: 4, dailyQuota: 36),
    ],
    doctors: [
      DoctorMock(
        name: 'dr. Malik Kudus, Sp.A',
        schedule: 'Senin, Selasa, dan Kamis • Praktik 08.00-13.00',
        status: 'Sisa 14 Kuota',
        available: true,
      ),
      DoctorMock(
        name: 'dr. Sarah Melati, Sp.PD',
        schedule: 'Senin, Rabu, dan Jumat • Praktik 08.00-14.00',
        status: 'Sisa 9 Kuota',
        available: true,
      ),
      DoctorMock(
        name: 'dr. Hendra Wijaya, Sp.JP',
        schedule: 'Selasa dan Kamis',
        status: 'Tidak Praktik Hari Ini',
        available: false,
      ),
      DoctorMock(
        name: 'dr. Rina Kartika, Sp.M',
        schedule: 'Senin dan Rabu',
        status: 'Kuota Penuh Hari Ini',
        available: false,
      ),
    ],
  );

  static const _klinikEksekutif = ClinicCatalogEntry(
    ketentuan:
        'Klinik Eksekutif (Non-BPJS / Asuransi Swasta & Umum) dengan ruang tunggu prioritas dan waktu tunggu minimal. Loket buka pukul 08.00–16.00 WIB.',
    paymentType: 'Umum / Asuransi Eksekutif',
    polis: [
      PoliMock(
        name: 'Poli Jantung & Pembuluh Darah',
        doctorsCount: 5,
        dailyQuota: 48,
      ),
      PoliMock(name: 'Poli Gigi', doctorsCount: 3, dailyQuota: 30),
      PoliMock(name: 'Poli Anak', doctorsCount: 4, dailyQuota: 40),
      PoliMock(name: 'Poli Syaraf', doctorsCount: 2, dailyQuota: 25),
      PoliMock(name: 'Poli Kulit dan Kelamin', doctorsCount: 3, dailyQuota: 35),
      PoliMock(name: 'Poli Penyakit Dalam', doctorsCount: 5, dailyQuota: 50),
    ],
    doctors: [
      DoctorMock(
        name: 'dr. Ahmad Fauzi, Sp. Jp',
        schedule: 'Senin, Rabu, dan Jumat • Praktik 08.00-14.00',
        status: 'Sisa 12 Kuota',
        available: true,
      ),
      DoctorMock(
        name: 'dr. Lisa Mariana, Sp. S',
        schedule: 'Senin, Rabu, dan Jumat • Praktik 08.00-14.00',
        status: 'Sisa 12 Kuota',
        available: true,
      ),
      DoctorMock(
        name: 'dr. Amir Rahman, Sp. T',
        schedule: 'Senin dan Rabu',
        status: 'Tidak Praktik Hari Ini',
        available: false,
      ),
      DoctorMock(
        name: 'dr. Siti Nurhaliza, Sp. KJ',
        schedule: 'Senin dan Rabu',
        status: 'Kuota Penuh Hari Ini',
        available: false,
      ),
    ],
  );

  static const _telemedicine = ClinicCatalogEntry(
    ketentuan:
        'Konsultasi video daring bersama dokter spesialis tanpa perlu datang ke rumah sakit. Tautan ruang video dan resep elektronik dikirim otomatis 15 menit sebelum jadwal.',
    paymentType: 'Telemedicine (E-Wallet / VA)',
    polis: [
      PoliMock(name: 'Tele-Konsultasi Umum', doctorsCount: 6, dailyQuota: 60),
      PoliMock(name: 'Tele-Poli Anak', doctorsCount: 4, dailyQuota: 32),
      PoliMock(
        name: 'Tele-Penyakit Dalam & Kontrol Obat',
        doctorsCount: 5,
        dailyQuota: 40,
      ),
      PoliMock(name: 'Tele-Kesehatan Jiwa', doctorsCount: 3, dailyQuota: 20),
      PoliMock(name: 'Tele-Gizi Klinik', doctorsCount: 2, dailyQuota: 24),
    ],
    doctors: [
      DoctorMock(
        name: 'dr. Nadia Kusuma, Sp.A',
        schedule: 'Setiap Hari • Sesi Video 09.00-17.00',
        status: 'Sisa 8 Slot Video',
        available: true,
      ),
      DoctorMock(
        name: 'dr. Bagus Pratama, Sp.PD',
        schedule: 'Senin–Jumat • Sesi Video 10.00-15.00',
        status: 'Sisa 6 Slot Video',
        available: true,
      ),
      DoctorMock(
        name: 'dr. Dewi Anggraini, Sp.KJ',
        schedule: 'Rabu dan Jumat',
        status: 'Kuota Video Penuh',
        available: false,
      ),
    ],
  );

  static const _kankerTerpadu = ClinicCatalogEntry(
    ketentuan:
        'Pusat Layanan Kanker Terpadu (Onkologi) menyediakan konsultasi kemoterapi, radioterapi, dan bedah onkologi dengan pendampingan khusus pasien lansia & difabel.',
    paymentType: 'BPJS Rujukan Onkologi / Umum',
    polis: [
      PoliMock(name: 'Poli Onkologi Medik', doctorsCount: 4, dailyQuota: 30),
      PoliMock(name: 'Poli Bedah Onkologi', doctorsCount: 3, dailyQuota: 24),
      PoliMock(
        name: 'Poli Radioterapi & Kedokteran Nuklir',
        doctorsCount: 3,
        dailyQuota: 20,
      ),
      PoliMock(
        name: 'Poli Hematologi Onkologi',
        doctorsCount: 2,
        dailyQuota: 18,
      ),
      PoliMock(
        name: 'Klinik Nyeri & Perawatan Paliatif',
        doctorsCount: 2,
        dailyQuota: 16,
      ),
    ],
    doctors: [
      DoctorMock(
        name: 'Prof. dr. Surya Darma, Sp.PD-KHOM',
        schedule: 'Senin, Rabu, dan Kamis • Praktik 08.00-13.00',
        status: 'Sisa 7 Kuota',
        available: true,
      ),
      DoctorMock(
        name: 'dr. Ratna Sari, Sp.B(K)Onk',
        schedule: 'Senin, Selasa, dan Jumat • Praktik 09.00-14.00',
        status: 'Sisa 5 Kuota',
        available: true,
      ),
      DoctorMock(
        name: 'dr. Bima Sakti, Sp.Onk.Rad',
        schedule: 'Selasa dan Kamis',
        status: 'Tidak Praktik Hari Ini',
        available: false,
      ),
    ],
  );
}
