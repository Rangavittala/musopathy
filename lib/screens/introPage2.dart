import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:musopathy/models/data.dart';

import 'package:musopathy/screens/languagePage.dart';
import 'package:musopathy/screens/loginUi.dart';
import 'package:musopathy/screens/videopage.dart';

import 'package:musopathy/widgets/custom_drawer.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WebViewExample extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  Future<int> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return 1;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return 1;
    }
    return Future.error(
        "This is the error", StackTrace.fromString("This is its trace"));
  }

  WebViewController _controller;
  // final flutterWebviewPlugin = new FlutterWebviewPlugin();
  bool loggedin = false;
  String url =
      "https://player.vimeo.com/video/563210963?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479";
  // Rect myRect = Rect.fromLTRB(5.0, 5.0, 5.0, 5.0);
  @override
  void initState() {
    super.initState();
    check();
  }

  void check() async {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
        loggedin = false;
      } else {
        print('User is signed in!');
        loggedin = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //  print(loggedin);
    final Future<int> result = checkConnection();
    return SafeArea(
      child: Scaffold(
        key: key,
        drawer: CustomDrawer(),
        appBar: AppBar(
          elevation: 0,
          bottomOpacity: 0.0,
          leading: IconButton(
              icon: Icon(Icons.menu),
              iconSize: 30.0,
              color: Theme.of(context).primaryColor,
              onPressed: () => key.currentState.openDrawer()),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            'MUSOPATHY',
            style: TextStyle(
              color: Colors.cyan,
              fontFamily: 'Ubuntu',
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // drawer: Drawer(),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              LimitedBox(
                maxHeight: 230,
                maxWidth: double.infinity,
                child: FutureBuilder<int>(
                  future:
                      result, // a previously-obtained Future<String> or null
                  builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                    if (snapshot.hasData) {
                      return WebView(
                          initialUrl: url,
                          javascriptMode: JavascriptMode.unrestricted,
                          onWebViewCreated: (WebViewController c) {
                            _controller = c;
                          });
                    } else if (snapshot.hasError) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          Text(
                            "net:: ERR_INTERNET_DISCONNECTED",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            child: Text("Tap to retry once connected"),
                            onTap: () {
                              setState(() {});
                            },
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'The Musopathy breathing and tonation program uniquely combines - Breathing, Tonation and Phonation and gives triple benefits to participants in the most effortless manner.  It includes only the easiest techniques and simplifies even challenging ones.  It has benefited hundreds of Covid positive or rehab patients as well as healthy participants by improving lung, immunological, health and oxygen saturation and decreased stress, anxiety and depression.',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 18),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () {
                  _controller.clearCache();
                  // _controller1.pause();
                  if (Provider.of<Data>(context, listen: false).loggedin ==
                      true) {
                    // final snackBar =
                    //     SnackBar(content: Text('You are already logged in!!!'));

                    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Fluttertoast.showToast(
                        msg: "You are already loggedin",
                        toastLength: Toast.LENGTH_LONG);
                  } else {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => MyHomePage()));
                  }
                },
                child: new Container(
                  margin: EdgeInsets.symmetric(horizontal: 70.0),
                  alignment: Alignment
                      .center, // on giving this the container got its size later
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade800,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: new Text(
                    "Join Us 😊", //without alignment the size is according to the text
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () async {
                  await _controller.clearCache();

                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Language()));
                },
                child: new Container(
                  margin: EdgeInsets.symmetric(horizontal: 70.0),
                  alignment: Alignment
                      .center, // on giving this the container got its size later
                  height: 45.0,
                  decoration: BoxDecoration(
                    color: Colors.orange.shade700,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: new Text(
                    "Videos", //without alignment the size is according to the text
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
