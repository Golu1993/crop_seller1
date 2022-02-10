class CropCareModel {
  int? status;
  String? message;
  List<Data>? data;

  CropCareModel({this.status, this.message, this.data});

  CropCareModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
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
  int? type;
  String? title;
  String? path;

  Data({this.type, this.title, this.path});

  Data.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = this.type;
    data['title'] = this.title;
    data['path'] = this.path;
    return data;
  }
}
