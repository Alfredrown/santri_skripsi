class VisitHistoryItem {
  const VisitHistoryItem({
    required this.id,
    required this.dateLabel,
    required this.timeLabel,
    required this.serviceType,
    required this.poliklinik,
    required this.doctorName,
    required this.queueNumber,
    required this.paymentType,
    required this.diagnosis,
    required this.doctorNotes,
    required this.prescriptions,
  });

  final String id;
  final String dateLabel;
  final String timeLabel;
  final String serviceType;
  final String poliklinik;
  final String doctorName;
  final int queueNumber;
  final String paymentType;
  final String diagnosis;
  final String doctorNotes;
  final List<String> prescriptions;
}

abstract final class RiwayatMockData {
  static const List<VisitHistoryItem> visits = [
    VisitHistoryItem(
      id: 'visit-1',
      dateLabel: '14 Oktober 2026',
      timeLabel: '09:40 WIB',
      serviceType: 'Rawat Jalan',
      poliklinik: 'Poliklinik Anak',
      doctorName: 'dr. Sarah Melati, Sp.A',
      queueNumber: 12,
      paymentType: 'BPJS Kesehatan',
      diagnosis: 'ISPA Ringan (Infeksi Saluran Pernapasan Akut)',
      doctorNotes:
          'Istirahat cukup, perbanyak minum air hangat, dan hindari paparan asap. Kontrol kembali bila demam lebih dari 3 hari.',
      prescriptions: [
        'Paracetamol Sirup 120mg/5ml — 3x1 sendok takar setelah makan',
        'Vitamin C 50mg — 1x1 tablet sehari',
      ],
    ),
    VisitHistoryItem(
      id: 'visit-2',
      dateLabel: '02 September 2026',
      timeLabel: '11:15 WIB',
      serviceType: 'Rawat Jalan',
      poliklinik: 'Poli Gigi',
      doctorName: 'drg. Budi Santoso, Sp.KG',
      queueNumber: 8,
      paymentType: 'Umum',
      diagnosis: 'Karies Gigi Molar Rahang Bawah (Tambal Komposit)',
      doctorNotes:
          'Tindakan penambalan selesai. Hindari makanan terlalu keras atau dingin selama 24 jam ke depan. Kontrol rutin 6 bulan sekali.',
      prescriptions: [
        'Asam Mefenamat 500mg — 3x1 bila nyeri',
        'Obat Kumur Antiseptik — 2x sehari setelah menyikat gigi',
      ],
    ),
    VisitHistoryItem(
      id: 'visit-3',
      dateLabel: '19 Agustus 2026',
      timeLabel: '08:30 WIB',
      serviceType: 'Telemedicine',
      poliklinik: 'Poli Jantung & Pembuluh Darah',
      doctorName: 'dr. Malik Kudus, Sp.JP',
      queueNumber: 5,
      paymentType: 'Telemedicine (E-Wallet)',
      diagnosis: 'Kontrol Hipertensi Terkendali',
      doctorNotes:
          'Tekanan darah stabil (125/80 mmHg). Lanjutkan konsumsi obat rutin dan diet rendah garam. Resep elektronik diteruskan ke farmasi.',
      prescriptions: [
        'Amlodipine 5mg — 1x1 tablet pagi hari',
        'Atorvastatin 10mg — 1x1 tablet malam hari',
      ],
    ),
  ];

  static VisitHistoryItem findById(String id) {
    return visits.firstWhere(
      (v) => v.id == id,
      orElse: () => visits.first,
    );
  }
}
