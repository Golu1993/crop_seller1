class ProductUpdatemodel {
  int? status;
  String? message;
  List<ProductUpdateData>? data;

  ProductUpdatemodel({this.status, this.message, this.data});

  ProductUpdatemodel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductUpdateData>[];
      json['data'].forEach((v) {
        data!.add(new ProductUpdateData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductUpdateData {
  String? growthId;
  String? sellerId;
  String? productId;
  String? photoPeriodId;
  String? electricity;
  String? highestRh;
  String? lowestRh;
  String? dayTemprature;
  String? nightTemprature;
  String? water;
  String? waterPh;
  String? waterTemprature;
  String? germination;
  String? vegetative;
  String? flowering;
  String? growthDate;
  String? status;
  String? created;
  String? modified;
  String? photoPeriod;
  String? labour;

  ProductUpdateData(
      {this.growthId,
        this.sellerId,
        this.productId,
        this.photoPeriodId,
        this.electricity,
        this.highestRh,
        this.lowestRh,
        this.dayTemprature,
        this.nightTemprature,
        this.water,
        this.waterPh,
        this.waterTemprature,
        this.germination,
        this.vegetative,
        this.flowering,
        this.growthDate,
        this.status,
        this.created,
        this.modified,
        this.labour,
        this.photoPeriod});

  ProductUpdateData.fromJson(Map<String, dynamic> json) {
    growthId = json['growth_id'];
    sellerId = json['seller_id'];
    productId = json['product_id'];
    photoPeriodId = json['photo_period_id'];
    electricity = json['electricity'];
    highestRh = json['highest_rh'];
    lowestRh = json['lowest_rh'];
    dayTemprature = json['day_temprature'];
    nightTemprature = json['night_temprature'];
    water = json['water'];
    waterPh = json['water_ph'];
    waterTemprature = json['water_temprature'];
    germination = json['germination'];
    vegetative = json['vegetative'];
    flowering = json['flowering'];
    growthDate = json['growth_date'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
    labour = json['labour'];
    photoPeriod = json['photo_period'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['growth_id'] = this.growthId;
    data['seller_id'] = this.sellerId;
    data['product_id'] = this.productId;
    data['photo_period_id'] = this.photoPeriodId;
    data['electricity'] = this.electricity;
    data['highest_rh'] = this.highestRh;
    data['lowest_rh'] = this.lowestRh;
    data['day_temprature'] = this.dayTemprature;
    data['night_temprature'] = this.nightTemprature;
    data['water'] = this.water;
    data['water_ph'] = this.waterPh;
    data['water_temprature'] = this.waterTemprature;
    data['germination'] = this.germination;
    data['vegetative'] = this.vegetative;
    data['flowering'] = this.flowering;
    data['growth_date'] = this.growthDate;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['photo_period'] = this.photoPeriod;
    data['labour'] = this.labour;
    return data;
  }
}