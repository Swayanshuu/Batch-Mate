import 'package:flutter/material.dart';

class GradientText extends StatefulWidget {
  const GradientText({
    super.key,
    required this.text,
    required this.textSize,
    required this.textFamily,
  });

  final String text;
  final double textSize;
  final String textFamily;

  @override
  State<GradientText> createState() => _GradientTextState();
}

class _GradientTextState extends State<GradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller; // manage time and repeatation animatio
  late Animation<double> shimmerPosition;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(); // Continuous shine animation

    shimmerPosition = Tween<double>(begin: -1.0, end: 2.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ShaderMask(
        blendMode: BlendMode.srcIn,
        shaderCallback: (rect) {
          return LinearGradient(
            begin: const Alignment(-1, -1), // top-left
            end: const Alignment(1,1),     // bottom-right (diagonal = italic style)
            colors: const [
              Color(0xFFDADADA), // Dark silver
              Color.fromARGB(255, 59, 59, 59), // Light silver
              Color(0xFFDADADA), // Dark silver
            ],
            stops: [
              shimmerPosition.value - 0.3,
              shimmerPosition.value,
              shimmerPosition.value + 0.3,
            ],
          ).createShader(rect);
        },
        child: Text(
          widget.text,
          style: TextStyle(
            fontSize: widget.textSize,
            fontWeight: FontWeight.bold,
            fontFamily: widget.textFamily,
            color: Colors.white,
            letterSpacing: 1.5
          ),
        ),
      ),
    );
  }
}
