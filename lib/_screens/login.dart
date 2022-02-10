import 'dart:convert';

import 'package:crop_seller/_models/login_model.dart';
import 'package:crop_seller/_screens/forgot_password.dart';
import 'package:crop_seller/_screens/register.dart';
import 'package:crop_seller/_screens/splash.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/utility/utils.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dashboard.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Login_State();
  }
}

class Login_State extends State<Login> {
  TextStyle defaultStyle = TextStyle(color: Colors.white, fontSize: 16);
  TextStyle linkStyle = TextStyle(color: Colors.orange);
  bool isApi = true;
  final emailControler = TextEditingController(text: "dheerusingh59@gmail.com");
  final passwordControler = TextEditingController(text: "1");
  String session="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "Sign In",
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
                  height: 50,
                ),
                const Text(
                  "Username",
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
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      hintText: "Username",
                      contentPadding: EdgeInsets.only(
                          left: 10.0, top: 10, right: 10, bottom: 10),
                      border: InputBorder.none,
                      // suffixIcon: IconButton(
                      //   icon: Icon(Icons.alternate_email, size: 14),
                      //   onPressed: () => Fluttertoast.showToast(msg: "msg"),
                      // ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
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
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Required";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Password",
                      contentPadding: EdgeInsets.only(
                          left: 10.0, top: 10, right: 10, bottom: 10),
                      border: InputBorder.none,

                      // suffixIcon: IconButton(
                      //   icon: Icon(Icons.remove_red_eye_outlined, size: 14),
                      //   onPressed: () => Fluttertoast.showToast(msg: "msg"),
                      // ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Forgot_Password()))
                        },
                        child: Text(
                          "Forgot Password?",
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
                  height: 50,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: HexColor.fromHex('#7DC852'),
                        //primary: Color.fromARGB(1,125, 200, 82),
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    onPressed: () => {

                          if (validateViews())
                            {
                              APIServices(context,session).callApi(Const.login_url,getRequest()).then(
                                    (value) => checkResponse(value),
                                  ),
                            }
                        },
                    child: Text("Login",
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
                          children: [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Sign Up Now',
                              style: linkStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()
                                      ));
                                },
                            ),
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
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    MySharedPrefences().setSession("");

  }
  @override
  void dispose() {
    emailControler.dispose();
    passwordControler.dispose();
    super.dispose();
  }

  checkResponse(String value) {
    if(value!="") {
      LoginModel data = LoginModel.fromJson(jsonDecode(value));
      if (data.status == 1) {
        if (data.message == "Already Login.") {
          APIServices(context,"").callApi(Const.logout_url,  getRequest());
          Fluttertoast.showToast(msg: "Login again");
          return;
        }
        Fluttertoast.showToast(msg: data.message!);
        MySharedPrefences().setIsLogin(true);
        MySharedPrefences().setUserName('${data.data![0].fname??''} ${data.data![0].lname??''}');
        MySharedPrefences().setUserImage(data.data![0].image??'');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard()));
      } else {
        Fluttertoast.showToast(msg: data.message!);
      }
    }
  }

  Map getRequest() {
    var request = {
      'api': "1",
      'login': emailControler.text,
      'password': passwordControler.text,
    };
    return request;
  }

  validateViews() {
    if (emailControler.text == "") {
      Fluttertoast.showToast(msg: "Enter user name");
      return false;
    }
    else if (passwordControler.text == "") {
      Fluttertoast.showToast(msg: "Enter password");
      return false;
    }else{
      return true;
    }
  }
}
