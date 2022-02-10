import 'dart:convert';

import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/utils.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Forgot_Password extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Forgot_Password_State();
  }
}

class Forgot_Password_State extends State<Forgot_Password> {
  TextStyle defaultStyle = TextStyle(color: Colors.white, fontSize: 16);
  TextStyle linkStyle = TextStyle(color: Colors.orange);
  final emailControler = TextEditingController();
  final otpControler = TextEditingController();
  final passwordControler = TextEditingController();
  final cpasswordControler = TextEditingController();
  bool _isOtpSend = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/theme_back.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(top: 50, left: 20, right: 20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.only(left: 80, right: 80),
              child: Image.asset(
                "images/trans_logo.png",
                width: MediaQuery.of(context).size.width,
                height: 100,
                fit: BoxFit.contain,
              ),
            ),
            const Text(
              "Reset Password",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
            const Text(
              "Please enter the details below to reset password",
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: Colors.white60),
            ),
            _isOtpSend == true ? getResetPasswordWidget() : getOtpWidget(),
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.green),
                  backgroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () => {Navigator.pop(context)},
                child: Text("Back to Login",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 16,
                        color: Colors.white))),
          ]),
        )),
      ),
    );
  }

  getOtpWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        const Text(
          "Email",
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: TextFormField(
            controller: emailControler,
            style: TextStyle(color: Colors.black, fontSize: 14),
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: "Email",
              contentPadding: EdgeInsets.all(10.0),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: HexColor.fromHex('#7DC852'),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25))),
          onPressed: () => {
            if (emailControler.text != "")
              {
                APIServices(context,"")
                    .callApi(Const.get_otp_url, getRequest())
                    .then(
                      (value) => checkOtpResponse(value),
                    ),
              }
            else
              {Fluttertoast.showToast(msg: "Enter email address")},
          },
          child: Text(
            "Get OTP",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Colors.black),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  getResetPasswordWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 30,
        ),
        const Text(
          "OTP",
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: TextFormField(
            controller: otpControler,
            style: TextStyle(color: Colors.black, fontSize: 14),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: "OTP",
              contentPadding: EdgeInsets.all(10.0),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "New Password",
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: TextFormField(
            obscureText: true,
            controller: passwordControler,
            style: TextStyle(color: Colors.black, fontSize: 14),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: "New Password",
              contentPadding:
                  EdgeInsets.only(left: 10.0, top: 10, right: 10, bottom: 10),
              border: InputBorder.none,
              // suffixIcon: IconButton(
              //   icon: Icon(Icons.remove_red_eye_outlined, size: 14),
              //   onPressed: () => Fluttertoast.showToast(msg: "msg"),
              // ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Confirm Password",
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: TextFormField(
            obscureText: true,
            controller: cpasswordControler,
            style: TextStyle(color: Colors.black, fontSize: 14),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: "Confirm Password",
              contentPadding:
                  EdgeInsets.only(left: 10.0, top: 10, right: 10, bottom: 10),
              border: InputBorder.none,
              // suffixIcon: IconButton(
              //   icon: Icon(Icons.remove_red_eye_outlined, size: 14),
              //   onPressed: () => Fluttertoast.showToast(msg: "msg"),
              // ),
            ),
          ),
        ),
        const SizedBox(
          height: 30,
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
                    .callApi(Const.reset_password_url, getRequest())
                    .then(
                      (value) => checkResponse(value),
                    ),
              },
          },
          child: Text(
            "Submit",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: Colors.black),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => {
                  APIServices(context,"")
                      .callApi(Const.get_otp_url, getRequest())
                      .then(
                        (value) => checkOtpResponse(value),
                  ),
                },
                child: Text(
                  "Resend OTP",
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Map getRequest() {
    var request = {
      'api': "1",
      'email': emailControler.text,
      'sid': otpControler.text,
      'password': passwordControler.text,
      'confirm_password': cpasswordControler.text,
    };
    return request;
  }

  validateViews() {
    if (otpControler.text == "") {
      Fluttertoast.showToast(msg: "Enter otp");
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
    // if (value != "") {
    //   BasicModel data = BasicModel.fromJson(jsonDecode(value));
    //   if (data.status == 1) {
    //     Fluttertoast.showToast(msg: data.message!);
    //     Navigator.pop(context);
    //   } else {
    //     Fluttertoast.showToast(msg: data.message!);
    //   }
    // }
  }

  checkOtpResponse(String value) {
    // if (value != "") {
    //   BasicModel data = BasicModel.fromJson(jsonDecode(value));
    //   if (data.status == 1) {
    //     Fluttertoast.showToast(msg: data.message!);
    //     setState(() {
    //       _isOtpSend = true;
    //     });
    //     FocusNode();
    //   } else {
    //     Fluttertoast.showToast(msg: data.message!);
    //   }
    // }
  }
}
