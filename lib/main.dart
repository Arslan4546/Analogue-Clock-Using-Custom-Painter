import 'package:analogue_clock_using_custom_painter/custom_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analogue Clock',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Clock Using Custom Painter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late Ticker _ticker;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();

    // Initialize the current time
    _currentTime = DateTime.now();

    // Ticker to update the time every second
    _ticker = Ticker((_) {
      setState(() {
        _currentTime = DateTime.now();
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          children: [
            Container(
              width: 200, // Width of the container
              height: 200, // Height of the container
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Makes the container round
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black, // Shadow color
                    blurRadius: 10, // How much the shadow blurs
                    offset: Offset(3, 4), // Position of the shadow
                  ),
                ],
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade200,
                    Colors.purple.shade200,
                  ], // Gradient background
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            CustomPaint(
              size: const Size(200, 200),
              painter: ClockPainter(currentTime: _currentTime),
            ),
          ],
        ),
      ),
    );
  }
}
