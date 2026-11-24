import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:material_ui/material_ui.dart';

class UpcomingAppointment {
  const UpcomingAppointment({
    required this.doctorName,
    required this.clinicInfo,
    required this.badgeLabel,
    required this.dateLabel,
    required this.timeLabel,
    required this.userQueueNumber,
    required this.currentQueueNumber,
  });

  final String doctorName;
  final String clinicInfo;
  final String badgeLabel;
  final String dateLabel;
  final String timeLabel;
  final int userQueueNumber;
  final int currentQueueNumber;
}

class HospitalServiceItem {
  const HospitalServiceItem({
    required this.id,
    required this.title,
    required this.semanticDescription,
    required this.iconAsset,
    required this.iconBgColor,
  });

  final String id;
  final String title;
  final String semanticDescription;
  final String iconAsset;
  final Color iconBgColor;
}

class HomeState {
  const HomeState({
    required this.dateText,
    required this.userName,
    required this.searchQuery,
    required this.selectedNavIndex,
    required this.upcomingAppointment,
    required this.services,
  });

  final String dateText;
  final String userName;
  final String searchQuery;
  final int selectedNavIndex;
  final UpcomingAppointment? upcomingAppointment;
  final List<HospitalServiceItem> services;

  HomeState copyWith({
    String? searchQuery,
    int? selectedNavIndex,
    UpcomingAppointment? upcomingAppointment,
    bool clearAppointment = false,
  }) {
    return HomeState(
      dateText: dateText,
      userName: userName,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
      upcomingAppointment:
          clearAppointment ? null : (upcomingAppointment ?? this.upcomingAppointment),
      services: services,
    );
  }
}

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    return const HomeState(
      dateText: '30 September 2026',
      userName: 'Ahmed',
      searchQuery: '',
      selectedNavIndex: 0,
      upcomingAppointment: UpcomingAppointment(
        doctorName: 'Dr. Malik Kudus',
        clinicInfo: 'Klinik Spesialis • Poli Anak',
        badgeLabel: 'HARI INI',
        dateLabel: 'Senin, 1 November',
        timeLabel: '09.00 - 10.00',
        userQueueNumber: 16,
        currentQueueNumber: 11,
      ),
      services: [
        HospitalServiceItem(
          id: 'klinik-spesialis',
          title: 'Klinik Spesialis',
          semanticDescription: 'Buka layanan Klinik Spesialis',
          iconAsset: AppAssets.klinikSpesialis,
          iconBgColor: AppColors.iconBgSpesialis,
        ),
        HospitalServiceItem(
          id: 'klinik-eksekutif',
          title: 'Klinik Eksekutif',
          semanticDescription: 'Buka layanan Klinik Eksekutif',
          iconAsset: AppAssets.klinikEksekutif,
          iconBgColor: AppColors.iconBgEksekutif,
        ),
        HospitalServiceItem(
          id: 'telemedicine',
          title: 'Telemedicine',
          semanticDescription: 'Buka layanan konsultasi video Telemedicine',
          iconAsset: AppAssets.telemedicine,
          iconBgColor: AppColors.iconBgTelemedicine,
        ),
        HospitalServiceItem(
          id: 'kanker-terpadu',
          title: 'Kanker Terpadu',
          semanticDescription: 'Buka layanan Kanker Terpadu',
          iconAsset: AppAssets.kankerTerpadu,
          iconBgColor: AppColors.iconBgKanker,
        ),
        HospitalServiceItem(
          id: 'layanan-kamar',
          title: 'Informasi Layanan Kamar',
          semanticDescription: 'Buka Informasi Layanan Kamar Rawat Inap',
          iconAsset: AppAssets.layananKamar,
          iconBgColor: AppColors.iconBgKamar,
        ),
        HospitalServiceItem(
          id: 'layanan-operasi',
          title: 'Informasi Layanan Operasi',
          semanticDescription: 'Buka Informasi Layanan Operasi',
          iconAsset: AppAssets.layananOperasi,
          iconBgColor: AppColors.iconBgOperasi,
        ),
      ],
    );
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setNavIndex(int index) {
    state = state.copyWith(selectedNavIndex: index);
  }

  void cancelAppointment() {
    state = state.copyWith(clearAppointment: true);
  }
}

final homeProvider = NotifierProvider<HomeNotifier, HomeState>(HomeNotifier.new);
