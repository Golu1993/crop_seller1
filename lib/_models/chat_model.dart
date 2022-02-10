class ChatModel {
  int? status;
  String? message;
  List<ChatData>? data;

  ChatModel({this.status, this.message, this.data});

  ChatModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ChatData>[];
      json['data'].forEach((v) {
        data!.add(new ChatData.fromJson(v));
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

class ChatData {
  String? commentId;
  String? sellerId;
  String? buyerId;
  String? comment;
  String? commentedBy;
  String? status;
  String? created;
  String? modified;

  ChatData(
      {this.commentId,
        this.sellerId,
        this.buyerId,
        this.comment,
        this.commentedBy,
        this.status,
        this.created,
        this.modified});

  ChatData.fromJson(Map<String, dynamic> json) {
    commentId = json['comment_id'];
    sellerId = json['seller_id'];
    buyerId = json['buyer_id'];
    comment = json['comment'];
    commentedBy = json['commented_by'];
    status = json['status'];
    created = json['created'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comment_id'] = this.commentId;
    data['seller_id'] = this.sellerId;
    data['buyer_id'] = this.buyerId;
    data['comment'] = this.comment;
    data['commented_by'] = this.commentedBy;
    data['status'] = this.status;
    data['created'] = this.created;
    data['modified'] = this.modified;
    return data;
  }
}