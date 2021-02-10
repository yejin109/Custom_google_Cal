class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

void prompt(String url) async {
  print("Please go to the following URL and grant access:");
  print("  => $url");
  print("");

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class _ToDoListPageState extends State<ToDoListPage> {
  DocumentSnapshot currentDocu;
  Future _saving;

  @override
  Widget build(BuildContext context) {
    Usering usering = Provider.of<Usering>(context);

    String identity = "IDENTITY";
    String directory = "DIRECTORY";

    CollectionReference userCollection =
        FirebaseFirestore.instance.collection(directory);

    const _scopes = [cal.CalendarApi.CalendarScope];

    cal.Events loadEvent() {
      cal.Events todos = cal.Events();

      var _clientID = ClientId(
          "CLIENT ID",
          "");
      auth
          .clientViaUserConsent(_clientID, _scopes, prompt)
          .then((AuthClient client) {
        var calendar = cal.CalendarApi(client);
        calendar.events.list('primary').then((value) {
          value.items.forEach((element) {
            userCollection.doc(element.id).set({
              "KEY" : element."VALUE"
              ...
            }, SetOptions(merge: true));
          });
        });
        print("구글캘린더 연결 완료 ");
        return todos;
      });
      return null;
    }

    Widget _buildToDoList(
        BuildContext context, List<QueryDocumentSnapshot> docuList, int index) {
      DocumentSnapshot currentDocu = docuList[index];
      Timestamp recentWithStamp = currentDocu["KEY"];
      recentWithStamp ??= currentDocu["KEY"];
      DateTime recent = recentWithStamp.toDate();
      bool isDone = currentDocu["KEY"];

      return ListTile(
        key: ValueKey(currentDocu),
        title: Row(
          children: [
            Text(
              currentDocu['title'],
              style: TextStyle(
                  decoration:
                      isDone ? TextDecoration.lineThrough : TextDecoration.none,
                  color: isDone ? Colors.grey : Colors.black),
            ),
            SizedBox(width: 18.0),
            Text(currentDocu['VALUE'].toString()),
          ],
        ),
        subtitle: Text('${recent.month}월 ${recent.day}일'),
        onTap: () {
          userCollection.doc(currentDocu.id).set({
            'KEY': !isDone,
            'VALUE': docuList[docuList.length - 1]['VALUE'] + 1
          }, SetOptions(merge: true));
        },
        trailing: IconButton(
          icon: Icon(Icons.article),
          onPressed: () {
            Navigator.pushNamed(context, '/Sheet', arguments: <String, dynamic>{
              "KEY" : "VALUE"
              ...
              
            });
          },
        ),
      );
    }

    return Scaffold(
      drawer: CustomDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.list,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Text(
          '이름',
          style: TextStyle(color: Colors.amber[200]),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                usering.email == ''
                    ? Navigator.pushNamed(context, '/Register')
                    : Navigator.pushNamed(context, '/Account');
              }),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              loadEvent();
              List<QueryDocumentSnapshot> dataList = [];
              Future<QuerySnapshot> data = userCollection.get();
              Map<String, dynamic> docuData = {};
              data.then((value) {
                dataList = value.docs;
                for (int i = 0; i < dataList.length; i++) {
                  userCollection.doc(dataList[i].id).get().then((doc) {
                    docuData = doc.data();
                    if (docuData['VALUE'] == null) {
                      userCollection.doc(dataList[i].id).set(
                          {'VALUE': false, 'VALUE': 1000},
                          SetOptions(merge: true));
                    }
                    Timestamp recentWithStamp = docuData['VALUE'];
                    recentWithStamp ??= docuData['VALUE'];
                    DateTime recent = recentWithStamp.toDate();
                    bool isRecent;
                    if (recent.difference(DateTime.now()).abs() <
                        Duration(days: 7)) {
                      isRecent = true;
                      userCollection
                          .doc(dataList[i].id)
                          .set({"KEY": isRecent}, SetOptions(merge: true));
                    } else {
                      isRecent = false;
                      userCollection
                          .doc(dataList[i].id)
                          .set({"KEY": isRecent}, SetOptions(merge: true));
                    }
                  });
                }
              });
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.45,
          child: _buildList(context,_saving, userCollection,false),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.40,
          child: _buildList(context,_saving, userCollection,true),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.amber[500],
          ),
          backgroundColor: Colors.grey[300],
          foregroundColor: Colors.grey[300],
          onPressed: () {
            Navigator.pushNamed(context, '/CreateTodo');
          }),
    );
  }
}

void stateCheck(BuildContext context, String identifier) {
  if (identifier == null) {
    Navigator.pop(context);
  }
}

Widget _buildList(
    BuildContext context,
    Future saving,
    CollectionReference userCollection,
    bool VALUE
    ) {
  return Container(
    height: MediaQuery.of(context).size.height,
    child: FutureBuilder(
      future: saving,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collectionGroup("GROUP NAME")
                  .where("FIELD", isEqualTo: "VALUE")
                  .where("FIELD",isEqualTo: "VALUE")
                  .orderBy("FIELD")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: 32.0),
                        Text('Loading...'),
                      ],
                    ),
                  ));
                } else {
                  List<QueryDocumentSnapshot> docuList = snapshot.data.docs;

                  void _onReorder(int oldIndex, int newIndex) {
                    final DocumentSnapshot oldDocu = docuList[oldIndex];
                    docuList.insert(newIndex, oldDocu);

                    if (newIndex > oldIndex &&
                        newIndex != docuList.length - 1) {
                      docuList.removeAt(oldIndex);
                      newIndex = newIndex - 1;
                      docuList[newIndex].reference.update(
                          {'VALUE': docuList[newIndex + 1]['VALUE']});
                      for (int i = newIndex - 1; i > -1; i--) {
                        DocumentSnapshot thisDocu = docuList[i];
                        thisDocu.reference
                            .update({'VALUE': thisDocu['VALUE'] - 1});
                      }
                      for (int i = newIndex + 1; i < docuList.length; i++) {
                        DocumentSnapshot thisDocu = docuList[i];
                        thisDocu.reference
                            .update({'VALUE': thisDocu['VALUE'] + 1});
                      }
                    } else if (newIndex < oldIndex && newIndex != 0) {
                      docuList.removeAt(oldIndex + 1);
                      docuList[newIndex].reference.update(
                          {'VALUE': docuList[newIndex + 1]['VALUE']});
                      for (int i = newIndex - 1; i > -1; i--) {
                        DocumentSnapshot thisDocu = docuList[i];
                        thisDocu.reference
                            .update({'VALUE': thisDocu['VALUE'] - 1});
                      }
                      for (int i = newIndex + 1; i < docuList.length; i++) {
                        DocumentSnapshot thisDocu = docuList[i];
                        thisDocu.reference
                            .update({'VALUE': thisDocu['VALUE'] + 1});
                      }
                    } else if (newIndex == docuList.length - 1) {
                      docuList.removeAt(oldIndex);
                      newIndex -= 1;
                      docuList[newIndex].reference.update(
                          {'VALUE': docuList[newIndex - 1]['VALUE'] + 1});
                    } else if (newIndex == 0) {
                      docuList.removeAt(oldIndex);
                      docuList[newIndex]
                          .reference
                          .update({'VALUE': docuList[1]['VALUE'] - 1});
                    }
                  }

                  return ReorderableListView(
                    onReorder: _onReorder,
                    children: List.generate(docuList.length, (int index) {
                      DocumentSnapshot currentDocu = docuList[index];
      Timestamp recentWithStamp = currentDocu['VALUE'];
      recentWithStamp ??= currentDocu['VALUE'];
      DateTime recent = recentWithStamp.toDate();
      bool isDone = currentDocu['VALUE'];

      return ListTile(
        key: ValueKey(currentDocu),
        title: Row(
          children: [
            Text(
              currentDocu['title'],
              style: TextStyle(
                  decoration:
                      isDone ? TextDecoration.lineThrough : TextDecoration.none,
                  color: isDone ? Colors.grey : Colors.black),
            ),
            SizedBox(width: 18.0),
            Text(currentDocu['VALUE'].toString()),
          ],
        ),
        subtitle: Text('${recent.month}월 ${recent.day}일'),
        onTap: () {
          userCollection.doc(currentDocu.id).set({
            'VALUE': !isDone,
            'VALUE': docuList[docuList.length - 1]['VALUE'] + 1
          }, SetOptions(merge: true));
        },
        trailing: IconButton(
          icon: Icon(Icons.article),
          onPressed: () {
            Navigator.pushNamed(context, '/Sheet', arguments: <String, dynamic>{
              'id': currentDocu.id.toString(),
              'title': currentDocu['title'],
              'When': recent,
            });
          },
        ),
      );;
                    }),
                  );
                }
              });
        }
        return null;
      },
    ),
  );
}