import 'dart:convert';

import 'package:crop_seller/_models/login_model.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/utility/utils.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'basic_info.dart';

class RegisterMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Register(),
    );
  }
}

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Register_State();
  }
}

class Register_State extends State<Register> {
  TextStyle defaultStyle = TextStyle(color: Colors.white, fontSize: 16);
  TextStyle linkStyle = TextStyle(color: Colors.orange);
  final emailControler = TextEditingController();
  final passwordControler = TextEditingController();
  final cpasswordControler = TextEditingController();
  final mobileControler = TextEditingController();

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
              Container(
                padding: EdgeInsets.only(left: 80, right: 80),
                child: Image.asset(
                  "images/logo.png",
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  fit: BoxFit.contain,
                ),
              ),
              const Text(
                "Sign Up",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              const Text(
                "Please enter the details below to continue",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: Colors.white60),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Mobile Number",
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
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  controller: mobileControler,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Mobile Number",
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Email Address",
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
                  controller: emailControler,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Email Address",
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Password",
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
                  obscureText: true,
                  controller: passwordControler,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: "Password",
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Confirm password",
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
                  obscureText: true,
                  controller: cpasswordControler,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: "Confirm password",
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
                            APIServices(context,"")
                                .callApi(Const.register_url, getRequest())
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
              Container(
                margin: EdgeInsets.only(top: 50),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: defaultStyle,
                        children: <TextSpan>[
                          TextSpan(text: "Already registered user? "),
                          TextSpan(
                              text: 'Sign In Now',
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pop(context);
                                }),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Map getRequest() {
    var request = {
      'api': "1",
      'email': emailControler.text,
      'mobile': mobileControler.text,
      'password': passwordControler.text,
      'confirm_password': cpasswordControler.text,
    };
    return request;
  }

  validateViews() {
    if (mobileControler.text == "") {
      Fluttertoast.showToast(msg: "Enter mobile no");
      return false;
    } else if (emailControler.text == "") {
      Fluttertoast.showToast(msg: "Enter user email");
      return false;
    } else if (passwordControler.text == "") {
      Fluttertoast.showToast(msg: "Enter password");
      return false;
    } else if (cpasswordControler.text == "") {
      Fluttertoast.showToast(msg: "Enter confirm password");
      return false;
    } else if (cpasswordControler.text != passwordControler.text) {
      Fluttertoast.showToast(msg: "Confirm password not matched");
      return false;
    } else {
      return true;
    }
  }

  checkResponse(String value) {
    if (value != "") {
      LoginModel data = LoginModel.fromJson(jsonDecode(value));
      Fluttertoast.showToast(msg: data.message!);
      if (data.status == 1) {
        MySharedPrefences().setIsLogin(true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => BasicInfo(null)));
      }
    }
  }
}
