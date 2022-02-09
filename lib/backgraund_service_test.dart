import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackGraundServiceTest {
  var random = new Random();
  final List<String> duoe = [
    "قال رسول الله صلى الله عليه وسلم: (إِذَا مَاتَ الإنْسَانُ انْقَطَعَ عنْه عَمَلُهُ إِلَّا مِن ثَلَاثَةٍ: إِلَّا مِن صَدَقَةٍ جَارِيَةٍ، أَوْ عِلْمٍ يُنْتَفَعُ بِهِ، أَوْ وَلَدٍ صَالِحٍ يَدْعُو له",
    "عن جابر بن عبد الله -رضي الله عنه- قال: قال رسول الله صلّى الله عليه وسلم: (سلُوا اللهَ علمًا نافعًا، وتَعَوَّذُوا باللهِ منْ علمٍ لا ينفعُ",
    "قال صلّى الله عليه وسلّم: (سيأتيكُم أقوامٌ يطلبونَ العِلمَ، فإذا رأيتُموهم؛ فقولوا لَهُم مَرحبًا مَرحبًا بوصيَّةِ رسولِ اللَّهِ صلَّى اللَّهُ عليهِ وسلَّمَ، واقْنوهُم ",
    "قال رسول الله صلى الله عليه وسلم: (مَن جاءَ مَسجِدي هذا لم يَأتِهِ إلَّا لِخيرٍ يتعلَّمُهُ أو يعلِّمُهُ، فَهوَ بمنزلةِ المجاهِدِ في سبيلِ اللَّهِ، ومن جاءَ لغيرِ ذلِكَ فَهوَ بمنزلةِ الرَّجُلِ ينظرُ إلى متاعِ غيرِهِ)",
    "قال رسول الله صلى الله عليه وسلم: (نضَّرَ اللَّهُ امرأً سمِعَ منَّا حديثًا فحفِظَهُ حتَّى يبلِّغَهُ غيرَهُ، فرُبَّ حاملِ فقهٍ ليسَ بفَقيهٍ، ورُبَّ حاملِ فقهٍ إلى من هوَ أفقَهُ منهُ) "
  ];
  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        // this will executed when app is in foreground or background in separated isolate
        onStart: onStart,

        // auto start service
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        // auto start service
        autoStart: true,

        // this will executed when app is in foreground in separated isolate
        onForeground: onStart,

        // you have to enable background fetch capability on xcode project
        onBackground: onIosBackground,
      ),
    );
  }

// to ensure this executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
  void onIosBackground() {
    WidgetsFlutterBinding.ensureInitialized();
    print('FLUTTER BACKGROUND FETCH');
  }

  void onStart() {
    WidgetsFlutterBinding.ensureInitialized();
    final service = FlutterBackgroundService();
    service.onDataReceived.listen((event) {
      if (event["action"] == "setAsForeground") {
        service.setForegroundMode(true);
        return;
      }

      if (event["action"] == "setAsBackground") {
        service.setForegroundMode(false);
      }

      if (event["action"] == "stopService") {
        service.stopBackgroundService();
      }
    });

    // bring to foreground
    service.setForegroundMode(true);
    Timer.periodic(Duration(seconds: 3), (timer) async {
      if (!(await service.isServiceRunning())) timer.cancel();
      service.setNotificationInfo(
        title: "My App Service",
        content: duoe[random.nextInt(duoe.length)],
      );
      service.sendData(
        {"current_date": DateTime.now().toIso8601String()},
      );
    });
  }
}
