import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

main() => runApp(Index());

class Index extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _IndexState();
  }
}

class _IndexState extends State<Index> {
  List<ImageEntity> entities = [];

  void loadData() async {
    entities = [];
    var result = await PhotoManager.requestPermission();
    if (result) {
      // 获取权限
      print('获取权限成功');
      var assetPathList = await PhotoManager.getAssetPathList(hasVideo: false);
      for (var value in assetPathList) {
        var list = await value.assetList;
        for (var assetEntity in list) {
          var file = await assetEntity.file;
          ImageEntity imageEntity = ImageEntity();
          imageEntity.path = file;
          entities.add(imageEntity);
        }
      }
    } else {
      // 没有获取权限
      print('获取权限失败');
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    print('重新渲染');
    return MaterialApp(
      title: 'Flutter 相册',
      home: Container(
        decoration: BoxDecoration(color: Colors.grey),
        padding: EdgeInsets.all(5),
        child: Center(
          child: entities.isEmpty
              ? CircularProgressIndicator(semanticsLabel: '正在加载...',)
              : GridView.builder(
                  itemCount: entities.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemBuilder: (context, index) {
//                    ImageProvider imageProvider =
//                        FileImage(entities[index].path);
//                    var myImage = MyImage(
//                      key: Key(entities[index].path.path),
//                      imageProvider: imageProvider,
//                    );
//                    return Stack(
//                      alignment: AlignmentDirectional.bottomCenter,
//                      children: <Widget>[
//
//                        Text(
//                          entities[index].path.path,
//                          maxLines: 1,
//                          softWrap: false,
//                          textAlign: TextAlign.end,
//                          style: TextStyle(
//                            fontSize: 12,
//                            color: Colors.white,
//                          ),
//                        ),
//                      ],
//                    );
                    return Image.file(
                      entities[index].path,
                      fit: BoxFit.cover,
                    );
                  }),
        ),
      ),
    );
  }
}

class MyImage extends StatefulWidget {
  const MyImage({
    Key key,
    @required this.imageProvider,
  })  : assert(imageProvider != null),
        super(key: key);

  final ImageProvider imageProvider;

  @override
  _MyImageState createState() => _MyImageState();
}

class _MyImageState extends State<MyImage> {
  ImageStream _imageStream;
  ImageInfo _imageInfo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // We call _getImage here because createLocalImageConfiguration() needs to
    // be called again if the dependencies changed, in case the changes relate
    // to the DefaultAssetBundle, MediaQuery, etc, which that method uses.
    _getImage();
  }

  @override
  void didUpdateWidget(MyImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageProvider != oldWidget.imageProvider) _getImage();
  }

  void _getImage() {
    final ImageStream oldImageStream = _imageStream;
    _imageStream =
        widget.imageProvider.resolve(createLocalImageConfiguration(context));
    if (_imageStream.key != oldImageStream?.key) {
      // If the keys are the same, then we got the same image back, and so we don't
      // need to update the listeners. If the key changed, though, we must make sure
      // to switch our listeners to the new image stream.
      oldImageStream?.removeListener(_updateImage);
      _imageStream.addListener(_updateImage);
    }
  }

  void _updateImage(ImageInfo imageInfo, bool synchronousCall) {
    setState(() {
      // Trigger a build whenever the image changes.
      _imageInfo = imageInfo;
    });
  }

  @override
  void dispose() {
    _imageStream.removeListener(_updateImage);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RawImage(
      image: _imageInfo?.image, // this is a dart:ui Image object
      scale: _imageInfo?.scale ?? 1.0,
      fit: BoxFit.cover,
    );
  }
}

class ImageEntity {
  File path;
}
