class FaqModel {
  int? status;
  String? message;
  List<Data>? data;

  FaqModel({this.status, this.message, this.data});

  FaqModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
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
  String? faqId;
  String? adminId;
  String? question;
  String? answer;
  String? status;
  String? created;
  String? modified;
  bool? isOpen=false;

  Data(
      {this.faqId,
      this.adminId,
      this.question,
      this.answer,
      this.status,
      this.created,
      this.isOpen,
      this.modified});

  Data.fromJson(Map<String, dynamic> json) {
    faqId = json['faq_id'];
    adminId = json['admin_id'];
    question = json['question'];
    answer = json['answer'];
    status = json['status'];
    created = json['created'];
    isOpen = json['isOpen'];
    modified = json['modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['faq_id'] = faqId;
    data['admin_id'] = adminId;
    data['question'] = question;
    data['answer'] = answer;
    data['status'] = status;
    data['created'] = created;
    data['isOpen'] = isOpen;
    data['modified'] = modified;
    return data;
  }
}
