import 'package:get/get.dart';
import 'package:konsul/services/database_handler.dart';

import '../models/notification.dart' as k;

class NotificationController extends GetxController {
  final Rx<int> unReadNotification = RxInt(0);

  Future<void> refreshState() async {
    update();
  }

  Future<void> countUnreadNoitf() async {
    DatabaseHandler databaseHandler = DatabaseHandler.dbHandler;

    unReadNotification.value = await databaseHandler.countUnreadNotif();

    update();
  }

  Future<List<k.Notification>> getNotifications() async {
    DatabaseHandler databaseHandler = DatabaseHandler.dbHandler;

    List<Map<String, dynamic>> maps = await databaseHandler.getNotifications();

    List<k.Notification> notifications = [];

    for (var map in maps) {
      notifications.add(k.Notification.fromJSON(map));
    }

    return notifications;
  }

  Future<void> dumyData() async {
    DatabaseHandler databaseHandler = DatabaseHandler.dbHandler;

    databaseHandler.deleteAllNotifications();

    DateTime date = DateTime.now();

    List<Map> nots = [
      {
        'title': 'Waktu konsultasi anda telah tiba!',
        'subtitle':
            'Silahkan anda ke Dr. Riya untuk berkonsultasi penyakit anda',
        'new': true,
      },
      {
        'title': 'Waktu konsultasi anda telah tiba!',
        'subtitle':
            'Silahkan anda ke Dr. Andi Sindrom untuk berkonsultasi penyakit anda',
        'new': false,
      },
      {
        'title': 'Waktu konsultasi anda telah tiba!',
        'subtitle':
            'Silahkan anda ke Dr. Ahmad Wijaya untuk berkonsultasi penyakit anda',
        'new': false,
      }
    ];

    for (Map n in nots) {
      k.Notification notification = k.Notification(
        isnew: n['new'],
        title: n['title'],
        subtitle: n['subtitle'],
        date: date.toString(),
      );

      await databaseHandler.insertNotification(notification);
    }

    update();
  }

  Future<void> markAdRead() async {
    DatabaseHandler databaseHandler = DatabaseHandler.dbHandler;

    await databaseHandler.updateNotifications({
      'new': 0,
    });

    unReadNotification.value = await databaseHandler.countUnreadNotif();
  }

  Future<void> flushNotifications() async {
    DatabaseHandler databaseHandler = DatabaseHandler.dbHandler;

    await databaseHandler.deleteAllNotifications();

    update();
  }
}
