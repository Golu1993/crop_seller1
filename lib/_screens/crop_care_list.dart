import 'dart:convert';

import 'package:crop_seller/_models/crop_care_list_model.dart';
import 'package:crop_seller/_screens/crop_care_details.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';

class CropCareList extends StatefulWidget {
  String _cropType = '0';

  CropCareList(this._cropType);

  @override
  State<StatefulWidget> createState() {
    return CropCareListState();
  }
}

class CropCareListState extends State<CropCareList> {
  String session = '';
  bool _isApiSuccess = false;
  late CropCareListModel _cropCareListModel;
  List<CropCareData> _filterList = [];

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
      'action': 'list',
      'type': widget._cropType,
    };

    return request;
  }

  checkResponse(String response) {
    _cropCareListModel = CropCareListModel.fromJson(jsonDecode(response));
    if (_cropCareListModel.status == 1) {
      _filterList = _cropCareListModel.data ?? [];
      setState(() {
        _isApiSuccess = true;
      });
    }
  }

  getList() {
    return ListView.builder(
      itemCount: _filterList.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return getListItemWidget(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          // padding: EdgeInsets.only(top: 20),
          color: Colors.white,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("images/theme_back.png"),
          //     fit: BoxFit.cover,
          //   ),
          // ),

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
                          "images/cropcare_title.png",
                          width: MediaQuery.of(context).size.width,
                          height: 25,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                margin:
                    EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 10),
                child: TextFormField(
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: "Search",
                    contentPadding:
                        EdgeInsets.only(left: 10, right: 10, top: 15),
                    border: InputBorder.none,
                    suffixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) => filterList(value),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: _isApiSuccess ? getList() : SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getListItemWidget(int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CropCareDetails(_filterList[index])));
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              _filterList[index].title ?? '',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            Expanded(child: SizedBox()),
            Icon(
              Icons.keyboard_arrow_right,
              color: Colors.black54,
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        decoration: BoxDecoration(
          color:
              index % 2 == 0 ? Color.fromRGBO(242, 242, 242, 1) : Colors.white,
        ),
      ),
    );
  }

  filterList(String value) {
    setState(() {
      if (value == '') {
        _filterList = _cropCareListModel.data ?? [];
      } else {
        _filterList = _cropCareListModel.data
                ?.where((element) => (element.title ?? '')
                    .toLowerCase()
                    .contains(value.toLowerCase()))
                .toList() ??
            [];
      }
    });
  }
}
