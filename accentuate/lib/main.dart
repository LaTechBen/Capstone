import 'package:accentuate/firebase_options.dart';
import 'package:accentuate/signin_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'signup_page.dart';
import 'settings_page.dart';
import 'search_page.dart';
import 'createoutfit_page.dart';
import 'user_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Accentuate',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            elevation: 1,
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
          bottomAppBarTheme: BottomAppBarTheme(color: Color.fromARGB(255, 248, 201, 205)),
          // canvasColor: Color.fromARGB(255, 248, 201, 205),
          // colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 248, 201, 205), ),
          useMaterial3: true,
          
        ),
        // home: MyHomePage(
        //   title: "",
        // )
        // home: const UserPage(uid: 'qtdngM2pXSopCBDgC8zU')
        home: SigninPage()
        //home: CreateOutfitPage()
        );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? getUid() {
    if (_auth.currentUser?.uid == null) {
      // this is the test db entry
      return 'qtdngM2pXSopCBDgC8zU';
    }
    return _auth.currentUser?.uid;
  }

  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: currentPage == 2
          ? SettingsPage()
          : currentPage == 1
              ? SearchPage()
              : currentPage == 4
                  ? UserPage(uid: getUid())
                  : HomePage(uid: getUid()),
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Color.fromARGB(255, 248, 201, 205),
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      /** 
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      **/

      bottomNavigationBar: BottomAppBar(
          child: Row(
        children: [
          const Spacer(),
          IconButton(
            onPressed: () {
              setState(() {
                currentPage = 0;
              });
            },
            icon: const Icon(
              Icons.home,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              setState(() {
                currentPage = 1;
              });
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
          const Spacer(),
          // IconButton(
          //   onPressed: () {},
          //   icon: const Icon(
          //     Icons.ondemand_video,
          //   ),
          // ),
          // const Spacer(),
          IconButton(
            onPressed: () {
              setState(() {
                currentPage = 2;
              });
            },
            icon: const Icon(
              Icons.settings_applications_outlined,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              setState(() {
                currentPage = 4;
              });
            },
            icon: const Icon(
              Icons.person,
            ),
          ),
          const Spacer(),
        ],
      )),
    );
  }
}
