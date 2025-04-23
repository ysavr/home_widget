import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:homewidgetdemo/constant.dart';

import 'dash_with_sign.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HomeWidget.setAppGroupId(Constant().appGroupId);
  await HomeWidget.registerInteractivityCallback(interactiveCallback);
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> interactiveCallback(Uri? uri) async {
  // Set AppGroup Id. This is needed for iOS Apps to talk to their WidgetExtensions
  await HomeWidget.setAppGroupId(Constant().appGroupId);

  // We check the host of the uri to determine which action should be triggered.
  if (uri?.host == 'increment') {
    await _increment();
  } else if (uri?.host == 'clear') {
    await _clear();
  }
}

Future<int> get _value async {
  final value = await HomeWidget.getWidgetData<int>(Constant().countKey, defaultValue: 0);
  return value!;
}

Future<int> _increment() async {
  final oldValue = await _value;
  final newValue = oldValue + 1;
  await _sendAndUpdate(newValue);
  return newValue;
}

Future<void> _clear() async {
  await _sendAndUpdate(null);
}

Future<void> _sendAndUpdate([int? value]) async {
  await HomeWidget.saveWidgetData(Constant().countKey, value);
  await HomeWidget.renderFlutterWidget(
    DashWithSign(count: value ?? 0),
    key: 'dash_counter',
    logicalSize: const Size(100, 100),
  );
  try {
    await HomeWidget.updateWidget(
      iOSName: Constant().iOSWidgetName,
      androidName: Constant().androidWidgetName,
    );
  } catch(e, s) {
    print("error $e");
    print("stack $s");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _incrementCounter() async {
    await _increment();
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _requestToPinWidget() async {
    final isRequestPinSupported =
    await HomeWidget.isRequestPinWidgetSupported();
    if (isRequestPinSupported == true) {
      await HomeWidget.requestPinWidget(
        androidName: 'CounterGlanceWidgetReceiver',
      );
    }
  }

  Future<void> _checkInstalledWidgets() async {
    final installedWidgets = await HomeWidget.getInstalledWidgets();
    debugPrint(installedWidgets.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            FutureBuilder<int>(
              future: _value,
              builder: (_, snapshot) => Column(
                children: [
                  Text(
                    (snapshot.data ?? 0).toString(),
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  DashWithSign(count: snapshot.data ?? 0),
                ],
              ),
            ),
            TextButton(
              onPressed: () async {
                await _clear();
                setState(() {});
              },
              child: const Text('Clear'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
