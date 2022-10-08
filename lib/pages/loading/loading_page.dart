import 'package:appciona/config/notification_helper.dart';
import 'package:appciona/pages/audiovisual/audiovisual_page.dart';
import 'package:appciona/pages/turismo/turismo_main_page.dart';
import 'package:appciona/pages/ultimas_noticias/ultimas_noticias_page.dart';
import 'package:appciona/pages/widgets/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  bool loaded = false;

  checkForUserState() async {
    FirebaseAuth.instance.authStateChanges().listen((event) async {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await NotificationHelper.addMessagingListener();
      }
    });
  }

  @override
  void initState() {
    loaded = true;
    checkForUserState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loaded
        ? StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, data) {
              if (data.connectionState == ConnectionState.waiting) {
                return const MyHomePage(
                  userState: 2,
                );
              } else if (data.hasData) {
                return const MyHomePage(
                  userState: 1,
                );
              } else if (data.hasError) {
                return const MyHomePage(
                  userState: 0,
                );
              } else {
                return const MyHomePage(
                  userState: 0,
                );
              }
            },
          )
        : loadingView();
  }

  Widget loadingView() {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset(
                'assets/images/logo-green.png',
                width: size.width * 0.70,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int userState;
  const MyHomePage({
    Key? key,
    required this.userState,
  }) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        activeColor: const Color(0XFF00BAEF),
        inactiveColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.newspaper,
            ),
            label: 'Últimas noticias',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.play_circle_outline,
            ),
            label: 'Audiovisual',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.map,
            ),
            label: 'Turismo',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => UltimasNoticias(
                drawer: DrawerWidget(
                  userState: widget.userState,
                ),
              ),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => AudiovisualPage(
                drawer: DrawerWidget(
                  userState: widget.userState,
                ),
              ),
            );
          case 2:
            return CupertinoTabView(
              builder: (context) => TurismoMainPage(
                drawer: DrawerWidget(
                  userState: widget.userState,
                ),
              ),
            );
          default:
            return CupertinoTabView(
              builder: (context) => UltimasNoticias(
                drawer: DrawerWidget(
                  userState: widget.userState,
                ),
              ),
            );
        }
      },
    );
  }
}
