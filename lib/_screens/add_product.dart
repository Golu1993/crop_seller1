import 'dart:convert';
import 'dart:io';

import 'package:crop_seller/_models/basic_model.dart';
import 'package:crop_seller/_models/combo_model.dart';
import 'package:crop_seller/_models/product_list_model.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/utility/utils.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  ProductDetailsData? _productDetailsData;

  AddProduct(this._productDetailsData);

  @override
  State<StatefulWidget> createState() {
    return AddProductState();
  }
}

class AddProductState extends State<AddProduct> {
  List<File> _listImage = [];
  List<Photo> _listImageOld = [];
  String session = '';
  int _deleteIndex = 0;
  String _productId = '';
  String _categoryId = '';
  String _growingId = '';
  String _envirnomentId = '';
  String _photoPeriodId = '';
  String _cropType = 'Crop Type';
  String _Environment = 'Environment';
  String _growingMedium = 'Growing Medium';
  String _PhotoPeriod = 'Photo Period';
  List<CommonData> listGrowing = [];
  List<CommonData> listEnv = [];
  List<CommonData> listPhoto = [];
  List<Category> listCrop = [];
  var _videoUrlController = TextEditingController();
  var _nameController = TextEditingController();
  var _waterController = TextEditingController();
  var _weightController = TextEditingController();
  var _priceController = TextEditingController();
  var _descController = TextEditingController();

  setEditableData() {
    var data = widget._productDetailsData;
    if (data != null) {
      _productId = data.productId ?? '';
      _videoUrlController.text = data.videoUrl ?? '';
      _nameController.text = data.name ?? '';
      _waterController.text = data.water ?? '';
      _weightController.text = data.weight ?? '';
      _priceController.text = data.price ?? '';
      _descController.text = data.description ?? '';
      _categoryId = data.categoryId ?? '';
      _growingId = data.growingMediumId ?? '';
      _envirnomentId = data.environmentId ?? '';
      _photoPeriodId = data.photoPeriodId ?? '';
      _cropType = data.category ?? '';
      _growingMedium = data.growingMedium ?? '';
      _Environment = data.environment ?? '';
      _PhotoPeriod = data.photoPeriod ?? '';
      _listImageOld.addAll(data.photo ?? []);
    }
  }

  @override
  void initState() {
    super.initState();
    setEditableData();
    MySharedPrefences().getSession().then((value) => {
          session = value,
          APIServices(context, session)
              .callApi(Const.combo_url, getRequest())
              .then((value) => checkResponse(value)),
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'images/add_product_title.png',
                      width: MediaQuery.of(context).size.width,
                      height: 25,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Color.fromRGBO(228, 228, 228, 1),
                        padding: EdgeInsets.only(top: 10, bottom: 10),
                        child: Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                              child: _listImage.isNotEmpty ||
                                      _listImageOld.isNotEmpty
                                  ? Container(
                                      child: ListView(
                                        scrollDirection: Axis.horizontal,
                                        children: [
                                          showOldImages(),
                                          showPickedImages()
                                        ],
                                      ),
                                    )

                                  /*Expanded(
                                      child: SingleChildScrollView(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            showOldImages(),
                                            showPickedImages()
                                          ],
                                        ),
                                      ),
                                    )*/
                                  : Image.asset(
                                      'images/upload.png',
                                      width: 50,
                                      height: 50,
                                    ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                // primary: HexColor.fromHex('#7DC852'),
                                //primary: Color.fromARGB(1,125, 200, 82),
                                minimumSize: const Size(150, 35),
                              ),
                              onPressed: () {
                                showOptionDialog();
                              },
                              child: Text(
                                'Upload Images',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 50,
                        child: TextFormField(
                          controller: _videoUrlController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Upload Video Url',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      SizedBox(
                        // margin: EdgeInsets.only(top: 5),
                        height: 50,
                        child: TextFormField(
                          controller: _nameController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'Product Name',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        height: 50,
                        child: DropdownButton<Category>(
                          isExpanded: true,
                          menuMaxHeight: 200,
                          hint: Text(
                            _cropType,
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          elevation: 2,
                          underline: SizedBox(),
                          onChanged: (Category? newValue) {
                            setState(() {
                              _categoryId = newValue?.categoryId ?? '';
                              _cropType = newValue?.name ?? '';
                            });
                          },
                          items: listCrop.map((value) {
                            return DropdownMenuItem<Category>(
                                value: value,
                                child: SizedBox(
                                  width: 100,
                                  child: Text(value.name ?? ''),
                                ));
                          }).toList(),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: DropdownButton<CommonData>(
                          isExpanded: true,
                          hint: Text(
                            _growingMedium,
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          elevation: 2,
                          underline: SizedBox(),
                          onChanged: (CommonData? newValue) {
                            setState(() {
                              _growingId = newValue?.id ?? '';
                              _growingMedium = newValue?.name ?? '';
                            });
                          },
                          items: listGrowing.map((value) {
                            return DropdownMenuItem<CommonData>(
                              value: value,
                              child: Text(value.name ?? ''),
                            );
                          }).toList(),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        height: 50,
                        child: DropdownButton<CommonData>(
                          isExpanded: true,
                          hint: Text(
                            _Environment,
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          elevation: 2,
                          underline: SizedBox(),
                          onChanged: (CommonData? newValue) {
                            setState(() {
                              _envirnomentId = newValue?.id ?? '';
                              _Environment = newValue?.name ?? '';
                            });
                          },
                          items: listEnv.map((value) {
                            return DropdownMenuItem<CommonData>(
                              value: value,
                              child: Text(value.name ?? ''),
                            );
                          }).toList(),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: DropdownButton<CommonData>(
                          isExpanded: true,
                          hint: Text(
                            _PhotoPeriod,
                            style: TextStyle(color: Colors.black, fontSize: 14),
                          ),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          elevation: 2,
                          underline: SizedBox(),
                          onChanged: (CommonData? newValue) {
                            setState(() {
                              _photoPeriodId = newValue?.id ?? '';
                              _PhotoPeriod = newValue?.name ?? '';
                            });
                          },
                          items: listPhoto.map((value) {
                            return DropdownMenuItem<CommonData>(
                              value: value,
                              child: Text(value.name ?? ''),
                            );
                          }).toList(),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        height: 50,
                        child: TextFormField(
                          controller: _waterController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Water level in Litre',
                            labelStyle: TextStyle(color: Colors.black54),
                            hintText: 'Water level',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        height: 50,
                        child: TextFormField(
                          controller: _weightController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Weight(kg)',
                            labelStyle: TextStyle(color: Colors.black54),
                            hintText: 'Weight',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        height: 50,
                        child: TextFormField(
                          controller: _priceController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Price(\$)',
                            labelStyle: TextStyle(color: Colors.black54),
                            hintText: 'Price',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5),
                        child: TextFormField(
                          controller: _descController,
                          style: TextStyle(color: Colors.black, fontSize: 14),
                          keyboardType: TextInputType.multiline,
                          maxLines: 3,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'Product Description',
                            labelStyle: TextStyle(color: Colors.black54),
                            hintText: 'Product Description',
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                              right: 10,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Divider(
                        height: 1,
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
                                        .addProduct(_listImage,
                                            Const.product_url, getRequest())
                                        .then(
                                          (value) => checkResponse1(value),
                                        ),
                                  }
                              },
                          child: Text('SAVE',
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
          ),
        ),
      ),
    );
  }

  checkResponse(String response) {
    ComboModel data = ComboModel.fromJson(jsonDecode(response));
    if (data.status == 1) {
      setState(() {
        listCrop = data.data?[0].category ?? [];
        listGrowing = data.data?[0].growingMedium ?? [];
        listEnv = data.data?[0].environment ?? [];
        listPhoto = data.data?[0].photoPeriod ?? [];
      });
    }
  }
  checkDeleteResponse(String response) {
    BasicModel data = BasicModel.fromJson(jsonDecode(response));
    if (data.status == 1) {
      setState(() {
        Fluttertoast.showToast(msg: data.message??'');
        _listImageOld.removeAt(_deleteIndex);
      });
    }
  }

  checkResponse1(int? value) {
    if ((value ?? 0) == 200) {
      Fluttertoast.showToast(msg: 'Updated successfully');
      Navigator.pop(context, true);
    } else {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
  }

  Map getRequest() {
    var request = {
      'api': '1',
      'action': 'save',
      'name': _nameController.text,
      'description': _descController.text,
      'category_id': _categoryId,
      'growing_medium_id': _growingId,
      'photo_period_id': _photoPeriodId,
      'environment_id': _envirnomentId,
      'weight': _weightController.text,
      'water': _waterController.text,
      'price': _priceController.text,
      'video_url': _videoUrlController.text,
      'product_id': _productId,
    };

    return request;
  }
  Map getDeleteRequest(String mid) {
    var request = {
      'api': '1',
      'action': 'update_media_status',
      'media_id': mid,
    };

    return request;
  }

  showOptionDialog() {
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
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                _getImageFromGallery(1);
                Navigator.pop(context);
              },
              child: Text(
                'Open Camera',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              height: 30,
            ),
            GestureDetector(
              onTap: () {
                _getImageFromGallery(2);
                Navigator.pop(context);
              },
              child: Text(
                'Open Gallery',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext _context) => dialog);
  }

  _getImageFromGallery(int type) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: type == 2 ? ImageSource.gallery : ImageSource.camera,
    );
    printConsoleData('picked file path', pickedFile?.path ?? '');
    if (pickedFile != null) {
      setState(() {
        File imageFile = File(pickedFile.path);
        _listImage.add(imageFile);
      });
    }
  }

  showPickedImages() {
    var listview = ListView.builder(
        itemCount: _listImage.length,
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
              width: 70,
              margin: EdgeInsets.only(left: 10),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    bottom: 0,
                    top: 10,
                    right: 10,
                    child: Image.file(
                      _listImage[index],
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: IconButton(
                      onPressed: () {
                        _listImage.removeAt(index);
                        Fluttertoast.showToast(msg: 'File Deleted Successfully');
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.remove_circle_sharp,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ));
        });
    return listview;
  }

  showOldImages() {
    var listview = ListView.builder(
        itemCount: _listImageOld.length,
        shrinkWrap: true,
        primary: false,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Container(
              width: 70,
              margin: EdgeInsets.only(left: 10),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    bottom: 0,
                    top: 10,
                    right: 10,
                    child: Image.network(
                      _listImageOld[index].path ?? '',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: -10,
                    right: -10,
                    child: IconButton(
                      onPressed: () {
                        _deleteIndex=index;
                        APIServices(context, session)
                            .callApi(Const.product_url, getDeleteRequest(_listImageOld[index].mediaId ?? ''))
                            .then((value) => checkDeleteResponse(value));
                      },
                      icon: Icon(
                        Icons.delete_rounded,
                        color: Colors.red,
                        size: 25,
                      ),
                    ),
                  ),
                ],
              ));
        });
    return listview;
  }

  validateViews() {
    if (_listImage.isEmpty && _productId == '') {
      Fluttertoast.showToast(msg: 'Upload at least one image');
      return false;
    }
    if (_nameController.text == '') {
      Fluttertoast.showToast(msg: 'Enter product name');
      return false;
    }
    if (_categoryId == '') {
      Fluttertoast.showToast(msg: 'Select crop type');
      return false;
    }
    if (_growingId == '') {
      Fluttertoast.showToast(msg: 'Select growing medium');
      return false;
    }
    if (_envirnomentId == '') {
      Fluttertoast.showToast(msg: 'Select environment');
      return false;
    }
    if (_photoPeriodId == '') {
      Fluttertoast.showToast(msg: 'Select photo period');
      return false;
    }
    if (_waterController.text == '') {
      Fluttertoast.showToast(msg: 'Enter water level');
      return false;
    }
    if (_weightController.text == '') {
      Fluttertoast.showToast(msg: 'Enter weight');
      return false;
    }
    if (_priceController.text == '') {
      Fluttertoast.showToast(msg: 'Enter price for product');
      return false;
    }
    if (_descController.text == '') {
      Fluttertoast.showToast(msg: 'Enter product description');
      return false;
    } else {
      return true;
    }
  }
}
