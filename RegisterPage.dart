class _RegisterPageState extends State<RegisterPage> {

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User currentUser;
  String _name = "";
  String _email = "";
  String _url = "";

  String id = '';
  String password = '';
  String error = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> googleSingIn() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await account.authentication;
    final AuthCredential _authCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await _auth.signInWithCredential(_authCredential);
    final User user = userCredential.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    currentUser = _auth.currentUser;
    assert(user.uid == currentUser.uid);

    setState(() {
      _email = user.email;
      _url = user.photoURL;
      _name = user.displayName;
    });

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => ToDoListPage()),
        ModalRoute.withName('/ToDoList'));

    return 'success';
  }

  void googleSignOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();

    setState(() {});

    print("User Sign Out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Register',
      ),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
            RaisedButton(
              onPressed: () {
                if (_email == '') {
                  googleSingIn();
                } else {
                  googleSignOut();
                }
              },
              child: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.subdirectory_arrow_right),
                      Text( "Google Log In")
                    ],
                  )),
            )
          ])),
    );
  }
}
