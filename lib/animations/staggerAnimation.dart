import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class StaggerAnimation extends StatelessWidget {
  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius> borderRadius;
  final Animation<Color> color;

  StaggerAnimation({Key key, this.controller})
      : opacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: controller, curve: Interval(0.0, 0.1, curve: Curves.ease))),
        width = Tween<double>(begin: 50, end: 150).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.125, 0.25, curve: Curves.ease))),
        height = Tween<double>(begin: 50, end: 150).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.25, 0.375, curve: Curves.ease))),
        padding = EdgeInsetsTween(
                begin: const EdgeInsets.only(bottom: 16),
                end: const EdgeInsets.only(bottom: 75))
            .animate(CurvedAnimation(
                parent: controller,
                curve: Interval(0.25, 0.375, curve: Curves.ease))),
        borderRadius = BorderRadiusTween(
                begin: BorderRadius.circular(4), end: BorderRadius.circular(75))
            .animate(CurvedAnimation(
                parent: controller,
                curve: Interval(0.375, 0.5, curve: Curves.ease))),
        color = ColorTween(begin: Colors.indigo[100], end: Colors.orange[400])
            .animate(CurvedAnimation(
                parent: controller,
                curve: Interval(0.5, 0.75, curve: Curves.ease))),
        super(key: key);

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Container(
      padding: padding.value,
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: opacity.value,
        child: Container(
            width: width.value,
            height: height.value,
            decoration: BoxDecoration(
                color: color.value,
                border: Border.all(color: Colors.indigo[300], width: 3),
                borderRadius: borderRadius.value)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}

class StaggerDemo extends StatefulWidget {
  @override
  State createState() {
    return StaggerState();
  }
}

class StaggerState extends State<StaggerDemo>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
//    timeDilation = 10;

    return Scaffold(
      appBar: AppBar(
        title: Text('Staggered Animation'),
      ),
      body: GestureDetector(
        // 这里的意义 opaque 不透明 意味着下方控件 接收不到手势
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _playAnimation();
        },
        child: Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                )),
            child: StaggerAnimation(
              controller: controller.view,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      /// 同步执行动画 先顺序执行  再反方向执行
      await controller.forward().orCancel;
      await controller.reverse().orCancel;
    } on TickerCanceled {}
  }
}

main() => runApp(MaterialApp(
      home: StaggerDemo(),
    ));
