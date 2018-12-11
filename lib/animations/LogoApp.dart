import 'package:flutter/material.dart';

main() => runApp(MaterialApp(
      title: '动画',
      home: Scaffold(
        appBar: AppBar(
          title: Text('动画'),
        ),
        body: Center(
          child: Center(
            child: LogoApp(),
          ),
        ),
      ),
    ));


class LogoApp extends StatefulWidget  {

  @override
  State<StatefulWidget> createState() {
    return _LogoAppState();
  }
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin{

  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration:Duration(seconds: 2),vsync: this);
    final CurvedAnimation curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    animation = Tween(begin: 0.0,end: 300.0).animate(curve);
    animation..addListener((){})
    ..addStatusListener((_){
      if(_==AnimationStatus.completed){
        controller.reverse();
      }else if(_==AnimationStatus.dismissed){
        controller.forward();
      }
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return GrowTransition(animation: animation,child: LogoWidget(),);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: FlutterLogo(),
    );
  }
}

/// 动画工具
class GrowTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;

  const GrowTransition({Key key, this.animation, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          child: child,
          animation: animation,
          builder: (ctx, child) {
            return Container(
              height: animation.value,
              width: animation.value,
              child: child,
            );
          }),
    );
  }
}
