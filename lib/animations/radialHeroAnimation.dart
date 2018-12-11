import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'dart:math' as math;

class Photo extends StatelessWidget {
  final String photo;
  final VoidCallback onTap;
  final Color color;

  const Photo({Key key, this.photo, this.onTap, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).primaryColor.withOpacity(0.25),
      child: InkWell(
        onTap: onTap,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints size) {
            return Image.asset(
              photo,
              fit: BoxFit.contain,
            );
          },
        ),
      ),
    );
  }
}

class RadialExpansion extends StatelessWidget {
  final double maxRadius;
  final clipRectSize;
  final Widget child;

  const RadialExpansion({Key key, this.maxRadius, this.child})
      : clipRectSize = 2.0 * (maxRadius / math.sqrt2),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Center(
        child: SizedBox(
          width: clipRectSize,
          height: clipRectSize,
          child: ClipRect(
            child: child,
          ),
        ),
      ),
    );
  }
}

class RadialExpansionDemo extends StatelessWidget {
  static const double kMinRadius = 32;
  static const double kMaxRadius = 128;

  static const opacityCurve =
      const Interval(0, 0.75, curve: Curves.fastOutSlowIn);

  static RectTween _createRecTween(Rect begin, Rect end) {
    print("begin:" + begin.toString() + " end: " + end.toString());
    return MaterialRectArcTween(begin: begin, end: end);
  }

  static Widget _buildPage(
      BuildContext context, String imgName, String description) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: Center(
        child: Card(
          elevation: 8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                width: kMaxRadius * 2,
                height: kMaxRadius * 2,
                child: Hero(
                    tag: imgName,
                    createRectTween: _createRecTween,
                    child: RadialExpansion(
                      maxRadius: kMaxRadius,
                      child: Photo(
                        photo: imgName,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )),
              ),
              Text(
                description,
                style: TextStyle(fontWeight: FontWeight.bold),
                textScaleFactor: 3,
              ),
              const SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, String imgName, String description) {
    return Container(
      width: kMinRadius * 2,
      height: kMinRadius * 2,
      child: Hero(
          createRectTween: _createRecTween,
          tag: imgName,
          child: RadialExpansion(
            maxRadius: kMaxRadius,
            child: Photo(
              photo: imgName,
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                  return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        return Opacity(
                          opacity: opacityCurve.transform(animation.value),
                          child: _buildPage(context, imgName, description),
                        );
                      });
                }));
              },
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
//    timeDilation = 5.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Radial Transition Demo'),
      ),
      body: Container(
        padding: const EdgeInsets.all(32),
        alignment: FractionalOffset.bottomLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildHero(context, 'images/dog.jpg', '狗狗'),
            _buildHero(context, 'images/cat.jpg', '小猫'),
            _buildHero(context, 'images/dart.jpg', '小黄鸭'),
          ],
        ),
      ),
    );
  }
}

main() => runApp(MaterialApp(
      home: RadialExpansionDemo(),
    ));
