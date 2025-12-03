import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khokhar House Home Decoration 2025 Reviews',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _familyNameController = TextEditingController();
  final _reviewController = TextEditingController();
  bool _showThankYou = false;
  late AudioPlayer _audioPlayer;
  bool _isPlaying = true;
  List<Snowflake> _snowflakes = [];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initializeAudio();
    _generateSnowflakes();
  }

  void _initializeAudio() async {
    try {
      await _audioPlayer.setSource(AssetSource('jinglebells.mp3'));
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.resume();
    } catch (e) {
      // Handle audio initialization error
      print('Audio initialization failed: $e');
    }
  }

  void _generateSnowflakes() {
    _snowflakes = List.generate(50, (index) {
      final random = Random();
      return Snowflake(
        left: random.nextDouble() * MediaQuery.of(context).size.width,
        size: random.nextDouble() * 10 + 10,
        duration: Duration(seconds: random.nextInt(5) + 5),
        opacity: random.nextDouble(),
      );
    });
    setState(() {});
  }

  void _toggleMusic() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _submitReview() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _showThankYou = true;
      });
      _nameController.clear();
      _familyNameController.clear();
      _reviewController.clear();
      Timer(const Duration(seconds: 3), () {
        setState(() {
          _showThankYou = false;
        });
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _nameController.dispose();
    _familyNameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF004d00),
                  Color(0xFF003300),
                ],
              ),
            ),
          ),
          // Snowflakes
          ..._snowflakes.map((snowflake) => Positioned(
                left: snowflake.left,
                top: -10,
                child: AnimatedOpacity(
                  opacity: snowflake.opacity,
                  duration: snowflake.duration,
                  child: Text(
                    '❄',
                    style: TextStyle(
                      fontSize: snowflake.size,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
          // Main content
          SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  color: const Color(0xFFb30000),
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: const Text(
                    'Welcome to Khokhar House Home Decoration 2025',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                // Container
                Container(
                  margin: const EdgeInsets.all(30),
                  padding: const EdgeInsets.all(20),
                  constraints: const BoxConstraints(maxWidth: 900),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 15,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Submit Your Review',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: 'Your Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _familyNameController,
                              decoration: const InputDecoration(
                                hintText: 'Family Name',
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your family name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _reviewController,
                              decoration: const InputDecoration(
                                hintText: 'Write your review here...',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 4,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please write your review';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _submitReview,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFb30000),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              child: const Text('Submit Review'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      if (_showThankYou)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFd4edda),
                            border: Border.all(color: const Color(0xFFc3e6cb)),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Thank you for your review!',
                            style: TextStyle(
                              color: Color(0xFF155724),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _toggleMusic,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004d99),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(_isPlaying ? 'Pause Music' : 'Play Music'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Snowflake {
  final double left;
  final double size;
  final Duration duration;
  final double opacity;

  Snowflake({
    required this.left,
    required this.size,
    required this.duration,
    required this.opacity,
  });
}