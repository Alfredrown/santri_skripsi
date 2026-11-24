# Tasks 001 — Implementation Checklist (`santri_skripsi`)

- **Spec:** [spec.md](./spec.md)
- **Plan:** [plan.md](./plan.md)

## Phase A — Foundation & Accessibility Core
- [x] **T1: Project scaffold & theme tokens**
  - *Outputs:* `lib/core/theme/*`, `lib/core/constants/*`, `lib/core/router/app_router.dart`
  - *Check:* App boots on Android, iOS, and Web (`WebMobileFrame`) with zero analyzer warnings.
- [x] **T2: Accessibility primitives**
  - *Outputs:* `lib/core/accessibility/*`, `lib/core/widgets/accessible_*.dart`, `lib/core/widgets/app_toast.dart`
  - *Check:* All interactive widgets enforce `48×48 dp` minimum tap targets and explicit `Semantics`.

## Phase B — Core Booking & Queue Flow
- [x] **T3: Figma main design slice & 7-step booking flow**
  - *Inputs:* Figma `SANTRI-Skripsi-2026` main design frames
  - *Outputs:* `lib/features/booking/application/booking_notifier.dart`, `lib/features/booking/data/clinic_mock_catalog.dart`, booking screens `1 → 7`
  - *Check:* Tapping any clinic routes through steps 1–7; Klinik Spesialis dates generate dynamically from today's date.
- [x] **T4: Active queue, detail antrean & safe cancellation**
  - *Outputs:* `lib/core/widgets/cancel_queue_dialog.dart`, Detail Antrean ("Pasien di Depan Anda"), Home "Jadwal Mendatang" integration
  - *Check:* Pressing "Lanjutkan" returns to Home with active schedule; cancelling requires dialog confirmation.

## Phase C — Secondary Features & Verification
- [x] **T5: Home universal search & Berita carousel**
  - *Outputs:* `lib/features/home/application/home_notifier.dart`, `lib/features/news/data/news_mock_data.dart`, search & news detail views
  - *Check:* Search filters clinics/services; tapping any carousel item opens its detail page.
- [x] **T6: Reminder notifications (`H-3`, `H-2`, `H-1`, `Hari Ini`)**
  - *Outputs:* `lib/features/notifications/application/notification_notifier.dart`, notification screen
  - *Check:* Active schedule status triggers corresponding reminder entries in the notification center.
- [x] **T7: WCAG 2.1 AA accessibility audit**
  - *Check:* Screen-reader traversal, contrast ratios, and dynamic `A11yAnnouncer` feedback pass verification.
