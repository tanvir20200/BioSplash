import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'aboutPage.dart';
import 'diversityPage.dart';
import 'explorePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BioSplash',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/diversity': (context) => const DiversityPage(),
        '/about': (context) => const AboutPage(),
        '/explore': (context) => const ExplorePage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('BioSplash'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[
            Text(
              'Fish Information App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Explore the aquatic world',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _waveController;
  late AnimationController _logoController;
  late AnimationController _bubblesController;
  late Animation<double> _waveAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  final List<Bubble> _bubbles = [];

  @override
  void initState() {
    super.initState();
    
    // Wave animation
    _waveController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _waveAnimation = CurvedAnimation(
      parent: _waveController,
      curve: Curves.easeInOut,
    );

    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40.0,
      ),
    ]).animate(_logoController);

    _logoOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
    ));

    // Bubbles animation
    _bubblesController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    // Generate random bubbles
    for (int i = 0; i < 15; i++) {
      _bubbles.add(Bubble(
        x: math.Random().nextDouble() * 400,
        y: math.Random().nextDouble() * 800 + 400,
        size: math.Random().nextDouble() * 20 + 10,
        speed: math.Random().nextDouble() * 2 + 1,
      ));
    }

     _logoController.forward().then((_) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const AboutPage(), // Changed from HomePage to AboutPage
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 500),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _logoController.dispose();
    _bubblesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Animated waves
          AnimatedBuilder(
            animation: _waveController,
            builder: (context, child) {
              return CustomPaint(
                painter: WavePainter(
                  waveAnimation: _waveAnimation.value,
                  bubbles: _bubbles,
                  bubbleAnimation: _bubblesController.value,
                ),
                size: Size.infinite,
              );
            },
          ),
          // Logo and text
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _logoController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Opacity(
                        opacity: _logoOpacityAnimation.value,
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue.shade100,
                          ),
                          child: Image.asset(
                            'assets/logo.png',
                            width: 80,
                            height: 80,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                AnimatedBuilder(
                  animation: _logoOpacityAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _logoOpacityAnimation.value,
                      child: const Text(
                        'BIOSPLASH',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double waveAnimation;
  final List<Bubble> bubbles;
  final double bubbleAnimation;

  WavePainter({
    required this.waveAnimation,
    required this.bubbles,
    required this.bubbleAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final wavePath = Path();
    wavePath.moveTo(0, size.height);

    // Create multiple wave layers
    for (int i = 0; i < 3; i++) {
      double opacity = 0.2 + (i * 0.1);
      double amplitude = 25 - (i * 5);
      double frequency = 0.015 + (i * 0.005);
      double phase = waveAnimation * 2 * math.pi + (i * math.pi / 4);

      paint.color = Colors.blue.withOpacity(opacity);
      
      for (double x = 0; x <= size.width; x++) {
        double y = size.height * 0.5 +
            amplitude * math.sin((x * frequency) + phase);
        if (x == 0) {
          wavePath.moveTo(x, y);
        } else {
          wavePath.lineTo(x, y);
        }
      }

      wavePath.lineTo(size.width, size.height);
      wavePath.lineTo(0, size.height);
      canvas.drawPath(wavePath, paint);
      wavePath.reset();
    }

    // Draw bubbles
    final bubblePaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    for (var bubble in bubbles) {
      double adjustedY = bubble.y - (bubble.speed * 200 * bubbleAnimation);
      if (adjustedY < -50) {
        adjustedY = size.height + 50;
      }
      
      canvas.drawCircle(
        Offset(bubble.x, adjustedY),
        bubble.size * (0.8 + 0.2 * math.sin(bubbleAnimation * 2 * math.pi)),
        bubblePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Bubble {
  double x;
  double y;
  double size;
  double speed;

  Bubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}