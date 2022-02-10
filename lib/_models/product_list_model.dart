class ProductListModel {
  int? status;
  String? message;
  List<ProductDetailsData>? data;

  ProductListModel({this.status, this.message, this.data});

  ProductListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductDetailsData>[];
      json['data'].forEach((v) {
        data!.add(ProductDetailsData.fromJson(v));
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

class ProductDetailsData {
  String? productId;
  String? sellerId;
  String? categoryId;
  String? growingMediumId;
  String? photoPeriodId;
  String? environmentId;
  String? name;
  String? description;
  String? videoUrl;
  String? weight;
  String? water;
  String? price;
  String? status;
  String? created;
  String? modified;
  String? category;
  String? growingMedium;
  String? photoPeriod;
  String? environment;
  List<Photo>? photo;

  ProductDetailsData(
      {this.productId,
        this.sellerId,
        this.categoryId,
        this.growingMediumId,
        this.photoPeriodId,
        this.environmentId,
        this.name,
        this.description,
        this.videoUrl,
        this.weight,
        this.water,
        this.price,
        this.status,
        this.created,
        this.modified,
        this.category,
        this.growingMedium,
        this.photoPeriod,
        this.environment,
        this.photo});

  ProductDetailsData.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    sellerId = json['seller_id'];
    categoryId = json['category_id'];
    growingMediumId = json['growing_medium_id'];
    photoPeriodId = json['photo_period_id'];
    environmentId = json['environment_id'];
    name = json['name'];
    description = json['description'];
    videoUrl = json['video_url'];
    weight = json['weight'];
    water = json['water'];
    price = json['price'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
    category = json['category'];
    growingMedium = json['growing_medium'];
    photoPeriod = json['photo_period'];
    environment = json['environment'];
    if (json['photo'] != null) {
      photo = <Photo>[];
      json['photo'].forEach((v) {
        photo!.add(Photo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['seller_id'] = this.sellerId;
    data['category_id'] = this.categoryId;
    data['growing_medium_id'] = this.growingMediumId;
    data['photo_period_id'] = this.photoPeriodId;
    data['environment_id'] = this.environmentId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['video_url'] = this.videoUrl;
    data['weight'] = this.weight;
    data['water'] = this.water;
    data['price'] = this.price;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['category'] = this.category;
    data['growing_medium'] = this.growingMedium;
    data['photo_period'] = this.photoPeriod;
    data['environment'] = this.environment;
    if (this.photo != null) {
      data['photo'] = this.photo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Photo {
  String? mediaId;
  String? path;

  Photo({this.mediaId, this.path});

  Photo.fromJson(Map<String, dynamic> json) {
    mediaId = json['media_id'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['media_id'] = this.mediaId;
    data['path'] = this.path;
    return data;
  }
}