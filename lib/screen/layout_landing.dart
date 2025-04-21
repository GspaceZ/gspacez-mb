import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LayoutLanding extends StatefulWidget {
  final Widget child;
  const LayoutLanding({required this.child, super.key});

  @override
  State<LayoutLanding> createState() => _LayoutLandingState();
}

class _LayoutLandingState extends State<LayoutLanding>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat(reverse: true);

    _animation = TweenSequence<Alignment>([
      TweenSequenceItem(
          tween: Tween(
              begin: const Alignment(-1.0, 0.0),
              end: const Alignment(1.0, 0.0)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween(
              begin: const Alignment(1.0, 0.0),
              end: const Alignment(-1.0, 0.0)),
          weight: 50),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// TODO: CHECK LATER
  final List<Color> colors = [
    const Color(0xFF6C5DD3), // tím đậm
    const Color(0xFFAC6EFF), // tím sáng
    const Color(0xFF38BDF8), // xanh dương nhạt
    const Color(0xFF9333EA), // tím neon
  ];

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            height: screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: _animation.value,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.33, 0.66, 1.0],
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight / 3.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/svg/ic_logo.svg'),
                        const Text(
                          'Real comfortability',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'NotoSans',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  widget.child,
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
