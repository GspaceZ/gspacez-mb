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
  late Animation<Alignment> _alignmentAnimation;
  late Animation<double> _colorAnimation;

  // Định nghĩa các màu chính
  final List<Color> primaryColors = [
    const Color(0xFF6C5DD3), // tím đậm
    const Color(0xFF38BDF8), // xanh dương nhạt
    const Color(0xFF9333EA), // tím neon
    const Color(0xFF3B82F6), // xanh dương đậm
  ];

  List<Color> _getGradientColors(double value) {
    // Tính toán index của màu hiện tại và màu tiếp theo
    int colorCount = primaryColors.length;
    double scaledValue = value * (colorCount - 1);
    int currentIndex = scaledValue.floor();
    int nextIndex = (currentIndex + 1) % colorCount;
    double t = scaledValue - currentIndex;

    // Tạo gradient với 3 màu
    Color startColor = Color.lerp(primaryColors[currentIndex], primaryColors[nextIndex], t)!;
    Color middleColor = Color.lerp(
      primaryColors[(currentIndex + 1) % colorCount],
      primaryColors[(nextIndex + 1) % colorCount],
      t,
    )!;
    Color endColor = Color.lerp(
      primaryColors[(currentIndex + 2) % colorCount],
      primaryColors[(nextIndex + 2) % colorCount],
      t,
    )!;

    return [startColor, middleColor, endColor];
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    _alignmentAnimation = TweenSequence<Alignment>([
      TweenSequenceItem(
        tween: AlignmentTween(
          begin: const Alignment(-1.0, -0.5),
          end: const Alignment(1.0, 0.5),
        ),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );

    _colorAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutSine,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final colors = _getGradientColors(_colorAnimation.value);
          return Container(
            height: screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: colors,
                begin: _alignmentAnimation.value,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.5, 1.0],
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
