import 'package:flutter/material.dart';
import 'dart:math';

main() => runApp(SliverDemo());

class SliverDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '碎片',
      home: Scaffold(
//          appBar: AppBar(
//            title: Text('碎片'),
//          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text('SliverAppBar'),
                centerTitle: true,
                floating: true,
                snap: true,
                backgroundColor: Colors.green,
                expandedHeight: 200.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.asset('images/dog.jpg', fit: BoxFit
                      .cover),
                ),
              ),
//              SliverList(
//                  delegate: SliverChildListDelegate([
//                Container(color: Colors.red, height: 150.0),
//                Container(color: Colors.purple, height: 150.0),
//                Container(color: Colors.green, height: 150.0),
//                Container(color: Colors.red, height: 150.0),
//                Container(color: Colors.purple, height: 150.0),
//                Container(color: Colors.green, height: 150.0),
//                Container(color: Colors.red, height: 150.0),
//                Container(color: Colors.purple, height: 150.0),
//                Container(color: Colors.green, height: 150.0),Container(color: Colors.red, height: 150.0),
//                Container(color: Colors.purple, height: 150.0),
//                Container(color: Colors.green, height: 150.0),
//
//              ])),
//              SliverList(
//                delegate: SliverChildBuilderDelegate((context, index) {
//                  if (index > 10) {
//                    return null;
//                  }
//                  return Container(color: getRandomColor(), height: 150.0);
//                }),
//              )
//              SliverFixedExtentList(
//                itemExtent: 150.0,
//                delegate: SliverChildListDelegate(
//                  [
//                    Container(color: Colors.red),
//                    Container(color: Colors.purple),
//                    Container(color: Colors.green),
//                    Container(color: Colors.orange),
//                    Container(color: Colors.yellow),
//                    Container(color: Colors.pink),
//                  ],
//                ),

                SliverFixedExtentList(
                  itemExtent: 150.0,
                  delegate: SliverChildBuilderDelegate((BuildContext context,
                      int index){
                    return Container(color: getRandomColor(), height: 150.0);
                  },childCount: 10),
              ),
            ],
          )),
    );
  }
}

getRandomColor(){
  var random = Random.secure();
  return Color.fromARGB(random.nextInt(255), random.nextInt(255), random
      .nextInt(255), random.nextInt(255));
}