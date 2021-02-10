main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Usering>.value(
      value: FirestoreAuthenFeature().user,
      child: MaterialApp(
        title: 'AI Cloud Personal Management',
        theme: ThemeData(primarySwatch: Colors.indigo),
        initialRoute: '/Initial',
        routes: {
          '/Register': (context) => RegisterPage(),
          '/Account': (context) => AccountPage(),
          '/ToDoList': (context) => ToDoListPage(),
          '/CreateTodo': (context) => WritingPage(),
          '/Sheet': (context) => ToDoSheetPage(),
          '/Initial': (context) => InitialPage(),
          '/Memo': (context) => MeMoListPage(),
          '/MemoCreate': (context) => MemoCreatPage(),
          '/MemoDeco' :(context) => MemoDecoPage(),
        },
      ),
    );
  }
}
