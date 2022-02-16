import 'dart:convert';

import 'package:crop_seller/_models/basic_model.dart';
import 'package:crop_seller/_models/product_details_model.dart';
import 'package:crop_seller/_models/product_update_model.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
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
  String _PhotoPeriod = 'Light(in hours)';
  String _growthId = '';
  int daysEntry = 0;
  bool _isViewMode = false;
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
    currentPos = getDate().length - 1;
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _listData.length <= daysEntry
                          ? getFormWidget()
                          : SizedBox(),
                      getFilledTimeDataList(),
                    ],
                  ),
                ),
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
                  selectedDate =
                      DateFormat('yyyy-MM-dd').format(_listDays[index]);
                  hitUpdateDataAPI(1);
                  _isViewMode = false;
                  currentPos = index;
                  _PhotoPeriod = 'Light(in hours)';
                  photoPeriodId = '';
                  setEditableData(-1);
                  setState(() {});
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
    if (index == 0 && _listDays.isNotEmpty) {
      selectedDate =
          DateFormat('yyyy-MM-dd').format(_listDays[_listDays.length - 1]);
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
      primary: false,
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
                  _growthId = _listData[index].growthId ?? '',
                  _isViewMode = false,
                  setEditableData(index),
                  setState(() {}),
                },
                child: Text('Edit'),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(60, 30), primary: Colors.blue),
                onPressed: () => {
                  setEditableData(index),
                  _isViewMode = true,
                  setState(() {}),
                },
                child: Text('View'),
              ),
              SizedBox(
                width: 20,
              ),
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
                  enabled: !_isViewMode,
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
                child: Column(
              children: [
                Container(
                  height: 56,
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: DropdownButton<PhotoPeriod>(
                    menuMaxHeight: 400,
                    isExpanded: true,
                    hint: Text(
                      _PhotoPeriod,
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    elevation: 2,
                    underline: SizedBox(),
                    onChanged: (PhotoPeriod? newValue) {
                      setState(() {
                        photoPeriodId = newValue?.id ?? '';
                        _PhotoPeriod = newValue?.name ?? '';
                      });
                    },
                    items: !_isViewMode?_listPhotoPeriod.map((value) {
                      return DropdownMenuItem<PhotoPeriod>(
                        value: value,
                        child: Text(value.name ?? ''),
                      );
                    }).toList():null,
                  ),
                ),
                Container(
                  color: Colors.grey,
                  height: 1,
                )
              ],
            ))
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                child: TextFormField(
                  enabled: !_isViewMode,
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
                  enabled: !_isViewMode,
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
                  enabled: !_isViewMode,
                  controller: dayTempController,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Day Temperature in C',
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
                  enabled: !_isViewMode,
                  controller: nightTempController,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'Night Temprature in C',
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
                  enabled: !_isViewMode,
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
                  enabled: !_isViewMode,
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
                  enabled: !_isViewMode,
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
                  enabled: !_isViewMode,
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
                  enabled: !_isViewMode,
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
                  enabled: !_isViewMode,
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
                  enabled: !_isViewMode,
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
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color.fromRGBO(187, 187, 187, 1),
                  //primary: Color.fromARGB(1,125, 200, 82),
                  minimumSize: Size(150, 45),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25))),
              onPressed: () => {
                setEditableData(-1),
                _growthId = '',
                _isViewMode = false,
                setState(() {}),
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            _isViewMode
                ? SizedBox()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(125, 200, 82, 1),
                        //primary: Color.fromARGB(1,125, 200, 82),
                        minimumSize: Size(150, 45),
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
                    child: Text(
                      "Save",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                  ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  setEditableData(int index) {
    var dataModel = index == -1 ? ProductUpdateData() : _listData[index];

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
    labourController.text = dataModel.labour ?? '';
    _PhotoPeriod = dataModel.photoPeriod ?? 'Light(in hours)';
    photoPeriodId = dataModel.photoPeriodId ?? '';
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
