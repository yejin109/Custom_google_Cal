class _SummaryPageState extends State<SummaryPage> {
  @override
  void initState() {
    super.initState();
  }

  List<String> todo = ["CONTENTS"];

  List<String> eventsTitle = ["LIST CONTENTS"];

  List<dynamic> eventsSubtitle = [
    Text(''),
    Text('15분 전'),
    CircleAvatar(
      radius: 16.0,
    ),
  ];

  List<String> weeklyProgress = ["CONTENTS"];

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    int day = (today.weekday - 1) % 7;
    String dayInUse = dayTransformation(today.weekday);
    int date = today.day - 1;
    int dateInUse = today.day;
    String month = monthTransformation(today.month);
    int year = today.year;

    List<dynamic> dayHeaders = days(day);
    List<dynamic> dateHeaders = dates(date);

    return Scaffold(
      appBar: CustomAppBar(
        title: '요약 화면',
      ),
      drawer: CustomDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "TITLE",
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$dayInUse $dateInUse',
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.amber[300],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("$month $year"),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              for (int index = 0; index < 7; index++)
                Container(
                  width: MediaQuery.of(context).size.width / 7,
                  decoration: index == 0 ? todayDeco() : null,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          dayTransformation(dayHeaders[index]),
                          style: TextStyle(color: Colors.grey[500]),
                        ),
                        SizedBox(height: 4),
                        Text(dateHeaders[index].toString(),
                            style: TextStyle(color: Colors.grey[500])),
                      ]),
                ),
            ],
          ),
          SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.18,
              child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildSummaryTODOList(context, index)),
            ),
          ),
          SizedBox(height: 12.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.18,
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) =>
                      _buildEvents(context, index)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'TITLE',
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          SizedBox(height: 12.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              for (int index = 0; index < 3; index++)
                _buildWeeklyProgress(index)
            ],
          )
        ],
      ),
    );
  }

  Widget _buildWeeklyProgress(int index) {
    return Column(
      children: <Widget>[
        Text(
          weeklyProgress[index],
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.grey[500],
          ),
        ),
        SizedBox(
          height: 12.0,
        ),
        Container(
          width: 60.0,
          height: 60.0,
          child: Center(
            child: Text(
              '1:00:06',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.grey[700],
            shape: BoxShape.circle,
          ),
        )
      ],
    );
  }

  Widget _buildSummaryTODOList(BuildContext context, int index) {
    if (index == 0)
      return Text(
        todo[index],
        style: TextStyle(fontSize: 18.0),
      );
    return ListTile(
      leading: Icon(Icons.crop_square),
      title: Text(todo[index]),
      dense: true,
    );
  }

  Widget _buildEvents(BuildContext context, int index) {
    if (index == 0)
      return Text(
        eventsTitle[index],
        style: TextStyle(fontSize: 18.0),
      );
    return ListTile(
      leading: Container(
        width: 36.0,
        height: 36.0,
        decoration: BoxDecoration(
          color: Colors.grey[700],
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
      title: Text(eventsTitle[index]),
      subtitle: Row(
        children: <Widget>[
          Icon(Icons.person_add),
          eventsSubtitle[index],
        ],
      ),
    );
  }

  todayDeco() {
    return BoxDecoration(
      color: Colors.amber[300],
      shape: BoxShape.circle,
    );
  }

  String dayTransformation(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 0:
        return 'Sun';
      default:
        return '?';
    }
  }

  String monthTransformation(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'Februrary';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 0:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';

      default:
        return '?';
    }
  }

  days(int today) {
    final List dayHeader = [];
    for (int i = 0; i < 7; i++) {
      today = today + 1;
      today = today % 7;
      dayHeader.add(today);
    }
    return dayHeader;
  }

  dates(int today) {
    final List dateHeader = [];
    for (int i = 0; i < 7; i++) {
      today = today + 1;
      dateHeader.add(today);
    }
    return dateHeader;
  }
}
