import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookingFlowState {
  const BookingFlowState({
    this.clinicCategory = 'Klinik Spesialis',
    this.selectedPoli = 'Poli Jantung & Pembuluh Darah',
    this.selectedDoctor = 'dr. Ahmad Fauzi, Sp. JP',
    this.selectedDate = 'Senin, 19 Maret 2026',
    this.selectedTime = '10.00 WIB',
    this.patientNik = '312125125125',
    this.patientName = 'Ahmed',
    this.patientBirthDate = '12 Mei 1998',
    this.useUserData = true,
  });

  final String clinicCategory;
  final String selectedPoli;
  final String selectedDoctor;
  final String selectedDate;
  final String selectedTime;
  final String patientNik;
  final String patientName;
  final String patientBirthDate;
  final bool useUserData;

  BookingFlowState copyWith({
    String? clinicCategory,
    String? selectedPoli,
    String? selectedDoctor,
    String? selectedDate,
    String? selectedTime,
    String? patientNik,
    String? patientName,
    String? patientBirthDate,
    bool? useUserData,
  }) {
    return BookingFlowState(
      clinicCategory: clinicCategory ?? this.clinicCategory,
      selectedPoli: selectedPoli ?? this.selectedPoli,
      selectedDoctor: selectedDoctor ?? this.selectedDoctor,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTime: selectedTime ?? this.selectedTime,
      patientNik: patientNik ?? this.patientNik,
      patientName: patientName ?? this.patientName,
      patientBirthDate: patientBirthDate ?? this.patientBirthDate,
      useUserData: useUserData ?? this.useUserData,
    );
  }
}

class BookingNotifier extends Notifier<BookingFlowState> {
  @override
  BookingFlowState build() => const BookingFlowState();

  void startFlow(String clinicCategory) {
    state = BookingFlowState(clinicCategory: clinicCategory);
  }

  void selectPoli(String poli) {
    state = state.copyWith(selectedPoli: poli);
  }

  void selectDoctor(String doctor) {
    state = state.copyWith(selectedDoctor: doctor);
  }

  void selectSchedule({required String date, required String time}) {
    state = state.copyWith(selectedDate: date, selectedTime: time);
  }

  void updatePatient({
    required String nik,
    required String name,
    required String birthDate,
    required bool useUserData,
  }) {
    state = state.copyWith(
      patientNik: nik,
      patientName: name,
      patientBirthDate: birthDate,
      useUserData: useUserData,
    );
  }
}

final bookingProvider =
    NotifierProvider<BookingNotifier, BookingFlowState>(BookingNotifier.new);
