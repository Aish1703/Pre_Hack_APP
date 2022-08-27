// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:camera/camera.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hackelth_app/utils/constants.dart';
import 'package:wakelock/wakelock.dart';
import '../layouts/chart.dart';

// ignore_for_file: prefer_const_constructors_in_immutables, avoid_single_cascade_in_expression_statements, prefer_final_fields, curly_braces_in_flow_control_structures, prefer_const_constructors, unnecessary_null_comparison, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api

class HeartRatePage extends StatefulWidget {
  HeartRatePage({Key? key}) : super(key: key);
  @override
  _HeartRatePageState createState() {
    return _HeartRatePageState();
  }
}

class _HeartRatePageState extends State<HeartRatePage>
    with TickerProviderStateMixin {
  bool _toggled = false;
  List<SensorValue> _data = [];
  CameraController? _controller;
  double _alpha = 0.3;
  late AnimationController _animationController;
  double _iconScale = 1;
  int _bpm = 0;
  int _fs = 30;
  int _windowLen = 30 * 6;
  CameraImage? _image;
  late double _avg;
  late DateTime _now;
  Timer? _timer;

  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _animationController
      ..addListener(() {
        setState(() {
          _iconScale = 1.0 + _animationController.value * 0.4;
        });
      });
    super.initState();
  }

  void _clearData() {
    _data.clear();
    int now = DateTime.now().millisecondsSinceEpoch;
    for (int i = 0; i < _windowLen; i++)
      _data.insert(
          0,
          SensorValue(
              DateTime.fromMillisecondsSinceEpoch(now - i * 1000 ~/ _fs), 128));
  }

  void _toggle() {
    _clearData();
    _initController().then((onValue) {
      Wakelock.enable();
      _animationController.repeat(reverse: true);
      setState(() {
        _toggled = true;
      });
      _initTimer();
      _updateBPM();
    });
  }

  void _untoggle() {
    _disposeController();
    Wakelock.disable();
    _animationController.stop();
    _animationController.value = 0.0;
    setState(() {
      _toggled = false;
    });
  }

  void _disposeController() {
    _controller?.dispose();
  }

  Future<void> _initController() async {
    try {
      List cameras = await availableCameras();
      _controller = CameraController(cameras[0], ResolutionPreset.low);
      await _controller!.initialize();
      Future.delayed(const Duration(milliseconds: 100)).then((onValue) {
        _controller!.setFlashMode(FlashMode.torch);
      });
      _controller!.startImageStream((CameraImage image) {
        _image = image;
      });
    } on Exception {
      debugPrint("Error");
    }
  }

  void _initTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 1000 ~/ _fs), (timer) {
      if (_toggled) {
        if (_image != null) _scanImage(_image!);
      } else {
        timer.cancel();
      }
    });
  }

  void _scanImage(CameraImage image) {
    _now = DateTime.now();
    _avg =
        image.planes.first.bytes.reduce((value, element) => value + element) /
            image.planes.first.bytes.length;
    if (_data.length >= _windowLen) {
      _data.removeAt(0);
    }
    setState(() {
      _data.add(SensorValue(_now, 255 - _avg));
    });
  }

  void _updateBPM() async {
    List<SensorValue> _values;
    double _avg;
    int _n;
    double _m;
    double _threshold;
    double _bpm;
    int _counter;
    int _previous;
    while (_toggled) {
      _values = List.from(_data); // create a copy of the current data array
      _avg = 0;
      _n = _values.length;
      _m = 0;
      for (var value in _values) {
        _avg += value.value / _n;
        if (value.value > _m) _m = value.value;
      }
      _threshold = (_m + _avg) / 2;
      _bpm = 0;
      _counter = 0;
      _previous = 0;
      for (int i = 1; i < _n; i++) {
        if (_values[i - 1].value < _threshold &&
            _values[i].value > _threshold) {
          if (_previous != 0) {
            _counter++;
            _bpm += 60 *
                1000 /
                (_values[i].time.millisecondsSinceEpoch - _previous);
          }
          _previous = _values[i].time.millisecondsSinceEpoch;
        }
      }
      if (_counter > 0) {
        _bpm = _bpm / _counter;
        setState(() {
          this._bpm = ((1 - _alpha) * this._bpm + _alpha * _bpm).toInt();
        });
      }
      await Future.delayed(Duration(milliseconds: 1000 * _windowLen ~/ _fs));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _toggled = false;
    _disposeController();
    Wakelock.disable();
    _animationController.stop();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(18),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              _controller != null && _toggled
                                  ? SizedBox(
                                      height: 70,
                                      width: 60,
                                      child: ClipOval(
                                          child: AspectRatio(
                                        aspectRatio:
                                            _controller!.value.aspectRatio,
                                        child: CameraPreview(
                                          _controller!,
                                          child: const Center(
                                            child: Icon(
                                              Icons.fingerprint_rounded,
                                              color: Colors.white,
                                              size: 60,
                                            ),
                                          ),
                                        ),
                                      )),
                                    )
                                  : Container(
                                      padding: EdgeInsets.all(12),
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                    ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(4),
                                child: Text(
                                  _toggled
                                      ? "Cover both camera and \nflash with your finger"
                                      : "Camera feed will display here",
                                  style: GEHackTheme.geStyle(
                                      size: 15,
                                      weight: FontWeight.w600,
                                      color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Expanded(
              flex: 1,
              child: Center(
                child: Transform.scale(
                  scale: _iconScale,
                  child: Stack(alignment: Alignment.center, children: [
                    IconButton(
                      icon: Icon(
                          _toggled ? Icons.favorite : Icons.favorite_outline),
                      color: GEHackTheme.redColor,
                      iconSize: MediaQuery.of(context).size.width * 0.35,
                      onPressed: () {
                        if (_toggled) {
                          _untoggle();
                        } else {
                          _toggle();
                        }
                      },
                    ),
                    Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          (_bpm > 30 && _bpm < 150 ? _bpm.toString() : "--"),
                          style: GEHackTheme.geStyle(
                              size: 18,
                              weight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ],
                    )),
                  ]),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(18),
                    ),
                    color: Colors.white),
                child: Chart(_data),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
