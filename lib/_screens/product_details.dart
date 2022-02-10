import 'dart:convert';

import 'package:crop_seller/_models/basic_model.dart';
import 'package:crop_seller/_models/product_details_model.dart';
import 'package:crop_seller/_screens/update_product.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetails extends StatefulWidget {
  String productId = '';

  @override
  State<StatefulWidget> createState() {
    return ProductDetailsState();
  }

  ProductDetails(this.productId);
}

class ProductDetailsState extends State<ProductDetails> {
  String session = '';
  String type = '';
  bool _isApiSuccess = false;
  bool _isShowOPCost = false;
  late ProductData _productData;
  var titleController = TextEditingController();
  var usageController = TextEditingController();
  var unitCostController = TextEditingController();

  var defaultStyle = TextStyle(color: Colors.black);
  var linkStyle = TextStyle(color: Colors.orange);

  @override
  void initState() {
    super.initState();
    MySharedPrefences().getSession().then((value) => {
          session = value,
         callProductDetailsAPI(),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color.fromRGBO(248, 246, 246, 1),
          child: Column(
            children: [
              Container(
                color: Colors.black,
                padding:
                    EdgeInsets.only(left: 15, top: 15, right: 15, bottom: 10),
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
                          'images/back.png',
                        ),
                      ),
                    ),
                    Image.asset(
                      'images/product_details_title.png',
                      width: MediaQuery.of(context).size.width,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _isApiSuccess
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10,top: 20,right: 10,bottom: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15)),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 5.0,
                                    spreadRadius: 1.0,
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ImageSlideshow(

                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height * 0.3,
                                    initialPage: 0,
                                    indicatorColor: Colors.white,
                                    indicatorBackgroundColor: Colors.grey,
                                    children: [
                                      for (int i = 0;
                                      i < (_productData.photo?.length ?? 0);
                                      i++)
                                        (Image.network(
                                          _productData.photo?[i].path ?? "",
                                          fit: BoxFit.fill,
                                        )),
                                    ],
                                    onPageChanged: (value) {
                                    },
                                    autoPlayInterval: 5000,
                                    isLoop: true,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 15, top: 15, bottom: 15),
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              _productData.name ?? '',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              _productData.category ?? '',
                                              style: TextStyle(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              _productData.created ?? '',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(child: SizedBox()),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 10, right: 10),
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color:
                                                  Color.fromRGBO(38, 93, 38, 1),
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  bottomLeft:
                                                      Radius.circular(25)),
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        UpdateProduct(_productData),
                                                  ),
                                                ).then((value) => callProductDetailsAPI());
                                              },
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'images/play_circle.png',
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                  Text(
                                                    '  UPDATE NOW',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    height: 1,
                                  ),
                                  getAverageGrowthWidget(),
                                  getDetailsWidget(),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  getOperationalCostWidget(),
                                  SizedBox(
                                    height: 20,
                                  )
                                ],
                              ),
                            ),
                            getBottomButtonWidget()
                          ],
                        ),
                      )
                    : SizedBox(),
              )
            ],
          ),
        ),
      ),
    );
  }

  checkResponse(String response) {
    ProductDetailsModel data =
        ProductDetailsModel.fromJson(jsonDecode(response));
    if (data.status == 1) {
      setState(() {
        _productData = data.data?[0] ?? ProductData();
        _isApiSuccess = true;
      });
    }
  }

  checkResponse2(String response) {
    BasicModel data = BasicModel.fromJson(jsonDecode(response));
    Fluttertoast.showToast(msg: data.message!);
    if (data.status == 1) {
      Navigator.pop(context);
      callProductDetailsAPI();
    }
  }

  Map getRequest() {
    var request = {
      'api': '1',
      'action': 'product_detail',
       'product_id': widget.productId,
    };
    return request;
  }

  Map getRequestOPCost(String costId) {
    var request = {
      'api': '1',
      'action': 'crop_operational_cost',
      'title': titleController.text,
      'crop_usage': usageController.text,
      'unit_cost': unitCostController.text,
      'product_id': widget.productId,
      'type': type,
      'cost_id': costId,
      //'product_id': '1',
    };
    return request;
  }

  getDetailsWidget() {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Growing Temp',
            style: TextStyle(
                fontSize: 15, color: Colors.green, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.orange,
            height: 100,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Product Descriptions',
            style: TextStyle(
                fontSize: 15, color: Colors.green, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                'Growing Medium',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 11,
                ),
              ),
              Expanded(child: SizedBox()),
              Text(
                _productData.growingMedium ?? '',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Text(
                'Environment',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Expanded(child: SizedBox()),
              Text(
                _productData.environment ?? '',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Text(
                'Photo Period',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Expanded(child: SizedBox()),
              Text(
                _productData.photo_period ?? '',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Divider(),
          Row(
            children: [
              Text(
                'Weight and Price',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Expanded(child: SizedBox()),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: '${_productData.weight ?? ' '} KG :',
                        style: defaultStyle),
                    TextSpan(
                        text: '\$ ${_productData.price ?? ' '}',
                        style: linkStyle),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'About ${_productData.name ?? ''}',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            _productData.description ?? '',
            textAlign: TextAlign.justify,
            style: TextStyle(color: Colors.grey, fontSize: 11),
          ),
        ],
      ),
    );
  }

  getAverageGrowthWidget() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Environment',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Avg Day Temp (F)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              _productData.growthEverage?.avgDayTemprature ??
                                  '',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Avg Night Temp (F)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              _productData.growthEverage?.avgNightTemprature ??
                                  '',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Avg High RH%',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              _productData.growthEverage?.avgHighestRh ?? '',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Avg Low RH%',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              _productData.growthEverage?.avgLowestRh ?? '',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  width: 1,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Light Cycle',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Avg Light Height (in)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              '${_productData.growthEverage?.avgLightHeight ?? ''}',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Avg Watts (W)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              _productData.growthEverage?.avgWatt ?? '',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Total Day Cycle (HR)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              '${_productData.growthEverage?.totalDayCycle ?? ''}',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Grams Per Watt',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              '${_productData.growthEverage?.gramsPerWatt ?? ''}',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Water/Soil Data',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Avg Water PH',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              _productData.growthEverage?.avgWaterPh ?? '',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Total Water Used',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              _productData.growthEverage?.totalWaterUsed ?? '',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Avg Water Per Plant',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              '${_productData.growthEverage?.avgWaterPerPlant ?? ''}',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Water Temp',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              _productData.growthEverage?.avgWaterTemprature ??
                                  '',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Cost Per Plant',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              '${_productData.growthEverage?.costPerPlant ?? ''}',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Growing Cycle',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'Days In Germination',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              _productData.growthEverage?.germinationDays ?? '',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Days In Vegetation',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              _productData.growthEverage?.vegetationDays ?? '',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            Text(
                              'Days in Flower',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 11,
                              ),
                            ),
                            Expanded(child: SizedBox()),
                            Text(
                              _productData.growthEverage?.floweringDays ?? '',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color.fromRGBO(246, 246, 246, 1),
      ),
    );
  }

  getOperationalCostWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      color: Color.fromRGBO(246, 246, 246, 1),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Operation Cost',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                ),
              ),
              Expanded(child: SizedBox()),
              GestureDetector(
                child: Container(
                  // padding: EdgeInsets.all(5),
                  child: Icon(
                    _isShowOPCost ? Icons.remove : Icons.add,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.green),
                ),
                onTap: () {
                  setState(() {
                    _isShowOPCost = !_isShowOPCost;
                  });
                },
              )
            ],
          ),
          _isShowOPCost
              ? Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '  UTILITIES',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            color: Color.fromRGBO(235, 235, 235, 1),
                            height: 25,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(flex: 2, child: SizedBox()),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Usage',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Unit Cost',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                )
                              ],
                            ),
                          ),
                          getUtilitiesData(),
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add more utilities',
                                  style: TextStyle(
                                    color: Color.fromRGBO(11, 50, 243, 1),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  child: Container(
                                    // padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(11, 50, 243, 1),
                                    ),
                                  ),
                                  onTap: () {
                                    type = 'utilities';
                                    editOperationalCostDialog(null, '1');
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '  SEEDS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            color: Color.fromRGBO(235, 235, 235, 1),
                            height: 25,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Genetics',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Qunatity',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Unit Cost',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                )
                              ],
                            ),
                          ),
                          getSeedsData(),
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add more seeds',
                                  style: TextStyle(
                                    color: Color.fromRGBO(11, 50, 243, 1),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  child: Container(
                                    // padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(11, 50, 243, 1),
                                    ),
                                  ),
                                  onTap: () {
                                    type = 'seeds';
                                    editOperationalCostDialog(null, '2');
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '  SOIL/SOIL ADDITIVES',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            color: Color.fromRGBO(235, 235, 235, 1),
                            height: 25,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Brands',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Usage',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Unit Cost',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                )
                              ],
                            ),
                          ),
                          getSoilsData(),
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add more Soil/Soil Additives',
                                  style: TextStyle(
                                    color: Color.fromRGBO(11, 50, 243, 1),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  child: Container(
                                    // padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(11, 50, 243, 1),
                                    ),
                                  ),
                                  onTap: () {
                                    type = 'soil_additives';
                                    editOperationalCostDialog(null, '3');
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '  NUTRIENTS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            color: Color.fromRGBO(235, 235, 235, 1),
                            height: 25,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Brands',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Usage',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Unit Cost',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                )
                              ],
                            ),
                          ),
                          getNutrientsData(),
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add more Nutrients',
                                  style: TextStyle(
                                    color: Color.fromRGBO(11, 50, 243, 1),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  child: Container(
                                    // padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(11, 50, 243, 1),
                                    ),
                                  ),
                                  onTap: () {
                                    type = 'nutrients';
                                    editOperationalCostDialog(null, '4');
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '  MISC. COST',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            color: Color.fromRGBO(235, 235, 235, 1),
                            height: 25,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Description',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Usage',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Unit Cost',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                )
                              ],
                            ),
                          ),
                          getMiscCostData(),
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add more MISC. COST',
                                  style: TextStyle(
                                    color: Color.fromRGBO(11, 50, 243, 1),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  child: Container(
                                    // padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(11, 50, 243, 1),
                                    ),
                                  ),
                                  onTap: () {
                                    type = 'misc_cost';
                                    editOperationalCostDialog(null, '5');
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 2, bottom: 2),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '  LABOR HOURS',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            color: Color.fromRGBO(235, 235, 235, 1),
                            height: 25,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'Name',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Wage',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    'Hours',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                )
                              ],
                            ),
                          ),
                          getLaborHoursData(),
                          SizedBox(
                            height: 35,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Add more utilities',
                                  style: TextStyle(
                                    color: Color.fromRGBO(11, 50, 243, 1),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                GestureDetector(
                                  child: Container(
                                    // padding: EdgeInsets.all(5),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(11, 50, 243, 1),
                                    ),
                                  ),
                                  onTap: () {
                                    type = 'labor_hours';
                                    editOperationalCostDialog(null, '6');
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }

  getBottomButtonWidget() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            color: Color.fromRGBO(38, 93, 38, 0.60),
            child: Column(
              children: [
                Text(
                  'Day',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '${_productData.day ?? ' '}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            color: Color.fromRGBO(38, 93, 38, 0.80),
            child: Column(
              children: [
                Text(
                  'Utility Cost',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '\$ ${_productData.day ?? ' '}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(10),
            color: Color.fromRGBO(38, 93, 38, 1),
            child: Column(
              children: [
                Text(
                  'Total Cost',
                  style: TextStyle(color: Colors.white),
                ),
                Text(
                  '\$ ${_productData.day ?? ' '}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  getUtilitiesData() {
    var data = _productData.operationalCost?.utilities ?? [];
    var list = ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        data[index].title ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data[index].cropUsage ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data[index].unitCost ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        type = 'utilities';
                        editOperationalCostDialog(data[index]);
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Color.fromRGBO(235, 235, 235, 1),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(
                height: 0.1,
              )
            ],
          ),
        );
      },
    );
    return list;
  }

  getSeedsData() {
    var data = _productData.operationalCost?.seeds ?? [];
    var list = ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        data[index].title ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data[index].cropUsage ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data[index].unitCost ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        type = 'seeds';
                        editOperationalCostDialog(data[index]);
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Color.fromRGBO(235, 235, 235, 1),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0.1,
              )
            ],
          ),
        );
      },
    );
    return list;
  }

  getSoilsData() {
    var data = _productData.operationalCost?.soilAdditives ?? [];
    var list = ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        data[index].title ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data[index].cropUsage ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data[index].unitCost ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        type = 'soil_additives';
                        editOperationalCostDialog(data[index]);
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Color.fromRGBO(235, 235, 235, 1),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0.1,
              )
            ],
          ),
        );
      },
    );
    return list;
  }

  getNutrientsData() {
    var data = _productData.operationalCost?.nutrients ?? [];
    var list = ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        data[index].title ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data[index].cropUsage ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data[index].unitCost ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        type = 'nutrients';
                        editOperationalCostDialog(data[index]);
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Color.fromRGBO(235, 235, 235, 1),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0.1,
              )
            ],
          ),
        );
      },
    );
    return list;
  }

  getMiscCostData() {
    var data = _productData.operationalCost?.miscCost ?? [];
    var list = ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        data[index].title ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data[index].cropUsage ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data[index].unitCost ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        type = 'misc_cost';
                        editOperationalCostDialog(data[index]);
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Color.fromRGBO(235, 235, 235, 1),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0.1,
              )
            ],
          ),
        );
      },
    );
    return list;
  }

  getLaborHoursData() {
    var data = _productData.operationalCost?.laborHours ?? [];
    var list = ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        data[index].title ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data[index].cropUsage ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        data[index].unitCost ?? '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        type = 'labor_hours';
                        editOperationalCostDialog(data[index]);
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        color: Color.fromRGBO(235, 235, 235, 1),
                        child: Icon(
                          Icons.edit_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 0.1,
              )
            ],
          ),
        );
      },
    );
    return list;
  }

  editOperationalCostDialog(OperationalData? data, [String type = '']) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ('   ${data?.typeName ?? getTitle(type)}').toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 50,
                    child: TextFormField(
                      controller: titleController..text = data?.title ?? '',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: getTitleHint(data?.type ?? type),
                          contentPadding: EdgeInsets.only(top: 5)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 50,
                    child: TextFormField(
                      controller: usageController..text = data?.cropUsage ?? '',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          labelText: getUsageHint(data?.type ?? type),
                          contentPadding: EdgeInsets.only(top: 5)),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    height: 50,
                    child: TextFormField(
                      controller: unitCostController
                        ..text = data?.unitCost ?? '',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          labelText: getUnitCostHint(data?.type ?? type),
                          contentPadding: EdgeInsets.only(top: 5)),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(180, 180, 180, 1),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10))),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'CANCEL',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            )),
                      )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          APIServices(context, session)
                              .callApi(Const.product_url,
                                  getRequestOPCost(data?.costId ?? ''))
                              .then((value) => checkResponse2(value));
                        },
                        child: Container(
                            height: 45,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(125, 200, 82, 1),
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10))),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'SAVE',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14),
                              ),
                            )),
                      )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  getTitle(String type) {
    switch (type) {
      case '1':
        {
          return 'UTILITIES';
        }
      case '2':
        {
          return 'SEEDS';
        }
      case '3':
        {
          return 'SOIL/SOIL ADDITIVES';
        }
      case '4':
        {
          return 'NUTRIENTS';
        }
      case '5':
        {
          return 'MISC. COST';
        }
      case '6':
        {
          return 'LABOR HOURS';
        }
      default:
        return 'Brands';
    }
  }

  getTitleHint(String s) {
    switch (s) {
      case '1':
        {
          return 'Title';
        }
      case '2':
        {
          return 'Genetics';
        }
      case '5':
        {
          return 'Description';
        }
      case '6':
        {
          return 'Name';
        }
      default:
        return 'Brands';
    }
  }

  getUsageHint(String s) {
    switch (s) {
      case '2':
        return 'Quantity';

      case '6':
        return 'Wage';

      default:
        return 'Usage';
    }
  }

  getUnitCostHint(String s) {
    switch (s) {
      case '6':
        return 'Hours';
      default:
        return 'Unit Cost';
    }
  }

  callProductDetailsAPI() {
    APIServices(context, session)
        .callApi(Const.product_url, getRequest())
        .then((value) => checkResponse(value));
  }
}
