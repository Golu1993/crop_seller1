import 'package:crop_seller/_models/combo_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountryList extends StatefulWidget {
  List<CommonData> _listCountry = [];

  CountryList(this._listCountry);

  @override
  State<StatefulWidget> createState() {
    return CountryListState();
  }
}

class CountryListState extends State<CountryList> {
  String _filterText='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          padding: EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: TextFormField(
                  style: TextStyle(color: Colors.black, fontSize: 14),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Search Country',
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) =>
                  {
                    setState(() {
                      _filterText=value;
                    })
                  },
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: getCountryList(_filterText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getCountryList(String value) {
   var list= getFilterList(value);
    var listView = ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              Navigator.pop(context,list[index]);
            },
            child: ListTile(
              title: Text(list[index].name ?? ''),
            ),
          );
        });
    return listView;
  }
  List<CommonData> getFilterList(String value) {
    print(value);
   var  _filterList = value != '' ? widget._listCountry.where(
              (element) => ((element.name ?? '').toLowerCase()).contains(value.toLowerCase())).toList():widget._listCountry;
   return _filterList;
  }
}
