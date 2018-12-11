// TapboxA manages its own state.
import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class TabBoxA extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _TabBoxState();
  }
}

class _TabBoxState extends State<TabBoxA> {
  bool _active = false;

  void _toggleActive() {
    setState(() {
      _active = !_active;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _toggleActive,
        child: Container(
          child: Center(
            child: Text(
              _active ? 'Active' : 'InActive',
              style: TextStyle(fontSize: 32, color: Colors.white),
            ),
          ),
          width: 200,
          height: 200,
          decoration: BoxDecoration(
              color: _active ? Colors.lightGreen[700] : Colors.grey[600]),
        ));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '点击变色',
      home: Scaffold(
        appBar: AppBar(
          title: Text('点击变色'),
        ),
        body: TabBoxA(),
      ),
    );
  }
}
