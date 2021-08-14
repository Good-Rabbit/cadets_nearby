import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:cadets_nearby/pages/subPages/accountSub.dart';
import 'package:cadets_nearby/pages/subPages/homeSub.dart';
import 'package:cadets_nearby/pages/subPages/messageSub.dart';
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
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: PageView(
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
            MessageSubPage(),
            NotificationSubPage(),
            AccountSubPage(),
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
              icon: Icon(Icons.home),
              title: Text('Home'),
              textAlign: TextAlign.center,
              activeColor: Colors.redAccent,
              inactiveColor: Theme.of(context).accentColor,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.message),
              title: Text('Messages'),
              textAlign: TextAlign.center,
              activeColor: Colors.brown,
              inactiveColor: Theme.of(context).accentColor,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.notifications),
              title: Text('Notifications'),
              textAlign: TextAlign.center,
              activeColor: Colors.purpleAccent,
              inactiveColor: Theme.of(context).accentColor,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.manage_accounts),
              title: Text('Account'),
              textAlign: TextAlign.center,
              activeColor: Colors.teal,
              inactiveColor: Theme.of(context).accentColor,
            ),
          ],
        ));
  }
}
