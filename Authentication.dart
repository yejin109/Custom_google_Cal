class FirestoreAuthenFeature {
  
  final FirebaseAuth _authen = FirebaseAuth.instance;

  Usering _userFromFirebaseUser(User user) {
    return user != null
        ? Usering(
            "KEY": "VALUE",
            ...
            )
        : Usering("KEY": "INITIAL VALUE", ... );
  }

  StreamController<Usering> userController = StreamController();

  Stream<Usering> get user {
    return _authen.authStateChanges().map(_userFromFirebaseUser);
  }

  void dispose() {
    this.userController.close();
  }
}
