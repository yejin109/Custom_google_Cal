class _AccountPageState extends State<AccountPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void googleSignOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    setState(() {});
    print("User Sign Out");
  }

  @override
  Widget build(BuildContext context) {
    var usering = Provider.of<Usering>(context);

    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.grey[500],
      leading: Builder(builder: (context) {
        return IconButton(
          icon: Icon(
            Icons.list,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      }),
      title: Text(
        'User Account',
        style: TextStyle(color: Colors.amber[400]),
      ),
      actions: <Widget>[
       
      ],
    ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image.network(usering.url),
            Divider(
              height: 60.0,
              color: Colors.grey[850],
              thickness: 0.5,
              endIndent: 30.0,
            ),
            Text(
              usering.name,
              style: TextStyle(color: Colors.amber[300]),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              usering.email,
              style: TextStyle(color: Colors.amber[300]),
            ),
            Divider(
              height: 60.0,
              color: Colors.grey[850],
              thickness: 0.5,
              endIndent: 30.0,
            ),
            RaisedButton(
              onPressed: () {
                googleSignOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => InitialPage()),
                    ModalRoute.withName('/Initial'));
              },
              child: Center(
                child: Text('Log out'),
              ),
              color: Colors.grey[400],
              textColor: Colors.amber[400],
            )
          ],
        ),
      ),
    );
  }
}
