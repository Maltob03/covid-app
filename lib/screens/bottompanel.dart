import 'package:common_bottom_navigation_bar/pages/help%20us%20page.dart';
import 'package:common_bottom_navigation_bar/pages/countryPage.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>()
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_selectedIndex].currentState.maybePop();

        print(
            'isFirstRouteInCurrentTab: ' + isFirstRouteInCurrentTab.toString());

        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              label: "Home",
              activeIcon: Icon(
                Icons.home,
                color: Colors.black,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.language_outlined,
                color: Colors.black,
              ),
              label: "World Cases",
              activeIcon: Icon(
                Icons.language_outlined,
                color: Colors.black,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.masks,
                color: Colors.black,
                size: 36,
              ),
              label: "INFO",
              activeIcon: Icon(
                Icons.masks,
                color: Colors.black,
                size: 36,
              ),
            ),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        body: Stack(
          children: [
            _buildOffstageNavigator(0),
            _buildOffstageNavigator(1),
            _buildOffstageNavigator(2),
          ],
        ),
      ),
    );
  }

  Map<String, WidgetBuilder> _routeBuilders(BuildContext context, int index) {
    return {
      '/': (context) {
        return [
          HomePage(),
          CountryPage(),
          InfoScreen(),
        ].elementAt(index);
      },
    };
  }

  Widget _buildOffstageNavigator(int index) {
    var routeBuilders = _routeBuilders(context, index);

    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (routeSettings) {
          return MaterialPageRoute(
            builder: (context) => routeBuilders[routeSettings.name](context),
          );
        },
      ),
    );
  }
}
