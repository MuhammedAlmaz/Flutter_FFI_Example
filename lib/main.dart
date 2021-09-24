import 'package:ffi_example/helper/ffi.dart';
import 'package:flutter/material.dart';
import 'dart:math' as Math;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FFI Demo',
      theme: ThemeData(primarySwatch: Colors.red),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int a = 0;
  int b = 0;

  @override
  initState() {
    _performanceTest();
  }

  int factorial({required int a}) {
    if (a > 1) {
      return a * factorial(a: a - 1);
    } else {
      return 1;
    }
  }

  _performanceTest() {
    int loopSize = Math.pow(10, 6).toInt();
    int factorialValue = 1000;
    AppFFI().initializeFactorialFunctions();

    //#region FFI
    Stopwatch stopwatch = new Stopwatch()..start();
    for (int i = 0; i < loopSize; i++) {
      AppFFI().factorial(a: factorialValue);
    }
    print('FFI executed in ${stopwatch.elapsed}');
    //#endregion

    //#region dart
    stopwatch.reset();
    for (int i = 0; i < loopSize; i++) {
      factorial(a: factorialValue);
    }
    print('Dart executed in ${stopwatch.elapsed}');
    stopwatch.stop();
    //#endregion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FFI Demo")),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(onChanged: (value) => this.setState(() => a = int.parse(value.length == 0 ? "0" : value))),
            TextField(onChanged: (value) => this.setState(() => b = int.parse(value.length == 0 ? "0" : value))),
            Text("Sonuç: ${AppFFI().sum(a: a, b: b)}"),
          ],
        ),
      ),
    );
  }
}
