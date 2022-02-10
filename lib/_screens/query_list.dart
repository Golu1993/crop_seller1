import 'dart:convert';

import 'package:crop_seller/_models/query_model.dart';
import 'package:crop_seller/_screens/query_chat.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QueryList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QueryListState();
  }
}

class QueryListState extends State<QueryList> {
  String session = '';
  bool _isApiSuccess = false;
  List<QueryData> _listQuery = [];

  @override
  void initState() {
    super.initState();
    MySharedPrefences().getSession().then((value) => {
      session = value,
      APIServices(context, session)
          .callApi(Const.chat_url, getRequest())
          .then(
            (value) => checkResponse(value),
      ),
    });
  }

  Map getRequest() {
    var request = {
      'api': '1',
      'action': 'product_query',
    };
    return request;
  }

  checkResponse(String response) {
    QueryModel data = QueryModel.fromJson(jsonDecode(response));
    if (data.status == 1) {
      _isApiSuccess = true;
      _listQuery = data.data ?? [];
      setState(() {});
      return;
    }
    Fluttertoast.showToast(msg: data.message!);
  }
  getList() {
    return ListView.builder(
        itemCount: _listQuery.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return getListItems(index);
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
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
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
                    Container(
                      // padding: EdgeInsets.only(left: 50, right: 50),
                      child: Column(
                        children: [
                          Image.asset(
                            "images/query_title.png",
                            width: MediaQuery.of(context).size.width,
                            height: 30,
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: _isApiSuccess
                    ? Container(
                  padding: EdgeInsets.all(15),
                  color: Color.fromRGBO(240, 240, 240, 1),
                  child: getList(),
                )
                    : SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getListItems(int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Q. ${_listQuery[index].question??''}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                Text(
                  _listQuery[index].productName??'',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.green,
                  ),
                ),
                Text(
                  _listQuery[index].categoryName??'',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            padding: EdgeInsets.only(left: 10, right: 10),
            width: double.infinity,
            child: Row(
              children: [
                Text(
                  'By :- ${_listQuery[index].buyerName??''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange,
                  ),
                ),
                Expanded(child: SizedBox()),
                ElevatedButton(
                  onPressed: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => QueryChat(_listQuery[index].buyerId??'')))
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.minPositive, 25),
                      primary: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: Text(
                    "Reply",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                )
              ],
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10)),
                color: Colors.black12),
          ),
        ],
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 3,
            color: Colors.grey,
           // offset: const Offset(0.0, 0.0),

          ),
        ],
          borderRadius: BorderRadius.circular(10), color: Colors.white),
    );
  }
}
