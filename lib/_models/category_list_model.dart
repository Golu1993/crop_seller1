class CategoryListModel {
  int? status;
  String? message;
  List<Data>? data;

  CategoryListModel({this.status, this.message, this.data});

  CategoryListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data =  <Data>[];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? categoryId;
  String? name;
  String? image;
  bool? isSelect=false;
  String? description;

  Data({this.categoryId, this.name, this.image,this.isSelect, this.description});

  Data.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    name = json['name'];
    image = json['image'];
    isSelect = json['isSelect'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['name'] = name;
    data['image'] = image;
    data['isSelect'] = isSelect;
    data['description'] = description;
    return data;
  }
}