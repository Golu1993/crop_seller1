class LoginModel {
  int? status;
  String? message;
   List<Data>? data;

  LoginModel({ this.status, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? email;
  String? mobile;
  String? fname;
  String? lname;
  int? companyId;
  int? loginId;
  String? loginUid;
  String? image;
  bool? loggedIn;

  Data(
      { this.email,
        this.mobile,
        this.fname,
        this.lname,
        this.companyId,
        this.loginId,
        this.loginUid,
        this.image,
        this.loggedIn});

  Data.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    mobile = json['mobile'];
    fname = json['fname'];
    lname = json['lname'];
    companyId = json['company_id'];
    loginId = json['login_id'];
    loginUid = json['login_uid'];
    image = json['image'];
    loggedIn = json['logged_in'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['company_id'] = this.companyId;
    data['login_id'] = this.loginId;
    data['login_uid'] = this.loginUid;
    data['image'] = this.image;
    data['logged_in'] = this.loggedIn;
    return data;
  }
}