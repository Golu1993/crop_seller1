class OrderModel {
  int? status;
  String? message;
  List<OrderData>? data;

  OrderModel({this.status, this.message, this.data});

  OrderModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <OrderData>[];
      json['data'].forEach((v) {
        data!.add(new OrderData.fromJson(v));
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

class OrderData {
  OrderObj? orderObj;
  List<OrderTracking>? orderTracking;
  ProductObj? productObj;
  BuyerObj? buyerObj;
  SellerObj? sellerObj;

  OrderData(
      {this.orderObj,
        this.orderTracking,
        this.productObj,
        this.buyerObj,
        this.sellerObj});

  OrderData.fromJson(Map<String, dynamic> json) {
    orderObj = json['order_obj'] != null
        ? new OrderObj.fromJson(json['order_obj'])
        : null;
    if (json['order_tracking'] != null) {
      orderTracking = <OrderTracking>[];
      json['order_tracking'].forEach((v) {
        orderTracking!.add(new OrderTracking.fromJson(v));
      });
    }
    productObj = json['product_obj'] != null
        ? new ProductObj.fromJson(json['product_obj'])
        : null;
    buyerObj = json['buyer_obj'] != null
        ? new BuyerObj.fromJson(json['buyer_obj'])
        : null;
    sellerObj = json['seller_obj'] != null
        ? new SellerObj.fromJson(json['seller_obj'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderObj != null) {
      data['order_obj'] = this.orderObj!.toJson();
    }
    if (this.orderTracking != null) {
      data['order_tracking'] =
          this.orderTracking!.map((v) => v.toJson()).toList();
    }
    if (this.productObj != null) {
      data['product_obj'] = this.productObj!.toJson();
    }
    if (this.buyerObj != null) {
      data['buyer_obj'] = this.buyerObj!.toJson();
    }
    if (this.sellerObj != null) {
      data['seller_obj'] = this.sellerObj!.toJson();
    }
    return data;
  }
}

class OrderObj {
  String? orderId;
  String? orderUid;
  String? buyerId;
  String? sellerId;
  String? shippingAddressId;
  String? productId;
  String? quantity;
  String? discount;
  String? subtotal;
  String? shipping;
  String? tax;
  String? total;
  String? paymentMode;
  String? status;
  String? created;
  String? modified;
  String? statusString;

  OrderObj(
      {this.orderId,
        this.orderUid,
        this.buyerId,
        this.sellerId,
        this.shippingAddressId,
        this.productId,
        this.quantity,
        this.discount,
        this.subtotal,
        this.shipping,
        this.tax,
        this.total,
        this.paymentMode,
        this.status,
        this.created,
        this.modified,
        this.statusString});

  OrderObj.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderUid = json['order_uid'];
    buyerId = json['buyer_id'];
    sellerId = json['seller_id'];
    shippingAddressId = json['shipping_address_id'];
    productId = json['product_id'];
    quantity = json['quantity'];
    discount = json['discount'];
    subtotal = json['subtotal'];
    shipping = json['shipping'];
    tax = json['tax'];
    total = json['total'];
    paymentMode = json['payment_mode'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
    statusString = json['status_string'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['order_uid'] = this.orderUid;
    data['buyer_id'] = this.buyerId;
    data['seller_id'] = this.sellerId;
    data['shipping_address_id'] = this.shippingAddressId;
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['discount'] = this.discount;
    data['subtotal'] = this.subtotal;
    data['shipping'] = this.shipping;
    data['tax'] = this.tax;
    data['total'] = this.total;
    data['payment_mode'] = this.paymentMode;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['status_string'] = this.statusString;
    return data;
  }
}

class OrderTracking {
  String? name;
  int? status;

  OrderTracking({this.name, this.status});

  OrderTracking.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}

class ProductObj {
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
  List<String>? images;

  ProductObj(
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
        this.images});

  ProductObj.fromJson(Map<String, dynamic> json) {
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
    images = json['images'].cast<String>();
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
    data['images'] = this.images;
    return data;
  }
}

class BuyerObj {
  String? buyerUid;
  String? fname;
  String? mname;
  String? lname;
  String? email;
  String? mobile;
  String? image;
  String? street;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? address;

  BuyerObj(
      {this.buyerUid,
        this.fname,
        this.mname,
        this.lname,
        this.email,
        this.mobile,
        this.image,
        this.street,
        this.city,
        this.state,
        this.zip,
        this.country,
        this.address});

  BuyerObj.fromJson(Map<String, dynamic> json) {
    buyerUid = json['buyer_uid'];
    fname = json['fname'];
    mname = json['mname'];
    lname = json['lname'];
    email = json['email'];
    mobile = json['mobile'];
    image = json['image'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    country = json['country'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['buyer_uid'] = this.buyerUid;
    data['fname'] = this.fname;
    data['mname'] = this.mname;
    data['lname'] = this.lname;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['image'] = this.image;
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['country'] = this.country;
    data['address'] = this.address;
    return data;
  }
}

class SellerObj {
  String? sellerUid;
  String? fname;
  String? mname;
  String? lname;
  String? email;
  String? mobile;
  String? image;
  String? street;
  String? city;
  String? state;
  String? zip;
  String? country;
  String? address;

  SellerObj(
      {this.sellerUid,
        this.fname,
        this.mname,
        this.lname,
        this.email,
        this.mobile,
        this.image,
        this.street,
        this.city,
        this.state,
        this.zip,
        this.country,
        this.address});

  SellerObj.fromJson(Map<String, dynamic> json) {
    sellerUid = json['seller_uid'];
    fname = json['fname'];
    mname = json['mname'];
    lname = json['lname'];
    email = json['email'];
    mobile = json['mobile'];
    image = json['image'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    zip = json['zip'];
    country = json['country'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seller_uid'] = this.sellerUid;
    data['fname'] = this.fname;
    data['mname'] = this.mname;
    data['lname'] = this.lname;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['image'] = this.image;
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['zip'] = this.zip;
    data['country'] = this.country;
    data['address'] = this.address;
    return data;
  }
}