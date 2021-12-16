import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:notifications/notifications.dart';
import 'package:http/http.dart' as http;
import 'models/trac_request_model.dart';

const apiLink = "https://api.thai2d3d.com/";
const secretKey = "Yv9GlO0wX4peYxWCMGpUXM9ZKJBU78tc8cvSld5sN20";
var headers = <String, String>{
  "content-type": "application/json",
  "Access-Control-Allow-Origin": "*",
  'Access-Control-Allow-Credentials': 'true',
  "Access-Control-Allow-Methods": "GET, POST, PATCH, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers":
      "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
  "apikey": "5b927b5a7f672",
  "app": "App",
};

class Noti extends StatefulWidget {
  @override
  _NotiState createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  Notifications? _notifications;
  StreamSubscription<NotificationEvent>? _subscription;
  List<NotificationEvent> _log = [];
  bool started = false;

  // String packageName = "mm.com.mptvas";
  String packageName = "package: com.google.android.apps.messaging";
  String amount = "";
  String tracId = "";
  String sender = "";
  String myPhone = "09401531039";
  String _message = "";

  String _textContent = 'Waiting for messages...';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    startListening();
  }

  void example() {
    Notifications().notificationStream!.listen((event) => print(event));
  }

  void startListening() {
    _notifications = Notifications();
    try {
      _subscription = _notifications!.notificationStream!.listen(onData);
      setState(() => started = true);
    } on NotificationException catch (exception) {
      print(exception);
    }
  }

  void stopListening() {
    _subscription?.cancel();
    setState(() => started = false);
  }

  void onData(NotificationEvent event) {
    //     setState(() {
    //   _log.add(event);
    // });
    print(event.toString());
    print(event.packageName);
    // if (event.packageName?.trim() == packageName &&
    //     event.message!.contains("WaveMoney: Rcv Amt:")) {
    setState(() {
      // _log.add(event);
      _textContent = event.message.toString();
    });
    // }
    // ignore: avoid_print
    // print(event.toString());
  }

  NotificationEvent notiEvent = NotificationEvent();
  @override
  Widget build(BuildContext context) {
    // print(_log.first)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            child: const Text('Regex'),
            onPressed: () {
              getRegex("");
            },
          ),
          ElevatedButton(
            child: const Text('SMS Message'),
            onPressed: () {
              getNotiDetails(_textContent.toString());
            },
          ),
          ElevatedButton(
            child: const Text('Noti Message'),
            onPressed: () {
              getNotiDetails(notiEvent.message.toString());
            },
          ),
          ElevatedButton(
            onPressed: () async {
              await getApiCall();
            },
            child: Text("Call Approved API"),
          ),
          Text("SMS message"),
          Text(_textContent ?? ""),
          Text("status:$responseStatus"),
          Text("Res:$responseMessage"),
          // ListView.builder(
          //     itemCount: _log.length,
          //     // reverse: true,

          //     itemBuilder: (BuildContext context, int idx) {
          //       final entry = _log[idx];
          //       getNotiDetails(entry.message.toString());
          //       return Container(
          //         padding: const EdgeInsets.all(8),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             Text(
          //               "Latest received SMS: $_message by $myPhone",
          //               style: const TextStyle(fontWeight: FontWeight.bold),
          //             ),
          //             // TextButton(
          //             //     onPressed: () async {
          //             //       await telephony.openDialer("123413453");
          //             //     },
          //             //     child: Text('Open Dialer')),
          //             ListTile(
          //               leading: Text(
          //                 "TimeStamp",
          //                 // entry.timeStamp,
          //                 // entry.timeStamp.toString().substring(0, 19),
          //                 style: const TextStyle(
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               trailing: Text(
          //                 "Package",
          //                 // entry.packageName
          //                 // .split('.').last
          //               ),
          //             ),
          //             Text("Sender : $sender"),
          //             Text("TracId: $tracId"),
          //             Text("Amount: $amount"),
          //           ],
          //         ),
          //       );
          //     }),
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: started ? stopListening : startListening,
        tooltip: 'NOTI Start/Stop',
        child: started ? Icon(Icons.stop) : Icon(Icons.play_arrow),
      ),
    );
  }

  String responseMessage = "";
  String responseStatus = "";
  Future<void> getApiCall() async {
    var url = apiLink + "api/transaction/topupapproveadded";
    String paymentName = "KBZ Pay";
    double transferAmount = 10000;
    String transactionNumber = "129056";
    String transferAccount = "09980502902";

    String input =
        "$transactionNumber${transferAmount.toString()}$paymentName$transferAccount$secretKey";
    String signature = md5.convert(input.codeUnits).toString();

    TracRequestModel model = TracRequestModel(
        paymentName: paymentName,
        secretKey: secretKey,
        signature: signature,
        transactionNumber: transactionNumber,
        transferAccount: transferAccount,
        transferAmount: transferAmount);

    var response = await http.post(
        Uri.parse(
          url,
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        // headers: header,
        // body: model.toJson()
        body: json.encode({
          "transactionNumber": transactionNumber,
          "paymentName": paymentName,
          "signature": signature,
          "secretKey": secretKey,
          "transferAccount": transferAccount,
          "transferAmount": transferAmount
        }));
    print(response.statusCode);
    print(response.body);
    // if (response.statusCode == 200) {
    setState(() {
      responseMessage = json.decode(response.body)["message"];
      responseStatus = json.decode(response.body)["status"];
    });
  }

  void getRegex(String s) {
    String s =
        "WaveMoney: Rcv Amt: 500,000.00 Ks, Sender: 9768605117, Trx ID: 719515230";
    var pattern = r'^(?=.*\bWaveMoney: Rcv Amt: \b)(?=.*\b Ks, Sender: \b).*$';
    RegExp exp = RegExp(pattern);
  }

  void getNotiDetails(String m) {
    // String m =
    //     "WaveMoney: Rcv Amt: 500,000.00 Ks, Sender: 9768605117, Trx ID: 719515230";

    //  String msg= noti.message.;

    //1st way

    // List<String> slist = m.trim().split(" ");
    // slist.forEach((e) {
    //   print(e);
    // });
    // amount = slist[3];
    // tracId = slist[9];
    // sender = slist[6];
    // print("Amount: $amount, TracId: $tracId, Sender: $sender");

    //2nd way
    if (m != "null") {
      amount = capture("WaveMoney: Rcv Amt:", "Ks,", m).trim();

      double amountNew = double.parse(amount.replaceAll(",", ""));

      sender = capture("Sender:", ", Trx ID:", m).trim();

      tracId = capture("Trx ID:", "", m).trim();
      String tracIdNew = tracId.substring(tracId.length - 6, tracId.length);
      print("Trac New: $tracIdNew");

      print("Amount: $amountNew, TracId: $tracId, Sender: $sender");
    }
  }

  String capture(String first, String second, String input) {
    int firstIndex = input.indexOf(first) + first.length;
    int secondIndex = input.length;
    if (second != "") {
      secondIndex = input.indexOf(second);
    }
    return input.substring(firstIndex, secondIndex);
  }
}
