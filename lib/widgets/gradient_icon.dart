import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon(
      this.icon,
      this.size,
      this.gradient, {Key? key}
      ) : super(key: key);

  factory GradientIcon.themeIcon(IconData iconData,double size) {
    return GradientIcon(iconData, size,
      const LinearGradient(
          tileMode: TileMode.decal,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Colors.cyan, Colors.indigo]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}