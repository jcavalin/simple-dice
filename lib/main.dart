import 'package:flutter/material.dart';
import 'dart:math';
import 'package:shake/shake.dart';

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

  void initState() {
    super.initState();
    ShakeDetector.autoStart(onPhoneShake: () {
      setImage();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  setState(() {
                    setImage();
                  });
                },
              )),
            ),
            Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text('Your number is $nextDiceImage', style: TextStyle(
                    color: Colors.white,
                    fontSize: 20),
                )
            ),
            Spacer(),
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: Text('Touch the dice', style: TextStyle(
                  color: Colors.white,
                  fontSize: 24),
              )
            ),
          ],
        )
      )
    );
  }

  void setImage() {
    nextDiceImage = Random().nextInt(6) + 1;
  }
}

