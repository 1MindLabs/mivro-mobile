import 'package:flutter/material.dart';

class CustomBackground extends StatelessWidget {
  final List<Widget>? children;
  final bool isHintText;
  final Widget? widget;
  const CustomBackground({
    super.key,
    this.children,
    this.isHintText = false,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: MediaQuery.of(context).size.height *
              0.01, // Adjust the position as needed
          left: MediaQuery.of(context).size.width *
              0.2, // Adjust left position as needed
          child: Container(
            width: 400, // Define size of the circle
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF5C8374), // Background color for the circle
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height *
              0.2, // Adjust the position as needed
          right: MediaQuery.of(context).size.width *
              0.2, // Adjust left position as needed
          child: Container(
            width: 400, // Define size of the circle
            height: 400,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromARGB(
                  104, 158, 200, 185), // Background color for the circle
            ),
          ),
        ),
        if (isHintText)
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.25,
            child: widget!,
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children!,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
