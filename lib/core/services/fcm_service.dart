import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:castly/core/services/local_notification_service.dart';

Future<void> _handlerBackgroundMessage(RemoteMessage message) async {}

class FCMService {
  final LocalNotificationService _localNotificationService;
  FCMService(this._localNotificationService);
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Future<void> init() async {
    await firebaseMessaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(_handlerBackgroundMessage);
    _handlerForegroundMessage();
  }

  Future<String> getDeviceToken() async {
    final token = await firebaseMessaging.getToken();
    return token ?? '';
  }

  void _handlerForegroundMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _localNotificationService.showNotification(message);
    });
  }
}
