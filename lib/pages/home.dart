import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:readiew/pages/subPages/accountSub.dart';
import 'package:readiew/pages/subPages/homeSub.dart';

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
            HomeSubPage(),
            Container(
                child: ColoredBox(
              color: Colors.greenAccent,
              child: Center(child: Text('TODO')),
            )),
            Container(
                child: ColoredBox(
              color: Colors.orangeAccent,
              child: Center(child: Text('TODO')),
            )),
            AccountSubPage(),
          ],
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: selectedIndex,
          backgroundColor: Colors.orange[100],
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            setSelectedIndex(index);
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
              activeColor: Colors.redAccent,
              inactiveColor: Theme.of(context).accentColor,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
              activeColor: Colors.green,
              inactiveColor: Theme.of(context).accentColor,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.settings),
              title: Text('Settings'),
              activeColor: Colors.purpleAccent,
              inactiveColor: Theme.of(context).accentColor,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.manage_accounts),
              title: Text('Account'),
              activeColor: Colors.blue,
              inactiveColor: Theme.of(context).accentColor,
            ),
          ],
        ));
  }
}
