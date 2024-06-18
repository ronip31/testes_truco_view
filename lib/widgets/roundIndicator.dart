import 'package:flutter/material.dart';

class RoundIndicator extends StatelessWidget {
  final List<Color> colors;

  const RoundIndicator({Key? key, required this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Column(
          children: [
            Container(
              width: 20,
              height: 16,
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < colors.length ? colors[index] : Colors.grey,
                border: Border.all(color: Colors.black, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 1),
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
