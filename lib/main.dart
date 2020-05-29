import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shake/shake.dart';
import 'dart:developer' as dev;
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(DiceRollingApp());
}

class DiceRollingApp extends StatefulWidget {
  @override
  _DiceRollingAppState createState() => _DiceRollingAppState();
}

class _DiceRollingAppState extends State<DiceRollingApp> {
  int nextDiceImage = 1;
  String message = '';
  bool rolling = false;

  void initState() {
    super.initState();
    ShakeDetector.autoStart(onPhoneShake: () {
      dev.log('shake');
      setImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.redAccent
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold (
        backgroundColor: Colors.redAccent,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.redAccent,
          title: Center(child: Text('A really simple dice'))
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Spacer(),
            Expanded(
              flex: 1,
              child: Center(child: FlatButton(
                child: Image.asset('assets/dice/dice-$nextDiceImage.png'),
                onPressed: () {
                    setImage();
                },
              )),
            ),
            Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(message, style: TextStyle(
                    color: Colors.white,
                    fontSize: 20),
                )
            ),
            Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text('Touch the dice or shake it', style: TextStyle(
                  color: Colors.white,
                  fontSize: 22),
              )
            ),
          ],
        )
      )
    );
  }

  void setImage() {
    if(rolling) {
      return;
    }

    setState(() {
      message = '';
      rolling = true;
    });

    int interval = 200;
    int limit = interval * 6;
    for( int mlseconds = interval ; mlseconds <= limit; mlseconds+=interval ) {
      new Timer(new Duration(milliseconds: mlseconds), () {
        setState(() {
          nextDiceImage = Random().nextInt(6) + 1;

          if(mlseconds == limit) {
            message = 'Your number is $nextDiceImage';
            rolling = false;
          }

          dev.log('dice value: $nextDiceImage');
        });
      });
    }
  }
}

