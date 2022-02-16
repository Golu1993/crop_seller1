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
  String? comment;
  String? commentedBy;
  String? status;
  String? created;
  String? modified;
  String? buyerName;
  String? name;
  String? categoryName;

  QueryData(
      {this.queryId,
        this.faqId,
        this.productId,
        this.buyerId,
        this.sellerId,
        this.comment,
        this.commentedBy,
        this.status,
        this.created,
        this.modified,
        this.buyerName,
        this.name,
        this.categoryName});

  QueryData.fromJson(Map<String, dynamic> json) {
    queryId = json['query_id'];
    faqId = json['faq_id'];
    productId = json['product_id'];
    buyerId = json['buyer_id'];
    sellerId = json['seller_id'];
    comment = json['comment'];
    commentedBy = json['commented_by'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
    buyerName = json['buyer_name'];
    name = json['name'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['query_id'] = this.queryId;
    data['faq_id'] = this.faqId;
    data['product_id'] = this.productId;
    data['buyer_id'] = this.buyerId;
    data['seller_id'] = this.sellerId;
    data['comment'] = this.comment;
    data['commented_by'] = this.commentedBy;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    data['buyer_name'] = this.buyerName;
    data['name'] = this.name;
    data['category_name'] = this.categoryName;
    return data;
  }
}