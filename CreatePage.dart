class _WritingPageState extends State<WritingPage> {
  String _sharedText;

  @override
  void initState() {
    super.initState();

    ShareService()
      ..onDataReceived = _handleSharedData
      ..getSharedData().then(_handleSharedData);
  }

  void _handleSharedData(String sharedData) {
    setState(() {
      _sharedText = sharedData;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  TextEditingController toDoNameController = TextEditingController();
  TextEditingController toDoContentsController = TextEditingController();

  DateTime today = DateTime.now();
  DateTime selectedDate;
  DateTime selectedTime;
  DateTime selectedWhen;
  String dateConfirm = DateFormat.yMd().format(DateTime.now());
  String timeConfirm = DateFormat.Hm().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    Usering usering = Provider.of<Usering>(context);
    String identity = usering."KEY";
    String defaultColPath = "COLLECTION PATH";

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
              Form(
                child: Theme(
                  data: ThemeData(
                    primarySwatch: Colors.indigo,
                    inputDecorationTheme: InputDecorationTheme(
                        labelStyle: TextStyle(
                            color: Colors.indigoAccent[250], fontSize: 18.0)),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(40.0),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          controller: toDoNameController,
                          decoration:
                              InputDecoration(labelText: "PLACE HOLDER"),
                          keyboardType: TextInputType.text,
                        ),
                        TextField(
                          controller: toDoContentsController,
                          decoration:
                              InputDecoration(labelText: "PLACE HOLDER"),
                          keyboardType: TextInputType.text,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('선택한 날짜'),
                  Text(dateConfirm != null ? dateConfirm : "선택없음"),
                ],
              ),
              SizedBox(height: 16.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('선택한 시간 : '),
                  Text(timeConfirm != null ? timeConfirm : "선택없음"),
                ],
              ),
              SizedBox(height: 16.0,),
              RaisedButton(
                  child: Text('날짜선택'),
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2018, 3, 5),
                        maxTime: DateTime(2026, 6, 7), onChanged: (date) {
                      setState(() {
                        dateConfirm = DateFormat.yMd().format(date);
                      });
                    }, onConfirm: (date) {
                      setState(() {
                        dateConfirm = DateFormat.yMd().format(date);
                        selectedDate = date;
                      });
                    });
                  }),
                  SizedBox(height: 16.0,),
              RaisedButton(
                  child: Text('시간선택'),
                  onPressed: () {
                    DatePicker.showTime12hPicker(context,
                        showTitleActions: true,
                        currentTime: DateTime.now(), onConfirm: (time) {
                      setState(() {
                        timeConfirm = DateFormat.Hm().format(time);
                        selectedTime = time;
                      });
                    });
                  }),
                  SizedBox(height: 32.0,),
              RaisedButton(
                  child: Text('입력 완료'),
                  onPressed: () {
                    createToDo(identity, defaultColPath);
                  })
            ],
          ),
        ),
      ),
    ));
  }

  void createToDo(
    String identity,
    String defaultColPath,
  ) {
    String toDoName =
        toDoNameController.text.replaceAll('{', '').replaceAll('}', '');
    String toDoContents = toDoContentsController.text;
    selectedWhen = sumUptime(selectedDate, selectedTime);
    Map<String, dynamic> data = {
      "FIELD": "VALUE",
      ...
    };
    FirebaseFirestore.instance.collection(defaultColPath).add(data);

    Navigator.pop(context);
  }

  DateTime sumUptime(DateTime date, DateTime hour) {
    int selectedYear = date.year;
    int selectedMonth = date.month;
    int selectedDay = date.day;
    int selectedHour = hour.hour;
    int selectedMinute = hour.minute;
    DateTime result = DateTime(
        selectedYear, selectedMonth, selectedDay, selectedHour, selectedMinute);
    return result;
  }
}
