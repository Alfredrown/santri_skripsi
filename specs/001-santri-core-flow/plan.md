# Plan 001 — Technical Architecture (`santri_skripsi`)

- **Spec:** [spec.md](./spec.md)
- **Constitution:** [AGENTS.md](../../AGENTS.md)

## 1. Architecture Overview
Feature-first layered Flutter architecture powered by **Riverpod** for reactive state and **GoRouter** for declarative routing.

```text
lib/
├── main.dart
├── app.dart
├── core/
│   ├── accessibility/   # a11y_constants.dart, a11y_announcer.dart, semantic_wrappers.dart
│   ├── constants/       # app_assets.dart, app_sizes.dart
│   ├── router/          # app_router.dart (GoRouter)
│   ├── theme/           # app_colors.dart, app_text_styles.dart, app_theme.dart
│   └── widgets/         # accessible_button.dart, accessible_card.dart, app_toast.dart,
│                        # cancel_queue_dialog.dart, secondary_page_header.dart, web_mobile_frame.dart
└── features/
    ├── booking/         # application/booking_notifier.dart, data/clinic_mock_catalog.dart, presentation/
    ├── home/            # application/home_notifier.dart, presentation/
    ├── news/            # data/news_mock_data.dart, presentation/
    └── notifications/   # application/notification_notifier.dart, presentation/
```

## 2. State Management Strategy (Riverpod)
- `BookingNotifier`: Manages the 7-step clinic registration state, selected clinic/doctor/dynamic date, active queue record, and "Pasien di Depan Anda" mock counter.
- `HomeNotifier`: Manages Home screen state, universal search filtering, and active "Jadwal Mendatang" card visibility.
- `NotificationNotifier`: Manages in-app notifications and `H-3` / `H-2` / `H-1` / `Hari Ini` appointment reminders synced with the active booking.

## 3. Accessibility Layer
- All interactive components use `AccessibleButton`, `AccessibleCard`, and `AccessibleTextField` to guarantee `48×48 dp` hit targets and consistent `Semantics`.
- `A11yAnnouncer` dispatches polite/assertive screen-reader announcements on state transitions and `AppToast` notifications.
- Color tokens in `AppColors` are audited against WCAG 2.1 AA contrast ratios.

## 4. Mock Data Strategy
- `clinic_mock_catalog.dart`: Provides structured mock data for Klinik Eksekutif, Klinik Spesialis, and secondary clinics, plus dynamic date generation from `DateTime.now()`.
- `news_mock_data.dart`: Provides mock articles for the Home Berita carousel and detail views.
