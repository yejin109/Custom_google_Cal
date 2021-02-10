import 'package:flutter/material.dart';
import 'package:to_j/Model/customAppBar.dart';
import 'package:to_j/Model/customDrawer.dart';

class ToDoSheetPage extends StatefulWidget {
  @override
  _ToDoSheetPageState createState() => _ToDoSheetPageState();
}

class _ToDoSheetPageState extends State<ToDoSheetPage> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> info = ModalRoute.of(context).settings.arguments;
    DateTime recent = info['When'];

    return Scaffold(
      appBar: CustomAppBar(
        title: '',
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    '제목 : ',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    info['title'],
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
              SizedBox(height: 40.0),
              Row(
                children: <Widget>[
                  Text(
                    'DUE : ',
                    style: TextStyle(fontSize: 24.0),
                  ),
                  SizedBox(
                    width: 4.0,
                  ),
                  Text(
                    '${recent.month}월 ${recent.day}일',
                    style: TextStyle(fontSize: 18.0),
                  )
                ],
              ),
            ]),
      ),
    );
  }
}
