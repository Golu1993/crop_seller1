import 'dart:convert';
import 'dart:io';

import 'package:crop_seller/_models/basic_model.dart';
import 'package:crop_seller/_models/profile_model.dart';
import 'package:crop_seller/_screens/address_info.dart';
import 'package:crop_seller/_screens/company_info.dart';
import 'package:crop_seller/_screens/login.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'bank_info.dart';
import 'basic_info.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile> {
  String session = '';
  late ProfileModel _profileModel;
  bool _isApiSuccess = false;

  @override
  void initState() {
    super.initState();
    MySharedPrefences().getSession().then((value) => {
          session = value,
          hitGetProfileAPI(),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color.fromRGBO(248, 246, 246, 1),
          child: Column(
            children: [
              Container(
                color: Colors.black,
                padding:
                    EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => {Navigator.pop(context)},
                      child: Container(
                        height: 40,
                        width: 40,
                        padding: EdgeInsets.only(
                            top: 5, left: 5, right: 15, bottom: 15),
                        child: Image.asset(
                          'images/back.png',
                        ),
                      ),
                    ),
                    Image.asset(
                      'images/my_profile.png',
                      width: MediaQuery.of(context).size.width,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isApiSuccess
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              //height: 150,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        top: 10,
                                        right: 20,
                                        bottom: 10),
                                    color: Color.fromRGBO(125, 200, 82, 1),
                                    child: Row(
                                      children: [
                                        Stack(
                                          children: [
                                            ClipOval(
                                              child: Image.network(
                                                (_profileModel.data?.sellerObj
                                                                ?.image ??
                                                            '') !=
                                                        ''
                                                    ? _profileModel
                                                            .data
                                                            ?.sellerObj
                                                            ?.image ??
                                                        ''
                                                    : 'https://miro.medium.com/max/1200/1*mk1-6aYaf_Bes1E3Imhc0A.jpeg',
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Positioned(
                                              height: 30,
                                              width: 40,
                                              right: 0,
                                              bottom: 0,
                                              child: InkWell(
                                                onTap: () {
                                                  showOptionDialog();
                                                },
                                                child: Icon(
                                                  Icons.photo_camera,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Flexible(
                                          child: Text(
                                            '${_profileModel.data?.sellerObj?.fname ?? ''} ${_profileModel.data?.sellerObj?.mname ?? ''} ${_profileModel.data?.sellerObj?.lname ?? ''}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      right: 20,
                                      bottom: -20,
                                      child: InkWell(
                                        onTap: () {
                                          logoutDialog(context);
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(
                                            Icons.logout,
                                            color: Colors.green,
                                            size: 25,
                                          ),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 40, left: 15, right: 15),
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.account_circle,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Basic Info',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(child: SizedBox()),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      BasicInfo(_profileModel
                                                          .data
                                                          ?.sellerObj))).then(
                                              (value) => hitGetProfileAPI());
                                        },
                                        child: Icon(
                                          Icons.edit_outlined,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Full Name',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          '${_profileModel.data?.sellerObj?.fname ?? ''} ${_profileModel.data?.sellerObj?.mname ?? ''} ${_profileModel.data?.sellerObj?.lname ?? ''}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Phone Number',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          _profileModel
                                                  .data?.sellerObj?.mobile ??
                                              '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Email',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          _profileModel
                                                  .data?.sellerObj?.email ??
                                              '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Birthday',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          '11/11/1111',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Gender',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          _profileModel
                                                  .data?.sellerObj?.gender ??
                                              '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Country',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          (_profileModel.data?.addressObj
                                                      ?.isNotEmpty ??
                                                  false)
                                              ? _profileModel
                                                      .data
                                                      ?.addressObj![0]
                                                      .countryName ??
                                                  ''
                                              : '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
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
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 20, left: 15, right: 15),
                              padding: EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_pin,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Address Info',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(child: SizedBox()),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Address(
                                                      (_profileModel
                                                                  .data
                                                                  ?.addressObj
                                                                  ?.isNotEmpty ??
                                                              false)
                                                          ? _profileModel.data
                                                              ?.addressObj![0]
                                                          : null,
                                                      true))).then(
                                              (value) => hitGetProfileAPI());
                                        },
                                        child: Icon(
                                          Icons.edit_outlined,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Address',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    getFullAddress() != ''
                                        ? getFullAddress()
                                        : 'Not available',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  )
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
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 20, left: 15, right: 15),
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.apartment_rounded,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Company Info',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(child: SizedBox()),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Company(
                                                      _profileModel.data
                                                          ?.companyObj))).then(
                                              (value) => hitGetProfileAPI());
                                        },
                                        child: Icon(
                                          Icons.edit_outlined,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Company Name',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          _profileModel.data?.companyObj
                                                  ?.companyName ??
                                              '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Social Security',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          _profileModel.data?.companyObj?.ein ??
                                              '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Driving License',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      (_profileModel.data?.companyObj
                                          ?.driverLicence ??
                                          '') !=
                                          ''
                                          ? Image.network(_profileModel
                                          .data
                                          ?.companyObj
                                          ?.driverLicence ??
                                          '',width: 60,
                                        height: 40,
                                        fit: BoxFit.cover,)
                                          : SizedBox(),
                                      Expanded(child: SizedBox(),flex: 2,)
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Tax Exemption',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          _profileModel.data?.companyObj
                                                  ?.taxExemption ??
                                              '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Number of Years in Business',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          _profileModel.data?.companyObj
                                                  ?.noOfYearInBusiness ??
                                              '',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
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
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(top: 20, left: 15, right: 15),
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.house_siding_rounded,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Bank Info',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Expanded(child: SizedBox()),
                                      InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => Bank(
                                                      getBankData(),
                                                      true))).then(
                                              (value) => hitGetProfileAPI());
                                        },
                                        child: Icon(
                                          Icons.edit_outlined,
                                          color: Colors.black,
                                          size: 25,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Bank Name',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          getBankName(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Account Number',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          getBankAccount(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
                                  Divider(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Routing Number',
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          getBankReceipt(),
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                      )
                                    ],
                                  ),
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
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      )
                    : SizedBox(),
              )
            ],
          ),
        ),
      ),
    );
  }

  checkResponse(String response) {
    BasicModel data = BasicModel.fromJson(jsonDecode(response));
    Fluttertoast.showToast(msg: data.message!);
    if (data.status == 1) {
      MySharedPrefences().setSession('');
      MySharedPrefences().setUserImage('');
      MySharedPrefences().setUserName('');
      APIServices.headers.clear();
      Navigator.pushAndRemoveUntil(context,
          MaterialPageRoute(builder: (context) => Login()), (route) => false);
      MySharedPrefences().setIsLogin(false);
    }
  }

  getFullAddress() {
    String data = '';
    if (_profileModel.data?.addressObj?.isEmpty ?? false) {
      return data;
    }
    var address = _profileModel.data?.addressObj?[0];
    if ((address?.address ?? '') != '') {
      data += address?.address ?? '';
    }
    if ((address?.city ?? '') != '') {
      if (data != '') {
        data += ',';
      }
      data += address?.city ?? '';
    }

    if ((address?.state ?? '') != '') {
      if (data != '') {
        data += ',';
      }
      data += address?.state ?? '';
    }
    if ((address?.countryName ?? '') != '') {
      if (data != '') {
        data += ',';
      }
      data += address?.countryName ?? '';
    }
    if ((address?.zip ?? '') != '') {
      if (data != '') {
        data += ' ( ';
      }
      data += address?.zip ?? '';
      data += ' )';
    }
    return data;
  }

  String getBankName() {
    String data = '';
    var bank = _profileModel.data?.bankObj;
    if ((bank?.length ?? 0) > 0) {
      data += bank![0].bankName ?? '';
    }
    return data;
  }

  String getBankAccount() {
    String data = '';
    var bank = _profileModel.data?.bankObj;
    if ((bank?.length ?? 0) > 0) {
      data += bank![0].accountNumber ?? '';
    }
    return data;
  }

  String getBankReceipt() {
    String data = '';
    var bank = _profileModel.data?.bankObj;
    if ((bank?.length ?? 0) > 0) {
      data += bank![0].receiptNumber ?? '';
    }
    return data;
  }

  checkResponse2(String value) {
    if (value != '') {
      _profileModel = ProfileModel.fromJson(jsonDecode(value));
      if (_profileModel.status == 1) {
        updateUserData();
        setState(() {
          _isApiSuccess = true;
        });
      } else {
        Fluttertoast.showToast(msg: _profileModel.message!);
      }
    }
  }

  checkResponse1(int? value) {
    if ((value ?? 0) == 200) {
      Fluttertoast.showToast(msg: 'Updated successfully');
      APIServices(context, session)
          .callApi(Const.common_base_url, getRequest())
          .then((value) => checkResponse2(value));
    } else {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  Map getRequest() {
    var request = {
      'api': '1',
      'action': 'profile',
    };
    return request;
  }

  showOptionDialog() {
    Dialog dialog = Dialog(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 3),
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                _getImageFromGallery(1);
                Navigator.pop(context);
              },
              child: Text(
                'Open Camera',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                _getImageFromGallery(2);
                Navigator.pop(context);
              },
              child: Text(
                'Open Gallery',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext _context) => dialog);
  }

  _getImageFromGallery(int type) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: type == 2 ? ImageSource.gallery : ImageSource.camera,
    );
    print('$pickedFile');
    if (pickedFile != null) {
      setState(() {
        File imageFile = File(pickedFile.path);
        APIServices(context, session)
            .uploadBuyerImage(
              imageFile.path,
              Const.common_base_url,
            )
            .then(
              (value) => checkResponse1(value),
            );
      });
    }
  }

  BankObj? getBankData() {
    if (_profileModel.data?.bankObj?.isNotEmpty ?? false) {
      return _profileModel.data?.bankObj?[0];
    }
    return null;
  }

  logoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Do you want to logout ? '),
          actionsAlignment: MainAxisAlignment.center,
          actions: <Widget>[
            ElevatedButton(
              child: const Text('NO'),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              width: 30,
            ),
            ElevatedButton(
              child: const Text('YES'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
              ),
              onPressed: () {
                APIServices(context, session)
                    .callApi(Const.logout_url, getRequest())
                    .then(
                      (value) => checkResponse(value),
                    );
              },
            ),
          ],
        );
      },
    );
  }

  String? getCountryName() {
    return (_profileModel.data?.addressObj?.isNotEmpty ?? false)
        ? _profileModel.data?.addressObj![0].countryName
        : null;
  }

  hitGetProfileAPI() {
    APIServices(context, session)
        .callApi(Const.common_base_url, getRequest())
        .then((value) => checkResponse2(value));
  }

  void updateUserData() {
    MySharedPrefences().setUserName('${_profileModel.data?.sellerObj?.fname??''} ${_profileModel.data?.sellerObj?.lname??''}');
    MySharedPrefences().setUserImage(_profileModel.data?.sellerObj?.image??'');
  }
}
