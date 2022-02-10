import 'dart:convert';

import 'package:crop_seller/_models/basic_model.dart';
import 'package:crop_seller/_models/profile_model.dart';
import 'package:crop_seller/_screens/address_info.dart';
import 'package:crop_seller/_screens/splash.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/utility/utils.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class BasicInfo extends StatefulWidget {
  SellerObj? _sellerData;

  BasicInfo(this._sellerData);

  @override
  State<StatefulWidget> createState() {
    return BasicInfo_State();
  }
}

class BasicInfo_State extends State<BasicInfo> {
  var fnameControler = TextEditingController();
  var mnameControler = TextEditingController();
  var lnameControler = TextEditingController();
  var dateController = TextEditingController();
  int _genderType = 0;
  String session = "";
  bool _isEditData = false;

  @override
  void initState() {
    super.initState();
    MySharedPrefences().getSession().then((value) => session = value);
    fnameControler.text = widget._sellerData?.fname ?? "";
    mnameControler.text = widget._sellerData?.mname ?? "";
    lnameControler.text = widget._sellerData?.lname ?? "";
    dateController.text = widget._sellerData?.dob ?? "";
    _genderType = (widget._sellerData?.gender ?? "") == "" ? 0 : 1;
    if (_genderType == 1) {
      _genderType = (widget._sellerData?.gender ?? "") == "male" ? 1 : 2;
    }
    _isEditData = widget._sellerData != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 50, left: 20, right: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/theme_back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => {Navigator.pop(context)},
                  child: Container(
                    height: 40,
                    width: 40,
                    padding:
                        EdgeInsets.only(top: 5, left: 5, right: 15, bottom: 15),
                    child: Image.asset(
                      "images/back.png",
                    ),
                  ),
                ),
                Expanded(child: SizedBox()),
                GestureDetector(
                  onTap: () => {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Splash()),
                        (route) => false)
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("Skip for later",
                          style: TextStyle(color: Colors.white, fontSize: 15)),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 50, right: 50),
              child: Column(
                children: [
                  Image.asset(
                    "images/register_logo.png",
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                  const Text(
                    "Complete your profile to get full access.",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: Colors.white60),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Steps 1 of 4",
                      style: TextStyle(fontSize: 12, color: Colors.yellow),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Basic Info",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                        Expanded(
                            child: Container(
                          height: 1,
                          color: Colors.white,
                        ))
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "First Name",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: TextFormField(
                        controller: fnameControler,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: "First Name",
                          contentPadding: EdgeInsets.all(10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Middle Name",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: TextFormField(
                        controller: mnameControler,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: "Middle Name",
                          contentPadding: EdgeInsets.all(10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Last Name",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: TextFormField(
                        controller: lnameControler,
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          hintText: "Last Name",
                          contentPadding: EdgeInsets.all(10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Gender",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => {
                                  setState(
                                    () {
                                      _genderType = 1;
                                    },
                                  ),
                                },
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: getGenderColor(1),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      bottomLeft: Radius.circular(25),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Male",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 1,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => {
                                  setState(
                                    () {
                                      _genderType = 2;
                                    },
                                  ),
                                },
                                child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: getGenderColor(2),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Female",
                                      ),
                                    )),
                              ),
                            ),
                            Container(
                              width: 1,
                              color: Colors.grey,
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => {
                                  setState(
                                    () {
                                      _genderType = 3;
                                    },
                                  ),
                                },
                                child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: getGenderColor(3),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(25),
                                        bottomRight: Radius.circular(25),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "NA",
                                      ),
                                    )),
                              ),
                            )
                          ],
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Date of Birth",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                          color: Colors.white),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25)),
                      child: TextFormField(
                        controller: dateController,
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          DateTime date = DateTime.now();

                          date = (await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now()))!;

                          dateController.text =
                              DateFormat('yyyy-MM-dd').format(date);
                        },
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        decoration: const InputDecoration(
                          hintText: "dd/mm/yyyy",
                          contentPadding: EdgeInsets.all(10.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: HexColor.fromHex('#7DC852'),
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        onPressed: () => {
                              if (validateViews())
                                {
                                  APIServices(context, session)
                                      .callApi(
                                          Const.common_base_url, getRequest())
                                      .then(
                                        (value) => checkResponse(value),
                                      ),
                                },
                            },
                        child: Text("Save & Continue",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.black))),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getGenderColor(int value) {
    if (_genderType == value) {
      return Colors.orange;
    } else {
      return Colors.white;
    }
  }

  Map getRequest() {
    var request = {
      'api': "1",
      'action': "basic_info",
      'fname': fnameControler.text,
      'mname': mnameControler.text,
      'lname': lnameControler.text,
      'gender': _genderType == 1
          ? "male"
          : _genderType == 2
              ? "female"
              : "na",
      'dob': dateController.text,
    };
    return request;
  }

  validateViews() {
    if (fnameControler.text == "") {
      Fluttertoast.showToast(msg: "Enter first name");
      return false;
    } else if (_genderType == 0) {
      Fluttertoast.showToast(msg: "Select gender type");
      return false;
    } else if (dateController.text == "") {
      Fluttertoast.showToast(msg: "Enter dob");
      return false;
    } else {
      return true;
    }
  }

  checkResponse(String value) {
    if (value != "") {
      BasicModel data = BasicModel.fromJson(jsonDecode(value));
      Fluttertoast.showToast(msg: data.message!);
      if (data.status == 1) {
        if (_isEditData) {
          Navigator.pop(context, true);
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Address(null)));
        }
      }
    }
  }
}
