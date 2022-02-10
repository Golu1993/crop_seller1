class ProductDetailsModel {
  int? status;
  String? message;
  List<ProductData>? data;

  ProductDetailsModel({this.status, this.message, this.data});

  ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductData>[];
      json['data'].forEach((v) {
        data!.add(new ProductData.fromJson(v));
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

class ProductData {
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
  List<PhotoPeriod>? photo_period_combo;
  String? photo_period;
  String? environment;
  int? day;
  int? info_days;
  int? entry_per_day;
  String? unitCost;
  String? totalCost;
  GrowthEverage? growthEverage;
  OperationalCost? operationalCost;
  List<Photo>? photo;

  ProductData(
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
        this.photo_period_combo,
        this.environment,
        this.photo_period,
        this.day,
        this.entry_per_day,
        this.info_days,
        this.unitCost,
        this.totalCost,
        this.growthEverage,
        this.operationalCost,
        this.photo});

  ProductData.fromJson(Map<String, dynamic> json) {
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
    if (json['photo_period_combo'] != null) {
      photo_period_combo = <PhotoPeriod>[];
      json['photo_period_combo'].forEach((v) { photo_period_combo!.add(new PhotoPeriod.fromJson(v)); });
    }
    environment = json['environment'];
    photo_period = json['photo_period'];
    day = json['day'];
    entry_per_day = json['entry_per_day'];
    info_days = json['info_days'];
    unitCost = json['unit_cost'];
    totalCost = json['total_cost'];
    growthEverage = json['growth_everage'] != null
        ? new GrowthEverage.fromJson(json['growth_everage'])
        : null;
    operationalCost = json['operational_cost'] != null
        ? new OperationalCost.fromJson(json['operational_cost'])
        : null;
    if (json['photo'] != null) {
      photo = <Photo>[];
      json['photo'].forEach((v) {
        photo!.add(new Photo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
    if (this.photo_period_combo != null) {
      data['photo_period_combo'] = this.photo_period_combo!.map((v) => v.toJson()).toList();
    }
    data['environment'] = this.environment;
    data['photo_period'] = this.photo_period;
    data['day'] = this.day;
    data['entry_per_day'] = this.entry_per_day;
    data['info_days'] = this.info_days;
    data['unit_cost'] = this.unitCost;
    data['total_cost'] = this.totalCost;
    if (this.growthEverage != null) {
      data['growth_everage'] = this.growthEverage!.toJson();
    }
    if (this.operationalCost != null) {
      data['operational_cost'] = this.operationalCost!.toJson();
    }
    if (this.photo != null) {
      data['photo'] = this.photo!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class PhotoPeriod {
  String? id;
  String? name;

  PhotoPeriod({this.id, this.name});

  PhotoPeriod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class GrowthEverage {
  String? avgHighestRh;
  String? avgLowestRh;
  String? avgDayTemprature;
  String? avgNightTemprature;
  String? totalWaterUsed;
  String? avgWaterPh;
  String? avgWaterTemprature;
  String? germinationDays;
  String? vegetationDays;
  String? floweringDays;
  String? avgWatt;
  String? avgWaterPerPlant;
  String? costPerPlant;
  String? totalDayCycle;
  String? gramsPerWatt;
  String? avgLightHeight;

  GrowthEverage(
      {this.avgHighestRh,
        this.avgLowestRh,
        this.avgDayTemprature,
        this.avgNightTemprature,
        this.totalWaterUsed,
        this.avgWaterPh,
        this.avgWaterTemprature,
        this.germinationDays,
        this.vegetationDays,
        this.floweringDays,
        this.avgWatt,
        this.avgWaterPerPlant,
        this.costPerPlant,
        this.totalDayCycle,
        this.gramsPerWatt,
        this.avgLightHeight});

  GrowthEverage.fromJson(Map<String, dynamic> json) {
    avgHighestRh = json['avg_highest_rh'];
    avgLowestRh = json['avg_lowest_rh'];
    avgDayTemprature = json['avg_day_temprature'];
    avgNightTemprature = json['avg_night_temprature'];
    totalWaterUsed = json['total_water_used'];
    avgWaterPh = json['avg_water_ph'];
    avgWaterTemprature = json['avg_water_temprature'];
    germinationDays = json['germination_days'];
    vegetationDays = json['vegetation_days'];
    floweringDays = json['flowering_days'];
    avgWatt = json['avg_watt'];
    avgWaterPerPlant = json['avg_water_per_plant'];
    costPerPlant = json['cost_per_plant'];
    totalDayCycle = json['total_day_cycle'];
    gramsPerWatt = json['grams_per_watt'];
    avgLightHeight = json['avg_light_height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avg_highest_rh'] = this.avgHighestRh;
    data['avg_lowest_rh'] = this.avgLowestRh;
    data['avg_day_temprature'] = this.avgDayTemprature;
    data['avg_night_temprature'] = this.avgNightTemprature;
    data['total_water_used'] = this.totalWaterUsed;
    data['avg_water_ph'] = this.avgWaterPh;
    data['avg_water_temprature'] = this.avgWaterTemprature;
    data['germination_days'] = this.germinationDays;
    data['vegetation_days'] = this.vegetationDays;
    data['flowering_days'] = this.floweringDays;
    data['avg_watt'] = this.avgWatt;
    data['avg_water_per_plant'] = this.avgWaterPerPlant;
    data['cost_per_plant'] = this.costPerPlant;
    data['total_day_cycle'] = this.totalDayCycle;
    data['grams_per_watt'] = this.gramsPerWatt;
    data['avg_light_height'] = this.avgLightHeight;
    return data;
  }
}

class OperationalCost {
  List<OperationalData>? utilities;
  List<OperationalData>? seeds;
  List<OperationalData>? soilAdditives;
  List<OperationalData>? nutrients;
  List<OperationalData>? miscCost;
  List<OperationalData>? laborHours;

  OperationalCost(
      {this.utilities,
        this.seeds,
        this.soilAdditives,
        this.nutrients,
        this.miscCost,
        this.laborHours});

  OperationalCost.fromJson(Map<String, dynamic> json) {
    if (json['Utilities'] != null) {
      utilities = <OperationalData>[];
      json['Utilities'].forEach((v) {
        utilities!.add(new OperationalData.fromJson(v));
      });
    }
    if (json['Seeds'] != null) {
      seeds = <OperationalData>[];
      json['Seeds'].forEach((v) {
        seeds!.add(new OperationalData.fromJson(v));
      });
    }
    if (json['Soil Additives'] != null) {
      soilAdditives = <OperationalData>[];
      json['Soil Additives'].forEach((v) {
        soilAdditives!.add(new OperationalData.fromJson(v));
      });
    }
    if (json['Nutrients'] != null) {
      nutrients = <OperationalData>[];
      json['Nutrients'].forEach((v) {
        nutrients!.add(new OperationalData.fromJson(v));
      });
    }
    if (json['Misc Cost'] != null) {
      miscCost = <OperationalData>[];
      json['Misc Cost'].forEach((v) {
        miscCost!.add(new OperationalData.fromJson(v));
      });
    }
    if (json['Labor Hours'] != null) {
      laborHours = <OperationalData>[];
      json['Labor Hours'].forEach((v) {
        laborHours!.add(new OperationalData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.utilities != null) {
      data['Utilities'] = this.utilities!.map((v) => v.toJson()).toList();
    }
    if (this.seeds != null) {
      data['Seeds'] = this.seeds!.map((v) => v.toJson()).toList();
    }
    if (this.soilAdditives != null) {
      data['Soil Additives'] =
          this.soilAdditives!.map((v) => v.toJson()).toList();
    }
    if (this.nutrients != null) {
      data['Nutrients'] = this.nutrients!.map((v) => v.toJson()).toList();
    }
    if (this.miscCost != null) {
      data['Misc Cost'] = this.miscCost!.map((v) => v.toJson()).toList();
    }
    if (this.laborHours != null) {
      data['Labor Hours'] = this.laborHours!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OperationalData {
  String? costId;
  String? sellerId;
  String? productId;
  String? title;
  Null? description;
  String? type;
  String? cropUsage;
  String? unitCost;
  String? status;
  String? created;
  String? modified;
  String? typeName;

  OperationalData(
      {this.costId,
        this.sellerId,
        this.productId,
        this.title,
        this.description,
        this.type,
        this.cropUsage,
        this.unitCost,
        this.status,
        this.created,
        this.modified,
        this.typeName});

  OperationalData.fromJson(Map<String, dynamic> json) {
    costId = json['cost_id'];
    sellerId = json['seller_id'];
    productId = json['product_id'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    cropUsage = json['crop_usage'];
    unitCost = json['unit_cost'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
    typeName = json['type_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cost_id'] = this.costId;
    data['seller_id'] = this.sellerId;
    data['product_id'] = this.productId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['type'] = this.type;
    data['crop_usage'] = this.cropUsage;
    data['unit_cost'] = this.unitCost;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['type_name'] = this.typeName;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['media_id'] = this.mediaId;
    data['path'] = this.path;
    return data;
  }
}