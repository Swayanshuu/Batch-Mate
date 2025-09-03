// ignore_for_file: file_names, deprecated_member_use
import 'dart:ui';

import 'package:classroombuddy/Screens/On-Boarding%20Screen/1stScreen.dart';
import 'package:classroombuddy/Screens/On-Boarding%20Screen/2ndScreen.dart';
import 'package:classroombuddy/Screens/On-Boarding%20Screen/3rdScreen.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

PageController _controller = PageController();
bool hasSeenBoarding = false;

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            children: [
              FirstScreen(controller: _controller),
              SecondScreen(controller: _controller),
              ThirdScreen(),
            ],
          ),
          Container(
            alignment: Alignment(0, 0.85),
            child: SmoothPageIndicator(
              controller: _controller,
              count: 3,
              effect: ExpandingDotsEffect(
                dotColor: Colors.white,
                activeDotColor: Colors.white,
                dotHeight: 14,
                dotWidth: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}




