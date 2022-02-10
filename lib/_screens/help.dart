import 'dart:convert';

import 'package:crop_seller/_models/basic_model.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/utility/utils.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dashboard.dart';

class Help extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HelpState();
  }
}

class HelpState extends State<Help> {
  String session = "";
  var _enquiryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    MySharedPrefences().getSession().then((value) => {
          session = value,
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 20),
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Image.asset(
                "images/help_title.png",
                width: MediaQuery.of(context).size.width,
                height: 25,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromRGBO(248, 246, 246, 1),
                  child: Column(
                    children: [
                      Text(
                        "Please get in touch and we will be happy to help you",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Card(
                        elevation: 5,
                        margin: EdgeInsets.only(top: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: TextFormField(
                          controller: _enquiryController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(
                            hintText: "Enter your query",
                            contentPadding: EdgeInsets.only(
                                left: 10.0, top: 10, right: 10, bottom: 10),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: HexColor.fromHex('#7DC852'),
                            //primary: Color.fromARGB(1,125, 200, 82),
                            minimumSize: const Size(200, 45),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        onPressed: () => {
                          if (_enquiryController.text == '')
                            {Fluttertoast.showToast(msg: "Enter your query")}
                          else
                            {
                              APIServices(context, session)
                                  .callApi(Const.enquiry_url, getRequest())
                                  .then(
                                    (value) => checkResponse(value),
                                  ),
                            }
                        },
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
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
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false);
    }
  }

  Map getRequest() {
    var request = {
      'api': '1',
      'action': 'enquiry',
      'enquiry': _enquiryController.text,
    };

    return request;
  }
}
