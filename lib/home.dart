import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String batteryLevel = 'Listening ...';
  String chargingLevel = 'Streaming...';
  late StreamSubscription _streamSubscription;

  static const batteryChannel = MethodChannel('battery');
  static const eventChannel = EventChannel('charging');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onListenBattery();
    onStreamBattery();
  }
  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32),
        child: Column(
          children: [
            Text(
              batteryLevel,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, color: Colors.blue),
            ),
            Text(
              chargingLevel,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  void onListenBattery() {
    batteryChannel.setMethodCallHandler((call) async {
      if (call.method == 'reportBatteryLevel') {
        final int batteryLevel = call.arguments;
        print(call.arguments);
        setState(() {
          this.batteryLevel = '$batteryLevel';
        });
      }
    });
  }

  void onStreamBattery() {
    _streamSubscription =  eventChannel.receiveBroadcastStream().listen((event) {
      setState(() {
        chargingLevel = event;
      });
    });
  }
}
