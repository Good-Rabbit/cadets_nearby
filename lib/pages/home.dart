import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cadets_nearby/pages/homeSetter.dart';
import 'package:flutter/material.dart';
import 'package:cadets_nearby/pages/subPages/accountSub.dart';
import 'package:cadets_nearby/pages/subPages/homeSub.dart';
import 'package:cadets_nearby/pages/subPages/aboutSub.dart';
import 'package:cadets_nearby/pages/subPages/notificationSub.dart';

class RealHome extends StatefulWidget {
  const RealHome({
    Key? key,
  }) : super(key: key);

  @override
  _RealHomeState createState() => _RealHomeState();
}

class _RealHomeState extends State<RealHome> {
  var pageController = PageController(initialPage: 0);
  int selectedIndex = 0;

  setSelectedIndex(int index) {
    selectedIndex = index;
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectedIndex != 0) {
          setSelectedIndex(0);
          return false;
        }
        return true;
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: !HomeSetterPage.auth.currentUser!.emailVerified
              ? Container()
              : PageView(
                  controller: pageController,
                  onPageChanged: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  children: [
                    HomeSubPage(
                      setSelectedIndex: setSelectedIndex,
                    ),
                    NotificationSubPage(),
                    AccountSubPage(),
                    AboutSubPage(),
                  ],
                ),
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: selectedIndex,
            backgroundColor: Theme.of(context).bottomAppBarColor,
            onItemSelected: (index) => setState(() {
              setSelectedIndex(index);
            }),
            items: [
              BottomNavyBarItem(
                icon: Icon(Icons.home_rounded),
                title: Text('Home'),
                textAlign: TextAlign.center,
                activeColor: Colors.redAccent,
                inactiveColor: Theme.of(context).accentColor,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.notifications_rounded),
                title: Text('Notifications'),
                textAlign: TextAlign.center,
                activeColor: Colors.brown,
                inactiveColor: Theme.of(context).accentColor,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.manage_accounts_rounded),
                title: Text('Account'),
                textAlign: TextAlign.center,
                activeColor: Colors.purpleAccent,
                inactiveColor: Theme.of(context).accentColor,
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.info_rounded),
                title: Text('About'),
                textAlign: TextAlign.center,
                activeColor: Colors.teal,
                inactiveColor: Theme.of(context).accentColor,
              ),
            ],
          )),
    );
  }
}
