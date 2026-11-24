# SANTRI Skripsi (`santri_skripsi`)

Accessible, WCAG 2.1 AA-compliant Flutter mobile & web application for hospital queue management, doctor scheduling, visit history, and patient services—designed for both **Android (TalkBack)** and **iOS (VoiceOver)**.

## Features Implemented
- **Home**: Personalized greeting, search bar, active upcoming appointment card (`Jadwal Mendatang`) with queue tracker, 2×3 hospital services grid (`Layanan Utama Rumah Sakit`), and accessibility news banner.
- **Jadwal**: Service category selector (`Klinik Spesialis`, `Klinik Eksekutif`, `Telemedicine`, `Kanker Terpadu`), live search filter, and Poliklinik list.
- **Riwayat**: Visit history search, year selector, interactive filter chips (`Semua Kunjungan`, `Rawat Jalan`, `Telemedicine`), and visit cards.
- **Settings**: Patient profile (`Profil Pasien`) with hospital QR code, account & security menu (`Ubah Kata Sandi`, `Kritik & Saran Layanan`, `Bantuan & FAQ`), and logout action.
- **Secondary Screens**:
  - `Detail Antrean` (queue progress, arrival QR verification, payment info, cancel action)
  - `Ketersediaan Kamar Rawat Inap` (bed availability KPIs + 6 room class cards)
  - `Info Pelayanan Operasi` (total & in-progress operation counters)
  - `Ubah Kata Sandi` (live strong-password criteria checklist)
  - `Kritik dan Saran Layanan` (accessible feedback form)
  - `FAQ` (topic filters + expandable accordions)

## Accessibility (WCAG 2.1 AA + TalkBack & VoiceOver)
- Minimum `48×48dp` interactive touch targets across all buttons, cards, and inputs.
- `MergeSemantics` & `OrderedTraversalPolicy` for logical screen-reader swipe navigation.
- Live screen-reader announcements via `A11yAnnouncer` (`SemanticsService.sendAnnouncement`).
- Dynamic text scaling up to `200%` (`WCAG 1.4.4`) and verified contrast ratios (`>= 4.5:1`).
- Automated WCAG verification in `test/accessibility_test.dart`.

## Getting Started

```bash
flutter pub get
flutter test
```

### Preview in Brave Browser (Web Phone Mirror)
```bash
export CHROME_EXECUTABLE="/Applications/Brave Browser.app/Contents/MacOS/Brave Browser"
flutter run -d chrome --web-port 8080
```
