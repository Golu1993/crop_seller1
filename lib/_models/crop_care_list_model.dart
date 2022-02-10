class CropCareListModel {
  int? status;
  String? message;
  List<CropCareData>? data;

  CropCareListModel({this.status, this.message, this.data});

  CropCareListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CropCareData>[];
      json['data'].forEach((v) {
        data!.add(CropCareData.fromJson(v));
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

class CropCareData {
  String? guideId;
  String? adminId;
  String? title;
  String? description;
  String? type;
  String? status;
  String? created;
  String? modified;

  CropCareData(
      {this.guideId,
        this.adminId,
        this.title,
        this.description,
        this.type,
        this.status,
        this.created,
        this.modified});

  CropCareData.fromJson(Map<String, dynamic> json) {
    guideId = json['guide_id'];
    adminId = json['admin_id'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['guide_id'] = this.guideId;
    data['admin_id'] = this.adminId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['type'] = this.type;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    return data;
  }
}