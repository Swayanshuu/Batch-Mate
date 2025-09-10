import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String screenshot;
  final String tag;

  const FullScreenImage({
    super.key,
    required this.screenshot,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: tag,
              child: Image.network(screenshot, fit: BoxFit.contain),
            ),
          ),
          // Close button at top-left
          Positioned(
            bottom: 80,
            right: 20,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.red, size: 30),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}
