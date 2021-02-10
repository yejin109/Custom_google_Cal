class _MemoDecoPageState extends State<MemoDecoPage> {
  var globalKey = new GlobalKey();

  EditableItem _activeItem;

  Offset _initPos;

  Offset _currentPos;

  double _currentScale;

  double _currentRotation;

  bool _inAction = false;

  EditableItem textData;

  EditableItem imageData;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;

    final Map<String, dynamic> info = ModalRoute.of(context).settings.arguments;
    final String contents = info["KEY"];
    final String imagePath = info["KEY"];
    final initialData = [
      EditableItem()
        ..type = ItemType.Text
        ..value = contents,
      EditableItem()
        ..type = ItemType.Image
        ..value = imagePath
    ];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_a_photo),
        onPressed: () {
          _capture();
          print('캡쳐');
        },
      ),
      body: GestureDetector(
        onScaleStart: (details) {
          if (_activeItem == null) return;

          _initPos = details.focalPoint;
          _currentPos = _activeItem.position;
          _currentScale = _activeItem.scale;
          _currentRotation = _activeItem.rotation;
        },
        onScaleUpdate: (details) {
          if (_activeItem == null) return;
          final delta = details.focalPoint - _initPos;
          final left = (delta.dx / screen.width) + _currentPos.dx;
          final top = (delta.dy / screen.height) + _currentPos.dy;

          setState(() {
            _activeItem.position = Offset(left, top);
            _activeItem.rotation = details.rotation + _currentRotation;
            _activeItem.scale = details.scale * _currentScale;
            if (_activeItem.type == ItemType.Image) {
              imageData = _activeItem;
            } else if (_activeItem.type == ItemType.Text) {
              textData = _activeItem;
            }
          });
        },
        child: RepaintBoundary(
          key: globalKey,
          child: Stack(
            children: [
              Container(color: Colors.black26),
              imageData == null
                  ? _buildItemWidget(initialData[1])
                  : _buildItemWidget(imageData),
              textData == null
                  ? _buildItemWidget(initialData[0])
                  : _buildItemWidget(textData)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemWidget(EditableItem e) {
    final screen = MediaQuery.of(context).size;

    var widget;
    switch (e.type) {
      case ItemType.Text:
        widget = Text(
          e.value,
          style: TextStyle(color: Colors.white),
        );
        break;
      case ItemType.Image:
        widget = Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Image.file(File(e.value)));
    }

    return Positioned(
      top: e.position.dy * screen.height,
      left: e.position.dx * screen.width,
      child: Transform.scale(
        scale: e.scale,
        child: Transform.rotate(
          angle: e.rotation,
          child: Listener(
            onPointerDown: (details) {
              if (_inAction) return;
              _inAction = true;
              _activeItem = e;
              _initPos = details.position;
              _currentPos = e.position;
              _currentScale = e.scale;
              _currentRotation = e.rotation;
            },
            onPointerUp: (details) {
              _inAction = false;
            },
            child: widget,
          ),
        ),
      ),
    );
  }

  void _capture() async {
    print("START CAPTURE");
    var renderObject = globalKey.currentContext.findRenderObject();
    if (renderObject is RenderRepaintBoundary) {
      var boundary = renderObject;
      ui.Image image = await boundary.toImage();
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();
      final directory = (await Directory.systemTemp.createTemp()).path;
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      GallerySaver.saveImage(imgFile.path);
      print("FINISH CAPTURE ${imgFile.path}");
    }
  }
}

enum ItemType { Image, Text }

class EditableItem {
  Offset position = Offset(0.1, 0.1);
  double scale = 1.0;
  double rotation = 0.0;
  ItemType type;
  String value;
}
