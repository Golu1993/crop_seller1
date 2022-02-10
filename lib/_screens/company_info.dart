import 'dart:io';

import 'package:crop_seller/_models/profile_model.dart';
import 'package:crop_seller/_screens/bank_info.dart';
import 'package:crop_seller/_screens/profile.dart';
import 'package:crop_seller/utility/Const.dart';
import 'package:crop_seller/utility/MySharedPrefences.dart';
import 'package:crop_seller/utility/utils.dart';
import 'package:crop_seller/webservices/APIServices.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Company extends StatefulWidget {
  CompanyObj? _companyObj;

  Company(this._companyObj);

  @override
  State<StatefulWidget> createState() {
    return Company_State();
  }
}

class Company_State extends State<Company> {
  var cNameController = TextEditingController();
  var einController = TextEditingController();
  var taxController = TextEditingController();
  var yearsController = TextEditingController();
  var dlController = TextEditingController();
  String session = '';
  bool _isEditData = false;
  bool _isDlSelected = true;
  File? imageFile;
  bool _isLocalDlImage = false;

  @override
  void initState() {
    super.initState();
    MySharedPrefences().getSession().then((value) => session = value);
    cNameController.text = widget._companyObj?.companyName ?? '';
    einController.text = widget._companyObj?.ein ?? '';
    taxController.text = widget._companyObj?.taxExemption ?? '';
    yearsController.text = widget._companyObj?.noOfYearInBusiness ?? '';
    _isEditData = widget._companyObj != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Steps 3 of 4',
                style: TextStyle(fontSize: 12, color: Colors.yellow),
              ),
              const SizedBox(
                height: 20,
              ),
              getCompanyWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  getCompanyWidgets() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Company Info',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
        const Text(
          'Company Name',
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: TextFormField(
            controller: cNameController,
            style: TextStyle(color: Colors.black, fontSize: 14),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Company Name',
              contentPadding: EdgeInsets.all(10.0),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Social Security/EIN',
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: TextFormField(
            controller: einController,
            style: TextStyle(color: Colors.black, fontSize: 14),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Social Security/EIN',
              contentPadding: EdgeInsets.all(10.0),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Drivers License Upload',
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        ),
        GestureDetector(
          onTap: () => showOptionDialog(),
          child: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(left: 15, right: 20),
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(25)),
            child: Row(
              children: [
                Text(
                  'Drivers License',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                Expanded(child: SizedBox()),
                getDLImage(),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Tax Exemption',
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: TextFormField(
            controller: taxController,
            style: TextStyle(color: Colors.black, fontSize: 14),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Tax Exemption',
              contentPadding: EdgeInsets.all(10.0),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          'Number of Years in Business',
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          child: TextFormField(
            controller: yearsController,
            style: TextStyle(color: Colors.black, fontSize: 14),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              hintText: 'Number of Years in Business',
              contentPadding: EdgeInsets.all(10.0),
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
                          .updateBuyerCompanyData(imageFile?.path,
                              Const.common_base_url, getRequest())
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
    );
  }

  Map getRequest() {
    var request = {
      'api': '1',
      'action': 'company_info',
      'company_name': cNameController.text,
      'ein': einController.text,
      'tax_exemption': taxController.text,
      'no_of_year_in_business': yearsController.text,
      'type': 'company',
    };
    return request;
  }

  validateViews() {
    if (cNameController.text == '') {
      Fluttertoast.showToast(msg: 'Enter company name');
      return false;
    } else if (einController.text == '') {
      Fluttertoast.showToast(msg: 'Enter EIN');
      return false;
    } else if (!_isDlSelected) {
      Fluttertoast.showToast(msg: 'Upload your DL image');
      return false;
    } else if (taxController.text == '') {
      Fluttertoast.showToast(msg: 'Enter tax exemption');
      return false;
    } else if (yearsController.text == '') {
      Fluttertoast.showToast(msg: 'Enter no of years in business');
      return false;
    } else {
      return true;
    }
  }

  checkResponse(int? value) {
    if ((value ?? 0) == 200) {
      Fluttertoast.showToast(msg: 'Updated successfully');
      if (_isEditData) {
        Navigator.pop(context, true);
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>Bank(null, false)));
      }
    } else {
      Fluttertoast.showToast(msg: 'Something went wrong');
    }
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
    print('$pickedFile');
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      _isDlSelected = true;
      _isLocalDlImage = true;
      setState(() {
        widget._companyObj?.driverLicence = pickedFile.path;
      });
    }
  }

  getDLImage() {
    return _isLocalDlImage
        ? Image.file(
            imageFile ?? File(''),
            fit: BoxFit.cover,
            height: 40,
            width: 80,
          )
        : ((widget._companyObj?.driverLicence ?? '') != '')
            ? Image.network(
                widget._companyObj?.driverLicence ?? '',
                fit: BoxFit.cover,
                height: 40,
                width: 80,
              )
            : SizedBox();
  }
}
