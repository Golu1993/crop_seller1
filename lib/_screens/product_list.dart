import 'dart:async';
import 'dart:convert';

import 'package:crop_seller/_models/basic_model.dart';
import 'package:crop_seller/_models/product_list_model.dart';
import 'package:crop_seller/_screens/add_product.dart';
import 'package:crop_seller/_screens/product_details.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProductListState();
  }
}

class ProductListState extends State<ProductList> {
  bool isSelect = false;
  String session = '';
  bool _isApiSuccess = false;
  bool _isDataEmpty = false;
  int page = 1;
  List<ProductDetailsData> _listData = [];

  @override
  void initState() {
    super.initState();
    MySharedPrefences().getSession().then((value) => {
          session = value,
          hitGetProductDetailsAPI(),
        });
  }

  Map getRequest() {
    var request = {
      'api': '1',
      'action': 'list',
      'page': page.toString(),
    };

    return request;
  }

  Map getStatusRequest(String pid, bool status) {
    var request = {
      'api': '1',
      'action': 'update_product_status',
      'product_id': pid,
      'status': status == true ? 'enable' : 'disable',
    };

    return request;
  }

  checkResponse(String response) {
    ProductListModel _productListData =
        ProductListModel.fromJson(jsonDecode(response));
    if (_productListData.status == 1) {
      setState(() {
        if (page == 1) {
          _listData.clear();
          _listData = _productListData.data ?? [];
        } else {
          _listData.addAll(_productListData.data ?? []);
        }
        _isDataEmpty = _productListData.data?.isEmpty ?? true;
        _isApiSuccess = true;
      });
    }
  }

  checkResponse2(String response) {
    BasicModel data = BasicModel.fromJson(jsonDecode(response));
    Fluttertoast.showToast(msg: data.message!);
    if (data.status == 1) {
      setState(() {});
    }
  }

  getList() {
    var listview = ListView.builder(
      itemCount: _listData.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        if (index == _listData.length - 1) {
          if (!_isDataEmpty&&_listData.length>9) {
            page++;
            Timer(
                Duration(milliseconds: 500),
                () => {
                      APIServices(context, session)
                          .callApi(Const.product_url, getRequest())
                          .then((value) => checkResponse(value))
                    });
          }
        }
        return getListItemWidget(index);
      },
    );
    return listview;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 15,
              ),
              Image.asset(
                "images/product_list_title.png",
                width: MediaQuery.of(context).size.width,
                height: 25,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                color: Colors.lightGreen,
                alignment: Alignment.centerLeft,
                padding:
                    EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Add Product",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddProduct(null))).then((value) => hitGetProductDetailsAPI());
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(35, 103, 53, 1),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: _isApiSuccess
                      ? Container(
                          padding: EdgeInsets.only(left: 15, right: 15),
                          color: Color.fromRGBO(248, 246, 246, 1),
                          child: getList(),
                        )
                      : SizedBox())
            ],
          ),
        ),
      ),
    );
  }

  getListItemWidget(int index) {
    var data = _listData[index];
    return Card(
      margin: EdgeInsets.only(top: 15),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              image: DecorationImage(
                image: NetworkImage(data.photo?.isNotEmpty ?? false
                    ? data.photo![0].path ?? ''
                    : 'https://media.nationalgeographic.org/assets/photos/120/983/091a0e2f-b93d-481b-9a60-db520c87ec33.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      data.name ?? '',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                    Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProductDetails(
                                    _listData[index].productId ??
                                        '')));
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.remove_red_eye_outlined,
                          color: Color.fromRGBO(35, 103, 53, 1),
                          size: 20,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(206, 229, 220, 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AddProduct(_listData[index]))).then((value) => hitGetProductDetailsAPI());
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        child: Icon(
                          Icons.edit,
                          color: Colors.lightBlue,
                          size: 20,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color.fromRGBO(205, 223, 241, 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    /* Container(
                      width: 30,
                      height: 30,
                      child: Icon(
                        Icons.delete_forever_sharp,
                        color: Colors.orange,
                        size: 20,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color.fromRGBO(247, 215, 202, 1),
                      ),
                    ),*/
                  ],
                ),
                Text(
                  data.category ?? '',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "${data.weight ?? ''} kg",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "  \$ ${data.price ?? ''} ",
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Expanded(child: SizedBox()),
                    Switch(
                        activeColor: Colors.orange,
                        value: data.status == "1" ? true : false,
                        onChanged: (value) {
                          setState(() {
                            data.status == "1"
                                ? data.status = "0"
                                : data.status = "1";
                            APIServices(context, session)
                                .callApi(
                                    Const.product_url,
                                    getStatusRequest(
                                        data.productId ?? '', value))
                                .then((value) => checkResponse2(value));
                          });
                        }),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  hitGetProductDetailsAPI() {
    APIServices(context, session)
        .callApi(Const.product_url, getRequest())
        .then((value) => checkResponse(value));
  }
}
