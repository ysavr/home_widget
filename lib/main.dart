import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_widget/home_widget.dart';
import 'package:homewidgetdemo/constant.dart';

import 'bloc/counter_bloc.dart';
import 'dash_with_sign.dart';

Future<void> mainInit() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HomeWidget.setAppGroupId(Constant().appGroupId);
  await HomeWidget.registerInteractivityCallback(interactiveCallback);
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => CounterBloc())],
      child: const MyApp(),
    ),
  );
}

@pragma('vm:entry-point')
Future<void> interactiveCallback(Uri? uri) async {
  if (uri?.host == 'increment') {
    final value = await HomeWidget.getWidgetData<int>('count_key', defaultValue: 0);
    final newValue = (value ?? 0) + 1;
    await HomeWidget.saveWidgetData('count_key', newValue);
  } else if (uri?.host == 'clear') {
    await HomeWidget.saveWidgetData('count_key', 0);
  }
  await HomeWidget.updateWidget(
    iOSName: 'MyHomeWidget',
    androidName: 'MyHomeWidget',
  );
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
    _syncFromWidget();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncFromWidget();
    }
  }

  Future<void> _syncFromWidget() async {
    final bloc = context.read<CounterBloc>();
    final sharedCount = await HomeWidget.getWidgetData<int>('count_key', defaultValue: 0);
    final currentBlocState = bloc.state;

    if (sharedCount != null && sharedCount != currentBlocState) {
      bloc.add(SyncCounter(sharedCount));
    }
  }

  Future<void> _syncToWidget(int value) async {
    await HomeWidget.saveWidgetData('count_key', value);
    await HomeWidget.updateWidget(
      iOSName: 'MyHomeWidget',
      androidName: 'MyHomeWidget',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: BlocBuilder<CounterBloc, int>(
        builder: (context, count) {
          _syncToWidget(count);
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('You have pushed the button this many times:'),
                Text(
                  "$count",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                DashWithSign(count: count),
                TextButton(
                  onPressed: () async {
                    context.read<CounterBloc>().add(ClearCounter());
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<CounterBloc>().add(IncrementCounter());
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
