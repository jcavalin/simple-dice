import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shake/shake.dart';
import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:screen/screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ads/ads.dart';
import 'app_localizations.dart';

void main() {
  runApp(DiceRollingApp());
}

class DiceRollingApp extends StatefulWidget {
  @override
  _DiceRollingAppState createState() => _DiceRollingAppState();
}

class _DiceRollingAppState extends State<DiceRollingApp> {
  int nextDiceImage = 1;
  int lastDiceValue;
  String message = '';
  String messageLast = '';
  bool rolling = false;
  BuildContext context;

  void initState() {
    super.initState();

    Ads('ca-app-pub-3940256099942544~3347511713',
            bannerUnitId: 'ca-app-pub-3940256099942544/6300978111')
        .showBannerAd();

    ShakeDetector.autoStart(onPhoneShake: () {
      dev.log('shake');
      setImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    Screen.keepOn(true);

    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.redAccent));

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        supportedLocales: [
          Locale('en', 'US'),
          Locale('pt', 'BR'),
        ],
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        localeResolutionCallback: (locale, supportLocales) {
          if (locale == null) {
            return supportLocales.first;
          }

          for (var supportedLocale in supportLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }

          return supportLocales.first;
        },
        home: Scaffold(
            backgroundColor: Colors.redAccent,
            appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.redAccent,
                title: Center(
                    child: Text('A really simple dice'
                        // AppLocalizations.of(context).translate('title')
                        ))),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Expanded(
                  child: Center(
                      child: FlatButton(
                    child: Image.asset('assets/dice/dice-$nextDiceImage.png'),
                    onPressed: () {
                      setImage();
                    },
                  )),
                ),
                Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      message,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                Container(
                    child: Text(
                  messageLast,
                  style: TextStyle(color: Colors.white, fontSize: 10),
                )),
                Spacer(),
                Container(
                    margin: const EdgeInsets.only(bottom: 55),
                    child: Text(
                      'Touch the dice or shake it',
                      //AppLocalizations.of(context).translate('tip'),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
              ],
            )));
  }

  void setImage() {
    if (rolling) {
      return;
    }

    if (message != '') {
      lastDiceValue = nextDiceImage;
    }

    setState(() {
      message = '';
      messageLast = '';
      rolling = true;
    });

    int interval = 250;
    int limit = interval * 6;
    for (int mlseconds = interval; mlseconds <= limit; mlseconds += interval) {
      new Timer(new Duration(milliseconds: mlseconds), () {
        setState(() {
          nextDiceImage = Random().nextInt(6) + 1;

          if (mlseconds == limit) {
            message =
                /*AppLocalizations.of(this.context).translate('result') +*/
                'Your number is $nextDiceImage';

            if (lastDiceValue != null) {
              messageLast =
                  /*AppLocalizations.of(this.context).translate('last_result') +*/
                  'Your last number was $lastDiceValue';
            }

            rolling = false;
          }

          dev.log('dice value: $nextDiceImage');
        });
      });
    }
  }
}
