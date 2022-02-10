class ComboModel {
  int? status;
  String? message;
  List<Data>? data;

  ComboModel({this.status, this.message, this.data});

  ComboModel.fromJson(Map<String, dynamic> json) {
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
  List<CommonData>? country;
  List<Category>? category;
  List<CommonData>? environment;
  List<CommonData>? growingMedium;
  List<CommonData>? photoPeriod;

  Data(
      {this.country,
        this.category,
        this.environment,
        this.growingMedium,
        this.photoPeriod});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['country'] != null) {
      country = <CommonData>[];
      json['country'].forEach((v) {
        country!.add(CommonData.fromJson(v));
      });
    }
    if (json['category'] != null) {
      category = <Category>[];
      json['category'].forEach((v) {
        category!.add(Category.fromJson(v));
      });
    }
    if (json['environment'] != null) {
      environment = <CommonData>[];
      json['environment'].forEach((v) {
        environment!.add(CommonData.fromJson(v));
      });
    }
    if (json['growing_medium'] != null) {
      growingMedium = <CommonData>[];
      json['growing_medium'].forEach((v) {
        growingMedium!.add(CommonData.fromJson(v));
      });
    }
    if (json['photo_period'] != null) {
      photoPeriod = <CommonData>[];
      json['photo_period'].forEach((v) {
        photoPeriod!.add(CommonData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.country != null) {
      data['country'] = this.country!.map((v) => v.toJson()).toList();
    }
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.environment != null) {
      data['environment'] = this.environment!.map((v) => v.toJson()).toList();
    }
    if (this.growingMedium != null) {
      data['growing_medium'] =
          this.growingMedium!.map((v) => v.toJson()).toList();
    }
    if (this.photoPeriod != null) {
      data['photo_period'] = this.photoPeriod!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommonData {
  String? id;
  String? name;

  CommonData({this.id, this.name});

  CommonData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Category {
  String? categoryId;
  String? name;
  String? image;
  String? description;

  Category({this.categoryId, this.name, this.image, this.description});

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    return data;
  }
}