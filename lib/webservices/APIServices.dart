import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/utility/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class APIServices {
  BuildContext _context;
  String session;

  APIServices(this._context, this.session) {
    printConsoleData('api session=====', session);
  }

  static Map<String, String> headers = {};

  void updateCookie(http.Response response) {
    String? rawCookie = response.headers['set-cookie'];
    printConsoleData('rawCookie', rawCookie);
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      var session = (index == -1) ? rawCookie : rawCookie.substring(0, index);
      MySharedPrefences().setSession(session);
      headers['cookie'] = session;
      //Fluttertoast.showToast(msg: "session saved");
    }
  }

  Future<String> callApi(String mainUrl, Map request,[newLogin=false]) async {
    try {
      if (headers.isEmpty && session != '') {
        headers['cookie'] = session;
        printConsoleData('rawCookie headers=====', headers.toString());
        printConsoleData('request session=====', session);
      }
      if(newLogin){
        headers['cookie']='';
      }
      var url = '${Const.main_url}$mainUrl';
      printConsoleData(' request URL=====', url);
      printConsoleData(' request params=====', request.toString());

      showLoaderDialog(_context);
      final response = await http
          .post(
            Uri.parse(url),
            body: request,
            headers: headers,
          )
          .timeout(Duration(seconds: 30));
      Navigator.pop(_context);
      updateCookie(response);
      printConsoleData('response data====', response.body);

      if (response.statusCode == 200) {
        return response.body;
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: e.runtimeType.toString());
      printConsoleData('Exception  ', e.toString());
      Navigator.pop(_context);
    }
    return '';
  }
  Future<String> callApi1(String mainUrl, Map request) async {
    try {
      if (headers.isEmpty && session != '') {
        headers['cookie'] = session;
        printConsoleData('rawCookie headers=====', headers.toString());
        printConsoleData('request session=====', session);
      }
      var url = '${Const.main_url}$mainUrl';
      printConsoleData(' request URL=====', url);
      printConsoleData(' request params=====', request.toString());

      showLoaderDialog(_context);
      final response = await http
          .post(
            Uri.parse(url),
            body: json.encoder,
            headers: headers,
          )
          .timeout(Duration(seconds: 30));
      Navigator.pop(_context);
      updateCookie(response);
      printConsoleData('response data====', response.body);

      if (response.statusCode == 200) {
        return response.body;
      }
    } on Exception catch (e) {
      printConsoleData('Exception  ', e.runtimeType.toString());
      Navigator.pop(_context);
    }
    return '';
  }

  Future<int> updateBuyerCompanyData(filepath, mainUrl, Map data) async {
    var url = '${Const.main_url}$mainUrl';
    printConsoleData(' request URL=====', url);
    printConsoleData(' request image filepath=====', filepath);
    printConsoleData(' request data=====', data.toString());

    showLoaderDialog(_context);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['cookie'] = session;
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['api'] = '1';
    request.fields['action'] = data['action'];
    request.fields['company_name'] = data['company_name'];
    request.fields['ein'] = data['ein'];
    request.fields['type'] = data['type'];
    request.fields['tax_exemption'] = data['tax_exemption'];
    request.fields['no_of_year_in_business'] = data['no_of_year_in_business'];

    request.files
        .add(await http.MultipartFile.fromPath('driver_licence', filepath));
    var res = await request.send();
    Navigator.pop(_context);
    printConsoleData(' request statusCode=====', res.statusCode.toString());
    return res.statusCode;
  }

  Future<int> uploadBuyerImage(filepath, mainUrl) async {
    var url = '${Const.main_url}$mainUrl';
    printConsoleData(' request URL=====', url);
    printConsoleData(' request image filepath=====', filepath);
    showLoaderDialog(_context);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['cookie'] = session;
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['api'] = '1';
    request.fields['action'] = 'upload_profile_image';

    request.files.add(await http.MultipartFile.fromPath('image', filepath));
    var res = await request.send();
    Navigator.pop(_context);
    printConsoleData(' request statusCode=====', res.statusCode.toString());
    return res.statusCode;
  }

  Future<int> addProduct(List<File> filepath, mainUrl, Map data) async {
    var url = '${Const.main_url}$mainUrl';
    printConsoleData(' request URL=====', url);
    printConsoleData(' request image filepath=====', filepath.toString());
    printConsoleData(' request data=====', data.toString());
    printConsoleData(' request session=====', session);
    showLoaderDialog(_context);
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['cookie'] = session;
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['api'] = '1';
    request.fields['action'] =data['action'];
    request.fields['name'] = data['name'];
    request.fields['description'] = data['description'];
    request.fields['category_id'] = data['category_id'];
    request.fields['growing_medium_id'] = data['growing_medium_id'];
    request.fields['photo_period_id'] = data['photo_period_id'];
    request.fields['environment_id'] = data['environment_id'];
    request.fields['weight'] = data['weight'];
    request.fields['water'] = data['water'];
    request.fields['price'] = data['price'];
    request.fields['video_url'] = data['video_url'];
    request.fields['product_id'] = data['product_id'];
    for (int i = 0; i < filepath.length; i++) {
      request.files.add(await http.MultipartFile.fromPath('files[$i]', filepath[i].path));
    }

    var res = await request.send();
    Navigator.pop(_context);
    printConsoleData(' request statusCode=====', res.statusCode.toString());
    return res.statusCode;
  }
}
