import 'dart:convert';

import 'package:crop_seller/_models/dashboard_model.dart';
import 'package:crop_seller/_models/login_model.dart';
import 'package:crop_seller/_screens/add_product.dart';
import 'package:crop_seller/_screens/crop_care.dart';
import 'package:crop_seller/_screens/profile.dart';
import 'package:crop_seller/_screens/query_list.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

import 'notifications.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  String _imagePath = '';
  String _userName = '';
  String session = '';
  bool _isApiSuccess = false;
  Position? position;
  DashboardData? _dashboardData;
  double _lat=28.8040898;
  double _long=76.2202096;

  @override
  initState() {
    super.initState();
    _determinePosition().then((value1) => {
          position = value1,
         hitDashboardAPI(value1.latitude,value1.longitude),
        });
    getLoginData();
  }

  Map getRequest(double _lat,double _long) {
    var request = {
      'api': '1',
      'action': 'weather',
      'lat': _lat.toString(),
      'lon': _lat.toString(),
    };
    return request;
  }

  checkResponse(String response) {
    DashboardModel data = DashboardModel.fromJson(jsonDecode(response));
    if (data.status == 1) {
      _dashboardData = data.data ?? DashboardData();
      getLoginData();
      setState(() {
        _isApiSuccess = true;
      });
      return;
    }
    Fluttertoast.showToast(msg: data.message!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Image.asset(
                      'images/home_top_back.png',
                      height: 220,
                      width: MediaQuery.of(context).size.height,
                      fit: BoxFit.fill,
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificatiosList()));
                        },
                        child: Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 30,
                      right: 40,
                      left: 40,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: _imagePath == ''
                                ? Image.asset(
                                    'images/corn.png',
                                    fit: BoxFit.fill,
                                    height: 100,
                                    width: 100,
                                  )
                                : Image.network(
                                    _imagePath,
                                    fit: BoxFit.fill,
                                    height: 100,
                                    width: 100,
                                  ),
                          ),
                          SizedBox(width: 20),
                          Text(
                            _userName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.yellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -65,
                      right: 30,
                      left: 30,
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 20, top: 20, right: 20, bottom: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      ClipOval(
                                        child: _isApiSuccess
                                            ? Image.network(
                                                _dashboardData
                                                        ?.temperature?.icon ??
                                                    '',
                                                height: 35,
                                                width: 35,
                                              )
                                            : Image.asset(
                                                'images/temperature.png',
                                                height: 35,
                                                width: 35,
                                              ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _dashboardData?.temperature?.name ??
                                                '-',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Temperature',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipOval(
                                          child: _isApiSuccess
                                              ? Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color.fromRGBO(9, 64, 159, 1)
                                            ),
                                            child: Image.network(
                                              _dashboardData
                                                  ?.weather?.icon ??
                                                  '',
                                              height: 35,
                                              width: 35,
                                            ),
                                          )
                                              : Image.asset(
                                                  'images/rain.png',
                                                  height: 35,
                                                  width: 35,
                                                )),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _dashboardData?.weather?.name ??
                                                '-',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Weather  ',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipOval(
                                        child: _isApiSuccess
                                            ? Image.network(
                                                _dashboardData
                                                        ?.humidity?.icon ??
                                                    '',
                                                height: 35,
                                                width: 35,
                                              )
                                            : Image.asset(
                                                'images/water.png',
                                                height: 35,
                                                width: 35,
                                              ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _dashboardData?.humidity?.name ??
                                                '-',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Humidity',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipOval(
                                        child: _isApiSuccess?Image.network(
                                          _dashboardData?.windspeed?.icon??'',
                                          height: 35,
                                          width: 35,
                                        ):Image.asset(
                                          'images/wind.png',
                                          height: 35,
                                          width: 35,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _dashboardData?.windspeed?.name ??
                                                '-',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            'Windspeed',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(35, 103, 53, 1),
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 70,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Action',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 100,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Image.asset(
                                        'images/new_order.png',
                                        width: 80,
                                      ),
                                    ),
                                    Positioned(
                                      top: 20,
                                      left: 20,
                                      bottom: 20,
                                      child: Text(
                                        _dashboardData?.order?.newOrder ?? '00',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        left: 20,
                                        bottom: 20,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'New Orders',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_right_alt_sharp,
                                              color: Colors.black,
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5,
                                      ),
                                    ]),
                              ),
                            )),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Container(
                                height: 100,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Image.asset(
                                        'images/pending_order.png',
                                        width: 80,
                                      ),
                                    ),
                                    Positioned(
                                      top: 20,
                                      left: 20,
                                      bottom: 20,
                                      child: Text(
                                        _dashboardData?.order?.inProgress ??
                                            '00',
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        left: 20,
                                        bottom: 20,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'In Progress Orders',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_right_alt_sharp,
                                              color: Colors.black,
                                            )
                                          ],
                                        )),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5,
                                      ),
                                    ]),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Quick Action',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AddProduct(null))).then((value) => null);
                              },
                              child: Container(
                                height: 150,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 10,
                                      right: 15,
                                      child: Image.asset(
                                        'images/product_icon.png',
                                        width: 60,
                                      ),
                                    ),
                                    Positioned(
                                        left: 20,
                                        bottom: 40,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Product',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_right_alt_sharp,
                                              color: Colors.black,
                                            )
                                          ],
                                        )),
                                    Positioned(
                                      left: 20,
                                      bottom: 20,
                                      child: Text(
                                        'Add Products',
                                        style: TextStyle(
                                          color: Colors.orange,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'images/product_back.png')),
                                ),
                              ),
                            )),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Profile())).then((value) => getLoginData());
                              },
                              child: Container(
                                height: 150,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 10,
                                      right: 15,
                                      child: Image.asset(
                                        'images/profile_icon.png',
                                        width: 60,
                                      ),
                                    ),
                                    Positioned(
                                        left: 20,
                                        bottom: 40,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Profile',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_right_alt_sharp,
                                              color: Colors.black,
                                            )
                                          ],
                                        )),
                                    Positioned(
                                      left: 20,
                                      bottom: 20,
                                      child: Text(
                                        'Edit your profile',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'images/profile_back.png')),
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CropCare()));
                                },
                                child: Container(
                                  height: 150,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        top: 10,
                                        right: 15,
                                        child: Image.asset(
                                          'images/cropcare_icon.png',
                                          width: 60,
                                        ),
                                      ),
                                      Positioned(
                                          left: 20,
                                          bottom: 40,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Crop Care',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_right_alt_sharp,
                                                color: Colors.black,
                                              )
                                            ],
                                          )),
                                      Positioned(
                                        left: 20,
                                        bottom: 20,
                                        child: Text(
                                          'Care your crop',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'images/cropcare_back.png')),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => QueryList()));
                              },
                              child: Container(
                                height: 150,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      top: 10,
                                      right: 15,
                                      child: Image.asset(
                                        'images/query_icon.png',
                                        width: 60,
                                      ),
                                    ),
                                    Positioned(
                                        left: 20,
                                        bottom: 40,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Product',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Icon(
                                              Icons.arrow_right_alt_sharp,
                                              color: Colors.black,
                                            )
                                          ],
                                        )),
                                    Positioned(
                                      left: 20,
                                      bottom: 20,
                                      child: Text(
                                        'You have new query',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage('images/query_back.png')),
                                ),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getLoginData() {
    MySharedPrefences().getUserImage().then((value) => _imagePath=value);
    MySharedPrefences().getUserName().then((value) => _userName=value);
    setState(() {});
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print(Future.error('Location services are disabled.'));
     return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);

    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        hitDashboardAPI(_lat,_long);
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<Position> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    return position;
  }

  hitDashboardAPI(double _lat,double _long) {
    MySharedPrefences().getSession().then((value) => {
      session = value,
      APIServices(context, session)
          .callApi(Const.dashboard_url, getRequest(_lat,_long))
          .then(
            (value) => checkResponse(value),
      ),
    });
  }
}
