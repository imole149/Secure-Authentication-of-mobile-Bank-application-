import 'package:flutter/material.dart';

class BrightCareLogo extends StatelessWidget {
  final Color color;
  final bool showTagline;

  const BrightCareLogo({
    this.color = Colors.white,
    this.showTagline = true,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shield,
            color: color,
            size: 28,
          ),
        ),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BrightCare',
              style: TextStyle(
                color: color,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (showTagline)
              Text(
                'Safeguarded banking',
                style: TextStyle(
                  color: color.withOpacity(0.85),
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
