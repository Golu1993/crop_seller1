import 'dart:convert';

import 'package:crop_seller/_models/basic_model.dart';
import 'package:crop_seller/_models/profile_model.dart';
import 'package:crop_seller/_screens/dashboard.dart';
import 'package:crop_seller/_screens/profile.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/utility/utils.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Bank extends StatefulWidget {
  BankObj? _bankObj;
  bool _isEditData = false;

  Bank(this._bankObj, this._isEditData);

  @override
  State<StatefulWidget> createState() {
    return Bank_State();
  }
}

class Bank_State extends State<Bank> {
  var bNameController = TextEditingController();
  var accNoController = TextEditingController();
  var cAccNoController = TextEditingController();
  var routingController = TextEditingController();
  String session = "";
  String bank_id = "";

  @override
  void initState() {
    super.initState();
    MySharedPrefences().getSession().then((value) => session = value);
    bNameController.text = widget._bankObj?.bankName ?? "";
    accNoController.text = widget._bankObj?.accountNumber ?? "";
    cAccNoController.text = widget._bankObj?.accountNumber ?? "";
    routingController.text = widget._bankObj?.receiptNumber ?? "";
    bank_id = widget._bankObj?.bankId ?? "";
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const Text(
                "Steps 4 of 4",
                style: TextStyle(fontSize: 12, color: Colors.yellow),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Bank Info",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              const Text(
                "Bank Name",
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
                  controller: bNameController,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Bank Name",
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Bank Account Number",
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
                  controller: accNoController,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Bank Account Number",
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Confirm Account Number",
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
                  controller: cAccNoController,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Confirm Account Number",
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Routing Number",
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
                  controller: routingController,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: "Routing Number",
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
                                .callApi(Const.common_base_url, getRequest())
                                .then(
                                  (value) => checkResponse(value),
                                ),
                          },
                      },
                  child: Text("Submit",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black))),
            ],
          ),
        ),
      ),
    );
  }

  Map getRequest() {
    var request = {
      'api': "1",
      'action': "bank_info",
      'bank_name': bNameController.text,
      'account_number': accNoController.text,
      'confirm_account_number': cAccNoController.text,
      'receipt_number': routingController.text,
      'bank_id': bank_id,
    };
    return request;
  }

  validateViews() {
    if (bNameController.text == "") {
      Fluttertoast.showToast(msg: "Enter bank name");
      return false;
    } else if (accNoController.text == "") {
      Fluttertoast.showToast(msg: "Enter account no.");
      return false;
    } else if (cAccNoController.text == "") {
      Fluttertoast.showToast(msg: "Enter confirm account no.");
      return false;
    } else if (accNoController.text != cAccNoController.text) {
      Fluttertoast.showToast(msg: "Confirm account no. not matched");
      return false;
    } else if (routingController.text == "") {
      Fluttertoast.showToast(msg: "Enter receipt no.");
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
        if (widget._isEditData) {
          Navigator.pop(context,true);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>Dashboard()),
                  (route) => false);
        }
      }
    }
  }
}
