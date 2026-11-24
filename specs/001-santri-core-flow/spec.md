# Spec 001 — SANTRI Core Outpatient Queue & Booking Flow

- **Status:** Active
- **Design Reference:** [SANTRI-Skripsi-2026 (Figma)](https://www.figma.com/design/Hss92Sg3JzPejImjF2JKIH/SANTRI-Skripsi-2026)
- **Constitution:** [AGENTS.md](../../AGENTS.md)

## 1. User Stories
- **As a patient**, I want to browse available clinics and register for an outpatient queue through a guided 7-step flow, so that I can book an appointment without visiting the hospital counter.
- **As a patient with visual or motor impairments**, I want every screen, button, and status update to work seamlessly with TalkBack and VoiceOver, so that I can register and track my queue independently.
- **As a patient with an active appointment**, I want to view my upcoming schedule, receive H-3/H-2/H-1/Hari Ini reminders, track how many patients are ahead of me, and safely cancel if needed.

## 2. Acceptance Criteria (EARS Notation)

### Ubiquitous
- The system shall render all UI in Flutter with WCAG 2.1 AA contrast, `48×48 dp` minimum touch targets, and screen-reader semantics.
- The system shall provide mock catalog data for all clinic types (not only Klinik Eksekutif) so every clinic entry is navigable end-to-end.

### Event-Driven
- WHEN a user taps any clinic card on the Home screen THE system SHALL route the user into the 7-step booking flow (`1 → 2 → 3 → 4 → 5 → 6 → 7`).
- WHEN a user opens the schedule picker in Klinik Spesialis THE system SHALL generate available dates dynamically relative to the current system date.
- WHEN a user taps "Lanjutkan" on the "Antrean Berhasil Didaftarkan" confirmation screen THE system SHALL return to the Home screen with the newly registered appointment active under "Jadwal Mendatang".
- WHEN a user taps "Batalkan Antrean" THE system SHALL display a confirmation dialog (`CancelQueueDialog`) before mutating or removing the active queue.
- WHEN a user taps the universal search button on the Home screen THE system SHALL open a search interface that filters clinics, doctors, and services.
- WHEN a user taps a news item in the Berita carousel THE system SHALL navigate to the corresponding news detail screen.

### State-Driven
- WHILE an appointment is active in "Jadwal Mendatang" THE system SHALL display its reminder countdown status (`H-3`, `H-2`, `H-1`, or `Hari Ini`) and surface corresponding alerts in the Notification center.
- WHILE a user views "Detail Antrean" THE system SHALL display the live/mocked queue position including the "Pasien di Depan Anda" counter.

### Unwanted Behavior
- IF a booking, cancellation, or navigation action fails THEN THE system SHALL display an accessible error toast (`AppToast`) and announce the error via `A11yAnnouncer`.
- IF a user dismisses the cancellation confirmation dialog THEN THE system SHALL preserve the active queue without side effects.

### Optional Features
- WHERE the application runs on a desktop web browser THE system SHALL wrap the viewport in `WebMobileFrame` to preserve mobile proportions for demo and testing.

## 3. Non-Functional Requirements
- **Accessibility:** Full TalkBack (Android) and VoiceOver (iOS) traversal order, zero semantic label omissions on icon-only buttons, and WCAG AA compliance.
- **Performance:** Smooth 60fps scrolling on Home, Berita carousel, and clinic lists.
- **Maintainability:** Clear separation of Riverpod notifiers (`application/`), mock repositories (`data/`), and UI widgets (`presentation/`).

## 4. Out of Scope
- Real hospital backend API / BPJS integration (mock data only for thesis prototype).
- Real push notification infrastructure (FCM/APNs); reminders are simulated in-app via `NotificationNotifier`.
- Payment gateway processing.
