import 'package:erp_admin/module/Profile/Screens/ProfileScreen.dart';
import 'package:flutter/material.dart';

import '../DashBoard/Screens/DashBoardScreen.dart';
import '../EmployeeList&Profile/Screens/EmployeeListScreen.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({super.key});

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {
  int _selectedIndex = 0;

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  void _onTabSelected(int index) {
    if (_selectedIndex == index) {
      // If the tab is already selected, pop to the first route
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  final List<String> _screenTitles = ['DashBoard', 'EmployeeList', 'Profile'];

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (RouteSettings settings) {
          Widget page;
          switch (index) {
            case 0:
              page = Dashboardscreen();
              break;
            case 1:
              page = EmployeeScreen();
              break;
            case 2:
              page = ProfileScreen();
              break;
            default:
              page = Dashboardscreen();
          }
          return MaterialPageRoute(builder: (_) => page);
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (_navigatorKeys[_selectedIndex].currentState!.canPop()) {
      // If the current tab's navigator can pop, go back
      _navigatorKeys[_selectedIndex].currentState!.pop();
      return Future.value(false); // Don't exit app
    } else {
      if (_selectedIndex != 0) {
        // If not on Home tab, switch to Home
        setState(() {
          _selectedIndex = 0;
        });
        return Future.value(false); // Stay in app
      }
      // If already on Home tab, allow app exit
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            _screenTitles[_selectedIndex],
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: List.generate(3, (index) => _buildOffstageNavigator(index)),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.green,
          currentIndex: _selectedIndex,
          onTap: _onTabSelected,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'DashBoard'),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'EmployeeList',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
