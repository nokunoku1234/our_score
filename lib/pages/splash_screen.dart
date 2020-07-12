import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_resumaker/main.dart';
import 'package:simple_resumaker/model/model.dart';
import 'package:simple_resumaker/utils/admob.dart';
import 'package:simple_resumaker/utils/db_provider.dart';

List<SaveData> dbData = [];

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _initialized = false;
  bool _expired = false;
  bool _visible = false;


  @override
  void initState() {
    super.initState();

    _changeVisible();
    _initialize();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _visible ? 1.0 : 0.0,
          duration: Duration(seconds: 2),
          child: Container(
            width: MediaQuery.of(context).size.width*0.8,
            child: Image.asset('assets/image/app_icon.gif')
          ),
        ),
      ),
    );
  }

  _changeVisible() async {
    Timer(Duration(seconds: 1),(){
      _visible = true;
      setState(() {
      });
    });
  }

  Future<void> setDb() async{
    await DbProvider.setDb();
    dbData = await DbProvider.getData();

    setState(() {

    });
  }

  _initialize() async {
    AdMob.deviceData =  await AdMob.getDeviceData();
    setDb();

    _initialized = true;
    _moveToMainScreen();
  }

  _startTimer() async {
    Timer(Duration(milliseconds: 3700),(){
      _expired = true;
      _moveToMainScreen();
    });
  }

  _moveToMainScreen(){
    if (_initialized && _expired) {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => HomePage(setDb: setDb)
      ));
    }
  }
}
