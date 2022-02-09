import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  //NotificationService a singleton object
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = '123';
  var random = new Random();
  final List<String> duoe = [
    "قال رسول الله صلى الله عليه وسلم: (إِذَا مَاتَ الإنْسَانُ انْقَطَعَ عنْه عَمَلُهُ إِلَّا مِن ثَلَاثَةٍ: إِلَّا مِن صَدَقَةٍ جَارِيَةٍ، أَوْ عِلْمٍ يُنْتَفَعُ بِهِ، أَوْ وَلَدٍ صَالِحٍ يَدْعُو له",
    "عن جابر بن عبد الله -رضي الله عنه- قال: قال رسول الله صلّى الله عليه وسلم: (سلُوا اللهَ علمًا نافعًا، وتَعَوَّذُوا باللهِ منْ علمٍ لا ينفعُ",
    "قال صلّى الله عليه وسلّم: (سيأتيكُم أقوامٌ يطلبونَ العِلمَ، فإذا رأيتُموهم؛ فقولوا لَهُم مَرحبًا مَرحبًا بوصيَّةِ رسولِ اللَّهِ صلَّى اللَّهُ عليهِ وسلَّمَ، واقْنوهُم ",
    "قال رسول الله صلى الله عليه وسلم: (مَن جاءَ مَسجِدي هذا لم يَأتِهِ إلَّا لِخيرٍ يتعلَّمُهُ أو يعلِّمُهُ، فَهوَ بمنزلةِ المجاهِدِ في سبيلِ اللَّهِ، ومن جاءَ لغيرِ ذلِكَ فَهوَ بمنزلةِ الرَّجُلِ ينظرُ إلى متاعِ غيرِهِ)",
    "قال رسول الله صلى الله عليه وسلم: (نضَّرَ اللَّهُ امرأً سمِعَ منَّا حديثًا فحفِظَهُ حتَّى يبلِّغَهُ غيرَهُ، فرُبَّ حاملِ فقهٍ ليسَ بفَقيهٍ، ورُبَّ حاملِ فقهٍ إلى من هوَ أفقَهُ منهُ) "
  ];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    'channel ID',
    'channel name',
    'channel description',
    playSound: true,
    priority: Priority.defaultPriority,
    importance: Importance.unspecified,
    enableVibration: true,
    styleInformation: InboxStyleInformation(["", ""],
        htmlFormatContent: true, contentTitle: ""),
    ongoing: true,
  );

  Future<void> showNotifications() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      "Notification Title",
      duoe[random.nextInt(duoe.length)],
      NotificationDetails(android: _androidNotificationDetails),
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

Future selectNotification(String payload) async {
  //handle your logic here
}
