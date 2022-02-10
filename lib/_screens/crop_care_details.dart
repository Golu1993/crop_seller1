import 'package:crop_seller/_models/crop_care_list_model.dart';
import 'package:flutter/material.dart';

class CropCareDetails extends StatefulWidget {
  CropCareData? _cropCareData;

  CropCareDetails(this._cropCareData);

  @override
  State<StatefulWidget> createState() {
    return CropCareDetailsState();
  }
}

class CropCareDetailsState extends State<CropCareDetails> {
  String session = '';
  bool _isApiSuccess = false;

  /* @override
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
      'guide_id': widget._guideId,
    };

    return request;
  }

  checkResponse(String response) {
    _cropCareListModel = CropCareListModel.fromJson(jsonDecode(response));
    if (_cropCareListModel.status == 1) {
      setState(() {
        _isApiSuccess = true;
      });
    }
  }*/

  getList() {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return getListItemWidget(index);
      },
    );
  }

  getBenefitsList() {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      primary: false,
      itemBuilder: (context, index) {
        return getBenefitsItemWidget(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle boldStyle = TextStyle(
        color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold);
    TextStyle normalStyle = TextStyle(color: Colors.black54);
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
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
                          "images/cropcare_details.png",
                          width: MediaQuery.of(context).size.width,
                          height: 25,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                color: Colors.lightGreen,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget._cropCareData?.title ?? '',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              /* Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.auto_graph_sharp),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Guaranteed Analysis",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Card(
                          elevation: 5,
                          margin: EdgeInsets.only(top: 15, bottom: 15),
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              children: [
                                getList(),
                                Container(
                                  height: 40,
                                  padding: EdgeInsets.only(right: 15),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    "11.20 LBS/GAL",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      color: Color.fromRGBO(197, 197, 197, 1)),
                                )
                              ],
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley",
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Benefits",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        getBenefitsList(),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              "images/compatibility.png",
                              height: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Compatibility",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(style: boldStyle, text: "Dilution : "),
                              TextSpan(
                                  style: normalStyle,
                                  text:
                                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum "
                                          "has been the industry's standard dummy text ever since the 1500s, when an unknown printer "
                                          "took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, "
                                      "but also the leap into electronic typesetting, remaining essentially unchanged."),
                            ],
                          ),
                          textAlign: TextAlign.justify,
                        )
                      ],
                    ),
                  ),
                ),
              )*/
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      widget._cropCareData?.description ?? '',
                      textAlign: TextAlign.justify,
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getListItemWidget(int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
        top: 10,
      ),
      alignment: Alignment.centerLeft,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Alpha",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
              Expanded(child: SizedBox()),
              Text(
                "10%",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: index == 4 ? Colors.white : Color.fromRGBO(197, 197, 197, 1),
          )
        ],
      ),
    );
  }

  getBenefitsItemWidget(int index) {
    return Row(
      children: [
        ClipOval(
          child: Container(
            height: 8,
            width: 8,
            color: Colors.orangeAccent,
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
          "Alpha",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
