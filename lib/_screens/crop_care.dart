import 'dart:convert';

import 'package:crop_seller/_models/crop_care_model.dart';
import 'package:crop_seller/_screens/crop_care_list.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';

class CropCare extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CropCareState();
  }
}

class CropCareState extends State<CropCare> {
  String session = '';
  bool _isApiSuccess = false;
  late CropCareModel _cropCareModel;

  @override
  void initState() {
    super.initState();
    MySharedPrefences().getSession().then((value) => {
          session = value,
          APIServices(context, session)
              .callApi(Const.crop_care_url, getRequest())
              .then((value) => checkResponse(value)),
        });
  }

  Map getRequest() {
    var request = {
      'api': '1',
      'action': 'type_list',
    };

    return request;
  }

  checkResponse(String response) {
    _cropCareModel = CropCareModel.fromJson(jsonDecode(response));
    if (_cropCareModel.status == 1) {
      setState(() {
        _isApiSuccess = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.black,
                padding:
                    EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
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
                          "images/back.png",
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Image.asset(
                          "images/crop_care.png",
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: _isApiSuccess ? getCropCareItem() : SizedBox(),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("images/crop_care_bg.png"),
                      fit: BoxFit.fitWidth,
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

  getCropCareItem() {
    var listview = ListView.builder(
        itemCount: _cropCareModel.data?.length ?? 0,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 15),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CropCareList('${_cropCareModel.data![index].type ?? 0}')),
                );
              },
              child: Column(
                children: [
                  Image.network(
                    _cropCareModel.data![index].path ?? "",
                    width: 150,
                    height: 150,
                  ),
                  Text(
                    _cropCareModel.data![index].title ?? "",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )
                ],
              ),
            ),
          );
        });
    return listview;
  }
}
