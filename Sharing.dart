class ShareService {
  void Function(String) onDataReceived;

  ShareService() {

    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg.contains("resumed")) {
        getSharedData().then((String data) {
      
          if (data.isEmpty) {
            return;
          }


          onDataReceived(data);
        });
      }
      return;
    });
  }

  Future<String> getSharedData() async {
    return await MethodChannel('com.example.to_j')
            .invokeMethod("getSharedData") ??
        "";
  }
}