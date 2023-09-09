import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'metamask_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chatter',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Chatter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.surface,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          centerTitle: true,
          title: Text(widget.title,
              style:
                  const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          actions: <Widget>[
            Container(
                padding: const EdgeInsets.all(5),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.black),
                  onPressed: _incrementCounter,
                ))
          ]),
      body: ChangeNotifierProvider(
          create: (context) => MetamaskProvider()..start(),
          builder: (context, child) {
            return Container(child: Center(
              child: Consumer<MetamaskProvider>(
                  builder: (context, provider, child) {
                late final String message;
                if (provider.isConnected && provider.isOepratingChain) {
                  message = 'Connected';
                } else if (provider.isConnected && !provider.isOepratingChain) {
                  message =
                      'Wrong chain. Please connect to ${MetamaskProvider.operatingChain}';
                } else if (provider.isEnabled) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // const Text("Welcome to Chatter. Let's Connect"),
                      MaterialButton(
                          onPressed: () =>
                              context.read<MetamaskProvider>().connect(),
                          color: Colors.greenAccent,
                          padding: const EdgeInsets.all(0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                  'https://i0.wp.com/kindalame.com/wp-content/uploads/2021/05/metamask-fox-wordmark-horizontal.png?fit=1549%2C480&ssl=1',
                                  width: 250),
                            ],
                          )),
                    ],
                  );
                } else {
                  message = 'Please use a Web3 supported browser.';
                }
                return Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black),
                );
              }),
            ));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.search),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
