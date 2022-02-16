import 'package:crop_seller/_screens/help.dart';
import 'package:crop_seller/_screens/home_page.dart';
import 'package:crop_seller/_screens/order_list.dart';
import 'package:crop_seller/_screens/product_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Dashboard extends StatefulWidget {
  int selectedIndex = 0;
  int orderIndex = 0;

  Dashboard([this.selectedIndex=0,this.orderIndex=0]);

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  int _orderIndex = 0;
  DateTime? currentBackPressTime;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex=widget.selectedIndex;
    _orderIndex=widget.orderIndex;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: Center(
            child: showPages(_selectedIndex),
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.white,
            showUnselectedLabels: true,
            backgroundColor: Colors.black,
            type: BottomNavigationBarType.fixed,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.black,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.pages_outlined),
                label: 'Products',
                backgroundColor: Colors.black,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_sharp),
                label: 'Orders',
                backgroundColor: Colors.black,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.help_sharp),
                label: 'Help',
                backgroundColor: Colors.black,
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.person),
              //   label: 'Account',
              //   backgroundColor: Colors.black,
              // ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.orange,
            onTap: _onItemTapped,
          ),
        ),
        onWillPop: onWillPop);
  }

  showPages(int index) {
    switch (index) {
      case 0:
        {
          return HomePage();
        }
      case 1:
        {
          return ProductList();
        }
      case 2:
        {
          return OrderList(_orderIndex);
        }
      case 3:
        {
          return Help();
        }
    }
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(msg: "Press again to exit");
      return Future.value(false);
    }
    SystemNavigator.pop();
    return Future.value(true);
  }
}
