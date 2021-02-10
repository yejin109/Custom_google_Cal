class _MemoCreatPageState extends State<MemoCreatPage> {
  File imageFile;
  String imagePath = "";

  TextEditingController memoContentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Usering usering = Provider.of<Usering>(context);
    final screen = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 24.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        child: Text('Gallery'),
                        onPressed: () {
                          fromGallery();
                        },
                      ),
                      RaisedButton(child: Text('입력 완료'), onPressed: () {
                        Navigator.pushNamed(context,'/MemoDeco',arguments: <String,dynamic>{
                          'imagePath':imagePath,
                          'contents' : memoContentController.text,
                        });
                      }),
                    ],
                  ),
                  Container(
                      child: imageFile != null
                          ? Container(
                              child: Image.file(imageFile, fit: BoxFit.cover),
                            )
                          : Container()),
                  Form(
                    child: Theme(
                      data: ThemeData(
                        primarySwatch: Colors.indigo,
                        inputDecorationTheme: InputDecorationTheme(
                            labelStyle: TextStyle(
                                color: Colors.indigoAccent[250],
                                fontSize: 18.0)),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(40.0),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: memoContentController,
                              decoration:
                                  InputDecoration(hintText: "PLACE HOLDER"),
                              keyboardType: TextInputType.text,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }

  Future<PickedFile> fromGallery() async {
    PickedFile pickedImage = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
        imagePath = pickedImage.path;
      });
    }
  }
}
