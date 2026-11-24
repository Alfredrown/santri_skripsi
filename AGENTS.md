# AGENTS.md — Project Constitution (`santri_skripsi`)

> This file is the project-level **constitution** for **SANTRI Skripsi 2026** (an accessible Flutter outpatient clinic queue & booking application). Every specification, plan, task, and code change—by humans or AI coding agents—MUST respect these rules.

## 1. Workflow Rules (Spec-Driven Development)
- The system shall treat files under `specs/NNN-feature-name/` (`spec.md`, `plan.md`, `tasks.md`) as the single source of truth for feature behavior.
- WHEN a new feature or behavior change is requested THE agent SHALL update or create the corresponding `spec.md` before modifying application code.
- The agent shall pause for human review at every phase boundary (`Specify → Plan → Tasks → Implement`).
- The agent shall reference the relevant spec path in commit messages and pull requests (e.g., `feat(booking): dynamic clinic schedule, refs specs/001-santri-core-flow/spec.md`).

## 2. Technology Stack & Architecture
- The system shall be implemented exclusively in **Flutter** (Dart SDK `^3.14.0`) targeting **Android**, **iOS**, and **Web** (mobile-framed preview). Native Kotlin/Swift UI screens are out of scope.
- The system shall use **Riverpod** (`flutter_riverpod`) for all application state management.
- The system shall use **GoRouter** (`go_router`) for declarative navigation in `lib/core/router/app_router.dart`.
- The system shall follow a feature-first folder structure under `lib/features/<feature>/{application,data,presentation}/`, with shared primitives in `lib/core/`.
- The agent shall not introduce new runtime dependencies in `pubspec.yaml` without explicit human approval.

## 3. Design Source of Truth
- The system shall derive visual layouts, typography, spacing, and color tokens from the **SANTRI-Skripsi-2026** Figma file (`https://www.figma.com/design/Hss92Sg3JzPejImjF2JKIH/SANTRI-Skripsi-2026`).
- WHEN a Figma screen and existing code diverge THE agent SHALL flag the discrepancy to the human reviewer before overwriting either.

## 4. Accessibility & WCAG 2.1 AA Compliance (Non-Negotiable)
- The system shall comply with **WCAG 2.1 Level AA** across both Android (**TalkBack**) and iOS (**VoiceOver**).
- The system shall enforce a minimum touch target size of `48×48 dp` on all interactive controls (`lib/core/accessibility/a11y_constants.dart`).
- The system shall maintain a minimum color contrast ratio of `4.5:1` for normal text and `3:1` for large text and UI components.
- The system shall wrap all interactive controls with explicit `Semantics` labels, roles, and hints using `lib/core/accessibility/semantic_wrappers.dart` and `lib/core/widgets/accessible_*.dart`.
- WHEN dynamic state changes occur (toast errors, queue status updates, booking confirmation, cancellation) THE system SHALL announce the update to assistive technologies via `lib/core/accessibility/a11y_announcer.dart`.
- The system shall respect system text scaling (`MediaQuery.textScalerOf`) without text clipping or layout overflow.

## 5. Quality & Verification
- The agent shall run `flutter analyze` and accessibility/widget tests after completing each task in `tasks.md`.
- IF a user action fails or encounters an invalid state THEN THE system SHALL display an accessible toast notification (`lib/core/widgets/app_toast.dart`) rather than failing silently.
