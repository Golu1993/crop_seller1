import 'dart:convert';

import 'package:crop_seller/_models/basic_model.dart';
import 'package:crop_seller/_models/order_model.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/utility/utils.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderList extends StatefulWidget {
  int _tabIndex = 0;

  OrderList([this._tabIndex=0]);

  @override
  State<StatefulWidget> createState() {
    return OrderList_State();
  }
}

class OrderList_State extends State<OrderList> {
  int tabIndex = 0;
  int position = -1;
  List<OrderData> _listData = [];

  String session = '';
  bool _isApiSuccess = false;

  @override
  void initState() {
    super.initState();
    tabIndex=widget._tabIndex;
    MySharedPrefences().getSession().then((value) => {
          session = value,
          APIServices(context, session)
              .callApi(Const.order_url, getRequest())
              .then(
                (value) => checkResponse(value),
              ),
        });
  }

  checkResponse(String response) {
    OrderModel data = OrderModel.fromJson(jsonDecode(response));
    if (data.status == 1) {
      _listData = data.data ?? [];
      setState(() {
        _isApiSuccess = true;
      });
      return;
    }
    Fluttertoast.showToast(msg: data.message!);
  }

  checkResponse2(String response) {
    BasicModel data = BasicModel.fromJson(jsonDecode(response));
    Fluttertoast.showToast(msg: data.message!);
    if (data.status == 1) {
      APIServices(context, session).callApi(Const.order_url, getRequest()).then(
            (value) => checkResponse(value),
          );
    }
  }

  Map getRequest() {
    var request = {
      'api': '1',
      'action': 'order_list',
    };
    return request;
  }

  Map getStatusRequest(String status, String oid) {
    var request = {
      'api': '1',
      'action': 'update_order_status',
      'status': status,
      'comment': '',
      'order_id': oid,
    };
    return request;
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
              Image.asset(
                "images/my_order.png",
                width: MediaQuery.of(context).size.width,
                height: 25,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 15,
                ),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => onTabClick(0),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                              child: Text(
                                "New Orders",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: getTabTextLineColor(tabIndex, 0)),
                              ),
                            ),
                            Container(
                                height: getTabLineSize(tabIndex, 0),
                                color: getTabTextLineColor(tabIndex, 0))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                          onTap: () => onTabClick(1),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                                child: Text(
                                  "Completed",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: getTabTextLineColor(tabIndex, 1)),
                                ),
                              ),
                              Container(
                                  height: getTabLineSize(tabIndex, 1),
                                  color: getTabTextLineColor(tabIndex, 1))
                            ],
                          )),
                    ),
                    Expanded(
                      child: GestureDetector(
                          onTap: () => onTabClick(2),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                                child: Text(
                                  "In Progress",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: getTabTextLineColor(tabIndex, 2)),
                                ),
                              ),
                              Container(
                                height: getTabLineSize(tabIndex, 2),
                                color: getTabTextLineColor(tabIndex, 2),
                              )
                            ],
                          )),
                    ),
                    Expanded(
                      child: GestureDetector(
                          onTap: () => onTabClick(3),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 30,
                                child: Text(
                                  "Cancelled",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: getTabTextLineColor(tabIndex, 3)),
                                ),
                              ),
                              Container(
                                height: getTabLineSize(tabIndex, 3),
                                color: getTabTextLineColor(tabIndex, 3),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: Color.fromRGBO(248, 246, 246, 1),
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: _isApiSuccess ? getListItem(tabIndex) : SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTabClick(int index) {
    setState(() {
      position = -1;
      tabIndex = index;
    });
  }

  getListItem(int tabIndex) {
    var _listOrderData = getListData();
    if(_listOrderData.isEmpty){
     return Container(
       child: Align(
         alignment: Alignment.center,
         child: Text('No Order found',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
       ),
     );
    }
    var listview = ListView.builder(
        itemCount: _listOrderData.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return getListItemsWidget(position, index,_listOrderData);
        });
    return listview;
  }

  getListItemsWidget(int pos, int index, List<OrderData> list) {
    var orderData = list[index];
    return GestureDetector(
      onTap: () {
        setState(() {
          if (position == index) {
            position = -1;
          } else {
            position = index;
          }
        });
      },
      child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 3)]),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  orderData.productObj?.images?.isEmpty ?? true
                      ? Image.asset(
                          'images/corn.png',
                          height: 80,
                          fit: BoxFit.contain,
                        )
                      : SizedBox(),
                  // Image.network(
                  //   orderData.productObj?.images?[0] ?? '',
                  //   height: 80,
                  //   fit: BoxFit.contain,
                  // ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ORDERED ID: #${orderData.orderObj?.orderUid ?? ''}',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color.fromRGBO(116, 116, 116, 1)),
                        ),
                        Text(
                          orderData.productObj?.name ?? '',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$ ${orderData.orderObj?.total ?? ''}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${orderData.orderObj?.quantity ?? ''} kg',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                ],
              ),
              tabIndex == 0
                  ? Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext _context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Do you want to accept the order ?',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => {
                                            Navigator.pop(context, 'OK'),
                                            APIServices(context, session)
                                                .callApi(
                                                    Const.order_url,
                                                    getStatusRequest(
                                                        'accept',
                                                        orderData.orderObj
                                                                ?.orderId ??
                                                            ''))
                                                .then(
                                                  (value) =>
                                                      checkResponse2(value),
                                                ),
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              'Accept',
                              style: TextStyle(color: Colors.green),
                            ),
                            style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.infinity, 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                side: BorderSide(color: Colors.green)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext _context) {
                                    return AlertDialog(
                                      title: Text(
                                        'Do you want to cancel the order ?',
                                        style: TextStyle(fontSize: 13),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () => {
                                            Navigator.pop(context, 'OK'),
                                            APIServices(context, session)
                                                .callApi(
                                                    Const.order_url,
                                                    getStatusRequest(
                                                        'cancelled',
                                                        orderData.orderObj
                                                                ?.orderId ??
                                                            ''))
                                                .then(
                                                  (value) =>
                                                      checkResponse2(value),
                                                ),
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.deepOrangeAccent),
                            ),
                            style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.infinity, 30),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                side:
                                    BorderSide(color: Colors.deepOrangeAccent)),
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              getCropDetails(pos, index, orderData)
            ],
          )),
    );
  }

  getCropDetails(int position, int index, OrderData data) {
    if (position == index) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          getHorizontalLine(),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PRODUCT NAME',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      data.productObj?.name ?? '',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'ORDERED ON',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      getDate(data.productObj?.created ?? ''),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'STATUS',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      StringExtension(data.orderObj?.statusString ?? '')
                          .capitalize(),
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'QUANTITY',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${data.orderObj?.quantity ?? ' '} kg',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'PRICE',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '\$${data.orderObj?.total ?? ' '}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'TOTAL PAYMENT',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '\$${data.orderObj?.total ?? ' '}',
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ADDRESS',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${getFullAddress(data)}',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          tabIndex != 3
              ? Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      width: double.infinity,
                      height: 30,
                      color: Colors.black12,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "TRACK ORDER",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: getTrackTabColor(index, 0),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: getTrackTabColor(index, 1),
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: getTrackTabColor(index, 1),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: getTrackTabColor(index, 2),
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: getTrackTabColor(index, 2),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: getTrackTabColor(index, 3),
                            ),
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: getTrackTabColor(index, 3),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          getStatusName(index, 0),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: SizedBox(),
                        ),
                        Text(
                          getStatusName(index, 1),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        ),
                        Text(
                          getStatusName(index, 2),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(),
                        ),
                        Text(
                          getStatusName(index, 3),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : SizedBox(),
        ],
      );
    } else {
      return SizedBox();
    }
  }

  String getStatusName(int index, int id) {
    return _listData[index].orderTracking?[id].name ?? '';
  }

  getTabTextLineColor(int tabIndex, int pos) {
    if (tabIndex == pos) {
      return Colors.green;
    } else {
      return Colors.grey;
    }
  }

  getTrackTabColor(int index, int pos) {
    if ((_listData[index].orderTracking?[pos].status ?? '') == 1) {
      return Colors.green;
    } else {
      return Colors.black26;
    }
  }

  getFullAddress(OrderData orderData) {
    String data = "";
    var address = orderData.buyerObj;
    if ((address?.address ?? "") != "") {
      data += address?.address ?? "";
    }
    if ((address?.city ?? "") != "") {
      if (data != "") {
        data += ",";
      }
      data += address?.city ?? "";
    }

    if ((address?.state ?? "") != "") {
      if (data != "") {
        data += ",";
      }
      data += address?.state ?? "";
    }
    if ((address?.country ?? "") != "") {
      if (data != "") {
        data += ",";
      }
      data += address?.country ?? "";
    }
    if ((address?.zip ?? "") != "") {
      if (data != "") {
        data += " ( ";
      }
      data += address?.zip ?? "";
      data += " )";
    }
    return data;
  }

  String getDate(String datetime) {
    var date1 = datetime.split(' ')[0];
    // var date = DateFormat('dd/mm/yyyy')
    //     .format(DateFormat('yyyy-MM-dd HH:mm:ss').parse(datetime));
    return date1;
  }

  getTabLineSize(int tabIndex, int pos) {
    if (tabIndex == pos) {
      return 3.0;
    } else {
      return 1.0;
    }
  }

  List<OrderData> getListData() {
    switch (tabIndex) {
      case 0:
        {
          return _listData
              .where((element) => (element.orderObj?.status ?? '') == '1')
              .toList();
        }
      case 1:
        {
          return _listData
              .where((element) => (element.orderObj?.status ?? '') == '4')
              .toList();
        }
      case 2:
        {
          return _listData
              .where((element) =>
                  (element.orderObj?.status ?? '') == '2' ||
                  (element.orderObj?.status ?? '') == '3')
              .toList();
        }
      case 3:
        {
          return _listData
              .where((element) => (element.orderObj?.status ?? '') == '0')
              .toList();
        }
      default:
        {
          return _listData;
        }
    }
  }
}
