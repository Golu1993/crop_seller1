import 'dart:convert';

import 'package:crop_seller/_models/basic_model.dart';
import 'package:crop_seller/_models/product_details_model.dart';
import 'package:crop_seller/_models/product_update_model.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/utility/utils.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class UpdateProduct extends StatefulWidget {
  ProductData _productData;

  UpdateProduct(this._productData);

  @override
  State<StatefulWidget> createState() {
    return UpdateProductState();
  }
}

class UpdateProductState extends State<UpdateProduct> {
  int currentPos = 0;
  String session = "";
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  bool _isApiSuccess = true;
  var electricController = TextEditingController();
  var lightController = TextEditingController();
  var highRHController = TextEditingController();
  var lowRHController = TextEditingController();
  var dayTempController = TextEditingController();
  var nightTempController = TextEditingController();
  var waterController = TextEditingController();
  var waterGalController = TextEditingController();
  var waterPhController = TextEditingController();
  var waterTempController = TextEditingController();
  var gmController = TextEditingController();
  var vegController = TextEditingController();
  var flowersController = TextEditingController();
  var labourController = TextEditingController();
  List<ProductUpdateData> _listData = [];
  String productId = '';
  String photoPeriodId = '';
  String _growthId = '';
  bool _canShowForm = false;
  int daysEntry = 0;
  List<PhotoPeriod> _listPhotoPeriod = [];

  @override
  void initState() {
    super.initState();
    productId = widget._productData.productId ?? '';
    photoPeriodId = widget._productData.photoPeriodId ?? '';
    daysEntry = widget._productData.entry_per_day ?? 4;
    _listPhotoPeriod.addAll(widget._productData.photo_period_combo ?? []);
    MySharedPrefences().getSession().then((value) => {
          session = value,
          hitUpdateDataAPI(0),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: Column(
            children: [
              Container(
                color: Colors.black,
                padding:
                    EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
                      "images/update_product_title.png",
                      width: MediaQuery.of(context).size.width,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 0.5, color: Colors.grey)),
                height: 45,
                child: getDaysList(),
              ),
              Expanded(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: _listData.isEmpty || _canShowForm
                        ? getFormWidget()
                        : Column(
                            children: [
                              getFilledTimeDataList(),
                              _listData.length < daysEntry
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: Size(100, 40),
                                        primary: HexColor.fromHex('#7DC852'),
                                      ),
                                      onPressed: () => {
                                        _canShowForm = true,
                                        setState(() {}),
                                      },
                                      child: Text('Add More'),
                                    )
                                  : SizedBox(),
                            ],
                          )),
              ),
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
      Navigator.pop(context);

    }
  }

  checkResponse1(String response) {
    ProductUpdatemodel data = ProductUpdatemodel.fromJson(jsonDecode(response));
    if (data.status == 1) {
      _listData = data.data ?? [];
      setState(() {});
    } else {
      Fluttertoast.showToast(msg: data.message!);
    }
  }

  Map getRequest() {
    var request = {
      'api': '1',
      'action': 'plant_growth',
      'electricity': electricController.text,
      'highest_rh': highRHController.text,
      'lowest_rh': lowRHController.text,
      'day_temprature': dayTempController.text,
      'night_temprature': nightTempController.text,
      'water': waterController.text,
      'water_ph': waterPhController.text,
      'water_temprature': waterTempController.text,
      'germination': gmController.text,
      'vegetative': vegController.text,
      'flowering': flowersController.text,
      'growth_date': selectedDate,
      'product_id': productId,
      'photo_period_id': photoPeriodId,
      'labour': labourController.text,
      'growth_id': _growthId,
    };

    return request;
  }

  Map getRequest1() {
    var request = {
      'api': '1',
      'action': 'gorwth_list',
      'type': 'list',
      'growth_date': selectedDate,
      'product_id': productId,
    };

    return request;
  }

  validateViews() {
    if (electricController.text == '' &&
        lightController.text == '' &&
        highRHController.text == '' &&
        lightController.text == '' &&
        dayTempController.text == '' &&
        nightTempController.text == '' &&
        waterController.text == '' &&
        waterGalController.text == '' &&
        waterPhController.text == '' &&
        waterTempController.text == '' &&
        gmController.text == '' &&
        vegController.text == '' &&
        flowersController.text == '' &&
        labourController.text == '') {
      Fluttertoast.showToast(msg: 'Enter some values');
      return false;
    } else {
      return true;
    }
  }

  getDaysList() {
    List<DateTime> _listDays = getDate();
    currentPos=_listDays.length-1;
    var list = ListView.builder(
      controller: _controller,
        itemCount: _listDays.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Row(
            children: [
              GestureDetector(
                onTap: () {
                  _canShowForm = false;
                  selectedDate =
                      DateFormat('yyyy-MM-dd').format(_listDays[index]);
                  hitUpdateDataAPI(1);
                  setState(() {
                    currentPos = index;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: currentPos == index ? Colors.green : Colors.white,
                  ),
                  width: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        getDay(_listDays[index]),
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        getMonth(_listDays[index]),
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              VerticalDivider(
                width: 0.5,
                color: Colors.grey,
              )
            ],
          );
        });
    return list;
  }

  List<DateTime> getDate() {
    List<DateTime> listDays = [];
    DateTime endDate = DateTime.now();
    DateTime startDate =
        endDate.subtract(Duration(days: widget._productData.info_days ?? 0));
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      var date = startDate.add(Duration(days: i));
      listDays.add(date);
    }
    return listDays;
  }

  String getDay(DateTime dates) {
    var date = DateFormat('dd').format(dates);
    return date;
  }

  String getMonth(DateTime dates) {
    var date = DateFormat.MMM().format(dates);
    return date;
  }

  hitUpdateDataAPI(int index) {
    List<DateTime> _listDays = getDate();
    if (index == 0&&_listDays.isNotEmpty) {
      selectedDate = DateFormat('yyyy-MM-dd').format(_listDays[_listDays.length-1]);
    }
    APIServices(context, session)
        .callApi(Const.product_url, getRequest1())
        .then(
          (value) => checkResponse1(value),
        );
  }

  getFilledTimeDataList() {
    var listView = ListView.builder(
      itemCount: _listData.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 10),
          height: 45,
          child: Row(
            children: [
              Text('${index + 1}. Time : ${_listData[index].created}'),
              Expanded(child: SizedBox()),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(60, 30), primary: Colors.orange),
                onPressed: () => {
                  _canShowForm = true,
                  _growthId=_listData[index].growthId??'',
                  setEditableData(index),
                  setState(() {}),
                },
                child: Text('Edit'),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        );
      },
    );
    return listView;
  }

  getFormWidget() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 2,
                  color: Colors.grey,
                  thickness: 1,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        child: TextFormField(
                          controller: electricController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Watts',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 57,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        child: TextFormField(
                          controller: lightController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Light (in hours)',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        child: TextFormField(
                          controller: highRHController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Highest RH %',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        child: TextFormField(
                          controller: lowRHController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: "Lowest RH %",
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        child: TextFormField(
                          controller: dayTempController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Day Temperature',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 57,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        child: TextFormField(
                          controller: nightTempController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Night Temprature',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        child: TextFormField(
                          controller: waterPhController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Water PH',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 57,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        child: TextFormField(
                          controller: waterGalController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Water (gal)',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        child: TextFormField(
                          controller: gmController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Gm',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 57,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        child: TextFormField(
                          controller: waterTempController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Water Temp',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        child: TextFormField(
                          controller: flowersController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Flowers',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 57,
                      width: 1,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        child: TextFormField(
                          controller: vegController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Veg',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        child: TextFormField(
                          controller: labourController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'Labour',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            // border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: HexColor.fromHex('#7DC852'),
                        //primary: Color.fromARGB(1,125, 200, 82),
                        minimumSize: const Size(200, 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25))),
                    onPressed: () => {
                          if (validateViews())
                            {
                              APIServices(context, session)
                                  .callApi(Const.product_url, getRequest())
                                  .then(
                                    (value) => checkResponse(value),
                                  ),
                            }
                        },
                    child: Text("SAVE",
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.black))),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  setEditableData(int index) {
    var dataModel = _listData[index];
    electricController.text = dataModel.electricity ?? '';
    lightController.text = dataModel.photoPeriod ?? '';
    highRHController.text = dataModel.highestRh ?? '';
    lowRHController.text = dataModel.lowestRh ?? '';
    dayTempController.text = dataModel.dayTemprature ?? '';
    nightTempController.text = dataModel.nightTemprature ?? '';
    waterController.text = dataModel.water ?? '';
    waterGalController.text = dataModel.water ?? '';
    waterPhController.text = dataModel.waterPh ?? '';
    waterTempController.text = dataModel.waterTemprature ?? '';
    vegController.text = dataModel.vegetative ?? '';
    gmController.text = dataModel.germination ?? '';
    flowersController.text = dataModel.flowering ?? '';
    labourController.text = dataModel.labour??'';
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
}
