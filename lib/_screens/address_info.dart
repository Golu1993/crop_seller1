import 'dart:convert';

import 'package:crop_seller/_models/basic_model.dart';
import 'package:crop_seller/_models/combo_model.dart';
import 'package:crop_seller/_models/profile_model.dart';
import 'package:crop_seller/_screens/company_info.dart';
import 'package:crop_seller/_screens/profile.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/utility/utils.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'country_list.dart';

class Address extends StatefulWidget {
  AddressObj? _addressData;
  bool _isEdit=false;

  Address(this._addressData, [this._isEdit=false]);

  @override
  State<StatefulWidget> createState() {
    return Address_State();
  }
}

class Address_State extends State<Address> {
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var zipcodeController = TextEditingController();
  var countryController = TextEditingController();
  String session = '';
  String _countryId = '';
  String _addressId = '';
  bool _isEditData = false;
  List<CommonData> _listCountry = [];

  @override
  void initState() {
    super.initState();
    MySharedPrefences().getSession().then((value) => {
          session = value,
          APIServices(context, session)
              .callApi(Const.combo_url, getRequest())
              .then((value) => checkResponse1(value)),
        });
    _isEditData = widget._addressData != null;
    if (!_isEditData) {
      return;
    }
    addressController.text = widget._addressData?.address ?? '';
    cityController.text = widget._addressData?.city ?? '';
    stateController.text = widget._addressData?.state ?? '';
    zipcodeController.text = widget._addressData?.zip ?? '';
    countryController.text = widget._addressData?.countryName ?? '';
    _countryId = widget._addressData?.country ?? '';
    _addressId = widget._addressData?.addressId ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: 50, left: 20, right: 20),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/theme_back.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => {Navigator.pop(context)},
                child: Container(
                  height: 40,
                  width: 40,
                  padding:
                      EdgeInsets.only(top: 5, left: 5, right: 15, bottom: 15),
                  child: Image.asset(
                    'images/back.png',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 50, right: 50),
                child: Column(
                  children: [
                    Image.asset(
                      'images/register_logo.png',
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      fit: BoxFit.contain,
                    ),
                    const Text(
                      'Complete your profile to get full access.',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                          color: Colors.white60),
                    ),
                  ],
                ),
              ),
              const Text(
                'Steps 2 of 4',
                style: TextStyle(fontSize: 12, color: Colors.yellow),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Address Info',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white),
              ),
              const Text(
                'Address',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.white),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: TextFormField(
                  controller: addressController,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'Address',
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'City',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.white),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: TextFormField(
                  controller: cityController,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'City',
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'State/Province',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.white),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: TextFormField(
                  controller: stateController,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    hintText: 'State/Province',
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'ZipCode',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.white),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: TextFormField(
                  controller: zipcodeController,
                  inputFormatters: [LengthLimitingTextInputFormatter(6)],
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: 'ZipCode',
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Country',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.white),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(left: 15, right: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25)),
                child: TextFormField(
                  controller: countryController,
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  textInputAction: TextInputAction.done,
                  onTap: () => {
                    FocusScope.of(context).requestFocus(FocusNode()),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CountryList(_listCountry))).then((value) => {
                          _countryId = value.id ?? '',
                          countryController.text = value.name ?? '',
                          setState(() {})
                        })
                  },
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.keyboard_arrow_down),
                    hintText: 'Country',
                    contentPadding: EdgeInsets.only(left: 10,top: 15,right: 20,bottom: 5),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: HexColor.fromHex('#7DC852'),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () => {
                        if (validateViews())
                          {
                            APIServices(context, session)
                                .callApi(Const.common_base_url, getRequest())
                                .then(
                                  (value) => checkResponse(value),
                                ),
                          },
                      },
                  child: Text('Save & Continue',
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          color: Colors.black))),
            ],
          ),
        ),
      ),
    );
  }

  Map getRequest() {
    var request = {
      'api': '1',
      'action': 'address_info',
      'address': addressController.text,
      'state': stateController.text,
      'city': cityController.text,
      'zip': zipcodeController.text,
      'country': _countryId,
      'address_id': _addressId,
      'type': '1',
    };
    return request;
  }

  validateViews() {
    if (addressController.text == '') {
      Fluttertoast.showToast(msg: 'Enter address');
      return false;
    } else if (cityController.text == '') {
      Fluttertoast.showToast(msg: 'Enter city');
      return false;
    } else if (stateController.text == '') {
      Fluttertoast.showToast(msg: 'Enter state');
      return false;
    } else if (zipcodeController.text == '') {
      Fluttertoast.showToast(msg: 'Enter zipcode');
      return false;
    } else if (_countryId == '') {
      Fluttertoast.showToast(msg: 'Select country');
      return false;
    } else {
      return true;
    }
  }

  checkResponse(String value) {
    if (value != '') {
      BasicModel data = BasicModel.fromJson(jsonDecode(value));
      if (data.status == 1) {
        Fluttertoast.showToast(msg: data.message!);
        if (_isEditData) {
          Navigator.pop(context, true);
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>Company(null)));
        }
      }else {
        Fluttertoast.showToast(msg: data.message!);
      }
    }
  }

  checkResponse1(String response) {
    ComboModel data = ComboModel.fromJson(jsonDecode(response));
    if (data.status == 1) {
      setState(() {
        _listCountry =
            data.data?.isNotEmpty ?? false ? data.data![0].country ?? [] : [];
      });
    }
  }

  getCountryDialog() {
    Dialog dialog = Dialog(
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 3),
            ]),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(25)),
              child: TextFormField(
                style: TextStyle(color: Colors.black, fontSize: 14),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Search Country',
                  contentPadding: EdgeInsets.all(10.0),
                  border: InputBorder.none,
                ),
                onChanged: (value) => getCountryList(value),
              ),
            ),
            Divider(
              height: 1,
            ),
            Expanded(
                child: SingleChildScrollView(
              child: getCountryList(''),
            ))
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  getCountryList(String value) {
    List<CommonData> list = [];
    if (value != '') {
      list = _listCountry
          .where(
              (element) => (element.name ?? '').contains(value.toLowerCase()))
          .toList();
    } else {
      list = _listCountry;
    }

    var listView = ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('${index + 1}. ${list[index].name ?? ''}'),
          );
        });
    return listView;
  }
}
