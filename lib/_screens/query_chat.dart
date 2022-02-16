import 'dart:async';
import 'dart:convert';

import 'package:crop_seller/_models/basic_model.dart';
import 'package:crop_seller/_models/chat_model.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class QueryChat extends StatefulWidget {
  String _buyerId = '';
  String _productId = '';


  QueryChat(this._buyerId, this._productId);

  @override
  State<StatefulWidget> createState() {
    return QueryChatState();
  }
}

class QueryChatState extends State<QueryChat> {
  String session = '';
  List<ChatData> _listChat = [];
  var commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    MySharedPrefences()
        .getSession()
        .then((value) => {session = value, hitGetChatApi()});
  }

  Map getRequest() {
    var request = {
      'api': '1',
      'action': 'product_query_answer',
      'product_id': widget._productId,
      'buyer_id': widget._buyerId,
    };
    return request;
  }

  checkResponse(String response) {
    ChatModel data = ChatModel.fromJson(jsonDecode(response));
    if (data.status == 1) {
      setState(() {
        _listChat.clear();
        _listChat = data.data ?? [];
      });
      Timer(
          Duration(seconds: 2),
              () => {
            _scrollDown(),
          });
    } else {
      Fluttertoast.showToast(msg: data.message!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,

          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              padding: EdgeInsets.only(left: 20, right: 20,top: 20,bottom: 10),
              color: Colors.black,
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
                  Image.asset(
                    "images/query_title.png",
                    width: MediaQuery.of(context).size.width,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(15),
                child: getList(),
              ),
            ),
            Stack(
              children: [
                Container(
                  margin:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(242, 242, 242, 1),
                      borderRadius: BorderRadius.circular(25)),
                  child: TextFormField(
                    controller: commentController,
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: "Type Your comments",
                      contentPadding: EdgeInsets.only(left: 10, right: 10),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Positioned(
                    top: 15,
                    right: 30,
                    bottom: 15,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        Icons.send,
                        color: Colors.black,
                      ),
                      onPressed: () => {
                        if (commentController.text == '')
                          {Fluttertoast.showToast(msg: 'Enter your comments')}
                        else
                          {
                            APIServices(context, session)
                                .callApi(Const.product_url, getChatRequest())
                                .then(
                                  (value) => checkResponse2(value),
                            ),
                          },
                      },
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.minPositive, 25),
                          primary: Colors.orange,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      label: Text(
                        "Submit",
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    )),
              ],
            )
          ]),
        ),
      ),
    );
  }

  Map getChatRequest() {
    var request = {
      'api': '1',
      'action': 'product_query_reply',
      'buyer_id': widget._buyerId,
      'product_id': widget._productId,
      'comment': commentController.text,
      //comment_id:2
    };
    return request;
  }

  checkResponse2(String response) {
    BasicModel data = BasicModel.fromJson(jsonDecode(response));
    Fluttertoast.showToast(msg: data.message!);
    if (data.status == 1) {
      FocusManager.instance.primaryFocus?.unfocus();
      commentController.text = '';
      hitGetChatApi();
      setState(() {});
    }
  }

  final ScrollController _controller = ScrollController();

// This is what you're looking for!
  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  getList() {
    return ListView.builder(
      controller: _controller,
      itemCount: _listChat.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        if (_listChat[index].commentedBy == '2') {
          return otherChatItems(index);
        } else {
          return myChatItems(index);
        }
      },
    );
  }

  myChatItems(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              getTime(_listChat[index].created ?? ''),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                _listChat[index].comment ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Color.fromRGBO(242, 178, 82, 0.9)),
            ),
          ],
        ),
        Text(
          "Name",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  otherChatItems(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(bottom: 10),
              child: Text(
                _listChat[index].comment ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  color: Color.fromRGBO(242, 178, 82, 0.7)),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              getTime(_listChat[index].created ?? ''),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        Text(
          "Name",
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  String getTime(String datetime) {
    var time = DateFormat('HH:mm a')
        .format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(datetime));
    return time;
  }

  hitGetChatApi() {
    APIServices(context, session).callApi(Const.product_url, getRequest()).then(
          (value) => checkResponse(value),
    );
  }
}
