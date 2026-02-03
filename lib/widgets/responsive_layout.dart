import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget rightChild;
  final Widget? leftChild;

  const ResponsiveLayout({super.key, required this.rightChild, this.leftChild});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (isMobile) {
      return rightChild;
    }

    return Row(
      children: [
        // Left side - Black
        Expanded(
          child: Container(
            color: Colors.black,
            child: leftChild ?? Container(),
          ),
        ),
        // Right side - Dark grey (existing content)
        Expanded(
          child: Container(color: const Color(0xFF1A1A1A), child: rightChild),
        ),
      ],
    );
  }
}
