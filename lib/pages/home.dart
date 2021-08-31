import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cadets_nearby/pages/home_setter.dart';
import 'package:cadets_nearby/pages/sub_pages/about_sub.dart';
import 'package:cadets_nearby/pages/sub_pages/account_sub.dart';
import 'package:cadets_nearby/pages/sub_pages/contact_sub.dart';
import 'package:cadets_nearby/pages/sub_pages/home_sub.dart';
import 'package:flutter/material.dart';

class RealHome extends StatefulWidget {
  const RealHome({
    Key? key,
  }) : super(key: key);

  @override
  _RealHomeState createState() => _RealHomeState();
}

class _RealHomeState extends State<RealHome> {
  final pageController = PageController();
  int selectedIndex = 0;

  void setSelectedIndex(int index) {
    selectedIndex = index;
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
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
                    // NotificationSubPage(),
                    const ContactSubPage(),
                    const AccountSubPage(),
                    const AboutSubPage(),
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
                icon: const Icon(Icons.home_rounded),
                title: const Text('Home'),
                textAlign: TextAlign.center,
                activeColor: Colors.redAccent,
                inactiveColor: Theme.of(context).accentColor,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.contacts_rounded),
                title: const Text('Contacts'),
                textAlign: TextAlign.center,
                activeColor: Colors.brown,
                inactiveColor: Theme.of(context).accentColor,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.manage_accounts_rounded),
                title: const Text('Account'),
                textAlign: TextAlign.center,
                activeColor: Colors.purpleAccent,
                inactiveColor: Theme.of(context).accentColor,
              ),
              BottomNavyBarItem(
                icon: const Icon(Icons.info_rounded),
                title: const Text('About'),
                textAlign: TextAlign.center,
                activeColor: Colors.teal,
                inactiveColor: Theme.of(context).accentColor,
              ),
            ],
          )),
    );
  }
}
