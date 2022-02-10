class QueryModel {
  int? status;
  String? message;
  List<QueryData>? data;

  QueryModel({this.status, this.message, this.data});

  QueryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <QueryData>[];
      json['data'].forEach((v) {
        data!.add(new QueryData.fromJson(v));
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

class QueryData {
  String? queryId;
  String? faqId;
  String? productId;
  String? buyerId;
  String? sellerId;
  String? status;
  String? created;
  String? modified;
  String? categoryId;
  String? question;
  String? productName;
  String? categoryName;
  String? sellerName;
  String? buyerName;

  QueryData(
      {this.queryId,
        this.faqId,
        this.productId,
        this.buyerId,
        this.sellerId,
        this.status,
        this.created,
        this.modified,
        this.categoryId,
        this.question,
        this.productName,
        this.categoryName,
        this.buyerName,
        this.sellerName});

  QueryData.fromJson(Map<String, dynamic> json) {
    queryId = json['query_id'];
    faqId = json['faq_id'];
    productId = json['product_id'];
    buyerId = json['buyer_id'];
    sellerId = json['seller_id'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
    categoryId = json['category_id'];
    question = json['question'];
    productName = json['product_name'];
    categoryName = json['category_name'];
    sellerName = json['seller_name'];
    buyerName = json['buyer_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['query_id'] = this.queryId;
    data['faq_id'] = this.faqId;
    data['product_id'] = this.productId;
    data['buyer_id'] = this.buyerId;
    data['seller_id'] = this.sellerId;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['category_id'] = this.categoryId;
    data['question'] = this.question;
    data['product_name'] = this.productName;
    data['category_name'] = this.categoryName;
    data['seller_name'] = this.sellerName;
    data['buyer_name'] = this.buyerName;
    return data;
  }
}