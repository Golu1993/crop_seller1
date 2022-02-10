import 'package:flutter/material.dart';

class NotificatiosList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotificatiosListState();
  }
}

class NotificatiosListState extends State<NotificatiosList> {
  getList() {
    var listview = ListView.builder(
        itemCount: 50,
        shrinkWrap: true,
        primary: false,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(top: 10),
            child: getListItems(),
          );
        });
    return listview;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 20),
          color: Colors.black,
          // decoration: BoxDecoration(
          //   image: DecorationImage(
          //     image: AssetImage("images/theme_back.png"),
          //     fit: BoxFit.cover,
          //   ),
          // ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
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
                          "images/notification_title.png",
                          width: MediaQuery.of(context).size.width,
                          height: 30,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(

                child: Container(
                  color: Color.fromRGBO(248, 246, 246, 1),
                  child: getList(),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  getListItems() {
    return Card(
      margin:EdgeInsets.only(left: 15,right: 15),
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "By Tomato",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Asking for update on tomato",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                  ),
                ),
              ],
            ),
            Expanded(child: SizedBox()),
            Text(
              "40 min ago",
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
