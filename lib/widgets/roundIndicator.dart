import 'package:flutter/material.dart';

class RoundIndicator extends StatelessWidget {
  final List<Color> colors;

  const RoundIndicator({super.key, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Column(
          children: [
            Container(
              width: 15,
              height: 12,
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < colors.length ? colors[index] : Colors.grey,
                border: Border.all(color: Colors.black, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
