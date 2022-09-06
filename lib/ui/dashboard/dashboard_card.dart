import 'package:flutter/material.dart';

import '../../widgets/animations/animated_button.dart';

class DashboardCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final Color color;
  final IconData? iconData;
  final String? image;
  const DashboardCard({Key? key, required this.text, this.color = Colors.red, this.iconData, this.onTap, this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _color = Colors.white;
    final size = MediaQuery.of(context).size;
    final imageSize = size.height * 0.05;
    return AnimatedButton(
      onTap: () => onTap?.call(),
      child: Container(
        decoration: BoxDecoration(
          // boxShadow: kBoxShadow,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(20),
          color: _color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            image != null
                ? Image.asset(
                    image!,
                    // height: 40,
                    // width: 40,
                    height: imageSize,
                    width: imageSize,
                    color: Colors.black.withOpacity(0.7),
                  )
                : Icon(
                    iconData,
                    // size: 40,
                    size: imageSize,
                    color: Colors.black.withOpacity(0.7),
                  ),
            SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                text.toUpperCase(),
                textAlign: TextAlign.center,
                style: ThemeData.light().textTheme.bodyText2?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade900,
                      fontSize: size.width * 0.037,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}