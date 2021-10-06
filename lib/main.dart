import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'blue_screen.dart';

void main() {
  runApp(const Starter());
}

class Starter extends StatelessWidget {
  const Starter({Key? key}) : super(key: key);

  static const String titleApp = 'Starter';
  static const List<Widget> widgets = [First(), FindDevicesScreen()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: titleApp,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(titleApp),
        ),
        body: Swiper(
          itemBuilder: (BuildContext context, int index) {
            return widgets[index];
          },
          loop: false,
          scrollDirection: Axis.horizontal,
          pagination: const SwiperPagination(alignment: Alignment.center),
          indicatorLayout: PageIndicatorLayout.COLOR,
          controller: SwiperController(),
          autoplay: false,
          itemCount: widgets.length,
        )
      ),
    );
  }
}