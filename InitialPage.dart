class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    Usering usering = Provider.of<Usering>(context);
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          RaisedButton(
            child: Text('시작하기'),
            onPressed: () {
              if (usering."VALUE" == "") {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => RegisterPage()),
                    ModalRoute.withName('/Register'));
              } else if (usering."VALUE" != "") {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ToDoListPage()),
                    ModalRoute.withName('/ToDoList'));
              }
            },
          )
        ],
      )),
    );
  }
}
