import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NotificationType { queue, reminder, pharmacy, info }

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timeAgo,
    required this.type,
    this.isRead = false,
    this.routeTarget,
  });

  final String id;
  final String title;
  final String body;
  final String timeAgo;
  final NotificationType type;
  final bool isRead;
  final String? routeTarget;

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      body: body,
      timeAgo: timeAgo,
      type: type,
      isRead: isRead ?? this.isRead,
      routeTarget: routeTarget,
    );
  }
}

class NotificationNotifier extends Notifier<List<AppNotification>> {
  @override
  List<AppNotification> build() {
    return const [
      AppNotification(
        id: 'notif-1',
        title: 'Pengingat Jadwal (HARI INI)',
        body:
            '3 Pasien di depan Anda untuk Dr. Malik Kudus (Poli Anak). Harap bersiap menuju ruang tunggu.',
        timeAgo: '5 menit lalu',
        type: NotificationType.queue,
        isRead: false,
        routeTarget: '/detail-antrean',
      ),
      AppNotification(
        id: 'notif-2',
        title: 'Pengingat H-1 Kunjungan',
        body:
            'Besok Anda memiliki jadwal pemeriksaan pukul 09.00 WIB. Siapkan KTP & kode QR kedatangan.',
        timeAgo: '1 hari lalu',
        type: NotificationType.reminder,
        isRead: false,
        routeTarget: '/detail-antrean',
      ),
      AppNotification(
        id: 'notif-3',
        title: 'Layanan Pendampingan Disabilitas & Lansia',
        body:
            'Tim asistensi kursi roda dan juru bahasa isyarat siaga di Lobi Utama tanpa biaya tambahan.',
        timeAgo: '2 hari lalu',
        type: NotificationType.info,
        isRead: true,
        routeTarget: '/berita/pendampingan-kursi-roda',
      ),
    ];
  }

  int get unreadCount => state.where((n) => !n.isRead).length;

  void addNotification({
    required String title,
    required String body,
    required NotificationType type,
    String? routeTarget,
  }) {
    final newNotif = AppNotification(
      id: 'notif-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      body: body,
      timeAgo: 'Baru saja',
      type: type,
      isRead: false,
      routeTarget: routeTarget,
    );
    state = [newNotif, ...state];
  }

  void markAsRead(String id) {
    state = [
      for (final n in state)
        if (n.id == id) n.copyWith(isRead: true) else n,
    ];
  }

  void markAllAsRead() {
    state = [for (final n in state) n.copyWith(isRead: true)];
  }
}

final notificationProvider =
    NotifierProvider<NotificationNotifier, List<AppNotification>>(
  NotificationNotifier.new,
);
