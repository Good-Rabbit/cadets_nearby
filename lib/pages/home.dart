import 'package:flutter/material.dart';
import 'package:readiew/pages/subPages/HomeSub.dart';

class RealHome extends StatefulWidget {
  const RealHome({
    Key? key,
  }) : super(key: key);

  @override
  _RealHomeState createState() => _RealHomeState();
}

class _RealHomeState extends State<RealHome> {
  var pageViewController = PageController(initialPage: 0);
  static int index = 0;
  var navKey = GlobalKey();

  setSelectedIndex(int index) {
    _RealHomeState.index = index;
    pageViewController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: pageViewController,
            onPageChanged: (index) {
              print('changed');
              _RealHomeState.index = index;
              navKey.currentState!.setState(() {});
            },
            children: [
              HomeSubPage(),
              Container(child: ColoredBox(color: Colors.green)),
              Container(child: ColoredBox(color: Colors.blue)),
            ],
          ),
          // pageSetter(selectedIndex),
          CustomBottomNavigationBar(
            setIndex: setSelectedIndex,
            key: navKey,
          ),
        ],
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatefulWidget {
  CustomBottomNavigationBar({
    Key? key,
    required this.setIndex,
  }) : super(key: key);

  final Function setIndex;

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  var pages = [true, false, false];

  setSelected(int index) {
    setState(() {
      widget.setIndex(index);
      switch (index) {
        case 0:
          pages = [true, false, false];
          break;
        case 1:
          pages = [false, true, false];
          break;
        case 2:
          pages = [false, false, true];
          break;
        default:
          pages = [true, false, false];
          break;
      }
    });
  }

  buildNavItem(IconData icon, bool active, int selected) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.0),
      onTap: () {
        setSelected(selected);
      },
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).accentColor,
        child: CircleAvatar(
          radius: 20,
          backgroundColor:
              active ? Colors.white.withOpacity(0.5) : Colors.white,
          child: Icon(icon),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_RealHomeState.index) {
      case 0:
        pages = [true, false, false];
        break;
      case 1:
        pages = [false, true, false];
        break;
      case 2:
        pages = [false, false, true];
        break;
      default:
        pages = [true, false, false];
        break;
    }
    return Stack(
      children: [
        Positioned(
          bottom: 0,
          child: ClipPath(
            clipper: NavBarClipper(),
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).accentColor,
                    Theme.of(context).primaryColor,
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 45,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildNavItem(Icons.home, pages[0], 0),
              SizedBox(),
              buildNavItem(Icons.search, pages[1], 1),
              SizedBox(),
              buildNavItem(Icons.account_circle, pages[2], 2),
            ],
          ),
        ),
        Positioned(
          bottom: 10,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                'Home',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 1,
              ),
              Text(
                'Search',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                width: 1,
              ),
              Text(
                'Account',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class NavBarClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    Path path = Path();
    var sw = size.width;
    var sh = size.height;
    path.cubicTo(
      sw / 12,
      0,
      sw / 12,
      2 * sh / 5,
      2 * sw / 12,
      2 * sh / 5,
    );
    path.cubicTo(
      3 * sw / 12,
      2 * sh / 5,
      3 * sw / 12,
      0,
      4 * sw / 12,
      0,
    );
    path.cubicTo(
      5 * sw / 12,
      0,
      5 * sw / 12,
      2 * sh / 5,
      6 * sw / 12,
      2 * sh / 5,
    );
    path.cubicTo(
      7 * sw / 12,
      2 * sh / 5,
      7 * sw / 12,
      0,
      8 * sw / 12,
      0,
    );
    path.cubicTo(
      9 * sw / 12,
      0,
      9 * sw / 12,
      2 * sh / 5,
      10 * sw / 12,
      2 * sh / 5,
    );
    path.cubicTo(
      11 * sw / 12,
      2 * sh / 5,
      11 * sw / 12,
      0,
      sw,
      0,
    );
    path.lineTo(sw, sh);
    path.lineTo(0, sh);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    return false;
  }
}
